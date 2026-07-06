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
ALOSToy is a new version of any ventoy toolkit that helps you diagnose PC's. I built ALOSToy as the only developer. It is a different toolkit that is meant to modernise that 5.6 year old tool. ALOSToy is the first ventoy toolkit to feature an installer for it's AaravLegend-OS and to feature Google's Terrible OS (ChromeOS (Patched with Brunch to boot on all pc's.)).
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
ALOSToy est une nouvelle version de la boîte à outils Ventoy qui vous aide à diagnostiquer les PC. J'ai développé ALOSToy en tant que seul développeur. Il s'agit d'une boîte à outils différente, destinée à moderniser l'outil vieux de 5,6 ans. ALOSToy est la première boîte à outils Ventoy à proposer un programme d'installation pour son AaravLegend-OS et à intégrer le terrible système d'exploitation de Google (ChromeOS (corrigé avec Brunch pour démarrer sur tous les PC)).
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
ALOSToy ist eine neue Version eines Ventoy-Toolkits, das Ihnen bei der Diagnose von PCs hilft. Ich habe ALOSToy als einziger Entwickler erstellt. Es handelt sich um ein anderes Toolkit, das das 5,6 Jahre alte Tool modernisieren soll. ALOSToy ist das erste Ventoy-Toolkit, das über ein Installationsprogramm für AaravLegend-OS und Googles Terrible OS (ChromeOS (mit Brunch gepatcht, um auf allen PCs zu starten)) verfügt.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
ALOSToy es una nueva versión de cualquier kit de herramientas Ventoy que te ayuda a diagnosticar ordenadores. Yo soy el único desarrollador de ALOSToy. Se trata de un kit de herramientas diferente, diseñado para modernizar la herramienta anterior, que tenía ya 5,6 años. ALOSToy es el primer kit de herramientas Ventoy que incluye un instalador para AaravLegend-OS y el sistema operativo Terrible OS de Google (ChromeOS, parcheado con Brunch para arrancar en todos los ordenadores).
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
ALOSToy è una nuova versione di qualsiasi toolkit ventoy che ti aiuta a diagnosticare i PC. Ho creato ALOSToy come unico sviluppatore. Si tratta di un toolkit diverso, pensato per modernizzare quello vecchio di 5,6 anni. ALOSToy è il primo toolkit Ventoy a disporre di un programma di installazione per il suo AaravLegend-OS e a includere il Terrible OS di Google (ChromeOS (patchato con Brunch per l'avvio su tutti i PC)).
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
ALOSToyは、PCの診断を支援するVentoyツールキットの新バージョンです。ALOSToyは私が単独で開発したツールキットです。5.6年前のツールを現代化するために設計された、従来とは異なるツールキットです。ALOSToyは、AaravLegend-OS用のインストーラーを搭載した初のVentoyツールキットであり、Googleの「Terrible OS」(ChromeOS (全PCで起動可能なBrunchパッチ適用版)) を特徴としています。
"@
}
elseif ($Language -eq "ko") {
    if ($DPRKAccent) {
        # North Korean body.
        $text = @"
알로스토이는 개인용 컴퓨터를 진단하는 데 도움을 주는 벤토이 도구 모음의 새로운 버전입니다. 저는 유일한 개발자로서 알로스토이를 건설하였습니다. 이는 5.6년 된 도구를 현대화하기 위한 다른 도구 모음입니다. 알로스토이는 자체 아라브레전드 운영체제 설치 기능을 갖춘 첫 번째 벤토이 도구 모음이며, 구글의 열악한 운영체제(크롬 운영체제(모든 개인용 컴퓨터에서 구동되도록 브런치로 패치된))를 지원합니다.
"@
    }
    else {
        # South Korean body.
        $text = @"
ALOSToy는 PC 진단을 돕는 모든 Ventoy 툴킷의 새 버전입니다. ALOSToy는 제가 단독 개발자로 제작했습니다. 5.6년 된 기존 도구를 현대화하기 위해 고안된 차별화된 툴킷입니다. ALOSToy는 AaravLegend-OS용 설치 프로그램을 탑재한 최초의 벤토이 툴킷이며, 구글의 ‘끔찍한 OS’(ChromeOS, 모든 PC에서 부팅 가능하도록 Brunch 패치 적용)를 지원하는 최초의 벤토이 툴킷이기도 합니다.
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