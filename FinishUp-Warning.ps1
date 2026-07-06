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
If you reboot your computer to bios setup, you need to know where the secure boot setting is. It could be in the security tab or even trusted computing or windows os configuration, etc. Make sure you look up your motherboard or computer's bios manual to find out where it is!
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
Si vous redémarrez votre ordinateur pour accéder à la configuration du BIOS, vous devez savoir où se trouve le paramètre de démarrage sécurisé. Il peut se trouver dans l'onglet « Sécurité » ou même dans « Informatique de confiance » ou « Configuration du système d'exploitation Windows », etc. Assurez-vous de consulter le manuel du BIOS de votre carte mère ou de votre ordinateur pour savoir où il se trouve!
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
Wenn Sie Ihren Computer neu starten, um das BIOS-Setup aufzurufen, müssen Sie wissen, wo sich die Secure-Boot-Einstellung befindet. Diese könnte sich in der Registerkarte „Sicherheit“ oder sogar unter „Trusted Computing“ oder „Windows-Betriebssystemkonfiguration“ usw. befinden. Schlagen Sie unbedingt im Handbuch Ihres Motherboards oder Computers nach, um herauszufinden, wo sich diese Einstellung befindet!
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
Si reinicia el ordenador para acceder a la configuración del BIOS, debe saber dónde se encuentra la configuración de arranque seguro. Puede estar en la pestaña de seguridad o incluso en la configuración de confianza del sistema operativo Windows, etc. ¡Asegúrese de consultar el manual de la placa base o del BIOS del ordenador para averiguar dónde se encuentra!
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
Se riavvii il computer per accedere alla configuración del BIOS, devi sapere dove si trova l'impostazione de avvio sicuro. Potrebbe trovarsi nella scheda Sicurezza o anche in Trusted Computing o Configurazione del sistema operativo Windows, ecc. Assicurati di consultare il manuale della scheda madre o del BIOS del computer per scoprire dove si trova!
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
コンピュータを再起動してBIOS設定画面に入った場合、セキュアブート設定の場所を把握しておく必要があります。セキュリティタブや、信頼できるコンピューティング設定、Windows OS構成などにある可能性があります。必ずマザーボードまたはコンピュータのBIOSマニュアルを参照し、設定場所を確認してください！
"@
}
elseif ($Language -eq "ko") {
    if ($DPRKAccent) {
        # North Korean body.
        $text = @"
컴퓨터를 바이오스 설정으로 재시동할 경우 안전 부팅 설정 위치를 알아야 합니다. 보안 탭이나 신뢰할 수 있는 컴퓨팅, 또는 윈도우 운영체제 설정 등에 있을 수 있습니다. 반드시 자기의 메인보드나 컴퓨터 바이오스 설명서를 참고하여 위치를 확인하십시오!
"@
    }
    else {
        # South Korean body.
        $text = @"
컴퓨터를 BIOS 설정으로 재부팅할 경우, 보안 부팅 설정 위치가 어디인지 알아야 합니다. 보안 탭이나 신뢰할 수 있는 컴퓨팅, Windows OS 구성 등 다양한 위치에 있을 수 있습니다. 반드시 메인보드나 컴퓨터의 BIOS 설명서를 참고하여 해당 설정이 어디에 있는지 확인하세요!
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