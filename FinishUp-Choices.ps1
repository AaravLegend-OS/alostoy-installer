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
Now that ALOSToy is finished installing, do you want to exit, reboot your computer to it's firmware to disable Secure Boot or perform another installation?
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
Maintenant que l'installation d'ALOSToy est terminée, souhaitez-vous quitter, redémarrer votre ordinateur en mode firmware pour désactiver le Secure Boot ou effectuer une autre installation?
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
Nachdem die Installation von ALOSToy nun abgeschlossen ist, möchten Sie das Programm beenden, Ihren Computer neu starten, um Secure Boot über die Firmware zu deaktivieren, oder eine weitere Installation durchführen?
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
Ahora que se ha completado la instalación de ALOSToy, ¿deseas salir, reiniciar el ordenador en modo firmware para desactivar el arranque seguro o realizar otra instalación?
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
Ora che l'installazione di ALOSToy è terminata, desideri uscire, riavviare il computer in modalità firmware per disabilitare Secure Boot oppure eseguire un'altra installazione?
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
ALOSToyのインストールが完了しました。終了しますか、Secure Bootを無効にするためにコンピュータをファームウェアモードで再起動しますか、それとも別のインストールを実行しますか？
"@
}
elseif ($Language -eq "ko") {
    if ($DPRKAccent) {
        # North Korean body.
        $text = @"
ALOSToy 설치가 완료되었습니다. 종료하시겠습니까, 아니면 컴퓨터를 펌웨어로 재시작하여 Secure Boot를 비활성화하시겠습니까, 또는 다른 설치를 수행하시겠습니까?
"@
    }
    else {
        # South Korean body.
        $text = @"
ALOSToy 설치가 완료되었습니다. 이제 종료하시겠습니까, 아니면 컴퓨터를 펌웨어 모드로 재부팅하여 보안 부팅을 비활성화하시겠습니까, 아니면 다른 설치를 진행하시겠습니까?
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