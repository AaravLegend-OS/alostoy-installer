param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('en','fr','de','es','it','ja','ko')]
    [string]$Language
)
$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(120,10000)
if ($Language -eq "en") {
    # English body.
    $text = @"
ALOSToy V1.0 Standard - License agreement Copyright (C) 2026 AaravLegend-Inc

Did you pay for this? If so, you were SCAMMED and may have malware instead!

This toolkit is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This toolkit has been created in the hope that it will be useful, but WITHOUT ANY WARRANTY, not even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. For more information, see the GNU General Public License.
You should have received a copy of the GNU General Public License along with this toolkit. If not, see https://www.gnu.org/licenses/.

SECTION 1 - DEFINITIONS
"Toolkit" refers to ALOSToy v1.0 Standard, including its source files, isos, documentation and any related files. "You" refers to the licensee or user of the toolkit. "Modified version" refers to any derivative work based on the toolkit.

SECTION 2 - AVAILABILITY OF SOURCE CODE
The complete source code of ALOSToy v1.0 Standard must be made available to anyone to whom the object code is created. This ensures transparency, allows others to study, and modify the code. There are also freely available extensions that include installation media for reinstalling a popular OS. These can be found here.

SECTION 3 - MODIFICATION CONDITIONS
You are allowed to modify the source code and create derivative works under the following conditions:
You may base projects using this.
This toolset may be copied and forked to get a glimpse at Ventoy's advanced customisation.
You must not misrepresent the origin of the software.
Derivative works must also be licensed under the GNU GPL.
You may reverse engineer this software.
If you want to find the source product for ALOSToy Standard, please visit https://www.ventoy.net.

SECTION 4 - REDISTRIBUTION
You may copy and distribute verbatim copies of the Toolkit source files as you receive them, in any medium, if you:
Conspicuously and appropriately publish on each copy an appropriate copyright notice.
Keep intact all notices that this License applies to the code.
Give all recipients a copy of this License along with the toolkit.

SECTION 5 - NO WARRANTY
THE TOOLKIT GIVES NO WARRANTY, TO THE EXTENT PERMITTED BY APPLICABLE LAW. THE TOOLKIT IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

SECTION 6 - LIMITATION OF LIABILITY
IN NO EVENT, UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING, SHALL ANY COPYRIGHT HOLDER BE LIABLE TO YOU FOR ANY DAMAGES, INCLUDING GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE TOOLKIT.

SECTION 7 - CONTACT INFORMATION
For enquiries, bug reports or licensing questions, please contact via the following means:
Email: aaravkatariya2012alt@gmail.com
Alt Email: aaravkatariya2012@gmail.com
Phone: +447492947265
This license is based on the GNU General Public License v3. See https://www.gnu.org/licenses/gpl-3.0.html for complete terms.
This is the end of the license terms. Enjoy ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "fr") {
    # French body.
    $text = @"
ALOSToy V1.0 Standard - Contrat de licence Copyright (C) 2026 AaravLegend-Inc

Avez-vous payé pour cela ? Si oui, vous avez été victime d'une ARNAQUE et vous avez peut-être reçu un logiciel malveillant à la place!

Ce kit d'outils est un logiciel libre : vous pouvez le redistribuer et/ou le modifier selon les termes de la licence publique générale GNU telle que publiée par la Free Software Foundation, soit la version 3 de la licence, soit (à votre choix) toute version ultérieure.
Cette boîte à outils a été créée dans l'espoir qu'elle sera utile, mais SANS AUCUNE GARANTIE, pas même la garantie implicite de QUALITÉ MARCHANDE ou d'ADÉQUATION À UN USAGE PARTICULIER. Pour plus d'informations, consultez la licence publique générale GNU.
Vous devriez avoir reçu une copie de la licence publique générale GNU avec cette boîte à outils. Si ce n'est pas le cas, consultez https://www.gnu.org/licenses/.

SECTION 1 - DÉFINITIONS
Le terme « boîte à outils » désigne ALOSToy v1.0 Standard, y compris ses fichiers source, ses images ISO, sa documentation et tous les fichiers associés. Le terme « vous » désigne le titulaire de la licence ou l'utilisateur de la boîte à outils. Le terme « version modifiée » désigne toute œuvre dérivée basée sur la boîte à outils.

SECTION 2 - DISPONIBILITÉ DU CODE SOURCE
Le code source complet d'ALOSToy v1.0 Standard doit être mis à la disposition de toute personne pour laquelle le code objet est créé. Cela garantit la transparence et permet à d'autres personnes d'étudier et de modifier le code. Il existe également des extensions disponibles gratuitement qui comprennent des supports d'installation pour réinstaller un système d'exploitation populaire. Vous les trouverez ici.

SECTION 3 - CONDITIONS DE MODIFICATION
Vous êtes autorisé à modifier le code source et à créer des œuvres dérivées dans les conditions suivantes :
Vous pouvez baser vos projets sur celui-ci.
Cet ensemble d'outils peut être copié et dupliqué pour avoir un aperçu de la personnalisation avancée de Ventoy.
Vous ne devez pas déformer l'origine du logiciel.
Les œuvres dérivées doivent également être sous licence GNU GPL.
Vous pouvez procéder à une ingénierie inverse de ce logiciel.
Si vous souhaitez trouver le produit source pour ALOSToy Standard, veuillez consulter le site https://www.ventoy.net.

SECTION 4 - REDISTRIBUTION
Vous pouvez copier et distribuer des copies conformes des fichiers source du Toolkit tels que vous les avez reçus, sur tout support, à condition de :
Publiez de manière visible et appropriée sur chaque copie une mention de copyright appropriée.
Conservez intactes toutes les mentions indiquant que cette licence s'applique au code.
Donnez à tous les destinataires une copie de cette licence avec la boîte à outils.

SECTION 5 - ABSENCE DE GARANTIE
LA BOÎTE À OUTILS NE DONNE AUCUNE GARANTIE, DANS LA MESURE PERMISE PAR LA LOI APPLICABLE. LA BOÎTE À OUTILS EST FOURNIE « TELLE QUELLE », SANS GARANTIE D'AUCUNE SORTE, EXPRESSE OU IMPLICITE, Y COMPRIS, MAIS SANS S'Y LIMITER, LES GARANTIES IMPLICITES DE QUALITÉ MARCHANDE ET D'ADÉQUATION À UN USAGE PARTICULIER.

SECTION 6 - LIMITATION DE RESPONSABILITÉ
EN AUCUN CAS, SAUF SI LA LOI APPLICABLE L'EXIGE OU SI CELA A ÉTÉ CONVENU PAR ÉCRIT, LES TITULAIRES DE DROITS D'AUTEUR NE POURRONT ÊTRE TENUS RESPONSABLES ENVERS VOUS DE TOUT DOMMAGE, Y COMPRIS LES DOMMAGES GÉNÉRAUX, SPÉCIAUX, ACCESSOIRES OU CONSÉCUTIFS À L' , RÉSULTANT DE L'UTILISATION OU DE L'INCAPACITÉ À UTILISER LA BOÎTE À OUTILS.

SECTION 7 - COORDONNÉES
Pour toute demande de renseignements, signalement de bogues ou question relative aux licences, veuillez nous contacter par les moyens suivants :
E-mail : aaravkatariya2012alt@gmail.com
Autre e-mail : aaravkatariya2012@gmail.com
Téléphone : +447492947265
Cette licence est basée sur la licence publique générale GNU v3. Voir https://www.gnu.org/licenses/gpl-3.0.html pour les conditions complètes.
Ceci est la fin des conditions de licence. Profitez bien d'ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "de") {
    # German body.
    $text = @"
ALOSToy V1.0 Standard – Lizenzvereinbarung Copyright (C) 2026 AaravLegend-Inc

Haben Sie dafür bezahlt? Wenn ja, wurden Sie BETROGEN und haben möglicherweise stattdessen Malware erhalten!
Dieses Toolkit ist freie Software: Sie können es unter den Bedingungen der GNU General Public License, wie von der Free Software Foundation veröffentlicht, entweder in der Version 3 der Lizenz oder (nach Ihrer Wahl) in einer späteren Version weitergeben und/oder modifizieren.
Dieses Toolkit wurde in der Hoffnung erstellt, dass es nützlich ist, jedoch OHNE JEGLICHE GARANTIE, auch ohne die implizite Garantie der MARKTGÄNGIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK. Weitere Informationen finden Sie in der GNU General Public License.
Sie sollten zusammen mit diesem Toolkit eine Kopie der GNU General Public License erhalten haben. Falls nicht, finden Sie diese unter https://www.gnu.org/licenses/.

ABSCHNITT 1 – DEFINITIONEN
„Toolkit” bezieht sich auf ALOSToy v1.0 Standard, einschließlich seiner Quelldateien, ISOs, Dokumentation und aller zugehörigen Dateien. „Sie” bezieht sich auf den Lizenznehmer oder Nutzer des Toolkits. „Modifizierte Version” bezieht sich auf alle abgeleiteten Werke, die auf dem Toolkit basieren.

ABSCHNITT 2 – VERFÜGBARKEIT DES QUELLCODES
Der vollständige Quellcode von ALOSToy v1.0 Standard muss allen Personen zur Verfügung gestellt werden, für die der Objektcode erstellt wird. Dies gewährleistet Transparenz und ermöglicht es anderen, den Code zu studieren und zu modifizieren. Es gibt auch frei verfügbare Erweiterungen, die Installationsmedien für die Neuinstallation eines gängigen Betriebssystems enthalten. Diese finden Sie hier.

ABSCHNITT 3 – ÄNDERUNGSBEDINGUNGEN
Sie dürfen den Quellcode unter den folgenden Bedingungen ändern und abgeleitete Werke erstellen:
Sie können Projekte auf dieser Grundlage erstellen.
Dieses Toolset darf kopiert und geforkt werden, um einen Einblick in die erweiterten Anpassungsmöglichkeiten von Ventoy zu erhalten.
Sie dürfen die Herkunft der Software nicht falsch darstellen.
Abgeleitete Werke müssen ebenfalls unter der GNU GPL lizenziert werden.
Sie dürfen diese Software zurückentwickeln.
Wenn Sie das Quellprodukt für ALOSToy Standard suchen, besuchen Sie bitte https://www.ventoy.net.

ABSCHNITT 4 – WEITERVERBREITUNG
Sie dürfen unveränderte Kopien der Toolkit-Quelldateien, wie Sie sie erhalten haben, auf jedem Medium kopieren und verbreiten, wenn Sie:
auf jeder Kopie deutlich sichtbar und in angemessener Weise einen entsprechenden Copyright-Vermerk anbringen.
alle Hinweise, dass diese Lizenz für den Code gilt, unverändert beibehalten.
Sie allen Empfängern zusammen mit dem Toolkit eine Kopie dieser Lizenz aushändigen.

ABSCHNITT 5 – KEINE GEWÄHRLEISTUNG
DAS TOOLKIT GIBT KEINE GEWÄHRLEISTUNG, SOWEIT DIES NACH GELTENDEM RECHT ZULÄSSIG IST. DAS TOOLKIT WIRD „WIE BESEHEN“ OHNE JEGLICHE AUSDRÜCKLICHE ODER STILLSCHWEIGENDE GEWÄHRLEISTUNG, EINSCHLIESSLICH, ABER NICHT BESCHRÄNKT AUF DIE STILLSCHWEIGENDE GEWÄHRLEISTUNG DER MARKTGÄNGIGKEIT UND EIGNUNG FÜR EINEN BESTIMMTEN ZWECK, BEREITGESTELLT.

ABSCHNITT 6 – HAFTUNGSBESCHRÄNKUNG
IN KEINEM FALL, SOFERN NICHT GESETZLICH VORGESCHRIEBEN ODER SCHRIFTLICH VEREINBART, HAFTET EIN URHEBERRECHTSINHABER IHNEN GEGENÜBER FÜR SCHÄDEN, EINSCHLIESSLICH ALLGEMEINER, BESONDERER, ZUFÄLLIGER ODER FOLGESCHÄDEN , DIE SICH AUS DER NUTZUNG ODER DER UNMÖGLICHKEIT DER NUTZUNG DES TOOLKITS ERGEBEN.

ABSCHNITT 7 – KONTAKTINFORMATIONEN
Bei Anfragen, Fehlermeldungen oder Fragen zur Lizenzierung wenden Sie sich bitte über folgende Kanäle an uns:
E-Mail: aaravkatariya2012alt@gmail.com
Alternative E-Mail: aaravkatariya2012@gmail.com
Telefon: +447492947265
Diese Lizenz basiert auf der GNU General Public License v3. Die vollständigen Bedingungen finden Sie unter https://www.gnu.org/licenses/gpl-3.0.html.
Dies ist das Ende der Lizenzbedingungen. Viel Spaß mit ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "es") {
    # Spanish body.
    $text = @"
ALOSToy V1.0 Estándar - Acuerdo de licencia Copyright (C) 2026 AaravLegend-Inc

¿Ha pagado por esto? Si es así, ¡le han ESTAFADO y es posible que tenga malware en su lugar!
Este kit de herramientas es software libre: puede redistribuirlo y/o modificarlo bajo los términos de la Licencia Pública General GNU publicada por la Free Software Foundation, ya sea la versión 3 de la Licencia o (a su elección) cualquier versión posterior.
Este kit de herramientas se ha creado con la esperanza de que sea útil, pero SIN NINGUNA GARANTÍA, ni siquiera la garantía implícita de COMERCIABILIDAD o IDONEIDAD PARA UN FIN DETERMINADO. Para obtener más información, consulte la Licencia Pública General GNU.
Debería haber recibido una copia de la Licencia Pública General GNU junto con este kit de herramientas. Si no es así, consulte https://www.gnu.org/licenses/.

SECCIÓN 1 - DEFINICIONES
«Kit de herramientas» se refiere a ALOSToy v1.0 Standard, incluidos sus archivos fuente, isos, documentación y cualquier archivo relacionado. «Usted» se refiere al licenciatario o usuario del kit de herramientas. «Versión modificada» se refiere a cualquier trabajo derivado basado en el kit de herramientas.

SECCIÓN 2 - DISPONIBILIDAD DEL CÓDIGO FUENTE
El código fuente completo de ALOSToy v1.0 Standard debe estar a disposición de cualquier persona para la que se cree el código objeto. Esto garantiza la transparencia y permite que otros estudien y modifiquen el código. También hay extensiones disponibles gratuitamente que incluyen medios de instalación para reinstalar un sistema operativo popular. Se pueden encontrar aquí.

SECCIÓN 3 - CONDICIONES DE MODIFICACIÓN
Se permite modificar el código fuente y crear obras derivadas bajo las siguientes condiciones:
Puede basar proyectos en su uso.
Este conjunto de herramientas se puede copiar y bifurcar para echar un vistazo a la personalización avanzada de Ventoy.
No debe tergiversar el origen del software.
Las obras derivadas también deben tener licencia GNU GPL.
Puede realizar ingeniería inversa en este software.
Si desea encontrar el producto original de ALOSToy Standard, visite https://www.ventoy.net.

SECCIÓN 4: REDISTRIBUCIÓN
Puede copiar y distribuir copias literales de los archivos fuente del kit de herramientas tal y como los recibe, en cualquier medio, si:
Publica de forma visible y adecuada en cada copia un aviso de derechos de autor apropiado.
Mantiene intactos todos los avisos de que esta licencia se aplica al código.
Entregue a todos los destinatarios una copia de esta licencia junto con el kit de herramientas.

SECCIÓN 5 - SIN GARANTÍA
EL KIT DE HERRAMIENTAS NO OFRECE NINGUNA GARANTÍA, EN LA MEDIDA EN QUE LO PERMITA LA LEY APLICABLE. EL KIT DE HERRAMIENTAS SE PROPORCIONA «TAL CUAL», SIN GARANTÍA DE NINGÚN TIPO, YA SEA EXPRESA O IMPLÍCITA, INCLUIDAS, ENTRE OTRAS, LAS GARANTÍAS IMPLÍCITAS DE COMERCIABILIDAD E IDONEIDAD PARA UN FIN DETERMINADO.

SECCIÓN 6: LIMITACIÓN DE RESPONSABILIDAD
EN NINGÚN CASO, A MENOS QUE LO EXIJA LA LEY APLICABLE O SE ACUERDE POR ESCRITO, LOS TITULARES DE LOS DERECHOS DE AUTOR SERÁN RESPONSABLES ANTE USTED POR NINGÚN DAÑO, INCLUIDOS LOS DAÑOS GENERALES, ESPECIALES, INCIDENTALES O CONSECUENCIALES ES QUE SURJAN DEL USO O LA IMPOSIBILIDAD DE USAR EL KIT DE HERRAMIENTAS.

SECCIÓN 7 - INFORMACIÓN DE CONTACTO
Para consultas, informes de errores o preguntas sobre licencias, póngase en contacto con nosotros a través de los siguientes medios:
Correo electrónico: aaravkatariya2012alt@gmail.com
Correo electrónico alternativo: aaravkatariya2012@gmail.com
Teléfono: +447492947265
Esta licencia se basa en la Licencia Pública General GNU v3. Consulte https://www.gnu.org/licenses/gpl-3.0.html para conocer los términos completos.
Aquí finalizan los términos de la licencia. Disfrute de ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "it") {
    # Italian body.
    $text = @"
ALOSToy V1.0 Standard - Contratto di licenza Copyright (C) 2026 AaravLegend-Inc

Hai pagato per questo? Se sì, sei stato TRUFFATO e potresti avere un malware!

Questo toolkit è un software gratuito: puoi ridistribuirlo e/o modificarlo secondo i termini della GNU General Public License pubblicata dalla Free Software Foundation, sia nella versione 3 della Licenza, sia (a tua discrezione) in qualsiasi versione successiva.
Questo toolkit è stato creato nella speranza che possa essere utile, ma SENZA ALCUNA GARANZIA, nemmeno la garanzia implicita di COMMERCIABILITÀ o IDONEITÀ PER UN PARTICOLARE SCOPO. Per ulteriori informazioni, consulta la GNU General Public License.
Dovresti aver ricevuto una copia della GNU General Public License insieme a questo toolkit. In caso contrario, consulta https://www.gnu.org/licenses/.

SEZIONE 1 - DEFINIZIONI
Per "Toolkit" si intende ALOSToy v1.0 Standard, inclusi i file sorgente, le immagini ISO, la documentazione e qualsiasi file correlato. Per "Utente" si intende il licenziatario o l'utente del toolkit. Per "Versione modificata" si intende qualsiasi opera derivata basata sul toolkit.

SEZIONE 2 - DISPONIBILITÀ DEL CODICE SORGENTE
Il codice sorgente completo di ALOSToy v1.0 Standard deve essere reso disponibile a chiunque abbia creato il codice oggetto. Ciò garantisce la trasparenza e consente ad altri di studiare e modificare il codice. Sono inoltre disponibili estensioni gratuite che includono supporti di installazione per reinstallare un sistema operativo diffuso. Queste sono disponibili qui.

SEZIONE 3 - CONDIZIONI DI MODIFICA
È consentito modificare il codice sorgente e creare opere derivate alle seguenti condizioni:
È possibile basare progetti utilizzando questo.
Questo set di strumenti può essere copiato e biforcato per avere un assaggio della personalizzazione avanzata di Ventoy.
Non è consentito travisare l'origine del software.
Anche le opere derivate devono essere concesse in licenza ai sensi della GNU GPL.
È possibile decodificare questo software.
Se desiderate trovare il prodotto sorgente per ALOSToy Standard, visitate il sito https://www.ventoy.net.

SEZIONE 4 - RIDISTRIBUZIONE
È possibile copiare e distribuire copie fedeli dei file sorgente del Toolkit così come ricevuti, su qualsiasi supporto, a condizione che:
Pubblicare in modo visibile e appropriato su ciascuna copia un'adeguata nota sul copyright.
Mantenere intatti tutti gli avvisi che indicano che la presente Licenza si applica al codice.
Fornire a tutti i destinatari una copia della presente Licenza insieme al toolkit.

SEZIONE 5 - ESCLUSIONE DI GARANZIA
IL TOOLKIT NON FORNISCE ALCUNA GARANZIA, NEI LIMITI CONSENTITI DALLA LEGGE APPLICABILE. IL TOOLKIT VIENE FORNITO "COSÌ COM'È" SENZA ALCUN TIPO DI GARANZIA, ESPLICITA O IMPLICITA, INCLUSE, A TITOLO ESEMPLIFICATIVO MA NON ESAUSTIVO, LE GARANZIE IMPLICITE DI COMMERCIABILITÀ E IDONEITÀ PER UN PARTICOLARE SCOPO.

SEZIONE 6 - LIMITAZIONE DI RESPONSABILITÀ
IN NESSUN CASO, SALVO QUANTO PREVISTO DALLA LEGGE APPLICABILE O CONCORDATO PER ISCRITTO, I TITOLARI DEL DIRITTO D'AUTORE SARANNO RESPONSABILI NEI CONFRONTI DELL'UTENTE PER EVENTUALI DANNI, INCLUSE LE PERDITE GENERALI, SPECIALI, INCIDENTALI O CONSEGUENTI I DERIVANTI DALL'UTILIZZO O DALL'IMPOSSIBILITÀ DI UTILIZZARE IL TOOLKIT.

SEZIONE 7 - INFORMAZIONI DI CONTATTO
Per richieste di informazioni, segnalazioni di bug o domande relative alle licenze, contattare tramite i seguenti mezzi:
E-mail: aaravkatariya2012alt@gmail.com
Email alternativa: aaravkatariya2012@gmail.com
Telefono: +447492947265
La presente licenza è basata sulla GNU General Public License v3. Per i termini completi, consultare https://www.gnu.org/licenses/gpl-3.0.html.
Questo è il termine dei termini di licenza. Buon divertimento con ALOSToy v1.0 Standard.
"@
}
elseif ($Language -eq "ja") {
    # Japanese body.
    $text = @"
ALOSToy V1.0 Standard - ライセンス契約著作権 (C) 2026 AaravLegend-Inc

これは購入したものですか？もしそうなら、あなたは詐欺に遭い、マルウェアを入手した可能性があります！

このツールキットはフリーソフトウェアです：フリーソフトウェア財団が公開したGNU一般公衆利用許諾契約書（バージョン3または（任意で）それ以降のバージョン）の条件に基づき、再配布および／または改変が可能です。
このツールキットは有用であることを願って作成されましたが、いかなる保証もありません。商品性や特定目的への適合性に関する黙示の保証すら含まれません。詳細はGNU一般公衆利用許諾契約書を参照してください。
本ツールキットにはGNU一般公衆利用許諾契約書の写しが同封されているはずです。同封されていない場合は、https://www.gnu.org/licenses/ をご覧ください。

第1条 - 定義
「ツールキット」とは、ALOSToy v1.0 Standard（ソースファイル、ISOイメージ、ドキュメント、および関連ファイルを含む）を指します。「あなた」とは、ツールキットのライセンシーまたはユーザーを指します。「改変版」とは、ツールキットに基づくあらゆる派生作品を指します。
セクション2 - ソースコードの提供

ALOSToy v1.0 Standardの完全なソースコードは、オブジェクトコードが生成されたすべての者に提供されなければなりません。これ により透明性が確保され、他者がコードを研究・修正することが可能となります。また、人気OSの再インストール用インストールメディアを含む拡張機能も無料で利用可能です。これらはここで入手できます。
セクション3 - 改変条件

以下の条件下でソースコードの改変および派生作品の作成が許可されます：
本ツールセットを基にしたプロジェクトを作成できます。
本ツールセットは、Ventoyの高度なカスタマイズを把握するために複製・フォークできます。
ソフトウェアの出所を偽って表示してはなりません。
派生作品もGNU GPLの下でライセンスされなければなりません。
本ソフトウェアのリバースエンジニアリングは許可されます。
ALOSToy Standard のソース製品をお探しの方は、https://www.ventoy.net をご覧ください。

第4条 - 再配布
以下の条件を満たす場合、ツールキットのソースファイルを、受け取ったままの状態で、あらゆる媒体に複製・再配布することができます。
各コピーに、適切かつ目立つ形で適切な著作権表示を掲載すること。
本ライセンスがコードに適用される旨の通知をすべてそのまま保持すること。
ツールキットと共に本ライセンスの写しを全ての受領者に提供すること。

第5条 - 保証の否認
適用される法律で認められる範囲において、本ツールキットは一切の保証を行いません。 本ツールキットは「現状有姿」で提供され 、商品性および特定目的への適合性に関する黙示の保証を含むがこれに限定されない、明示または黙示のいかなる保証も一切行われない。

第6条 - 責任の制限
適用される法律で要求される場合、または書面で合意された場合を除き、いかなる著作権者も、ツールキットの使用または使用不能に起因する、一般的、特別、付随的、または 結果的損害を含む、いかなる損害についても、お客様に対して責任を負わないものとしま す。

第7条 - 連絡先情報
お問い合わせ、バグ報告、ライセンスに関するご質問は、以下の方法でご連絡ください：
Email: aaravkatariya2012alt@gmail.com
代替メールアドレス：aaravkatariya2012@gmail.com
電話: +447492947265
本ライセンスはGNU General Public License v3に基づいています。完全な条項についてはhttps://www.gnu.org/licenses/gpl-3.0.htmlを参照してください。
以上がライセンス条項の終わりです。ALOSToy v1.0 Standardをお楽しみください。
"@
}
elseif ($Language -eq "ko") {
    # South Korean body.
    $text = @"
ALOSToy V1.0 Standard - 라이선스 계약서 저작권 (C) 2026 AaravLegend-Inc

이걸 구매하셨나요? 그렇다면 사기 당한 것이며 악성 코드를 설치했을 수 있습니다!

이 툴킷은 자유 소프트웨어입니다: 귀하는 자유 소프트웨어 재단이 발표한 GNU 일반 공중 사용 허가서(GNU General Public License)의 조건에 따라, 라이선스 버전 3 또는 (귀하의 선택에 따라) 그 이후 버전을 사용하여 이를 재배포 및/또는 수정할 수 있습 니다.
이 툴킷은 유용할 것이라는 희망으로 제작되었으나, 상품성 또는 특정 목적에 대한 적합성에 대한 묵시적 보증을 포함하여 어떠 한 보증도 제공하지 않습니다. 자세한 내용은 GNU 일반 공중 사용 허가서를 참조하십시오.
본 툴킷과 함께 GNU 일반 공중 사용 허가서 사본을 받으셨을 것입니다. 그렇지 않은 경우 https://www.gnu.org/licenses/를 참조하십시오.

제1조 - 정의
"툴킷"은 소스 파일, ISO, 문서 및 관련 파일을 포함한 ALOSToy v1.0 Standard를 의미합니다. "귀하"는 툴킷의 라이선스 보유자 또는 사용자를 의미합니다. "수정 버전"은 툴킷을 기반으로 한 모든 파생 작업을 의미합니다.

제2조 - 소스 코드의 제공
ALOSToy v1.0 Standard의 완전한 소스 코드는 객체 코드가 생성된 모든 사람에게 제공되어야 합니다. 이는 투명성을 보장하고,  다른 사람들이 코드를 연구하고 수정할 수 있도록 합니다. 또한 널리 사용되는 운영 체제를 재설치하기 위한 설치 미디어를 포함한 무료로 이용 가능한 확장 기능도 있습니다. 여기에서 확인할 수 있습니다.

제3조 - 수정 조건
다음 조건 하에 소스 코드를 수정하고 파생 저작물을 생성할 수 있습니다:
이를 기반으로 프로젝트를 진행할 수 있습니다.
이 툴셋은 Ventoy의 고급 사용자 지정 기능을 살펴보기 위해 복사 및 포크할 수 있습니다.
소프트웨어의 출처를 허위로 표시해서는 안 됩니다.
파생 작품 역시 GNU GPL 라이선스 하에 배포되어야 합니다.
본 소프트웨어를 리버스 엔지니어링할 수 있습니다.
ALOSToy Standard의 소스 제품을 찾으려면 https://www.ventoy.net을 방문하십시오.

섹션 4 - 재배포
다음과 같은 경우, 수신한 툴킷 소스 파일의 원본 사본을 모든 매체로 복사 및 배포할 수 있습니다.
각 사본에 적절한 저작권 고지를 눈에 띄고 적절하게 게시해야 합니다.
본 라이선스가 해당 코드에 적용됨을 알리는 모든 고지를 그대로 유지합니다.
모든 수령인에게 툴킷과 함께 본 라이선스의 사본을 제공해야 합니다.

제5조 - 보증의 부인
해당 법률이 허용하는 범위 내에서, 툴킷은 어떠한 보증도 제공하지 않습니다. 본 툴킷은 "있는 그대로" 제공되며, 상품성 및 특정 목적에 대한 적합성에 대한 묵시적 보증을 포함하되 이에 국한되지 않는, 어떠한 종류의 명시적 또는 묵시적 보증도 제공되지 않습니다.

제6조 - 책임의 제한
적용 가능한 법률에 의해 요구되거나 서면으로 합의된 경우를 제외하고, 어떠한 저작권자도 본 툴킷의 사용 또는 사용 불능으로 인해 발생하는 일반적, 특별, 부수적 또는 결과적 손해 배상 등 어떠한 손해에 대해서도 귀하에게 책임을 지지 않습니다.

제7조 - 연락처 정보
문의 사항, 버그 보고 또는 라이선스 관련 질문은 다음 방법으로 연락해 주십시오:
이메일: aaravkatariya2012alt@gmail.com
대체 이메일: aaravkatariya2012@gmail.com
전화: +447492947265
본 라이선스는 GNU 일반 공중 사용 허가서 v3을 기반으로 합니다. 전체 약관은 https://www.gnu.org/licenses/gpl-3.0.html에서 확인하실 수 있습니다.
라이선스 조항은 여기까지입니다. ALOSToy v1.0 Standard를 즐기십시오.
"@
}
else {
    # If the user's language is not supported.
    Write-Error "No license text available for '$Language'"
    exit 1
}
Write-Output $text
exit 0