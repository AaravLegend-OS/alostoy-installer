param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('en','fr','de','es','it','ja','ko')]
    [string]$Language,
    [switch]$DPRKAccent
)
# Require language to be set to Korean for North Korean dialects.
if ($Language -ne 'ko' -and $DPRKAccent) {
    Write-Error "You have not selected Korean (ko) as the language. Therefore, you cannot display the text in a North Korean accent."
    exit 1
}
if ($Language -eq "en") {
    # English body.
    $text = @"


The size requirements for ALOSToy Standard are: 64GB without extensions and 128GB with extensions. If you try to install Extensions with a 64GB drive, we will stop you.
The size requirements for ALOSToy Extended are: Any USB drive that has over 128GB in storage. If you try to install the extended version with a 64GB or 128GB drive, we will stop you.
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"


Les exigences en matière de taille pour ALOSToy Standard sont les suivantes : 64 Go sans extensions et 128 Go avec extensions. Si vous essayez d'installer des extensions avec un disque de 64 Go, nous vous en empêcherons.
Les exigences en matière de taille pour ALOSToy Extended sont les suivantes : tout disque USB disposant d'une capacité de stockage supérieure à 128 Go. Si vous essayez d'installer la version étendue avec un disque de 64 Go ou 128 Go, nous vous en empêcherons.
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"


Die Größenanforderungen für ALOSToy Standard sind: 64 GB ohne Erweiterungen und 128 GB mit Erweiterungen. Wenn Sie versuchen, Erweiterungen mit einem 64-GB-Laufwerk zu installieren, werden wir Sie daran hindern.
Die Größenanforderungen für ALOSToy Extended sont: Jedes USB-Laufwerk mit einer Speicherkapazität von mehr als 128 GB. Wenn Sie versuchen, die erweiterte Version mit einem 64-GB- oder 128-GB-Laufwerk zu installieren, werden wir Sie daran hindern.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"


Los requisitos de tamaño para ALOSToy Standard son: 64 GB sin extensiones y 128 GB con extensiones. Si intenta instalar extensiones con una unidad de 64 GB, se lo impediremos.
Los requisitos de tamaño para ALOSToy Extended sont: cualquier unidad USB que tenga más de 128 GB de almacenamiento. Si intenta instalar la versión extendida con una unidad de 64 GB o 128 GB, se lo impediremos.
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"


I requisiti di spazio per ALOSToy Standard sono: 64 GB senza estensioni e 128 GB con estensioni. Se provi a installare le estensioni con un'unità da 64 GB, ti impediremo di farlo.
I requisiti di spazio per ALOSToy Extended sono: qualsiasi unità USB con oltre 128 GB di spazio di archiviazione. Se provi a installare la versión estesa con un'unità da 64 GB o 128 GB, ti impediremo di farlo.
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"


ALOSToy Standardの容量要件は、拡張機能なしの場合64GB、拡張機能ありの場合128GBです。64GBのドライブで拡張機能をインストールしようとすると、インストールを停止します。
ALOSToy Extendedの容量要件は、ストレージ容量が128GBを超えるUSBドライブです。64GBまたは128GBのドライブで拡張版をインストールしようとすると、インストールを停止します。
"@
}
elseif ($Language -eq "ko") {
    if ($DPRKAccent) {
        # North Korean body.
        $text = @"


ALOSToy 표준판의 용량 요구사항은 다음과 같습니다: 확장기능 없이 64GB, 확장기능 포함시 128GB입니다. 64GB 드라이브로 확장기능 설치를 시도할 경우 차단됩니다.
ALOSToy 확장판의 용량 요구사항은 다음과 같습니다: 저장용량 128GB를 초과하는 USB 드라이브입니다. 64GB 또는 128GB 드라이브로 확장판 설치를 시도할 경우 차단됩니다.
"@
    }
    else {
        # South Korean body.
        $text = @"


ALOSToy Standard의 용량 요구 사항은 다음과 같습니다: 확장 기능 없이 64GB, 확장 기능 포함 시 128GB입니다. 64GB 드라이브로 확장 기능을 설치하려고 하면 설치가 차단됩니다.
ALOSToy Extended의 용량 요구 사항은 다음과 같습니다: 저장 용량이 128GB를 초과하는 모든 USB 드라이브입니다. 64GB 또는 128GB 드라이브로 확장 버전을 설치하려고 하면 설치가 차단됩니다.
"@
    }
}
else {
    # If the user's language is not supported.
    Write-Error "No text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0