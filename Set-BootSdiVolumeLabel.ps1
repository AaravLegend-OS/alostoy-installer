<#
.SYNOPSIS
    Changes the NTFS volume label stored in a standard Windows boot.sdi file.
.DESCRIPTION
    This program edits a boot.sdi to whatever label you want. For use with WinPE ONLY!
    By default, when a WinPE boots up, it's label is set to "Boot" when the efi loader
    extracts the Windows PE into RAM. With this, you can customise that initial volume
    label that is assigned before boot and in WinPE (X drive)! Example: You can change
    the initial volume label to "My Custom WinPE" if you would like. The only rejected
    value is "Boot" because it is the default label that Windows PE has used for life.
.EXAMPLE
    .\Set-BootSdiVolumeLabel.ps1 -SdiPath 'C:\Media\Boot\boot.sdi' -Label 'My Custom WinPE' -InPlace
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, HelpMessage="Where is the path to your boot.sdi?")]
    [string]$SdiPath,
    [Parameter(Mandatory, HelpMessage="What should be the new label?")]
    [ValidateScript({ $_ -ine 'Boot' })]
    [string]$Label = 'Windows PE',
    [string]$OutputPath,
    [switch]$InPlace
)
Add-Type -AssemblyName PresentationFramework
$ErrorActionPreference = 'Stop'
function Get-U16 {
    param([byte[]]$Buffer, [int]$Offset)
    [BitConverter]::ToUInt16($Buffer, $Offset)
}
function Get-U32 {
    param([byte[]]$Buffer, [int]$Offset)
    [BitConverter]::ToUInt32($Buffer, $Offset)
}
function Get-U64 {
    param([byte[]]$Buffer, [int]$Offset)
    [BitConverter]::ToUInt64($Buffer, $Offset)
}
function Set-U16 {
    param([byte[]]$Buffer, [int]$Offset, [uint16]$Value)
    [Array]::Copy([BitConverter]::GetBytes($Value), 0, $Buffer, $Offset, 2)
}
function Set-U32 {
    param([byte[]]$Buffer, [int]$Offset, [uint32]$Value)
    [Array]::Copy([BitConverter]::GetBytes($Value), 0, $Buffer, $Offset, 4)
}
function Read-NtfsFileRecord {
    param(
        [byte[]]$FileBytes,
        [int]$Offset,
        [int]$RecordSize,
        [int]$SectorSize
    )
    if ($Offset -lt 0 -or $Offset + $RecordSize -gt $FileBytes.Length) { throw ('MFT record at offset 0x{0:X} is outside the SDI file.' -f $Offset) }
    $record = New-Object byte[] $RecordSize
    [Array]::Copy($FileBytes, $Offset, $record, 0, $RecordSize)
    if ([Text.Encoding]::ASCII.GetString($record, 0, 4) -ne 'FILE') { throw ('No NTFS FILE record was found at offset 0x{0:X}. This SDI layout is not supported.' -f $Offset) }
    if (($RecordSize % $SectorSize) -ne 0) { throw 'The NTFS file-record size is not a whole number of sectors.' }
    $usaOffset = Get-U16 $record 4
    $usaCount = Get-U16 $record 6
    $expectedUsaCount = [int]($RecordSize / $SectorSize) + 1
    if ($usaCount -ne $expectedUsaCount) { throw ('Unexpected NTFS update-sequence array size at record 0x{0:X}.' -f $Offset) }
    if ($usaOffset -lt 8 -or ($usaOffset + (2 * $usaCount)) -gt ($SectorSize - 2)) { throw ('Invalid NTFS update-sequence array location at record 0x{0:X}.' -f $Offset) }
    $sequence = Get-U16 $record $usaOffset
    for ($i = 1; $i -lt $usaCount; $i++) {
        $trailerOffset = ($i * $SectorSize) - 2
        if ((Get-U16 $record $trailerOffset) -ne $sequence) { throw ('NTFS update-sequence check failed at record 0x{0:X}, sector {1}.' -f $Offset, $i) }
        $savedWord = Get-U16 $record ($usaOffset + (2 * $i))
        Set-U16 $record $trailerOffset $savedWord
    }
    [pscustomobject]@{
        Record = $record
        UsaOffset = [int]$usaOffset
        UsaCount = [int]$usaCount
        SectorSize = $SectorSize
    }
}
function Write-NtfsUpdateSequence {
    param(
        [byte[]]$Record,
        [int]$UsaOffset,
        [int]$UsaCount,
        [int]$SectorSize
    )
    $sequence = Get-U16 $Record $UsaOffset
    $nextSequence = ([int]$sequence + 1) -band 0xFFFF
    if ($nextSequence -eq 0) { $nextSequence = 1 }
    Set-U16 $Record $UsaOffset ([uint16]$nextSequence)
    for ($i = 1; $i -lt $UsaCount; $i++) {
        $trailerOffset = ($i * $SectorSize) - 2
        $savedWord = Get-U16 $Record $trailerOffset
        Set-U16 $Record ($UsaOffset + (2 * $i)) $savedWord
        Set-U16 $Record $trailerOffset ([uint16]$nextSequence)
    }
}
function Get-VolumeNameAttribute {
    param([byte[]]$Record)
    if ([Text.Encoding]::ASCII.GetString($Record, 0, 4) -ne 'FILE') { throw 'The NTFS record signature is invalid.' }
    $firstAttribute = Get-U16 $Record 0x14
    $bytesInUse = Get-U32 $Record 0x18
    $bytesAllocated = Get-U32 $Record 0x1C
    if ($bytesInUse -gt $bytesAllocated -or $bytesInUse -gt $Record.Length) { throw 'The NTFS file-record size fields are invalid.' }
    if ($firstAttribute -lt 0x30 -or $firstAttribute -ge $bytesInUse) { throw 'The NTFS first-attribute offset is invalid.' }
    $cursor = [int]$firstAttribute
    $found = $null
    $foundEndMarker = $false
    while ($cursor + 8 -le $bytesInUse) {
        $type = Get-U32 $Record $cursor
        if ($type -eq [uint32]::MaxValue) {
            $foundEndMarker = $true
            break
        }
        $attributeLength = Get-U32 $Record ($cursor + 4)
        if ($attributeLength -lt 8 -or ($attributeLength % 8) -ne 0 -or
            ($cursor + $attributeLength) -gt $bytesInUse) {
            throw ('An invalid NTFS attribute was found at record offset 0x{0:X}.' -f $cursor)
        }
        if ($type -eq 0x60) {
            if ($null -ne $found) { throw 'The NTFS record contains more than one volume-name attribute.' }
            if ($Record[$cursor + 8] -ne 0) { throw 'The NTFS volume-name attribute is not resident; this SDI layout is not supported.' }
            $valueLength = Get-U32 $Record ($cursor + 16)
            $valueOffset = Get-U16 $Record ($cursor + 20)
            if (($valueLength % 2) -ne 0 -or $valueOffset -lt 24 -or
                ($valueOffset + $valueLength) -gt $attributeLength) {
                throw 'The NTFS volume-name attribute has invalid value bounds.'
            }
            $found = [pscustomobject]@{
                AttributeOffset = $cursor
                AttributeLength = [int]$attributeLength
                ValueLength = [int]$valueLength
                ValueOffset = [int]$valueOffset
                BytesInUse = [int]$bytesInUse
                BytesAllocated = [int]$bytesAllocated
                Name = [Text.Encoding]::Unicode.GetString($Record, $cursor + $valueOffset, $valueLength)
            }
        }
        $cursor += [int]$attributeLength
    }
    if (-not $foundEndMarker) { throw 'The NTFS attribute list has no end marker.' }
    if ($null -eq $found) { throw 'The NTFS $Volume record has no volume-name attribute.' }
    $found
}
function Set-VolumeNameInRecord {
    param(
        [byte[]]$Record,
        [string]$NewLabel,
        [int]$UsaOffset,
        [int]$UsaCount,
        [int]$SectorSize
    )
    $attribute = Get-VolumeNameAttribute $Record
    $labelBytes = [Text.Encoding]::Unicode.GetBytes($NewLabel)
    $newAttributeLength = [int]([Math]::Ceiling(($attribute.ValueOffset + $labelBytes.Length) / 8.0) * 8)
    $delta = $newAttributeLength - $attribute.AttributeLength
    $newBytesInUse = $attribute.BytesInUse + $delta
    if ($newBytesInUse -gt $attribute.BytesAllocated -or $newBytesInUse -gt $Record.Length) { throw 'The requested label will not fit in this NTFS file record.' }
    $tailStart = $attribute.AttributeOffset + $attribute.AttributeLength
    $tailLength = $attribute.BytesInUse - $tailStart
    if ($tailLength -lt 4) { throw 'The NTFS attribute list is too short to update safely.' }
    $newTailStart = $attribute.AttributeOffset + $newAttributeLength
    [Array]::Copy($Record, $tailStart, $Record, $newTailStart, $tailLength)
    if ($delta -lt 0) { for ($i = $newBytesInUse; $i -lt $attribute.BytesInUse; $i++) { $Record[$i] = 0 } }
    Set-U32 $Record ($attribute.AttributeOffset + 4) ([uint32]$newAttributeLength)
    Set-U32 $Record ($attribute.AttributeOffset + 16) ([uint32]$labelBytes.Length)
    [Array]::Copy(
        $labelBytes, 0, $Record,
        ($attribute.AttributeOffset + $attribute.ValueOffset),
        $labelBytes.Length
    )
    $paddingStart = $attribute.AttributeOffset + $attribute.ValueOffset + $labelBytes.Length
    $paddingEnd = $attribute.AttributeOffset + $newAttributeLength
    for ($i = $paddingStart; $i -lt $paddingEnd; $i++) { $Record[$i] = 0 }
    Set-U32 $Record 0x18 ([uint32]$newBytesInUse)
    Write-NtfsUpdateSequence $Record $UsaOffset $UsaCount $SectorSize
}
function Get-SdiPartBlob {
    param([byte[]]$FileBytes)
    if ($FileBytes.Length -lt 0x440 -or [Text.Encoding]::ASCII.GetString($FileBytes, 0, 8) -ne '$SDI0001') { throw 'The supplied file does not have a valid $SDI0001 signature.' }
    $blobCount = Get-U32 $FileBytes 0x70
    $tableStart = 0x400
    $entrySize = 0x40
    if ($blobCount -lt 1 -or $blobCount -gt 64 -or
        ($tableStart + ($blobCount * $entrySize)) -gt $FileBytes.Length) {
        throw 'The SDI blob table is invalid or uses an unsupported layout.'
    }
    $part = $null
    for ($i = 0; $i -lt $blobCount; $i++) {
        $entry = $tableStart + ($i * $entrySize)
        $tag = [Text.Encoding]::ASCII.GetString($FileBytes, $entry, 8).TrimEnd([char[]]@(0))
        if ($tag -eq 'PART') {
            if ($null -ne $part) { throw 'The SDI contains more than one PART blob; refusing to guess which one to edit.' }
            $blobOffset = Get-U64 $FileBytes ($entry + 0x10)
            $blobLength = Get-U64 $FileBytes ($entry + 0x18)
            if ($blobOffset -gt [uint64][int]::MaxValue -or
                $blobLength -gt [uint64][int]::MaxValue) {
                throw 'The SDI PART blob is too large for this PowerShell script.'
            }
            $offset = [int]$blobOffset
            $length = [int]$blobLength
            if ($offset -lt 0 -or $length -lt 512 -or
                ($offset + [long]$length) -gt $FileBytes.Length) {
                throw 'The SDI PART blob points outside the file or is too small.'
            }
            $part = [pscustomobject]@{
                Offset = $offset
                Length = $length
            }
        }
    }
    if ($null -eq $part) { throw 'The SDI has no PART blob.' }
    $part
}
if (-not [BitConverter]::IsLittleEndian) { throw 'This script requires a little-endian Windows system.' }
if ([string]::IsNullOrWhiteSpace($SdiPath)) { throw 'An SDI path is required.' }
if ([string]::IsNullOrWhiteSpace($Label)) { throw 'A non-empty volume label is required.' }
if ($Label.Length -gt 32) { throw 'NTFS volume labels can contain at most 32 characters.' }
$invalidLabelCharacters = '<>:"/\|?*'
foreach ($character in $Label.ToCharArray()) { if ([char]::IsControl($character) -or $invalidLabelCharacters.Contains([string]$character)) { throw 'The label contains a character that is not valid in a Windows volume label.' } }
if ($InPlace -and -not [string]::IsNullOrWhiteSpace($OutputPath)) { throw 'Use either -InPlace or -OutputPath, not both.' }
$inputFile = Get-Item -LiteralPath $SdiPath
if ($inputFile.PSIsContainer) { throw 'SdiPath must point to a boot.sdi file.' }
$inputFullPath = $inputFile.FullName
if ($InPlace) {
    $targetFullPath = $inputFullPath
    $backupPath = $inputFullPath + '.bak'
    if (Test-Path -LiteralPath $backupPath) { throw ('Backup already exists: {0}. Move it aside before using -InPlace.' -f $backupPath) }
} elseif ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $directory = [IO.Path]::GetDirectoryName($inputFullPath)
    $stem = [IO.Path]::GetFileNameWithoutExtension($inputFullPath)
    $extension = [IO.Path]::GetExtension($inputFullPath)
    $targetFullPath = Join-Path $directory ($stem + '.labeled' + $extension)
} else { $targetFullPath = [IO.Path]::GetFullPath($OutputPath) }
if (-not $InPlace -and [string]::Equals($targetFullPath, $inputFullPath, [StringComparison]::OrdinalIgnoreCase)) { throw 'OutputPath resolves to the input file. Use -InPlace to replace the source with a backup.' }
if (-not $InPlace -and (Test-Path -LiteralPath $targetFullPath)) { throw ('Output already exists: {0}. Choose another OutputPath.' -f $targetFullPath) }
$fileBytes = [IO.File]::ReadAllBytes($inputFullPath)
$part = Get-SdiPartBlob $fileBytes
$partOffset = $part.Offset
$partLength = $part.Length
if ([Text.Encoding]::ASCII.GetString($fileBytes, $partOffset + 3, 8) -ne 'NTFS    ') { throw 'The SDI PART blob is not an NTFS volume.' }
$bytesPerSector = Get-U16 $fileBytes ($partOffset + 0x0B)
$sectorsPerCluster = [int]$fileBytes[$partOffset + 0x0D]
if ($bytesPerSector -ne 512 -or $sectorsPerCluster -lt 1) { throw 'This script supports standard NTFS SDI volumes with 512-byte sectors.' }
$clusterSize = [long]$bytesPerSector * $sectorsPerCluster
$mftLcn = Get-U64 $fileBytes ($partOffset + 0x30)
$mftMirrorLcn = Get-U64 $fileBytes ($partOffset + 0x38)
$recordSizeCode = [int]$fileBytes[$partOffset + 0x40]
if ($recordSizeCode -gt 127) { $recordSizeCode -= 256 }
if ($recordSizeCode -eq 0) { throw 'The NTFS boot sector has an invalid MFT record-size code.' }
if ($recordSizeCode -gt 0) { $recordSize = [int]($clusterSize * $recordSizeCode) } else { $recordSize = [int][Math]::Pow(2, -$recordSizeCode) }
if ($recordSize -lt 512 -or $recordSize -gt 65536 -or ($recordSize % 512) -ne 0) { throw 'The NTFS MFT record size is invalid or unsupported.' }
$volumeRecordNumber = 3
$primaryRelative = ([long]$mftLcn * $clusterSize) + ($volumeRecordNumber * $recordSize)
$mirrorRelative = ([long]$mftMirrorLcn * $clusterSize) + ($volumeRecordNumber * $recordSize)
if (($primaryRelative + $recordSize) -gt $partLength -or
    ($mirrorRelative + $recordSize) -gt $partLength) {
    throw 'The NTFS MFT or mirror record lies outside the SDI PART blob.'
}
$primaryOffset = [int]($partOffset + $primaryRelative)
$mirrorOffset = [int]($partOffset + $mirrorRelative)
$primary = Read-NtfsFileRecord $fileBytes $primaryOffset $recordSize 512
$mirror = Read-NtfsFileRecord $fileBytes $mirrorOffset $recordSize 512
$primaryName = Get-VolumeNameAttribute $primary.Record
$mirrorName = Get-VolumeNameAttribute $mirror.Record
if ($primaryName.Name -ne $mirrorName.Name) { throw 'The primary and mirrored NTFS volume labels do not match; refusing to edit this SDI.' }
Set-VolumeNameInRecord $primary.Record $Label $primary.UsaOffset $primary.UsaCount 512
Set-VolumeNameInRecord $mirror.Record $Label $mirror.UsaOffset $mirror.UsaCount 512
[Array]::Copy($primary.Record, 0, $fileBytes, $primaryOffset, $recordSize)
[Array]::Copy($mirror.Record, 0, $fileBytes, $mirrorOffset, $recordSize)
$checkPrimary = Read-NtfsFileRecord $fileBytes $primaryOffset $recordSize 512
$checkMirror = Read-NtfsFileRecord $fileBytes $mirrorOffset $recordSize 512
if ((Get-VolumeNameAttribute $checkPrimary.Record).Name -ne $Label -or (Get-VolumeNameAttribute $checkMirror.Record).Name -ne $Label) { throw 'The updated primary or mirrored volume label did not validate.' }
$targetDirectory = [IO.Path]::GetDirectoryName($targetFullPath)
if (-not [IO.Directory]::Exists($targetDirectory)) { [IO.Directory]::CreateDirectory($targetDirectory) | Out-Null }
$temporaryPath = Join-Path $targetDirectory ('.' + [IO.Path]::GetFileName($targetFullPath) + '.' + [Guid]::NewGuid().ToString('N') + '.tmp')
try {
    [IO.File]::WriteAllBytes($temporaryPath, $fileBytes)
    if ($InPlace) {
        [IO.File]::Replace($temporaryPath, $inputFullPath, $backupPath, $true)
        Write-Host ('Updated: {0}' -f $inputFullPath)
        Write-Host ('Backup:  {0}' -f $backupPath)
    } else {
        [IO.File]::Move($temporaryPath, $targetFullPath)
        Write-Host ('Created: {0}' -f $targetFullPath)
        Write-Host ('Source unchanged: {0}' -f $inputFullPath)
    }
    Write-Host ('Volume label: {0}' -f $Label)
} finally {
    if (Test-Path -LiteralPath $temporaryPath) { [IO.File]::Delete($temporaryPath) }
    [System.Windows.MessageBox]::Show('Make sure to place this boot.sdi in the /boot directory of the Windows ISO otherwise, it will not apply!','Boot.sdi Label Changer','OK','Info') | Out-Null
}
