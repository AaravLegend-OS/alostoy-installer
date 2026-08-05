#Requires -PSEdition Desktop
#Requires -Version 5.1
<#
===========================================================================
Compile this with ps2exe for the executable version seen in the installer!
===========================================================================
Use the following build script in this to compile folderbrowse.ps1 into
folderbrowse.exe. It's name is build_folderbrowse.ps1.
#>
# Treat like an actual cmdlet.
[CmdletBinding()]
# Define parameters. WindowTitle, then starting directory.
param(
    [string]$WindowTitle = "Pick a Folder.",
    [int]$Timeout = 0,
    [string]$StartingDirectory = $null
)
# Add the types and assemblies for Windows Presentation Framework, WPF Core, Windows Base and XAML.
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml
function Get-SystemAppTheme {
    try {
        $value = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -ErrorAction Stop
        if ($value -eq 0) { return 'Dark' }
        return 'Light'
    } catch {
        return 'Dark'
    }
}
function Get-ThemeColors {
    $theme = if ($script:ThemeMode -eq 'Auto') { Get-SystemAppTheme } else { $script:ThemeMode }
    switch ($theme) {
        'Light' {
            [pscustomobject]@{
                Bg = '#FFF4F4F4'
                ControlBg = '#FFFFFFFF'
                BorderBrush = '#FFB8B8B8'
                TextBrush = '#FF111111'
                ComboPopupBg = '#FFFFFFFF'
                ComboHoverBg = '#FFF0F0F0'
                ComboSelectedBg = '#FFDADADA'
            }
        }
        default {
            [pscustomobject]@{
                Bg = '#FF000000'
                ControlBg = '#FF101010'
                BorderBrush = '#FF2A2A2A'
                TextBrush = '#FFFFFFFF'
                ComboPopupBg = '#FF101010'
                ComboHoverBg = '#FF2A2A2A'
                ComboSelectedBg = '#FF3A3A3A'
            }
        }
    }
}
function Set-ThemeBrush {
    param(
        [Parameter(Mandatory)][string]$Key,
        [Parameter(Mandatory)][string]$Hex
    )
    $Window.Resources[$Key] = [System.Windows.Media.BrushConverter]::new().ConvertFromString($Hex)
}
function Apply-Theme {
    $colors = Get-ThemeColors
    Set-ThemeBrush -Key 'Bg' -Hex $colors.Bg
    Set-ThemeBrush -Key 'ControlBg' -Hex $colors.ControlBg
    Set-ThemeBrush -Key 'BorderBrushDark' -Hex $colors.BorderBrush
    Set-ThemeBrush -Key 'TextBrushWhite' -Hex $colors.TextBrush
    Set-ThemeBrush -Key 'ComboPopupBg' -Hex $colors.ComboPopupBg
    Set-ThemeBrush -Key 'ComboHoverBg' -Hex $colors.ComboHoverBg
    Set-ThemeBrush -Key 'ComboSelectedBg' -Hex $colors.ComboSelectedBg
    if ($Window) {
        $Window.Background = $Window.Resources['Bg']
        $Window.Foreground = $Window.Resources['TextBrushWhite']
    }
}
# Function to create folder nodes.
function New-FolderNode {
    param([Parameter(Mandatory)][string]$Path)
    $node = [System.Windows.Controls.TreeViewItem]::new()
    $node.Tag = $Path
    $leaf = Split-Path -Path $Path -Leaf
    $node.Header = if ([string]::IsNullOrWhiteSpace($leaf)) { $Path } else { $leaf }
    $dummy = [System.Windows.Controls.TreeViewItem]::new()
    $dummy.Header = 'Loading...'
    [void]$node.Items.Add($dummy)
    $node
}
# Function to load all children in a directory.
function Load-Children {
    param([System.Windows.Controls.TreeViewItem]$Node)
    if ($Node.Items.Count -ne 1 -or $Node.Items[0].Header -ne 'Loading...') { return }
    $path = [string]$Node.Tag
    $Node.Items.Clear()
    try {
        [System.IO.Directory]::GetDirectories($path) | Sort-Object | ForEach-Object {
            [void]$Node.Items.Add((New-FolderNode -Path $_))
        }
    } catch {
        Write-Error "Access is denied. Here is the error information:`r`n`r`n$_"
    }
}
# Function to load all drives that can be selected.
function Refresh-Drives {
    $FolderTree.Items.Clear()
    Get-PSDrive -PSProvider FileSystem | Sort-Object Name | ForEach-Object {
        $rootNode = New-FolderNode -Path $_.Root
        $rootNode.Header = "$($_.Name):\"
        [void]$FolderTree.Items.Add($rootNode)
    }
    $FolderTree.UpdateLayout()
}
# Function to get the currently selected folder path.
function Get-SelectedFolderPath {
    $selected = $FolderTree.SelectedItem
    if ($selected -is [System.Windows.Controls.TreeViewItem] -and $selected.Tag) {
        return [string]$selected.Tag
    }
    return $null
}
# Function to show a topmost message box.
function Display-Message {
    param(
        [string]$Text,
        [System.Windows.MessageBoxButton]$Buttons = [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]$Icon = [System.Windows.MessageBoxImage]::Information
    )
    $OldTopmost = $Window.Topmost
    $Window.Topmost = $true
    $result = [System.Windows.MessageBox]::Show($Window, $Text, "Folder Picker", $Buttons, $Icon)
    $Window.Topmost = $OldTopmost
    return $result
}
# Function to show a topmost input box.
function Display-Prompt {
    param(
        [string]$Title = "Input",
        [string]$Prompt = "Enter value:",
        [string]$DefaultValue = ""
    )
    $oldTopmost = $Window.Topmost
    $Window.Topmost = $true
    $colors = Get-ThemeColors
    [xml]$popupXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="$Title"
        Width="420"
        Height="190"
        WindowStartupLocation="CenterOwner"
        ResizeMode="NoResize"
        ShowInTaskbar="False"
        Topmost="True"
        Background="$($colors.Bg)"
        Foreground="$($colors.TextBrush)"
        BorderThickness="0">
    <Window.Resources>
        <SolidColorBrush x:Key="BlackBg" Color="$($colors.Bg)"/>
        <SolidColorBrush x:Key="BlackBorder" Color="$($colors.BorderBrush)"/>
        <SolidColorBrush x:Key="WhiteText" Color="$($colors.TextBrush)"/>
        <Style TargetType="{x:Type TextBlock}">
            <Setter Property="Background" Value="{StaticResource BlackBg}"/>
            <Setter Property="Foreground" Value="{StaticResource WhiteText}"/>
        </Style>
        <Style TargetType="{x:Type TextBox}">
            <Setter Property="Background" Value="{StaticResource BlackBg}"/>
            <Setter Property="Foreground" Value="{StaticResource WhiteText}"/>
            <Setter Property="BorderBrush" Value="{StaticResource BlackBorder}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="CaretBrush" Value="{StaticResource WhiteText}"/>
        </Style>
        <Style TargetType="{x:Type Button}">
            <Setter Property="Background" Value="{StaticResource BlackBg}"/>
            <Setter Property="Foreground" Value="{StaticResource WhiteText}"/>
            <Setter Property="BorderBrush" Value="{StaticResource BlackBorder}"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>
    </Window.Resources>
    <Border Padding="12" Background="$($colors.Bg)" BorderBrush="$($colors.BorderBrush)" BorderThickness="0">
        <StackPanel Background="$($colors.Bg)">
            <TextBlock x:Name="PromptText"
                       Margin="0,0,0,10"
                       TextWrapping="Wrap"
                       Background="$($colors.Bg)"
                       Foreground="$($colors.TextBrush)"/>
            <TextBox x:Name="InputBox"
                     Height="28"
                     Margin="0,0,0,12"
                     Background="$($colors.Bg)"
                     Foreground="$($colors.TextBrush)"
                     BorderBrush="$($colors.BorderBrush)"
                     CaretBrush="$($colors.TextBrush)"/>
            <StackPanel Orientation="Horizontal"
                        HorizontalAlignment="Right"
                        Background="$($colors.Bg)">
                <Button x:Name="OkBtn"
                        Width="80"
                        Margin="0,0,8,0"
                        Content="OK"
                        Background="$($colors.Bg)"
                        Foreground="$($colors.TextBrush)"
                        BorderBrush="$($colors.BorderBrush)"/>
                <Button x:Name="CancelBtn"
                        Width="80"
                        Content="Cancel"
                        Background="$($colors.Bg)"
                        Foreground="$($colors.TextBrush)"
                        BorderBrush="$($colors.BorderBrush)"/>
            </StackPanel>
        </StackPanel>
    </Border>
</Window>
"@
    $reader = New-Object System.Xml.XmlNodeReader($popupXaml)
    $dialog = [System.Windows.Markup.XamlReader]::Load($reader)
    $dialog.Owner = $Window
    $dialog.Topmost = $true
    $promptText = $dialog.FindName("PromptText")
    $inputBox = $dialog.FindName("InputBox")
    $okBtn = $dialog.FindName("OkBtn")
    $cancelBtn = $dialog.FindName("CancelBtn")
    $promptText.Text = $Prompt
    $inputBox.Text = $DefaultValue
    $script:PopupValue = $null
    $okBtn.Add_Click({
        $script:PopupValue = $inputBox.Text
        $dialog.DialogResult = $true
        $dialog.Close()
    })
    $cancelBtn.Add_Click({
        $script:PopupValue = $null
        $dialog.DialogResult = $false
        $dialog.Close()
    })
    $dialog.Add_ContentRendered({
        $inputBox.Focus()
        $inputBox.SelectAll()
    })
    $null = $dialog.ShowDialog()
    $Window.Topmost = $oldTopmost
    return $script:PopupValue
}
[xml]$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="A folder picker by Aarav Katariya."
        Width="760"
        Height="520"
        WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        WindowStyle="None"
        WindowState="Maximized"
        Topmost="True"
        Background="#FF000000"
        Foreground="#FFFFFFFF">
    <Window.Resources>
        <SolidColorBrush x:Key="Bg" Color="#FF000000"/>
        <SolidColorBrush x:Key="ControlBg" Color="#FF101010"/>
        <SolidColorBrush x:Key="BorderBrushDark" Color="#FF2A2A2A"/>
        <SolidColorBrush x:Key="TextBrushWhite" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="ComboPopupBg" Color="#FF101010"/>
        <SolidColorBrush x:Key="ComboHoverBg" Color="#FF2A2A2A"/>
        <SolidColorBrush x:Key="ComboSelectedBg" Color="#FF3A3A3A"/>
        <Style TargetType="{x:Type TreeView}">
            <Setter Property="Background" Value="{DynamicResource Bg}"/>
            <Setter Property="Foreground" Value="{DynamicResource TextBrushWhite}"/>
            <Setter Property="BorderBrush" Value="{DynamicResource BorderBrushDark}"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>
        <Style TargetType="{x:Type TreeViewItem}">
            <Setter Property="Background" Value="{DynamicResource Bg}"/>
            <Setter Property="Foreground" Value="{DynamicResource TextBrushWhite}"/>
            <Setter Property="Padding" Value="3"/>
            <Setter Property="Margin" Value="0"/>
        </Style>
        <Style TargetType="{x:Type Button}">
            <Setter Property="Background" Value="{DynamicResource ControlBg}"/>
            <Setter Property="Foreground" Value="{DynamicResource TextBrushWhite}"/>
            <Setter Property="BorderBrush" Value="{DynamicResource BorderBrushDark}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8,4"/>
        </Style>
        <Style TargetType="{x:Type ComboBox}">
            <Setter Property="Background" Value="{DynamicResource ControlBg}"/>
            <Setter Property="Foreground" Value="{DynamicResource TextBrushWhite}"/>
            <Setter Property="BorderBrush" Value="{DynamicResource BorderBrushDark}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="4,2"/>
            <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="ScrollViewer.HorizontalScrollBarVisibility" Value="Auto"/>
            <Setter Property="ScrollViewer.VerticalScrollBarVisibility" Value="Auto"/>
            <Setter Property="ScrollViewer.CanContentScroll" Value="True"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ComboBox}">
                        <Grid SnapsToDevicePixels="True">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="24"/>
                            </Grid.ColumnDefinitions>
                            <Border Grid.ColumnSpan="2"
                                    Background="{TemplateBinding Background}"
                                    BorderBrush="{TemplateBinding BorderBrush}"
                                    BorderThickness="{TemplateBinding BorderThickness}"/>
                            <ContentPresenter x:Name="ContentSite"
                                              Grid.Column="0"
                                              Margin="6,2,2,2"
                                              VerticalAlignment="Center"
                                              HorizontalAlignment="Left"
                                              Content="{TemplateBinding SelectionBoxItem}"
                                              ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}"
                                              ContentTemplateSelector="{TemplateBinding ItemTemplateSelector}"
                                              IsHitTestVisible="False"
                                              RecognizesAccessKey="True"/>
                            <ToggleButton Grid.Column="1"
                                          Focusable="False"
                                          ClickMode="Press"
                                          IsChecked="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}"
                                          Background="{TemplateBinding Background}"
                                          BorderBrush="{TemplateBinding BorderBrush}"
                                          BorderThickness="0">
                                <Grid Background="Transparent">
                                    <TextBlock Text="▾"
                                               HorizontalAlignment="Center"
                                               VerticalAlignment="Center"
                                               Foreground="{TemplateBinding Foreground}"
                                               FontSize="11"/>
                                </Grid>
                            </ToggleButton>
                            <Popup x:Name="PART_Popup"
                                   Placement="Bottom"
                                   IsOpen="{TemplateBinding IsDropDownOpen}"
                                   AllowsTransparency="True"
                                   Focusable="False"
                                   PopupAnimation="Slide">
                                <Border MinWidth="{TemplateBinding ActualWidth}"
                                        Background="{DynamicResource ComboPopupBg}"
                                        BorderBrush="{DynamicResource BorderBrushDark}"
                                        BorderThickness="1">
                                    <ScrollViewer Margin="0"
                                                  SnapsToDevicePixels="True"
                                                  CanContentScroll="True">
                                        <ItemsPresenter KeyboardNavigation.DirectionalNavigation="Contained"/>
                                    </ScrollViewer>
                                </Border>
                            </Popup>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="{x:Type ComboBoxItem}">
            <Setter Property="Background" Value="{DynamicResource ComboPopupBg}"/>
            <Setter Property="Foreground" Value="{DynamicResource TextBrushWhite}"/>
            <Setter Property="Padding" Value="6,3"/>
            <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="{DynamicResource ComboHoverBg}"/>
                </Trigger>
                <Trigger Property="IsHighlighted" Value="True">
                    <Setter Property="Background" Value="{DynamicResource ComboHoverBg}"/>
                </Trigger>
                <Trigger Property="IsSelected" Value="True">
                    <Setter Property="Background" Value="{DynamicResource ComboSelectedBg}"/>
                    <Setter Property="Foreground" Value="{DynamicResource TextBrushWhite}"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                    <Setter Property="Foreground" Value="#FF888888"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>
    <Border Background="{DynamicResource Bg}" BorderBrush="{DynamicResource BorderBrushDark}" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="32"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            <Grid x:Name="TitleBar" Grid.Row="0" Background="{DynamicResource Bg}">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <TextBlock x:Name="TitleText"
                           VerticalAlignment="Center"
                           Margin="12,0,0,0"
                           Foreground="{DynamicResource TextBrushWhite}"
                           FontWeight="SemiBold"
                           Text="A folder picker by Aarav Katariya."/>
                <ComboBox x:Name="ThemeComboBox"
                          Grid.Column="1"
                          Width="110"
                          Height="24"
                          Margin="0,4,8,4"
                          VerticalAlignment="Center"
                          SelectedIndex="2">
                    <ComboBoxItem Content="Dark Mode"/>
                    <ComboBoxItem Content="Light Mode"/>
                    <ComboBoxItem Content="Auto"/>
                </ComboBox>
                <Button x:Name="CloseButton"
                        Grid.Column="2"
                        Width="46"
                        Height="32"
                        Content="✕"
                        Background="{DynamicResource Bg}"
                        BorderThickness="0"
                        Foreground="{DynamicResource TextBrushWhite}"
                        Cursor="Hand"/>
            </Grid>
            <Grid Grid.Row="1" Margin="12">
                <TreeView x:Name="FolderTree"
                          Background="{DynamicResource Bg}"
                          Foreground="{DynamicResource TextBrushWhite}"
                          BorderBrush="{DynamicResource BorderBrushDark}"
                          BorderThickness="1"
                          Padding="6"/>
            </Grid>
            <StackPanel Grid.Row="2"
                        Orientation="Horizontal"
                        HorizontalAlignment="Right"
                        Margin="12">
                <Button x:Name="NewFolderButton"
                        Width="100"
                        Height="32"
                        Margin="0,0,8,0"
                        Content="New Folder"/>
                <Button x:Name="RenameButton"
                        Width="100"
                        Height="32"
                        Margin="0,0,8,0"
                        Content="Rename"/>
                <Button x:Name="DeleteButton"
                        Width="100"
                        Height="32"
                        Margin="0,0,8,0"
                        Content="Delete"/>
                <Button x:Name="RefreshButton"
                        Width="100"
                        Height="32"
                        Margin="0,0,8,0"
                        Content="Refresh"/>
                <Button x:Name="OkButton"
                        Width="100"
                        Height="32"
                        Margin="0,0,8,0"
                        Content="OK"/>
                <Button x:Name="CancelButton"
                        Width="100"
                        Height="32"
                        Content="Cancel"/>
            </StackPanel>
        </Grid>
    </Border>
</Window>
"@
# Now read the window and find all the buttons.
$reader = New-Object System.Xml.XmlNodeReader $Xaml
$Window = [System.Windows.Markup.XamlReader]::Load($reader)
$FolderTree = $Window.FindName('FolderTree')
$OkButton = $Window.FindName('OkButton')
$CancelButton = $Window.FindName('CancelButton')
$RefreshButton = $Window.FindName('RefreshButton')
$NewFolderButton = $Window.FindName('NewFolderButton')
$RenameButton = $Window.FindName('RenameButton')
$DeleteButton = $Window.FindName('DeleteButton')
$CloseButton = $Window.FindName('CloseButton')
$TitleBar = $Window.FindName('TitleBar')
$TitleText = $Window.FindName('TitleText')
$ThemeComboBox = $Window.FindName('ThemeComboBox')
$Window.Title = $WindowTitle
$TitleText.Text = $WindowTitle
$script:ThemeMode = 'Auto'
Apply-Theme
# Then map the buttons to the commands.
$TitleBar.Add_MouseLeftButtonDown({
    param($sender, $e)
    if ($e.ChangedButton -eq [System.Windows.Input.MouseButton]::Left) { $Window.DragMove() }
})
$CloseButton.Add_Click({
    $script:SelectedPath = $null
    $Window.DialogResult = $false
    $Window.Close()
})
$ThemeComboBox.Add_SelectionChanged({
    $selected = $ThemeComboBox.SelectedItem
    if ($selected -is [System.Windows.Controls.ComboBoxItem]) {
        switch ([string]$selected.Content) {
            'Dark Mode' { $script:ThemeMode = 'Dark' }
            'Light Mode' { $script:ThemeMode = 'Light' }
            default { $script:ThemeMode = 'Auto' }
        }
        Apply-Theme
    }
})
$FolderTree.AddHandler(
    [System.Windows.Controls.TreeViewItem]::ExpandedEvent,
    [System.Windows.RoutedEventHandler]{
        param($sender, $e)
        $item = $e.OriginalSource
        if ($item -is [System.Windows.Controls.TreeViewItem]) { Load-Children $item }
    }
)
Refresh-Drives # Load or reload all the drives.
# Then start in the starting dir.
if ($StartingDirectory -and (Test-Path -LiteralPath $StartingDirectory)) {
    $target = (Resolve-Path -LiteralPath $StartingDirectory).Path
    foreach ($driveNode in $FolderTree.Items) {
        if ($target.StartsWith([string]$driveNode.Tag, [System.StringComparison]::OrdinalIgnoreCase)) {
            $driveNode.IsExpanded = $true
            Load-Children -Node $driveNode # Load the children.
            break
        }
    }
}
# Initialise the selected path to $null.
$script:SelectedPath = $null
# Map buttons to commands.
$OkButton.Add_Click({
    $selected = $FolderTree.SelectedItem
    if ($selected -and $selected.Tag) {
        $script:SelectedPath = [string]$selected.Tag
        $Window.DialogResult = $true
        $Window.Close()
    }
})
$CancelButton.Add_Click({
    $script:SelectedPath = $null
    $Window.DialogResult = $false
    $Window.Close()
})
$RefreshButton.Add_Click({ Refresh-Drives }) # Refresh button will reload all drives in the system.
$NewFolderButton.Add_Click({
    $parentPath = Get-SelectedFolderPath
    if (-not $parentPath) {
        Display-Message "Please select a folder first." ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }
    $name = Display-Prompt -Title $WindowTitle -Prompt "Enter new folder name:" -DefaultValue "New Folder"
    if ([string]::IsNullOrWhiteSpace($name)) { return }
    $invalid = [IO.Path]::GetInvalidFileNameChars()
    if ($name.IndexOfAny($invalid) -ge 0) {
        Display-Message "That folder name contains invalid characters." ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }
    $newPath = Join-Path -Path $parentPath -ChildPath $name
    if (Test-Path -LiteralPath $newPath) {
        Display-Message "That folder already exists." ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }
    try {
        [void][System.IO.Directory]::CreateDirectory($newPath)
        Refresh-Drives
    } catch {
        Display-Message "Failed to create folder.`r`n`r`n$($_.Exception.Message)" ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Error) | Out-Null
    }
})
$RenameButton.Add_Click({
    $oldPath = Get-SelectedFolderPath
    if (-not $oldPath) {
        Display-Message "Please select a folder first." ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }
    $parentPath = Split-Path -Path $oldPath -Parent
    if (-not $parentPath) {
        Display-Message "You cannot rename the root folder." ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }
    $currentName = Split-Path -Path $oldPath -Leaf
    $newName = Display-Prompt -Title $WindowTitle -Prompt "Enter the new folder name:" -DefaultValue $currentName
    if ([string]::IsNullOrWhiteSpace($newName)) { return }
    $invalid = [IO.Path]::GetInvalidFileNameChars()
    if ($newName.IndexOfAny($invalid) -ge 0) {
        Display-Message "That folder name contains invalid characters." ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }
    $newPath = Join-Path -Path $parentPath -ChildPath $newName
    if (Test-Path -LiteralPath $newPath) {
        Display-Message "A folder with that name already exists." ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }
    try {
        Move-Item -LiteralPath $oldPath -Destination $newPath
        Refresh-Drives
    } catch {
        Display-Message "Failed to rename folder.`r`n`r`n$($_.Exception.Message)" ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Error) | Out-Null
    }
})
$DeleteButton.Add_Click({
    $path = Get-SelectedFolderPath
    if (-not $path) {
        Display-Message "Please select a folder first." ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Warning) | Out-Null
        return
    }
    $result = Display-Message "Delete this folder and everything inside it?`r`n`r`n$path" ([System.Windows.MessageBoxButton]::YesNo) ([System.Windows.MessageBoxImage]::Warning)
    if ($result -ne [System.Windows.MessageBoxResult]::Yes) { return }
    try {
        Remove-Item -LiteralPath $path -Recurse -Force
        Refresh-Drives
    } catch {
        Display-Message "Failed to delete folder.`r`n`r`n$($_.Exception.Message)" ([System.Windows.MessageBoxButton]::OK) ([System.Windows.MessageBoxImage]::Error) | Out-Null
    }
})
# Set window states to borderless and maximised. (Hides taskbar too!)
$Window.WindowState = [System.Windows.WindowState]::Maximized
$Window.WindowStyle = [System.Windows.WindowStyle]::None
$Window.ResizeMode = [System.Windows.ResizeMode]::NoResize
# Force the window to be the topmost.
$Window.Topmost = $true
# Wait for $Timeout seconds so that the user can read messages.
Start-Sleep -Seconds $Timeout
# Clear the screen.
Clear-Host
# Show the User Interface.
$null = $Window.ShowDialog()
# Finally, say out the selected path. (Used by a for /f loop in batch that calls the folder browser.)
if ($SelectedPath) { Write-Output $SelectedPath } else { Write-Output "None" }
# End of folderbrowse.exe. Made by Aarav Katariya with love and care...
# Total line count: 623
