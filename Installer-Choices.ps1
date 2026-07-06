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
What will you like to do? 7 buttons will show up. Click on the one you want to do.
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
Que souhaitez-vous faire ? 7 boutons apparaîtront. Cliquez sur celui qui vous intéresse.
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
Was möchten Sie tun? Es werden 7 Schaltflächen angezeigt. Klicken Sie auf diejenige, die Sie ausführen möchten.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
¿Qué te gustaría hacer? Aparecerán 7 botones. Haz clic en el que quieras hacer.
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
Cosa ti piacerebbe fare? Appariranno 7 pulsanti. Clicca su quello che desideri fare.
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
何をしたいですか？7つのボタンが表示されます。やりたいものを選択してください。
"@
}
elseif ($Language -eq "ko") {
    if ($DPRKAccent) {
        # North Korean body.
        $text = @"
무엇을 하고 싶습니까? 일곱 개의 단추가 나타납니다. 원하는 단추를 누르십시오.
"@
    }
    else {
        # South Korean body.
        $text = @"
어떤 것을 하고 싶으신가요? 7개의 버튼이 표시됩니다. 원하는 버튼을 클릭하세요.
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