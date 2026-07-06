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
4 buttons which go by: Change Configuration, Install Ventoy Onto ${env:drivepath}, Update Ventoy On ${env:drivepath}, and Ventoy Is Already Installed On $env:drivepath will now show up. Click on one of them.
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
Quatre boutons intitulés: Modifier la configuration, Installer Ventoy sur ${env:drivepath}, Mettre à jour Ventoy sur ${env:drivepath} et Ventoy est déjà installé sur $env:drivepath s'affichent désormais. Cliquez sur l'un d'entre eux.
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
Es werden nun vier Schaltflächen angezeigt: „Konfiguration ändern“, „Ventoy auf $env:drivepath installieren“, „Ventoy auf $env:drivepath aktualisieren“ und „Ventoy ist bereits auf $env:drivepath installiert“. Klicken Sie auf eine davon.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
Ahora aparecerán cuatro botones: Cambiar configuración, Instalar Ventoy en ${env:drivepath}, Actualizar Ventoy en $env:drivepath y Ventoy ya está instalado en ${env:drivepath}. Haz clic en uno de ellos.
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
Verranno visualizzati 4 pulsanti denominati: Modifica configurazione, Installa Ventoy su ${env:drivepath}, Aggiorna Ventoy su $env:drivepath e Ventoy è già installato su ${env:drivepath}. Clicca su uno di essi.
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
「設定の変更」、「 ${env:drivepath} にVentoyをインストール」、「 ${env:drivepath} 上のVentoyを更新」、「 ${env:drivepath} にVentoyがすでにインストールされています」という4つのボタンが表示されます。いずれかをクリックしてください。
"@
}
elseif ($Language -eq "ko") {
    if ($DPRKAccent) {
        # North Korean body.
        $text = @"
"구성 변경", "${env:drivepath} 에 벤토이 설치", "${env:drivepath} 에 벤토이 갱신", "${env:drivepath} 에 이미 벤토이가 설치되어 있습니다"라는 4개의 버튼이 나타납니다. 그 중 하나를 누르십시오.
"@
    }
    else {
        # South Korean body.
        $text = @"
이제 ‘구성 변경’, ‘${env:drivepath} 에 Ventoy 설치’, ‘${env:drivepath} 에서 Ventoy 업데이트’, ‘${env:drivepath} 에 Ventoy가 이미 설치되어 있음’이라는 4개의 버튼이 표시됩니다. 그중 하나를 클릭하세요.
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