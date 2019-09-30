@echo off &title MediaCreationTool.bat by AveYo v2019.09.29  ||  pastebin.com/bBw0Avc4  or  git.io/MediaCreationTool.bat
:: Universal MediaCreationTool wrapper for all "RedStone" Windows 10 MCT versions: 1607, 1703, 1709, 1803 and 1809
:: Using as source nothing but microsoft-hosted original files for the current and past Windows 10 MCT releases
:: Ingenious full support for business editions (Enterprise / VL) selecting language, x86, x64 or AIO inside MCT GUI
:: Changelog:
:: - native xml patching so no editions spam: just combined client and combined business (individual business in 1607, 1703)
:: - patching all eula links to use http as MCT can fail at downloading - specially under naked Windows 7 host / outdated TLS
:: - generating products.xml entries for business editions in 1607 and 1703 that never had them included so far (optional)
:: - 50KB increase in script size is well worth above feature imho but you can skip it by copy/pasting until the NOTICE marker
:: - reinstated 1809 [RS5] with native xml patching of products.xml for MCT; added data loss warning for RS5
:: - RS5 is officially back! And a greatly improved choices dialog - feel free to use the small snippet in your own scripts
:: - added Auto Upgrade launch options preset with support for a setupcomplete.cmd in the current folder
:: - UPDATED 19H1 build 18362.356 ; RS5 build 17763.379 and show build number
:: - added LATEST MCT choice to dinamically download the current version (all others have hard-coded links)

:: Comment to not unhide combined business editions in products.xml that include them: 1709, 1803, 1809
set "UNHIDE_BUSINESS=yes"

:: Comment to not create individual business editions in products.xml that never included them: 1607, 1703
set "CREATE_BUSINESS=yes"

:: Add / remove launch parameters below if needed - it is preset for least amount of issues when doing upgrades
set OPTIONS=/Telemetry Disable /MigrateDrivers all /ResizeRecoveryPartition disable /ShowOOBE none

:: Uncomment to force a specific Edition, Architecture and Language - if enabled, all 3 must be used
rem set OPTIONS=%OPTIONS% /MediaEdition Enterprise /MediaArch x64 /MediaLangCode en-us

:: Uncomment to disable dynamic update
rem set OPTIONS=%OPTIONS% /DynamicUpdate Disable

:: Uncomment to force Auto Upgrade - no user intervention needed
rem set OPTIONS=%OPTIONS% /Eula Accept /MigChoice Upgrade /Auto Upgrade

:: Uncomment to show live mct console log for debugging
rem set "OPTIONS=%OPTIONS% /Console /DiagnosticPrompt enable /NoReboot"

:: Uncomment to bypass gui dialog choice and hardcode the target version: 1=1607, 2=1703, 3=1709, 4=1803, 5=1809, 6=1903, 7=LATEST
rem set/a MCT_VERSION=6

:: Available MCT versions
set versions=  1607 [RS1], 1703 [RS2], 1709 [RS3], 1803 [RS4], 1809 [RS5], 1903 [19H1], LATEST MCT

:: Show dialog w buttons: 1=outvar 2="choices" 3=selected [optional] 4="caption" 5=textsize 6=backcolor 7=textcolor 8=minsize
if not defined MCT_VERSION call :choices MCT_VERSION "%versions%" 7 "Choose MCT Windows 10 Version:" 15 0xff180052 Snow 400
if not defined MCT_VERSION echo No MCT_VERSION selected, exiting.. & timeout /t 5 & exit/b
goto version-%MCT_VERSION%

:version-7 - LATEST MCT
set "V="
set "B=LATEST AVAILABLE VIA MCT"
set "D="
set "CAB=https://go.microsoft.com/fwlink/?LinkId=841361"
set "MCT=https://go.microsoft.com/fwlink/?LinkId=691209"
goto process

:version-6
set "V=1903"
set "B=18362.356.190909-1636"
set "D=_20190912"
set "CAB=https://download.microsoft.com/download/4/e/4/4e491657-24c8-4b7d-a8c2-b7e4d28670db/products_20190912.cab"
set "MCT=https://software-download.microsoft.com/download/pr/MediaCreationTool1903.exe"
goto process

:version-5
set "V=1809"
set "B=17763.379.190312-0539"
set "D=_20190314"
set "CAB=https://download.microsoft.com/download/8/E/8/8E852CBF-0BCC-454E-BDF5-60443569617C/products_20190314.cab"
set "MCT=http://software-download.microsoft.com/download/pr/MediaCreationTool1809.exe"
goto process

:version-4
set "V=1803"
set "B=17134.112.180619-1212"
set "D=_20180705"
set "CAB=http://download.microsoft.com/download/5/C/B/5CB83D2A-2D7E-4129-9AFE-353F8459AA8B/products_20180705.cab"
set "MCT=http://software-download.microsoft.com/download/pr/MediaCreationTool1803.exe"
goto process

:version-3
set "V=1709"
set "B=16299.125.171213-1220"
set "D=_20180105"
set "CAB=http://download.microsoft.com/download/3/2/3/323D0F94-95D2-47DE-BB83-1D4AC3331190/products_20180105.cab"
set "MCT=http://download.microsoft.com/download/A/B/E/ABEE70FE-7DE8-472A-8893-5F69947DE0B1/MediaCreationTool.exe"
goto process

:version-2
set "V=1703"
set "B=15063.0.170710-1358"
set "D=_20170727" || note that only business editions are updated, while the consumer ones stay on 20170317 [TODO]
set "CAB=http://download.microsoft.com/download/9/5/4/954415FD-D9D7-4E1F-8161-41B3A4E03D5E/products_20170317.cab"
set "MCT=http://download.microsoft.com/download/1/C/4/1C41BC6B-F8AB-403B-B04E-C96ED6047488/MediaCreationTool.exe"
:: 1703 MCT is also bugged so use 1607 instead
set "MCT=http://download.microsoft.com/download/C/F/9/CF9862F9-3D22-4811-99E7-68CE3327DAE6/MediaCreationTool.exe"
goto process

:version-1
set "V=1607"
set "B=14393.0.161119-1705"
set "D=_20170116"
set "CAB=http://wscont.apps.microsoft.com/winstore/OSUpgradeNotification/MediaCreationTool/prod/Products_20170116.cab"
set "MCT=http://download.microsoft.com/download/C/F/9/CF9862F9-3D22-4811-99E7-68CE3327DAE6/MediaCreationTool.exe"
goto process

:process
echo.
echo  Selected MediaCreationTool.exe for Windows 10 Version %V% Build %B%
echo.
echo  "Windows 10" default MCT choice is usually combined consumer: Pro + Edu + Home
echo  "Windows 10 Enterprise"  is usually combined business: Pro VL +  Edu VL +  Ent
echo   RS1 and RS2 for business only come as individual idx: Pro VL or Edu VL or Ent
echo.
echo  If any issues, run script as Admin / check BITS service!
echo  Please wait while preparing products%D%.cab and MediaCreationTool%V%.exe ...
echo.
bitsadmin.exe /reset /allusers >nul 2>nul
net stop bits /y 2>nul
net start bits /y 2>nul

::if %V% EQU 1809 set "OPTIONS=%OPTIONS:Telemetry Disable=Telemetry Enable%" &rem Just in case MS screwed up again..

:: cleanup - can include temporary files too but not recommended as you can't resume via C:\$Windows.~WS\Sources\setuphost
pushd "%~dp0"
del /f /q products.* 2>nul &rem rd /s/q C:\$Windows.~WS 2>nul & rd /s/q C:\$WINDOWS.~BT 2>nul
:: download MCT
set "DOWNLOAD=(new-object System.Net.WebClient).DownloadFile"
if not exist MediaCreationTool%V%.exe powershell -noprofile -c "%DOWNLOAD%('%MCT%','MediaCreationTool%V%.exe');"
if not exist MediaCreationTool%V%.exe color 0e & echo Warning! missing MediaCreationTool%V%.exe
:: download and expand CAB
if defined CAB if not exist products%D%.cab powershell -noprofile -c "%DOWNLOAD%('%CAB%','products%D%.cab');"
if defined CAB if not exist products%D%.cab color 0e & echo Warning! cannot download products%D%.cab & set "CAB="
if defined CAB if exist products%D%.cab expand.exe -R products%D%.cab -F:* . >nul 2>nul
if defined CAB if exist products%D%.cab if not exist products.xml ren products%D%.cab products.xml
:: download fallback XML
if defined XML if not exist products%D%.xml powershell -noprofile -c "%DOWNLOAD%('%XML%','products%D%.xml');"
if defined XML if not exist products%D%.xml color 0e & echo Warning! cannot download products%D%.xml & set "XML="
if defined XML if not exist products.xml copy /y products%D%.xml products.xml >nul 2>nul
:: got products.xml?
if not exist products.xml color 0c & echo Error! products%D%.cab or products%D%.xml are not available atm & pause & exit /b
:: patch fallback XML for MCT
if not defined CAT set "CAT=1.3"
set "p1=[xml]$r=New-Object System.Xml.XmlDocument; $d=$r.CreateXmlDeclaration('1.0','UTF-8',$null); $null=$r.AppendChild($d);"
set "p2=$tmp=$r; foreach($n in @('MCT','Catalogs','Catalog')){ $e=$r.CreateElement($n); $null=$tmp.AppendChild($e); $tmp=$e; };"
set "p3=$h=$r.SelectNodes('/MCT/Catalogs/Catalog')[0];$h.SetAttribute('version','%CAT%'); [xml]$p=Get-Content './products.xml';"
set "p4=$null=$h.AppendChild($r.ImportNode($p.PublishedMedia,$true)); $r.Save('./products.xml')"
if defined XML powershell -noprofile -c "%p1% %p2% %p3% %p4%"
:: patch XML url for EULAs as older MCT has issues downloading them specially under naked Windows 7 host (likely TLS issue)
set "EULA_FIX=http://download.microsoft.com/download/C/0/3/C036B882-9F99-4BC9-A4B5-69370C4E17E9"
set "p5=foreach ($e in $p.MCT.Catalogs.Catalog.PublishedMedia.EULAS.EULA){$e.URL='%EULA_FIX%/EULA'+($e.URL -split '/EULA')[1]}"
powershell -noprofile -c "[xml]$p = Get-Content './products.xml'; %p5%; $p.Save('./products.xml')"
:: patch XML to unhide combined business editions in products.xml that include them: 1709, 1803, 1809
set "p6=foreach ($e in $p.MCT.Catalogs.Catalog.PublishedMedia.Files.File){ if ($e.Edition -eq 'Enterprise'){"
set "p7= $e.IsRetailOnly = 'False'; $e.Edition_Loc = 'Windows 10 ' + $e.Edition } }"
if "%UNHIDE_BUSINESS%"=="yes" powershell -noprofile -c "[xml]$p=Get-Content './products.xml';%p6%%p7%;$p.Save('./products.xml')"
:: patch XML to create individual business editions in products.xml that never included them: 1607, 1703
call :create_business >nul 2>nul
:: repack XML into CAB
makecab products.xml products.cab >nul
:: finally launch MCT with local configuration and optional launch parameters
if /i "%OPTIONS:/MigChoice Upgrade=%"=="%OPTIONS%" start "" MediaCreationTool%V%.exe /Selfhost %OPTIONS% & exit/b
:: if Upgrade selected, wait for MCT to finish then run setupprep with parameteres directly to overcome MCT limitations
set OPTIONS=/Selfhost %OPTIONS% /PostOOBE "%~dp0setupcomplete.cmd" & if not exist setupcomplete.cmd cd.>setupcomplete.cmd
set "p1=MediaCreationTool%V%.exe /Selfhost %OPTIONS% /Action CreateUpgradeMedia /NoFinalize"
set "p2=(if not exist C:\ESD\Windows\sources\setupprep.exe exit)"
set "p3=echo start \"setup\" \"%%~dp0sources\setupprep.exe\" %OPTIONS% > C:\ESD\Windows\auto.bat"
set "p4=start \"setup\" /min cmd.exe /c C:\ESD\Windows\auto.bat"
powershell -c "Start-Process cmd.exe -ArgumentList '/c %p1% & %p2% & %p3% & %p4%' -WindowStyle Hidden"
exit/b

:choices dialog w buttons: 1=outvar 2="choices" 3=selected [optional] 4="caption" 5=textsize 6=backcolor 7=textcolor 8=minsize
set "snippet=iex(([io.file]::ReadAllText('%~f0')-split':PS_CHOICE\:.*')[1]); Choices %*"
(for /f "usebackq" %%s in (`powershell -noprofile -c "%snippet:"='%"`) do set "%~1=%%s") &exit/b :PS_CHOICE:
function Choices($outputvar,$choices,$sel=1,$caption='Choose',[byte]$sz=12,$bc='MidnightBlue',$fc='Snow',[string]$min='400') {
 [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $f=New-Object System.Windows.Forms.Form;
 $bt=@(); $i=1; $global:rez=''; $ch=($choices+',Cancel').split(','); $ch | foreach { $b=New-Object System.Windows.Forms.Button;
 $b.Name=$i; $b.Text=$_; $b.Font='Tahoma,'+$sz; $b.Margin='0,0,9,9'; $b.Location='9,'+($sz*3*$i-$sz); $b.MinimumSize=$min+',18';
 $b.AutoSize=1; $b.cursor='Hand'; $b.add_Click({$global:rez=$this.Name;$f.Close()}); $f.Controls.Add($b); $bt+=$b; $i++ }
 $f.Text=$caption; $f.BackColor=$bc; $f.ForeColor=$fc; $f.StartPosition=4; $f.AutoSize=1; $f.AutoSizeMode=0; $f.MaximizeBox=0;
 $f.AcceptButton=$bt[$sel-1]; $f.CancelButton=$bt[-1]; $f.Add_Shown({$f.Activate();$bt[$sel-1].focus()}); $null=$f.ShowDialog();
 if($global:rez -ne $ch.length){ return $global:rez }else{ return $null } }  :PS_CHOICE:
:: Let's Make Console Scripts Friendlier Initiative by AveYo - MIT License -     call :choices rez "one, 2 two, three" 3 'Usage'

::==============================================================================================================================
:NOTICE: IF NOT INTERESTED IN BUSINESS EDITIONS FOR 1607 AND 1703, CAN STOP COPY/PASTING SCRIPT AFTER THIS LINE AND SAVE 50KB!
::==============================================================================================================================

:: For completeness, create VL entries for products.xml that never included them: 1607, 1703
:: I've chosen to generate them on-the-fly instead of linking to unnoficial edited and third-party hosted products.xml
:: $csv holds condensed official hashes and sizes for 1607 and 1703 VL esd's, later turned into full official urls needed by MCT
:create_business
if %V%0 EQU 16070 set "params= $release='RS1'; $build='14393'; $date='/2017/01/'; $code='.0.161119-1705.rs1_refresh';"
if %V%0 EQU 17030 set "params= $release='RS2'; $build='15063'; $date='/2017/07/'; $code='.0.170710-1358.rs2_release_svc_refresh';"
if "%CREATE_BUSINESS%"=="yes" if %V%0 NEQ 0 if %V%0 LSS 17090 (
 powershell -noprofile -c "%params%; $f=[io.file]::ReadAllText('%~f0') -split ':ps_xmlhackery\:.*'; iex ($f[1]);"
)
exit/b
:ps_xmlhackery: snippet start
$csv=ConvertFrom-CSV -Input @"
Edition, Arch, Lang, RS1dir, RS1sha1, RS1size, RS2dir, RS2sha1, RS2size, TODO_Edition_svc, TODO_RS2dir_svc, TODO_RS2sha1_svc, TODO_RS2size_svc
e,x64,ar-sa,d/updt,672bb229c831b84e95a6dbff94818528894540d3,2955820350,d/upgr,8efb029378cd955809e67baf2cc71c53c632e32c,3269761758,cs,c/Upgr,54dea1094afae58aa0959c914c083b8a99859450,5154024934,
e,x64,bg-bg,d/updt,97d613cdfb2ded4df2f71ef29fc93ca3656c6ed8,2911551848,d/upgr,64316f68725e92c2567dcf86981e5eb1c635fd09,3221290404,c,d/Upgr,3b7b29ce412bdf7d02d09c80fb2904fb51e33b54,4492129170,
e,x64,cs-cz,d/updt,7542eab92328937b8d09ee02cf8fa9cc6a196830,2918785956,c/upgr,5d0fa9367cbc1ce83ceb9ec130af97000e89b150,3231413240,c,c/Upgr,fe9c6df34d3839eb115ac022e654fd0c09c0a862,4492843350,
e,x64,da-dk,c/updt,bb9da04cd47d7973597386ffd203ed56e19d4d65,2946222420,c/upgr,3005a5859d2010da9fd1a77e6aab14ca233d73dd,3248303690,c,c/Upgr,647fd53e5c6c3cb596bd27485c3c2a0f4378f919,4505930436,
e,x64,de-de,d/updt,c9b01f8eceb84ea2e7abf8c8823a623d759a61d0,3019388686,c/upgr,f813662c59c2a382a940d82b96e825de80da7089,3348816134,c,c/Upgr,d6cd31298648aab2ff081004ceff2ffceb7aab64,4641670486,
e,x64,el-gr,d/updt,14e182c6ed9ba36c720fbd0c3f5ce7d64ed38ca5,2933879638,c/upgr,f2f713a69c342e4b6513bdb8974213530f37d6ee,3245990678,c,c/Upgr,9c8ce1a5e7faf8fbe4c41b09e9dbbf694387eb6f,4514091544,
e,x64,en-gb,d/updt,b972022ec65c9205195833b842983e527f287d0a,3002224046,c/upgr,a7100680c5718d34474579b0154819e2e528ffd7,3312981002,cs,d/Upgr,f46578e39b3445d962b22e98effbb935c6ada123,5206331924,
e,x64,en-us,c/updt,cbf97f9ee545d6bbff70c7fb9740e9fe5d6f4d77,3012544034,d/upgr,5477ecbdb80b477d3cb049d0d64831b72797be8b,3312849564,cs,c/Upgr,e49e0a8a439acdb669f2a130296214a9f07ded28,5179335746,
e,x64,es-es,c/updt,d6b21213c81c83c46965baf0c1da2f14d4f3eff2,3002625924,c/upgr,cf78240f01de56403f3ab7066cf061178a90ef3f,3319718002,cs,c/Upgr,0bbb3c8e9a6f1061e34aa7e1244888111e9f0622,5240569866,
e,x64,es-mx,c/updt,e7bb91c6aa0c9295718f0ea2761005ac4c556cc8,2943527594,d/upgr,8b4f2f3b2bf76a6ee78339332bb18e0476669b4d,3273904408,cs,c/Upgr,5ce4263f3a944495996119b80d18b72e9b552365,5177860846,
e,x64,et-ee,c/updt,ca9eba2953c9aed39e051f5d984e4a58c945d17d,2889988048,c/upgr,2be6d35081b25a3e808343ea0aae69fbe781f506,3200923112,c,c/Upgr,6ac606562d8fc63d9f6d53e5374c7a23c3dcafe7,4452561608,
e,x64,fi-fi,d/updt,b250bb11cbbea356417993455d639582ca4fd052,2932564162,c/upgr,5bde9ca7461591e51af74416335694ecc4b1ca5f,3230886556,c,c/Upgr,cffb7505b670c8f46c834e9b9a723f3f0aef2272,4498005828,
e,x64,fr-ca,d/updt,e33bc497cc5ef1a2ef362c23d2814d580aa22e26,2970085652,d/upgr,cccbccd532887d278fa922fd09f56bfdca5088bb,3294268308,c,c/Upgr,6af7994511d5228471ae1f9ed9c44810e79ab42e,4578609946,
e,x64,fr-fr,d/updt,b599b3275302e57b8e1ad25271da68c299c4de39,2996998394,d/upgr,64ff0e97c469fdd3b591ae226a16ebaa75c7e8d1,3309828430,cs,c/Upgr,82359e529119f287d382ae067bf734b78282528a,5225602638,
e,x64,he-il,c/updt,b82d6122d55c838393c5645520692acd101834a9,2927278142,c/upgr,d85a04e8c72279d00889be97fa9aa79e88964a89,3232690912,c,c/Upgr,c97f641aad3bf1d474833e9034285166642b65ba,4502612758,
e,x64,hr-hr,c/updt,bc2cbd1d92e60598115098238f12e8dac2c2166f,2898184950,c/upgr,b07812c974941b314884778654da1831f41d838e,3212042850,c,c/Upgr,f049975ef0424ad33850adb860374136c3f2477a,4475531494,
e,x64,hu-hu,c/updt,a0453e7dc3d34716caac2cacb473aa65ccecea3e,2918877960,c/upgr,3eec65d51e8c24e8b0c823071ef246df465270c9,3222250300,c,c/Upgr,5300d86d4d323b1150c2a4dbc1dad7517aeec7e6,4486261158,
e,x64,it-it,c/updt,9b48a0fef984b867e8018708785a6c70a696a469,2953574274,c/upgr,12c773f8db4c66d1a7d039e689a53e711f55b23b,3272240844,c,c/Upgr,bbee9c4107bfe2fccdf34170ab74c6b71947e4c2,4558250960,
e,x64,ja-jp,c/updt,ec30e2dfa29223fbeda28feeed89f7ed6d2911fd,3063387292,c/upgr,e214f6797b2f174db15901b79ae0285a0859e5e5,3391347078,c,d/Upgr,4bb9524d20bd51bfd22424036d7c303b5625edd9,4763918774,
e,x64,ko-kr,c/updt,8b9af5c684e639b1787c901baddb33e3ec1f17d5,2979348462,c/upgr,801a09ef5a8b28a98b620bdb83472f2a17265e17,3287839184,c,c/Upgr,5816dd8463de628a7565d4e0ef98f6fc8ef41390,4612478262,
e,x64,lt-lt,c/updt,97f81a28fa526e57e2e38235ce7103aa0fca0ff5,2890387644,c/upgr,11584883f422bbd13394a3b7aa502572bf204ba7,3204395822,c,c/Upgr,77adca4855549f28336bea5b3ab8e2a866eb5853,4467507388,
e,x64,lv-lv,d/updt,26775e677727ad2296e7de0620be132d144abd55,2897092188,c/upgr,c29e06c7e338df384fa4d0ec1798b07b4175056c,3202719722,c,c/Upgr,6e01d2186305f91eb94fc23de876e58d65bb8906,4462212878,
e,x64,nb-no,d/updt,7c42bfed895f37cf86153ee75325b5d4b71e3eab,2922664364,d/upgr,9b80ea391601f5eaa2dc82a86b51e4e8a5ef00d6,3224730246,c,c/Upgr,917575e89015a261d38bfb682ba4326c1de42f50,4495445338,
e,x64,nl-nl,c/updt,81b8974317b76417ae102951ec191f90fdfc00f9,2934556272,c/upgr,9d79d2877e7015039b7795311ee33b12e82103d4,3233989634,c,c/Upgr,06d8508cd017801196e0a5a0569c6b2d6cf58e25,4486440156,
e,x64,pl-pl,c/updt,7ddc4be2c46d3aa5b562bc593936b7bac33c6a4a,2929138222,c/upgr,78b3c876618557bccee0e9437466d70c0c136dcf,3254871838,c,c/Upgr,3ffd3b5d8c07cee0fcfe0fbf9a34f7f18723c047,4536228348,
e,x64,pt-br,d/updt,71de2e5a288324151bec24830bcedca5ad77a1ad,2953378710,d/upgr,01c57b64de3a66b7795c363ce0b80ca3567bcb49,3271500426,cs,c/Upgr,3e8b8635fbd823b97ef8600d43d7a735d05d6684,5180990168,
e,x64,pt-pt,d/updt,52dc57e4107dec547e68a9e74eec10244cea4f92,2941611330,d/upgr,6fdb16fb6bfd01cc846818eac4bbd468731137d3,3240619572,cs,d/Upgr,21bbac05214ddbd9287ad15f20a447cafe470e71,5155680742,
e,x64,ro-ro,c/updt,24950dd0d69cd50fe01f8e9309583772ef231518,2887834662,c/upgr,3b61d2d6592bf7172b20b6c087465e4e201a1b12,3213373488,c,c/Upgr,8ee1bd3f6bab7d291fb45ade38e22e2b3f26204b,4475337134,
e,x64,ru-ru,c/updt,8ce69e0236a2b5269c08a67edab908211585b3c1,2957770620,d/upgr,702da7305af22183af857b1d92f225ba89c846b1,3276687624,cs,c/Upgr,7d972a3a32039f8a3de3cb1639debec6cef90c9d,5200564820,
e,x64,sk-sk,d/updt,14accd88aa808e900ba902ac6509a5786d41be79,2888894912,c/upgr,2a76f3cf95bb8816bf2a4a77f60e5500eb0260df,3209901276,c,c/Upgr,9bb6e3babe046f8808544e9cd5177133d8f31eeb,4466932710,
e,x64,sl-si,d/updt,c1ac7d37d86e4dbdbb2992acc8d3b6e60e52919a,2881745984,c/upgr,45c67e340e223378aa8aa6aa5678d1ac5e3285a1,3205356168,c,c/Upgr,0ad7dac254a45a3081cb27882b2b8aba8ca3dead,4466558714,
e,x64,sr-latn-rs,c/updt,f8d80cb91733aa8b48c6b84327494e210b8e5494,2910809030,c/upgr,59d39830461b47692ecb8d8b3d3d5b5510bd2b41,3211056238,cs,c/Upgr,d3d4ec0be0f68b02267b2487f2cabff132ef9f7a,5083509604,
e,x64,sv-se,c/updt,d6196f5e660ef7055a0a5efad8892045131a7f9b,2931748080,c/upgr,d5bd28ea94a57f48c5dd9be95eaa77e1af5b879b,3225016350,c,c/Upgr,6c913fe62bbfb282064a0808bc2619fa958949f1,4499390394,
e,x64,th-th,c/updt,1286f4fef88b41884d8083aad666d63ca232be42,2910791934,d/upgr,10e7d1628d17f175c7be22b9cbfc31b0f4d6cf11,3225739176,cs,c/Upgr,a5fbebb96ff93b427428e222692395ba996157e8,5109695352,
e,x64,tr-tr,d/updt,871cf4807375a39b335468d44407023f19bade5f,2915633822,c/upgr,2bf79ce9f82e719816523039c6219fcb1681f211,3223779720,cs,c/Upgr,546b870e60771ff870226c98a0a34ebb9251627c,5100304424,
e,x64,uk-ua,c/updt,5b88fcd4211676ced3350a9bdf5abe0a37707991,2915857130,d/upgr,4689166d55d8b658144c219da32025ace59071be,3231204960,cs,c/Upgr,0d64bf092e32f18428f5014fb70bf7822c249969,5113533262,
e,x64,zh-cn,d/updt,e78e04e6204b107ffa36d898d58232c86e98199d,3131493920,c/upgr,ff6a432a6ee8204153cc057074fb07b5a41f201b,3475307584,zhc,c/Upgr,c2b0c017088e4cd91b5e8e750d12d648a5f6d031,6235494798,
e,x64,zh-tw,d/updt,4b4e82301a37192b69d70496fcf57c16aad681eb,3059396808,c/upgr,4b15f3fa006b472788efda8daae41dcc1cdc6335,3402457552,c,c/Upgr,82b9f790963e6ed7e306c838833a0b40482df2ce,4801535812,
e,x86,ar-sa,d/updt,c6daaa38f3eb589e8654a266320032ed3aa3a6f5,2253811598,d/upgr,489191d8cc329b9721ff26287bc71ff4cf02115a,2494711944,cs,c/Upgr,bc0cd95b8617b87c8f44c886ac602630650cd303,3985213078,
e,x86,bg-bg,d/updt,2c0063b9f769ba2307f84717ac2b915206a9d4a3,2218360574,d/upgr,117a347347deaa73dce186af781b7eda8e4fc62f,2450825804,c,d/Upgr,7834bed0ae7e72fd06004c19743c1e4fae9f1503,3456605902,
e,x86,cs-cz,d/updt,3108854bb25b7c75bac13289db5c2a2e9c920578,2214354874,c/upgr,30aa6d6caee1e882fd88018c7ddb9a747499b891,2450581096,c,c/Upgr,e12b05eed225ca7274d824180749c69211c6557b,3454980698,
e,x86,da-dk,c/updt,297f5fb65fa79f3ed1d0a6dcad202d863b71e9bc,2240352350,c/upgr,5451990e566561a587a8fd44bf81f3236fb27a8b,2469352822,c,c/Upgr,692c97dab305377fd5e8dc14ce2e222cc7eb6310,3473542342,
e,x86,de-de,d/updt,8af78913db117260a888d57c5376470cfc109670,2321843034,c/upgr,a19f69452edb66da0591a63ae7a2f9b319bedad3,2577096876,c,c/Upgr,52c33a275f77116954abe5f508d1254a49f5fe20,3613093430,
e,x86,el-gr,d/updt,b8bad577e15fbfaa27b8bdb53d1c6724fe64357a,2226440968,c/upgr,da04cef145557e500060759c3b759c03adf0580c,2468826000,c,c/Upgr,42421245bd52737c218ce6dd4463c2b8fba64453,3480491350,
e,x86,en-gb,d/updt,6d0466628b39e192bd675fae1dfafded7fff94d9,2305860070,c/upgr,c4371bd42a1d3463c40ad05b4f328471e8be80c4,2541092494,cs,d/Upgr,8fdabfed0f78d573a68b92dfeb5aad381aa8f986,4044831144,
e,x86,en-us,c/updt,72e16690f022fde1c59abc93457a1c6b8bd4c5dc,2310343386,d/upgr,65162f45583f38d53d01c5e5a64a69d1e73cc005,2542115274,cs,c/Upgr,14ca52d8348c51d146baa485a39f14f970d6d4ca,4019935624,
e,x86,es-es,c/updt,4b3999d40e9ac39c1ba4c1dec301c51aacc50f28,2298493682,c/upgr,000f7839c99dfc3e883c9c41a2e7e1f9b9d1049c,2547575630,cs,c/Upgr,9d96f6956aa7552d7750493b15d3a1e6f048ea2d,4078333636,
e,x86,es-mx,c/updt,3341b800403bb93375745ea4c3a4529ae5472fe3,2249633892,d/upgr,9315c4f7cdbacac86b47aa2637e90b1820c1e0b5,2496325838,cs,c/Upgr,1d8d025f7b361b5eb8840c64c11b00563a68493e,4026549346,
e,x86,et-ee,c/updt,06e7a360daba3388edefbdf56d958e98b2cae2d2,2192782608,c/upgr,1bb3b0c7df189c3cf2504a6c7b3044592991f510,2429782490,c,c/Upgr,5be72d3bd4d306353c90cf4dd2782afe2cb91ed2,3431035376,
e,x86,fi-fi,d/updt,3d13bc3b7ca9411cd791c5c861e022bfbf2db2ce,2235053854,c/upgr,32a72a1c0d4e70f7940e91c3e60aa10b6326d618,2455546618,c,c/Upgr,9b0305c08e971fbd0400d14e9be01cc1ff9e3a09,3450552724,
e,x86,fr-ca,d/updt,2200c921718cf3b8246cf4e82ae7127668790444,2267316492,d/upgr,904abb865818ee7ef3259129f49fde9464efd4cd,2520878858,c,c/Upgr,37e5d59d46288ecc672329fb679d0895c12fda8e,3551808600,
e,x86,fr-fr,d/updt,8b6805f55fd7c6641d182131f500c0340887c0b6,2297031996,d/upgr,b2d1ccaca7117637ccc74c86876d6289ec2499a3,2542088822,cs,c/Upgr,227dcfded0d0234a52f17291d303e827ae95f079,4069316356,
e,x86,he-il,c/updt,4011de9ecdf53b41fdb2ea9e0910bc6a0bca7939,2224939840,c/upgr,8a6662b13ceb703d8ccc874351843fd6f9918ee1,2455101288,c,c/Upgr,29d1219426c9b7ecc188a536bd72a59fbe3b915e,3465576968,
e,x86,hr-hr,c/updt,c689528beb00b9157cc3d08c2409ffaec84ea56c,2202588894,c/upgr,22b5565943863d9a82f6f0af17d0d8796e40dca9,2433083014,c,c/Upgr,c5b50ecde2e9554c45cf9fedcd69325da1d5e479,3435011968,
e,x86,hu-hu,c/updt,47e181c321033ac99850fb222047635a83d71d43,2223268852,c/upgr,b50222d340eb136fd736f2eb256c97072ed74f14,2443754316,c,c/Upgr,e7b2947bbe56d2aaaefb7fa3fc69dcad7619c38e,3443328860,
e,x86,it-it,c/updt,4e68dba7258c1af508d8c180564749b5b1b9b3fc,2247219130,c/upgr,1833f47a8968d2b31a8c90672dfb76d57a5ab022,2500145118,c,c/Upgr,8fc88c75930543e46a9fa9fb0242f046bc28fb9d,3527704158,
e,x86,ja-jp,c/updt,24d900e9937c520b10056e53775e6a5934a916a2,2355095860,c/upgr,e7c95f7ecfc9a46f1a66479ead6c6fa6194c0e28,2622699920,c,d/Upgr,8842a2d39699ec0d8d98c640d719c0ecdf37c212,3708871634,
e,x86,ko-kr,c/updt,296956b802ccf9a76083e6398db20d2b67186fd0,2265728512,c/upgr,a7e52b0652ad20c351d8d5a79cc4e7904f48390a,2511245616,c,c/Upgr,7f5e9a094990a09e6df7c2a75044c9ae73c112dd,3561429616,
e,x86,lt-lt,c/updt,1636c7532f21ebf6282e785f35840201ed6cb81c,2196863664,c/upgr,14be449da61677562b2f49de9f401a84d6d2c88b,2429457908,c,c/Upgr,a6ba0caeefb10ac4edf3e1de0fb3f1dcf1e8ebcf,3431999696,
e,x86,lv-lv,d/updt,aa16e2b2f317ab45e43885bb700a428d74244ef3,2196617270,c/upgr,1b85049cb4f85c0a50723a17f2b566c3ae05aa9f,2429484246,c,c/Upgr,07bdbbd466d4c849bc8b384dedbb0d333a7d4cf0,3430777386,
e,x86,nb-no,d/updt,a9bbff5197b258a37d4639a9699e938f86030777,2218857478,d/upgr,dfd2952d9ee50ffdaf70729577655fb52bbded02,2447487494,c,c/Upgr,33469e101c23f1105229c4db6fb45d14cf7c9bd7,3445782072,
e,x86,nl-nl,c/updt,c1ad0d57e0ba595e81ef7820f9db2b7c12114629,2223733356,c/upgr,db4d9998e2891a2c11af49e8edf864c4d669bee8,2453608998,c,c/Upgr,d37705a6c7d15de411803ab79f19c33ff2d84250,3457953538,
e,x86,pl-pl,c/updt,165494554c7fdb1be55e4399b6372515c2d6b1ab,2228062654,c/upgr,be5d2f555cdde8925c1ebd08a7f7a3222c9e612e,2474897208,c,c/Upgr,95049e5c4e9a6810d63bfd05c44a826904bba9c2,3498467418,
e,x86,pt-br,d/updt,a5006f26410655f0efa3a42c0ff63b6c9acf4d74,2264016962,d/upgr,ffde6034bdc95b6b3d4e651a8677ddc6bb2d180c,2503336302,cs,c/Upgr,d1f0b7e9d389ec7849b1d3c2e6cf71ffaf35192c,4022467940,
e,x86,pt-pt,d/updt,0b1a60b57e687aba766001a8b306870c9e7241b3,2229207498,d/upgr,4d41383f7e149f8f332683a803e80913bc9b1dc2,2472391446,cs,d/Upgr,c8e7ce6244fabb1b6b8e4b5fc08fcb56417bfe64,3984683320,
e,x86,ro-ro,c/updt,f1d43e2cbf3006e034b64eca9bc94de7ffa8cf94,2201439796,c/upgr,d150722d68fe7eeab6584e6b91ce40a51f6e83b9,2434175900,c,c/Upgr,57e1781a5baff6b5a5774ea19fa22df33b65f1ec,3424169714,
e,x86,ru-ru,c/updt,50f2f76e8a0e62f26a6238fd9471b16ca1b26186,2261034630,d/upgr,e4925023ca2a7c875a257542177f51adef9ac00a,2500599630,cs,c/Upgr,93f1bc119b37b2fa4d0feda4010e019146c13a4c,4027501312,
e,x86,sk-sk,d/updt,1796ddb7072d64e971b3f7ef7c3c3ecadfc7dd00,2197855320,c/upgr,2062f6e7a1cb1ae6dcc8755b6afec3cf92aaaeba,2428270146,c,c/Upgr,9003d06bf085f104a81f80c2dc67e9a859cb11d9,3436670580,
e,x86,sl-si,d/updt,2bcc0dd24a8fcf85e041d29c27be612d20f6c39a,2196163006,c/upgr,5edf9bc85d7893d5f8489693be58606ffd0733ce,2430123934,c,c/Upgr,3c8aee7e5dfd1f1998fa403d7bbf0a83c098d5ae,3431345458,
e,x86,sr-latn-rs,c/updt,242810176bd2c17e25c94b5478762bacd04f0c2c,2204793922,c/upgr,905b282702bd35a24335e13b7532bebdd6500577,2432563554,cs,c/Upgr,04445bfcad96ab7f16e2efa5a7e0ccc43f2ed168,3921903240,
e,x86,sv-se,c/updt,14642e83ecd3d000bfc10d5bcea08de83ca1fe39,2231055130,c/upgr,fdec6fe68064a5863424adbb88b1f3fab2f8f9ab,2456236258,c,c/Upgr,ae54456f5cc890ba46df202e79d9da9fd1613c9a,3459810606,
e,x86,th-th,c/updt,5660b3c566e05bbb58504c392470916996988bf5,2218450936,d/upgr,7e6804bb22e995c8d7fda7bf17003f1a598923c5,2452122006,cs,c/Upgr,64b8c32bdc3525fe23aa0732c00bd2e74a446356,3943763494,
e,x86,tr-tr,d/updt,2dbe29adf9297d98e66e42558fa673c0e76b4cf8,2215962556,c/upgr,440ca442a89e088530739ad7b1fb911aa4455a06,2446042716,cs,c/Upgr,04e32b4f3dce13cfbf2a871339583d88ec88b18b,3937919644,
e,x86,uk-ua,c/updt,02a14a526045c75cbbc1aa279d01f1f23686dd93,2219357380,d/upgr,e45c9e3569ab5763f1aa8fb3363256278a665d19,2453614364,cs,c/Upgr,e370edb89f357ddd8770d8128a06281540121202,3948779596,
e,x86,zh-cn,d/updt,2ddd95d076810d788d63082cffcbbd75bf921243,2421427008,c/upgr,feaf7891cc55c6f2716923a5e5aad8c9edccbba3,2693601882,c,c/Upgr,78db5a1aeac1a0a1797ce24205cf38d05f1dba2c,3738522140,
e,x86,zh-tw,d/updt,589eb269e0666134c1d31d67c665da50ea9b2a66,2361521848,c/upgr,ee8a66c1d34e68ba480b017f9aeed538a7847b05,2621863118,zhc,c/Upgr,9af6427364142c4778a47cc293e46d9f3d83a1a6,4938856824,
eN,x64,bg-bg,c/updt,d090ecc0e32e05a6c075eb8384f577315ac35ee2,2773448902,c/upgr,859fd1064516d2d86970313e20682c3f2da3b0f7,3063703618,cN,d/Upgr,328b938a4a0c918a330df467885bb5be2aa0a312,4320286378,
eN,x64,cs-cz,d/updt,3979b107d1af43aae3cc79bd7a2a081def5d04cf,2775734726,d/upgr,5885cef1a0a88972eafbf3240a91944a5bbaef0c,3063480034,cN,c/Upgr,b9f3be18f18400e3654864e3347d4b50c7821e81,4313726736,
eN,x64,da-dk,d/updt,f0a667d9584f10c47b3db96b0e6700f1a47021c3,2799132592,c/upgr,049db05e06fc85f2e4fa47daf620a91219f94da7,3064590226,cN,d/Upgr,a74566ff64b8401f5cdb5ffca250289ff7ec75f8,4321157666,
eN,x64,de-de,d/updt,e8a1023f0f21a7c99d1b5006ef520323238833cd,2888504080,c/upgr,8114e5eade5115f06e87cc63d82a56e6da4e9d71,3175541170,cN,d/Upgr,2776f70f8f1030caf2119700f73f59e618563761,4462371448,
eN,x64,el-gr,d/updt,8bd00622321661b9ca1eb7289d907a9056c713ce,2798418934,c/upgr,b02813b4225d89cb685c75b0d13950e9f5af90db,3068824274,cN,c/Upgr,7ebbc209906d53b679bcc64c0e7dda3a80df5273,4327521824,
eN,x64,en-gb,d/updt,f145a8eff3121dc8fb020c5a1750a0f2c117ecb3,2861883002,c/upgr,10b79168087eedc6f574af4c6c6893313702ec85,3137564572,cN,c/Upgr,accd87c0e5fe9d29ee747aab23833a3c22797585,4403861012,
eN,x64,en-us,c/updt,fab646ab44b5d956a91e0d2aa0e4a37f22ddf7cd,2859877184,c/upgr,3e2111b94ad40b063d6fc224da72f83205c374c8,3140230812,cN,c/Upgr,60fc9231f179d5dfc68759bb588c8848456a91ce,4392439588,
eN,x64,es-es,d/updt,7386e7b352e080a15f6a565feeace4c6e854703d,2848523494,c/upgr,9bbfcdebcd28939d5463630e0938ba6a82c69387,3147765694,cN,c/Upgr,2b8c43be8f4c6033e90666ab6d5b5686d3fc5d30,4418137454,
eN,x64,et-ee,d/updt,b487809fa9f137624e4bb205e389f0e599d17093,2748248864,c/upgr,577a6202ef0105c44fa46e852f02cadeb4d8d9a3,3032725650,cN,d/Upgr,ccd5c2190267759508d9e89824cd7e9a5ee31bf3,4284243356,
eN,x64,fi-fi,c/updt,dc40703bd5eca75ce2d234e367f23db5a71c807f,2796624854,d/upgr,d9c35e5ba0889424e10bd1391f482270b3c40853,3059882946,cN,c/Upgr,a4c9833593ad8345388b7795b9ff1b6cdf2d2420,4305089082,
eN,x64,fr-fr,c/updt,5838ee4f277ebd8ab33f3d40bbcc380a95f9e69b,2852055774,d/upgr,34e9d32c32d40b6fa1bffb9d5e43b7ee52ccc8a4,3130815842,cN,d/Upgr,2f7a3299f1d1022d9da510601f85ebabeafe374c,4417748764,
eN,x64,hr-hr,c/updt,f8d5c52045248839329634468038b184b7e9a491,2765426784,d/upgr,80fc1b08c6b4d89b65ab5d4aff5b8c4460120800,3033535336,cN,c/Upgr,367deed43cd47185b744ae0e8d5f054e524893dd,4284024828,
eN,x64,hu-hu,d/updt,65b67804be6e6a5e66f0046a8c779fc9599b571e,2780468248,c/upgr,ff090817737eabc45aab729654e73446c79b053b,3056933946,cN,c/Upgr,15b3a7c2130095734d36c1e14ea1b76eed53488f,4314183994,
eN,x64,it-it,d/updt,162bbba0399ed2e0cc12569676f4afcc685f08a0,2798572882,c/upgr,9f8316c823d069842e8cc52d9ced8b6915bfd612,3100499922,cN,c/Upgr,b6a5ad2177d0927d4e948117d68470e59f748795,4374652994,
eN,x64,lt-lt,d/updt,11c047008667638f72cfa7391b0ac14ce954a427,2755834506,c/upgr,9aef261cd6fffa9d1db2ab1ab7cd52678ef06094,3025353026,cN,c/Upgr,a338792b8f93bfc2e6f42c678438f5ecb628cea2,4285652620,
eN,x64,lv-lv,d/updt,230ac84bf1c669d375fd05159a8d26edb87cf264,2752316336,c/upgr,7fa4685a86839f3d8093be889e7dcb14b99a4581,3029332916,cN,d/Upgr,1d048e5c8a0fc4c71aabcf6260dac4f12f57062c,4286451662,
eN,x64,nb-no,c/updt,7939fcefabeed9a8cebf6ca04984e9c0f8470f50,2773039326,c/upgr,17ec8c4db6dd115fc45050205d4ee391d55847a8,3058404996,cN,c/Upgr,c832e1828a63670c0ddeef46dbd1f23953bf3585,4311118094,
eN,x64,nl-nl,c/updt,fbb84419e1b8618b83b91873ed5cc7fa1365a009,2775118184,c/upgr,9af5d931ed90868395e94fa99e15ce723153e7b4,3058285820,cN,c/Upgr,cdfaa786aab5aede2c189a9364a1ded5c455e4c4,4314471068,
eN,x64,pl-pl,d/updt,7ea026557e632da890a64e0fcf72f3672ef12e53,2778912686,c/upgr,3b8c6e1273d2d65562b81b0b1b63a8ce9ecdb3aa,3082538930,cN,c/Upgr,fb565ad9595c914c4c8562683a383c7101b4e4db,4361868286,
eN,x64,pt-pt,d/updt,0afce496d59bbfc1f1c6580dfb49bf0ca1e30275,2787935254,c/upgr,763b5bb74b702c18ba80f770dfa25a7af4dc4f91,3074473316,cN,d/Upgr,2557692915f69bb7a03febf6d1649f01019d2aee,4345691278,
eN,x64,ro-ro,d/updt,d88e0b470995cc081f9e73d06baf0ce6080445c9,2763055438,c/upgr,d9883e4a8242398402383ae47e4015a8c724b2f7,3035031152,cN,c/Upgr,53f6da08c95fd030ab8d363ce271097b76c70a79,4288274730,
eN,x64,sk-sk,c/updt,be661b5d237a8a93259d64754b09ae29f26cb42b,2763328164,c/upgr,c705871aa637455dbf04532b5ca462539d466d6d,3036114496,cN,c/Upgr,eef514d85db905ddd1df7ac86b18a4a92d703211,4291334866,
eN,x64,sl-si,c/updt,73a4a166b1eedff7c7465eed4ce3daa8eec1c051,2754008752,c/upgr,cb1485805fa62f1ed18d28a0418e45c5d612b31a,3026544424,cN,c/Upgr,cd0b3850ebfcaaeec62162c9798e0540e08dad20,4284690382,
eN,x64,sv-se,d/updt,70e0831a0c4078705b6699e8662d6cb0dc4875a0,2799778090,c/upgr,6cb6b740c9f5390f0e1bd29cd33890a78f20775e,3061594264,cN,d/Upgr,3b41563557f8d10e7176343ef75a057b90270b67,4313325854,
eN,x86,bg-bg,c/updt,f2206f926561fd89b69d6e7e61aa98956966dfd6,2111500580,c/upgr,3f2d95b5af40290989b42d7e85fb73c2deecb107,2343397300,cN,d/Upgr,4b7a9587d18820e2ddad0746e72db1ecf7c2d6b8,3344930198,
eN,x86,cs-cz,d/updt,e773288e71f7a17ec8e1525415134acbfa13a803,2113434488,d/upgr,ebb7e9db690c146503c1470f6431ebb3b9f90b8d,2339478712,cN,c/Upgr,fcfd47d02843bc31208c993b5844967754874586,3341526824,
eN,x86,da-dk,d/updt,9defa59a1627b3440684ce9605a43a0c4e88c770,2137434148,c/upgr,bc154a20faed8cb135617ea5f7c804a78b041663,2359187156,cN,d/Upgr,2c83382aee1feb008bfae02e3404bed801d8859d,3352624128,
eN,x86,de-de,d/updt,e62e766faffcd25ebce37b758aeac6e63208c332,2219030252,c/upgr,829e8e3a44ee0793a6c10b76d6fc0180cca52c60,2469646676,cN,d/Upgr,0605f6bad6126c1e078ea6d6bf3682a8ca5ceffb,3500548966,
eN,x86,el-gr,d/updt,880756cb261c7a7b32289e549011d9bb968d2706,2123659240,c/upgr,1731ca121d36bb3115282277de3f467dee4eee2b,2359266864,cN,c/Upgr,166cf41a5533ef617dbcfb7e183c69f10fb27723,3362593358,
eN,x86,en-gb,d/updt,7c3415af341630a1f01f2f0983e44579d6a23487,2200050658,c/upgr,d45cfdcc6d7227a8ed12ad24d718df17709fa8fb,2426801288,cN,c/Upgr,e5ac4532f4c51f989128b4179d8f9b82bda95b76,3434586978,
eN,x86,en-us,c/updt,5166cb73561f9c1190f9d6f8a35fe444877318f9,2201813278,c/upgr,b17b8827e6954672d2bd85276b73770801a3bf6a,2433137092,cN,c/Upgr,3354196b95179f1689f32dbcd4e4562c4006372c,3425803828,
eN,x86,es-es,d/updt,191a58383195e53864fcacb41313043a5ea77663,2196489320,c/upgr,87974fab21f2e4ffc783ee6de4e6942a6bcb943e,2438326380,cN,c/Upgr,e176b6c6edfe8b42f9bde4e019956342b4fc0500,3466232662,
eN,x86,et-ee,d/updt,d9f88ee10c3f41e5e152b24c78a35ab1f15d6af4,2095947306,c/upgr,4e55f61f68aaa863f3e98bd1159d09fe90508a7c,2320212652,cN,d/Upgr,183e77e0149419844db1fea6dfd93fbf7ae3bb29,3318039188,
eN,x86,fi-fi,c/updt,d3ed9db8b398eda4497c6b9d897555f5a5663d84,2137783028,d/upgr,70e4f643e220a70547bc75cafd358e5c247a918d,2342513800,cN,c/Upgr,783e199cb2d8c775e1e22f935c5466c3512be681,3342086938,
eN,x86,fr-fr,c/updt,36286ca54f121ca1247e1026e0c76bf3fdc4f2be,2193600366,d/upgr,61eaf46743223466e066c77c0563ad46501378d5,2428304540,cN,d/Upgr,7aaee513df23b8d4f7f5ba9ca9cbd7a3cc180a57,3460888844,
eN,x86,hr-hr,c/updt,742c2541073a78be847cbe684651b7fcab6b6fdb,2100724714,d/upgr,ad15cd4f66559bdbe0c42552f4d9ff645fcc5151,2328147230,cN,c/Upgr,293c3aa5780bf22ee7e2966c3bdd48f07384b39b,3325931078,
eN,x86,hu-hu,d/updt,444ac3b15980f3ef4f911fa2f920891e230118ca,2122154560,c/upgr,5bdb5d7c487fc0fb37b8b76c66c1f3e8e2682f06,2340664250,cN,c/Upgr,4fa4c8f9cacc9697361a08ee4087be06b2ee51ae,3343283534,
eN,x86,it-it,d/updt,f4deb16739ba26ec597725cc5a9a2580b33e7ca2,2144445692,c/upgr,4089301a2ea267526b974aae278aa5e0fc0134ae,2384586126,cN,c/Upgr,90108ce9193c9926f40598d09de819894fe4ae53,3408033770,
eN,x86,lt-lt,d/updt,0a1d7d1bd8456251c623d5c3f3e7e6f0a9c00e86,2094863630,c/upgr,d1725c85939679dd82fb8d551909e8686773e53f,2325646266,cN,c/Upgr,c405d8e361fd01311b28d36f338c43ffeefe64d4,3316766090,
eN,x86,lv-lv,d/updt,98948912070a686f3b7060b9f80446faba677b2d,2093716546,c/upgr,cdf68b52a97795d3bbddb17e08f5153868423082,2325624994,cN,d/Upgr,ab2e4411898c88f896f3dc12394e3855385b09aa,3315892144,
eN,x86,nb-no,c/updt,ba8c7be3fb2a12ae3a227ac60b69ce225f367933,2113695528,c/upgr,ab6a56a1e544b30cda33601f60ffdfe4b7a7c010,2337861734,cN,c/Upgr,a0383047b6f61a8f3ef3fe9d4f3a69940611ea87,3339353672,
eN,x86,nl-nl,c/updt,40d9d1a599a5266947f337fa6acfcaeeece8a865,2130921230,c/upgr,202eed2dd65dab2791ec1a4b04afbb1a28ca997a,2340806626,cN,c/Upgr,336ea719333b7f0ea83664f19f94bc86f306de4d,3336350894,
eN,x86,pl-pl,d/updt,487eab83f1e6f67058b50b9a889d790f49384567,2125591884,c/upgr,5292273b4477d413dcec2533ad2459ba1821891b,2365075840,cN,c/Upgr,252420857e20ea8281a8331dcddd1783778b2103,3383843608,
eN,x86,pt-pt,d/updt,40a28c0263920c0e13a1c450511718f61f2c67e1,2125017148,c/upgr,5659133bec9806a48096068ee53c2838beae6f6c,2356933976,cN,d/Upgr,42f6c4c387f6dfd7a4159ae8625a551d8eafae83,3375199302,
eN,x86,ro-ro,d/updt,5452de2544692ba234c744cb18676f1cbc3c7c3c,2101442992,c/upgr,efa8623d089f7df5c41453b862c9e686d0b0b157,2329162166,cN,c/Upgr,6c8700871412ab39743eececa3fbdec5f1858d2b,3323396908,
eN,x86,sk-sk,c/updt,6322ebdfaea5955e28ec0edba5595e6ecc3eabba,2096292986,c/upgr,b9b1705f81a7120a2bad78ffda154182814d53e9,2330022126,cN,c/Upgr,fc176ebb65cc38c7954ab30ce7f61a1c01a76eea,3327606862,
eN,x86,sl-si,c/updt,882e91a3c1e7a239ac4d39288c19228b8ba20c8d,2096786702,c/upgr,8cccac3b248a6e6879bb8f5baeb06a375bc8fe68,2326113308,cN,c/Upgr,7c5735ed6140bf920a1c606096086abe2b1a4d78,3322756826,
eN,x86,sv-se,d/updt,66c58033888d81d9e914463d941a525ef1f1c29b,2130127248,c/upgr,2e1c69c5a253cd7b7ed381e8a7d9ff02350ca8f2,2339127740,cN,d/Upgr,e73162d7c2cc193cbcfe7c3bc7d10e724346820b,3342015198,
p,x64,ar-sa,d/upgr,763f8d3532a4c3d95dddc0239ec6999c6c063c43,3017152712,c/upgr,3963c262ac8d2b8054df782a94354ffbd234f52d,3269139960,Cp,c/upgr,c14d92c6b2a4911bdc5b3e7042a1829503bd9274,3269825792,
p,x64,bg-bg,c/upgr,c56a9b9f6e7c37fc548686835755676ea04625d8,2968435508,c/upgr,d9868eb90a2d6a89244a402adfcb3fefc5a2e0e0,3229523040,Cp,d/upgr,3f01053d89d7604b4c27b2fc40eddf461ae711a4,3229873000,
p,x64,cs-cz,d/upgr,4ac0dbd8eb31b90ea7b500083a1a71f9665fb677,2976799184,d/upgr,b2c8da4d2f96e81a1dfa20a38e318ef604d27587,3225207160,Cp,c/upgr,f51e623b56cca865923b89ab2ff6ccc3c56e8b87,3230762516,
p,x64,da-dk,d/upgr,a15c3a85061a12b7cc9b366157bb9fbc30d71aba,3009307712,d/upgr,8bf3e4027b0ee612a32bfb0821e9f4424030c71c,3242370264,Cp,d/upgr,129ac792d3c386b70ec92e45bb72610aae07d34e,3247181416,
p,x64,de-de,c/upgr,dea2c577e64546463080a96c4b075e924a60d412,3219035316,c/upgr,3f35923a27d57e6b531a926824d68d70ca201e23,3349142306,Cp,d/upgr,a846811c7e6bdb340f55025abbbeb6002ac5f9da,3353407560,
p,x64,el-gr,c/upgr,4f9089bfd9b0815116fce8ee104a07f445ab82e3,2991041138,c/upgr,fc990c37e360b0b3242ae7b4989fd3bcc457635b,3246934952,Cp,d/upgr,be4f121702b281eca2cea51db9f449ce427112af,3246260908,
p,x64,en-gb,c/upgr,db057a5eac7cb0d65691e758f3949c13f26a513d,3176583254,d/upgr,7e7b2b9d0c229a5083fd45a7d17e77bcdabf8e69,3312166688,Cp,c/upgr,e0465484f290e8e6a4fe2f89a6af2519de9543a8,3311275842,
p,x64,en-us,c/upgr,a67fdee4fc4b5703b4ab599a5578a2dbe2f655f2,3319805853,d/upgr,4ec0294c4ece0c7d977c7de1fac74f5a43412c37,3306899294,Cp,c/upgr,0682223aab20ef69d84e5afac5114637d4b4e1b7,3310257702,
p,x64,es-es,d/upgr,8428460416a1effb60b2e204c40c436cef439727,3089825090,c/upgr,d62f6693f86651315289ec6c2a36951e330053a4,3318862104,Cp,c/upgr,bc30e6881c3fe41e1b4065e55181411b404d36be,3321265576,
p,x64,es-mx,d/upgr,0d6d30912e3cfb6b05481a8dac29cb165d5ec531,3021626512,c/upgr,5732b1f2c9716012a0a5e8262f380a903b857612,3266281600,Cp,c/upgr,bfc1c9903891d3522c5a4c47c3e6e417430ddc5e,3267135634,
p,x64,et-ee,c/upgr,736038bc59a7adbd86622480076d54c916ca583e,2947223572,c/upgr,4d4653f610d9ac20bd32aa4860a055c8ee4724d7,3199845540,Cp,c/upgr,6437e7101c66cc050d511cb1494d191f03104f50,3188672354,
p,x64,fi-fi,d/upgr,894658288a4de3bdadc3c92caafbc77d6beaf8df,2988097106,d/upgr,a9ce6b78c9dfd83bea9a93f9693dca3db27ea3f0,3224291788,Cp,c/upgr,866003414d0428f7f1531ccae5258b3a395b515c,3230876940,
p,x64,fr-ca,c/upgr,b7af8f72ebeb77a7529a91ba82fa96b5d7c1aca5,3057151984,d/upgr,48d917594ec3ee11df4ecb89a28d67d5621d34b1,3288230206,Cp,d/upgr,fec83ba95b24c6c465f723c9dcb9735e94fce59b,3285386162,
p,x64,fr-fr,c/upgr,fba5faa2d2d3c656a6e2180be4aed091e179dfbf,3151088370,c/upgr,fcdef8db06ed83cefc4a9764edf9e300c8a834e0,3306810834,Cp,c/upgr,0c397059084051db14bbbc2f03ac2c54cd697d80,3310673500,
p,x64,he-il,d/upgr,cce395f6f1ef65da5a9514312f7988fb975c7aab,2988102890,d/upgr,352cb000c67fdb818f2b6055354a167d4cd0a69d,3232992066,Cp,c/upgr,bd8d5e7b3a22fc2e04bbee8c91760446be5d91ef,3232805440,
p,x64,hr-hr,c/upgr,c6a879a1bde4828296073b45bee522a530fde1ce,2964453442,d/upgr,f939dc75371ec69876c572d491498aaa4a0bea72,3211331764,Cp,d/upgr,058ed9d5e2349ba96933d5cb77ed911eb4c59daa,3211591820,
p,x64,hu-hu,d/upgr,952368f507a15afac4d0c4c42697c36794c57a28,2976155974,d/upgr,ab6424a97b162cc189a3ee111f230b9b5decefc0,3221998158,Cp,d/upgr,755570148e93728c30be784e4efd519a17130eac,3217801132,
p,x64,it-it,c/upgr,ac52981de1ff7d7f7b8e8d2a4981130dd9b7062a,3027424610,d/upgr,b14fbaaa8ac55b6036fa2749bdb10d9eddfca97a,3271830856,Cp,c/upgr,57036f4c664c168bed25bbf6863bd311c85abe04,3273865766,
p,x64,ja-jp,c/upgr,87dc289be935d27958cf49f9d97b3db6f2d69721,3249832189,c/upgr,4cc008c93ceb0b76392a1c012c76ee14fcbee660,3399536718,Cp,c/upgr,d5130674508274b8566410cf1678c9029eaabb1c,3401947536,
p,x64,ko-kr,d/upgr,9f5180fb3d8792b87ee078df3b64cc1504221b0b,3053846230,c/upgr,b6399dbba1a2852805086b4581d4b202dabd0d2f,3286198386,Cp,c/upgr,a1e687190e8e6685e77d27fcf3ec2547b9a44020,3286438694,
p,x64,lt-lt,c/upgr,cd7650dac53a9f94e1556879d30ed5965a0703eb,2959202730,c/upgr,8a7beb73b01dd32141ad119a09a8bc01ebec01da,3205686580,Cp,d/upgr,59c009ac2b1c916d0c0dd28bb0b0bfa435f82806,3203262552,
p,x64,lv-lv,c/upgr,060160161b5ed79d53a3bffa7fc0014806664979,2967916812,d/upgr,26425a6a8d0f6aa9a05782977b692e190f7b3fe1,3203530768,Cp,d/upgr,bbf71c39d7a0058f8da853a49defe66fdba0363d,3202932796,
p,x64,nb-no,c/upgr,80dcd802fde6998d7f82d9e34457d29106180150,2986394866,d/upgr,cf80da8119dff6edd83fc14d04f1c07a93154522,3227302824,Cp,c/upgr,0dbd12a2ac24991c2fc36ada57d6b8e98b9121e1,3228375154,
p,x64,nl-nl,c/upgr,64a639f0066eed9c454e3e33451efde18dd6ba98,3005059082,c/upgr,dbce7a99d33758f6880e3e25869f4dcf8cba168f,3231406962,Cp,c/upgr,ac61b53cb9fc580d96c328252b2941d3b4c0ac61,3223361678,
p,x64,pl-pl,d/upgr,953d0e942518a30e8e98fd1dea151926fc8944af,2988628234,d/upgr,711e0bd9cba640f046d24c965478dc4c64b6bb56,3254396898,Cp,c/upgr,e2a3737340ad78a84180a237a0471664f16aea64,3253638222,
p,x64,pt-br,c/upgr,9d925ec3a182e0c2822e37900f89bccb79c666ed,3030217044,c/upgr,6a1729c45317670a371ab95a2888c8d46c246efd,3271791946,Cp,d/upgr,832fa9a2a15284e22e8f35fb525d0d5e1ff76e3f,3271321094,
p,x64,pt-pt,d/upgr,5cd6a59fe21427feee2a34f825f8783752c23d5d,3007507556,d/upgr,543d6cf7ba085eb01fe476589b3f853f68e14a1f,3242820652,Cp,d/upgr,39403ffd7149bdf0b2f77ff2df8f3db6bc039210,3250651610,
p,x64,ro-ro,d/upgr,b15bf61a558013f5202cd175308979af0a95d49a,2955444630,d/upgr,7043ae390b72561e8575213280c65932fcd57bf8,3212920292,Cp,d/upgr,78a976196003a78c893345cdd0e894e3dc1aa868,3211058932,
p,x64,ru-ru,d/upgr,f27830fe80f8a1f56c1d492d1007f63363ff69f5,3039587116,c/upgr,5c82a5b3d47e369e08950d1bf990d66af71382ee,3277964848,Cp,d/upgr,131e9d62875fba1fb850dd7049a95ab7c12e4088,3277631114,
p,x64,sk-sk,c/upgr,ea535aa8e2d891fdbedd9cd6a7d261c91280e495,2944655478,d/upgr,2be1c1c86924229c575ea86256ea6ceafa9250c5,3209614406,Cp,d/upgr,41b909be577d62672773cd3c4cbb114c6f591e58,3207087432,
p,x64,sl-si,d/upgr,50c210f92a64a625d320fbe704d1e2d0fe129dd1,2941825400,c/upgr,a76a6a9aba283de1d5a2c13e25f2d6f46b7b7328,3193801558,Cp,c/upgr,66de87423c1898e6c51fe365828b4d0aa253f350,3207377866,
p,x64,sr-latn-rs,c/upgr,235a4d11b0346a527f34e68822b0d08af5637323,2972572460,c/upgr,35e53089ec427c155f267988176a98a9ba6729c1,3205347802,Cp,c/upgr,e6dfd0b6b3dab54df4b4cb238dcedf56eef668af,3204975844,
p,x64,sv-se,d/upgr,956f1c12d67edd9ca19cf26a9b871610c4e51758,2996962528,d/upgr,73a9dc803eadeb9026e7e431cb244af6bfe7c0b4,3238580990,Cp,c/upgr,73ac336ea1fbbad0401aeb544caa3187817de1ff,3236248950,
p,x64,th-th,d/upgr,64529e2290a400a605093bbf7169060ac0f9bbbb,2976849192,d/upgr,edc54e4750f7716be213f9b18e65b4eb492be1f0,3233561098,Cp,c/upgr,006c13e1c5200b2ead3af98e131453141001cee3,3232756772,
p,x64,tr-tr,d/upgr,65612b0b4ac01f1bb2fec7b8a161ff31b9bf7ebe,2975807725,d/upgr,f800b571c0045b463801a504a7025816ff741d6c,3218876806,Cp,c/upgr,602228a5cd61cb125136405ce632df149febc666,3218559990,
p,x64,uk-ua,c/upgr,3d2b3939b2f60afec719c89443b170c48fba83ac,2981529906,c/upgr,867689f02d837ec57b73cd705ad7bf8c70c7ddd5,3230917596,Cp,d/upgr,6f5195a6e597af3c4722a0d3fdb931aa396c5f95,3230732982,
p,x64,zh-cn,c/upgr,efdd42f9baea736aebfb443922ffbd0de4b0e2b7,3203380142,c/upgr,63be8d0a2fb3ede0f5336ab238c871a10a2a3515,3462073854,Cp,c/upgr,f17caba2bb17f5b644c4101853997ea4287da15e,3476157956,
p,x64,zh-tw,d/upgr,ec6068642e34a049a9bf9ff79ea439722fe6bfec,3136948712,c/upgr,450f612a2ef4eb388806e0e71456a45f3ff86702,3405611514,Cp,c/upgr,d804fd2513179f3a0125ea2f469882ca6348006f,3410492148,
p,x86,ar-sa,d/upgr,1bd076aea51f88e19c600d34d06050f78e87099e,2316041282,c/upgr,9576073ffabf77db7d51f90a37aa2df01f3fabd0,2494401210,Cp,c/upgr,1d2ca8241211b4a43ad177e6f6b6858fc11d828b,2494094298,
p,x86,bg-bg,c/upgr,d9ff9494d106af25bad566591933e20f3cbb9c01,2285063890,c/upgr,dba3940d5ad6dc45140bb6994d20aa527766cea6,2450825844,Cp,d/upgr,90dc74f9d70ad85452bd2648dfa080ebf1488fc1,2450730318,
p,x86,cs-cz,d/upgr,f721cf9c925e778ab8b0014cd8727156613664a0,2275903108,d/upgr,50c30eb573ec91cfcca178745775d38f7b986b78,2450450424,Cp,c/upgr,ae3f2be4210f405f46ca9f75541497dd4dd8ed34,2450465634,
p,x86,da-dk,d/upgr,e830209b7541756470aa21ebca191dfc6ac39561,2305464234,c/upgr,c9a3e82cf520a3814454c24c35a4c06919ed1652,2468847300,Cp,d/upgr,e97df831e1a4a248fcc2056533357c0b4d242ec8,2469501706,
p,x86,de-de,c/upgr,968aaf9107ec3d486f1125a109a1ade30cae07db,2495166956,c/upgr,4e203ac80f25a6a21727dc915d80074bc5877954,2569095198,Cp,d/upgr,982c83d528beefec55cff5256593f1b7f6882465,2577244892,
p,x86,el-gr,c/upgr,6e029e44b04367c7f684888280b52666f999b47c,2286941358,c/upgr,dd90f8a993016a0847101c8e2eb1b059177860ea,2468868678,Cp,d/upgr,ff124d82fccd663a89b8fb37f5c3c6c902ab74ce,2469421452,
p,x86,en-gb,c/upgr,21fb6904b75427ffc9e9d3fadd3e0df9a4035598,2476842804,d/upgr,b611bd4eb7e100596062445444a90b37d32a1540,2540699908,Cp,c/upgr,dfcdad6b17bce3294a194da144ffa743065b3224,2539673708,
p,x86,en-us,c/upgr,d91e124cbe2bfbd372a936a401bd462f4773ceee,2602533592,d/upgr,5af2b28a2edeee03d47c17668797c8795cf56d2e,2541865106,Cp,c/upgr,26c98eebcfb98fbdb7a4feb2bd4d7a5af10a966d,2541942496,
p,x86,es-es,d/upgr,b5af8299317ac3398e93a122b06c846c4e18b6a5,2370591066,c/upgr,7ee3ab0dc272ae71ad9638e64f734bc733e20a51,2546579330,Cp,c/upgr,26e1a956a6256306581821f8daa79c9c70198805,2546592744,
p,x86,es-mx,d/upgr,205d7918b164275b9fc747dd05d9bf3d5d82272c,2339980484,c/upgr,ed1de56ac8f100eb7ceed68da3787004434d0c6d,2495688050,Cp,c/upgr,dbdbcdfe19e6c3a8f0956eea71366ca5459bb7e9,2497534844,
p,x86,et-ee,c/upgr,e39b8aebf84482322316e54a8e7fc03b200d6b5e,2250794742,c/upgr,c067ab95f0417dfe757f673f48cf77606ced0e99,2429532836,Cp,c/upgr,84ba4fcd196fa6ca5eedbfd2b8480b6b0769c295,2429187620,
p,x86,fi-fi,d/upgr,5a5a127d2b9f67eb076b2bb8a8d05588ab33e41c,2294397954,d/upgr,5145376a20a27f09b990b8442c062f91139f4b59,2455923358,Cp,c/upgr,191c17795076f4b6c4e6e3cfe516963f4cdeda3f,2446597602,
p,x86,fr-ca,c/upgr,3921cf2651b9bf40729c503f59ea39dadd67c1ca,2340335032,d/upgr,0d84ca5ed316ab3dddc76ecb624bad5c758e5adc,2521110928,Cp,d/upgr,25135a5cf80d7861a982f8f803a1f4e4c9d5a440,2521048502,
p,x86,fr-fr,c/upgr,52c657286188ae0ff2e4dcb9e19238affbebdd95,2431461582,c/upgr,51175bc8447a6bf82b742c2bedb2513ce3c26772,2542532614,Cp,c/upgr,6dd4530a1269e0e20bdd06835f576d683f74b49e,2542291154,
p,x86,he-il,d/upgr,294bee60f7d248b6766c331ed6d291f23cab54f3,2282465040,d/upgr,35d3f60ebe22ba28fe51522a71d70269944a8789,2457645752,Cp,c/upgr,dc7f7b2ba57af87b0be9a3e1db530f5c0060b8c3,2458340528,
p,x86,hr-hr,c/upgr,453579e6e76c81fc72a2b78b554c8cafaa4a23b0,2265497235,d/upgr,a1c6c6d83e61563a5b094e59f9591d4a48430236,2433167276,Cp,d/upgr,1a00ca3cbd2e2edf2f28b998b76dd9d0199feb2b,2433066866,
p,x86,hu-hu,d/upgr,237677d16e6f2256687a02e2c07d44042ec4a5c6,2284059150,d/upgr,4d5d740d8b644610fdfc403f09c75e471dc48fa1,2443048982,Cp,d/upgr,7588aace72ea6d3cfe58002aed6ee48296e129bd,2438124550,
p,x86,it-it,c/upgr,86b071f191f5193270378258c69814988df0f10f,2312619924,d/upgr,cedc39f6ae98c61ac0647b4a067040b1a244c913,2500671908,Cp,c/upgr,087a29bc3999e7f08b5b6ea4a0418d086356ffb8,2500752414,
p,x86,ja-jp,c/upgr,f7491c42d0d64688df6630378657cc2bf725e89e,2526997792,c/upgr,5f3a233a97b3a824de588902db59175274e7c6fe,2623127146,Cp,c/upgr,f4aa0008e7f14fb1733459f20afffd418faab944,2622581948,
p,x86,ko-kr,d/upgr,6639d29ba6934b13bcd5bec97a10cdaf1cdd30c7,2337854332,c/upgr,b5908819eca098113bc9ef3f763a1b75aad14b84,2511427192,Cp,c/upgr,49441d48df5c925f07033934113d0994f18260ff,2502888026,
p,x86,lt-lt,c/upgr,1d142359840ab83fb067468cbb295845d07db385,2256006622,c/upgr,09c68f4e38d2b94671012239cf29867671999271,2429889618,Cp,d/upgr,4750916fbcd94ac8aed2a3e1f3bc86c2f8c4d560,2429644736,
p,x86,lv-lv,c/upgr,2a3033731f8b28041fbe193a3f718cc62a301e6f,2260414882,d/upgr,71d5489b02a14a1ff7eca965ceb9833f19627447,2428535640,Cp,d/upgr,506dfef2e177c99bf651922dfaf4d305cc2ee493,2428550008,
p,x86,nb-no,c/upgr,5c5e576148999231f138597401cb14f25ea15829,2279262560,d/upgr,070a95e2239444b095e94bb42d1d9da70f13283b,2441045070,Cp,c/upgr,257edda3afe6b8c79d037c7a41f447f2d8ae7577,2447404304,
p,x86,nl-nl,c/upgr,823da75e12b4688f0e08acb6efa686266c91d3fe,2301425470,c/upgr,0149b5bcb08496f561e962adf8bf4bb4eb74dae7,2453422694,Cp,c/upgr,4841584e112a46b78b1c067d0b9b419edb0ea58d,2453303838,
p,x86,pl-pl,d/upgr,df3a74d6bd322219e33031e7e97c7ad7ac503bc1,2284329308,d/upgr,07c08c77c8932aff2cd74aa51f25767200fb2d05,2475957478,Cp,c/upgr,4fef419470b54527b80b03c23047a5a166140716,2474858606,
p,x86,pt-br,c/upgr,70142b3f23e729829b377ec56941cfa41c723204,2337652576,c/upgr,b57a3631b25084d4608c1297d80d6aaae245bc1b,2503293424,Cp,d/upgr,0c65c2272cb8c809e3319b45f7f8fc7654a1feec,2503398966,
p,x86,pt-pt,d/upgr,b8b1c20b0cc4383b54c6547f295ad8e8a7897d2e,2293680178,d/upgr,04c8f1dbe58217d0e9ec83570dc205002d2fbf62,2473189542,Cp,d/upgr,afcce63aebb31c59ef8dee91d84df122d52c3c9e,2473139530,
p,x86,ro-ro,d/upgr,5ce741cb144a804e2281c8476f9c65f0b4a1594e,2263202628,d/upgr,6f3b6a6d0129fc638f0183fa02e9c06a46efbf69,2433641874,Cp,d/upgr,841f2da59b42375630535670f82048e19fb6e510,2428222138,
p,x86,ru-ru,d/upgr,517619490219771a44196bb803dcc099110d9e05,2331906278,c/upgr,b7ce8535a9d98b725decd942e0d3be30754a0575,2499856318,Cp,d/upgr,87672127528ac82df6a74c44b03dc5ce3593e0a6,2495447324,
p,x86,sk-sk,c/upgr,eff3680bbbd0b45f27dabf4a054606fd78b30422,2258865734,d/upgr,1a19d541a7d730b039e8df7dd7398bfcf4830291,2434620244,Cp,d/upgr,2f19b3368d7f4d566537ad7988a3c7074221b563,2434561644,
p,x86,sl-si,d/upgr,736233c3b0da875665d9fd8abd093771352d4608,2255942595,c/upgr,0e50d975b2fe90a58aecc3c7cc201457f435c025,2429892232,Cp,c/upgr,50e7d8a52d3f72de70d62fa106f010c3ec83ef2c,2429146556,
p,x86,sr-latn-rs,c/upgr,2d44d42cfe870638ee5d517da54f3286790decd4,2264817096,c/upgr,00596ed8b28cfdc923415ce6331866b81d91033f,2432319216,Cp,c/upgr,f47bdcea249f5ace47b61fb12c2bc3c9d0dceb8d,2432702504,
p,x86,sv-se,d/upgr,9b7ad348af69829d1adb57d12f5315bda42f6ecd,2303368688,d/upgr,74da5ba69fe1e6910f3cc9a085a794f12e22ef58,2445959076,Cp,c/upgr,e525a2c94d140e2968348a4ceee9f1302e3c0cf2,2455646222,
p,x86,th-th,d/upgr,2676ce00bc5b187ca87dfbae04226471b3bc36ec,2275252504,d/upgr,67f63c4d073486cd33353f450883d921dde35945,2450007156,Cp,c/upgr,3e8134ff60f8c4270815c46e81de1219cc4aa0dd,2449861100,
p,x86,tr-tr,d/upgr,250c7ec09eaebb90681467d906ba22f5aab890c8,2276829342,d/upgr,b6a86891756286e3ba6b1ebd4d47e59c0c1cf5c1,2448261418,Cp,c/upgr,e837b9c18fd19fdaa82a33558a1861061621c4c3,2446573846,
p,x86,uk-ua,c/upgr,47ed1f3b95a08c706e13f5b4afb5e4ae0173a56a,2287688882,c/upgr,4f4683215f0b795a943992677e989e4977016227,2453351344,Cp,d/upgr,ea2dfe55cbb11b9cd7925456f760c8708e2927f3,2455312920,
p,x86,zh-cn,c/upgr,bf32e2b319724e7fc6765330c55888cc3eda6637,2492418640,c/upgr,a09759e7eba5eb47e1714ef9fb90fbb9b8b16926,2693248436,Cp,c/upgr,941fa1dc171ceacc2bfa74358b1b059a20bd348f,2693677552,
p,x86,zh-tw,d/upgr,e80465b8395ca5afe4a3002519d2f100514f39eb,2437070118,c/upgr,b04b61789de4357e5b558e3304d251be84717905,2622868522,Cp,c/upgr,ba02b1405853c7ed9ac356b72da8cd61d7cc51d7,2621526350,
pN,x64,bg-bg,c/upgr,fc329f5b4f683d6c9dce6da8ab12254f4aee79a2,2773968628,c/upgr,5f44e18a89a33ee13c3f58956e2875c4a69e4339,3062965392,CpN,c/upgr,bc6f3ed80777f53f3e571b59c49ba66b6cec77c3,3062397988,
pN,x64,cs-cz,c/upgr,c8c121aa245eebedef4142d86e8c444c82eb5ebf,2773293502,c/upgr,eab2c98d358e19006bc5501eb376eb78c5f61ff4,3061390492,CpN,c/upgr,d543e99e1fa403e5f1dc808ab6d93c6dfacea1cf,3057085524,
pN,x64,da-dk,c/upgr,01fa575f4e02f6d7b63cf02f691cdad8b7d06385,2797523030,d/upgr,b16e9860d40df7b56e1dd6ac5c66d3695ca605ac,3071035468,CpN,c/upgr,bb44807866a380ac774d7f429c08ac18ab12c349,3065453756,
pN,x64,de-de,d/upgr,dceb5a8fbefd5c891523cdaf7d9ef85ba78648ca,2887386902,d/upgr,b4f3bf648271229e67c02d4a9c3e928f59671182,3174390478,CpN,c/upgr,6921baa02daa182acdf181e9ddb027880cd63392,3174844888,
pN,x64,el-gr,c/upgr,33997af7aa98ddf701dd77a197a01ada0083cd16,2801821428,d/upgr,ba6536791a95ddde7eb6d2092fbe4dc256263bc3,3058180776,CpN,c/upgr,79ebf829968114f14c5e5f05ea5938f168555eb4,3069219680,
pN,x64,en-gb,d/upgr,91815f5e30a2b75891b396c8a0b2848befaeb46b,2859609418,d/upgr,ebf08fbb1b8a857b5ddf615ecdb2e05576fde6fe,3138889370,CpN,d/upgr,1d9b0fd4016f134a1b0f74f5f56457577c981ad2,3137835916,
pN,x64,en-us,c/upgr,eef8273e5aff097f031d3eced6081a2ff1ce6e70,2859983836,d/upgr,8f08b14b8e4215d95df4aa8f6677c442f3280608,3134074578,CpN,d/upgr,7d7fc029faffc55ac0951112abb6c0a1425565ef,3139578158,
pN,x64,es-es,c/upgr,28c0c3facdee14fca9c415baf12e852424cfe823,2849603408,c/upgr,e980e0e4d391747c5079b9bcf8fa02f3610dadf8,3147378694,CpN,d/upgr,dffcbf2efbe23c4e1506814b8fdca1e3657ce0f7,3148098502,
pN,x64,et-ee,c/upgr,956dcd0e2e74458d9c530837e76e3e85c87569af,2749178492,c/upgr,a5459eab69a630f6de0f5f7ed390d80da6287d1e,3033156374,CpN,d/upgr,f36464b4dbe92e8b558b157c9e206ac9bee2f9c4,3032540226,
pN,x64,fi-fi,c/upgr,2bdb6ac2dbc58954f7cd24270fe3e90284e54daa,2797659170,d/upgr,b41a9b486513d44ea20c0036973ce7e7e5677d2d,3058342604,CpN,d/upgr,94ae6449d8f54e8631b4ec18e7c799e7f6d84bd7,3060255460,
pN,x64,fr-fr,c/upgr,2911e901d843d85ff7d4d8a26df117c915739d1e,2851575648,d/upgr,7b1918b7a43b5c484f9604888dfd571eb5ef989c,3135241050,CpN,d/upgr,1cdf5621e36c0dcd8465598a0f22e584da864390,3135431030,
pN,x64,hr-hr,c/upgr,2bb2b9c596d7c58a152533c0f68c193dff262f7d,2765117444,c/upgr,83872704fe26c66dddb5588c43d0c5105f0a8e7e,3031238450,CpN,c/upgr,98bd65adf770525632ca906936c74cbc81fc2bee,3028064622,
pN,x64,hu-hu,c/upgr,650ca39bc961abf7798fa7877bd44bec042426a0,2782768444,c/upgr,dfe00bed39f3293acedfc60d4703b093b627c1bf,3046729422,CpN,c/upgr,255ea6ae36abb850c2bfcb91e0fe737033e9186f,3057125380,
pN,x64,it-it,c/upgr,63287c51ff616254966ed37d52ca9300cbb12230,2800506190,c/upgr,9b988be77d94a9ceecfdd3c0aeb1a2921f3b3ab4,3100978042,CpN,d/upgr,3b88033d807d13e38f5bcdb4d80dcbacc3ed84ed,3095783756,
pN,x64,lt-lt,d/upgr,33ce1e39bcd256df8476f189e5a6a051de49cd13,2754636784,c/upgr,0712851abb0163df81f8692ffab04d6b1b19c7d5,3028157126,CpN,d/upgr,214bce114ec4c55069a923ed74df022fd21274b3,3029334588,
pN,x64,lv-lv,d/upgr,fb774f04e2f477d5060cdf15ccb67a57471a5511,2755350776,d/upgr,d1678361ca61445e7e808a67548dc37292ebb2af,3028725540,CpN,c/upgr,ac58f236313eea397089012b93d15f91061c00fb,3029923220,
pN,x64,nb-no,d/upgr,c1a2d7a1b2a5215831439f80a716768eabea41b9,2772100158,c/upgr,326efdbe48d12dfbf7fb5be385d99ddf9891c464,3059758392,CpN,c/upgr,d9d76cfade43e69519e3457ed1812be99f40c6d6,3058863170,
pN,x64,nl-nl,c/upgr,e363e17767440f8c902e96ab193c926610ffadd6,2773104714,d/upgr,834e4a5b1ee8a34ea6d7ab97d1543727ef07f066,3058822848,CpN,d/upgr,069413f59af79c4a17247c00c0cbb72900226a5c,3062815958,
pN,x64,pl-pl,c/upgr,695623b0a4f468c1dd7c5807faf84dfc9b9356f2,2780436314,d/upgr,f503b82af5c2a1d7d3db92867c7ad8ea8c506e25,3078483218,CpN,d/upgr,9f8cf758a21db8eb8c4ea90676d48fc489dcf588,3082649992,
pN,x64,pt-pt,c/upgr,5d54830d399eaee9d14223f9085684c5182cdab4,2788551940,c/upgr,105e7656ad4f9472f46a990e9af6fc6008bb0299,3076144756,CpN,d/upgr,c3f9c4c91ba4975cd076440f9cbc8fea83e9ad0f,3073884062,
pN,x64,ro-ro,d/upgr,d98b84579055ca2114bb86390def6a06d4450e40,2765807026,c/upgr,07129c8b89771ee78d55b28fa0235eb5fbc203a3,3035255674,CpN,d/upgr,5b0e2ec90b76fdf2fbd80d1eb9125391270449c4,3037504840,
pN,x64,sk-sk,d/upgr,fef5249e7b211a31db3c756f8746cc69093b8f89,2762718640,c/upgr,96df6aaa8c80e17a364518e4407ec341654b7312,3038980680,CpN,c/upgr,e33c3a3b05f0755a82ea1a78faae2622020c8471,3036733382,
pN,x64,sl-si,d/upgr,ac0ede2cf10e95a905f4070bcf08651625d8cf6a,2758415634,c/upgr,3e44dc84aef2463ed56352740a0b170651acda74,3027672078,CpN,d/upgr,cceac86b9224da00e9ff65cac0097cc046a03782,3028089944,
pN,x64,sv-se,d/upgr,1ed5517d01de32c3cc1f77cdecfe4f356c0d94c8,2797681810,c/upgr,451e5df2b8a32f7bfd04ed1b20737a16b0a3d770,3055257762,CpN,c/upgr,6a51d1055eef3d98c97dc24fd8837a913b3be49a,3060215324,
pN,x86,bg-bg,c/upgr,ef1cdac011e2796516bb2ecd489f5a95807db56e,2111630422,c/upgr,784397435172346058dcddaaf598f50c1106052c,2342230796,CpN,c/upgr,9ecd5f827a57eb3ee0bbf37301a227d4f24d179d,2342951616,
pN,x86,cs-cz,c/upgr,c2fb76d2890cd7b33759d070bd4fa9daed67839d,2111595264,c/upgr,f7d6e4300851b880570a4b42c290ea43a51e825a,2340828822,CpN,c/upgr,9559e862a5a87a0c63c6db21777e000bd0c3094b,2341574836,
pN,x86,da-dk,c/upgr,6f3a269b3f46310845cc4671753f9bb5e0c53fbc,2137463158,d/upgr,1705dd7e86d7afcf517c549a94e2db7a445b595f,2357616126,CpN,c/upgr,ac24ae9ad4946a21e25d8f7479e171faefddec09,2359250046,
pN,x86,de-de,d/upgr,bfe79458d02aeaffbff01df43e43af6cff1086a2,2220146562,c/upgr,3d1516229572cd93b7aa643c5afbd38f6208e9f6,2468947694,CpN,c/upgr,c31056b05628d759e6bebe88f7fba95670f1182a,2469074664,
pN,x86,el-gr,c/upgr,93a91f0147950b7a92f1b52206d4185d5fe2adf7,2120864956,d/upgr,d2b7504700e688f39d66a773bae8f0e5ce34f79b,2358200780,CpN,c/upgr,3a5d8ff2606e346e082cb5be4af035617496c27f,2356571374,
pN,x86,en-gb,d/upgr,00f726c42be7c11b5fa7761cc26f9957880d1324,2198424742,c/upgr,4de9f2360f0645a3fadfab850f9ab48762573d78,2427693510,CpN,d/upgr,a1bcbeeb18b74e2ff42a1ba1310b7758466b4e3c,2421905214,
pN,x86,en-us,c/upgr,5e29955a7ce81907f0d90f61ef0c87a4d5693150,2202017206,d/upgr,a7497ef7aff694250be967d2d10c6116a5d26523,2431422208,CpN,d/upgr,fef3fbf968a908be357cfe05598ecbedef4d8312,2431435908,
pN,x86,es-es,c/upgr,cd2c62a7e75b6d0afe39da402b63b1f042b2ee60,2195845498,c/upgr,a08ff7d5dfe25eb51d56341c4df866577c6e5e65,2440408844,CpN,d/upgr,bbd200aed4d01f5e9a3a4bacf9b45ee39f43e0db,2440392892,
pN,x86,et-ee,c/upgr,618bb7a7e6305ae5a4ad05417c1d7a6d1c240d94,2095309794,c/upgr,0a26ea09337519ba115f21b78e3f0aed0ab45b0d,2320456032,CpN,d/upgr,6a4e4038f63159bbc325a82ec5de866bd194fde5,2320548090,
pN,x86,fi-fi,c/upgr,8c673bcaf88ff3675573a358be304962900a6971,2136318712,d/upgr,bab89eeb930561e0140eb12be7a06d6df16476bc,2342355544,CpN,d/upgr,f36a5493cd7c60d6a87243e275b5a120307e75d8,2342135676,
pN,x86,fr-fr,c/upgr,eb7fd4ca93539d05478dec8ee088184df9ad340b,2199089480,d/upgr,1fa92c0dd81a6cac8efa741d27d6902f04f5f941,2432693414,CpN,d/upgr,855928de413c9ba7871c755cd21d230aae29c8da,2433292388,
pN,x86,hr-hr,c/upgr,90a92a7b6a6ca30d4e0b609178c9aaa49c0fcc28,2100765434,c/upgr,0a725ce083bacfcced9022209bef12ab5dfdd58a,2327449750,CpN,c/upgr,b41862a6a44c6d1d31e0db561f98567d30e9f3be,2328143676,
pN,x86,hu-hu,c/upgr,7407a410bf6d9573cb22b06cc98ea8467f0df658,2121777568,c/upgr,0aa88a593232240db6c89ab9bcd3d994fe047f8e,2342265870,CpN,c/upgr,ed0a6cb52934aed0ff3515647cb6aaad19822c21,2342348014,
pN,x86,it-it,c/upgr,f4863cd0ecf5bfee974b9c423c9d864e9bfba3b9,2144659586,c/upgr,8d67fd32d106b0d7ab3b8375a013f681cbba1dff,2385126888,CpN,d/upgr,ab7680434d8e0eef090ed716ea5f5b529c07e3e2,2385508970,
pN,x86,lt-lt,d/upgr,e2db5267355217e8f572b6b482b5b15e0ae85121,2094530112,c/upgr,37b27db921300461795edcaae085528735fa28aa,2326102028,CpN,d/upgr,97bc36cfa160cabc16045a89eac2bffaccd24cbe,2326049126,
pN,x86,lv-lv,d/upgr,a342940c936e67f0f93c433c935b868d58d8867c,2094597898,d/upgr,fcb378ef59b277223986482e8d0528608f74d4ff,2326564272,CpN,c/upgr,0df11005b117df8ca1c1fd63b8486fc0d3c58033,2318688586,
pN,x86,nb-no,d/upgr,c850d7cc8aa9b5c6a1f443efb313482c9e01fa12,2113869760,c/upgr,c485cf3d979b1d3e85f249d39489c9c7ae077720,2338122848,CpN,c/upgr,84e82fc8152496f2f1edb608dac3aa27e34990f7,2339569524,
pN,x86,nl-nl,c/upgr,31f1d6c1735d862d9c4a5aad54983b9ac691dc3e,2131740526,d/upgr,9f9538de6a63c6eb9a510c1edf3f8dbf7c885dbf,2342693286,CpN,d/upgr,f3768a2905ddb9d08972e542ffa7c4959572820b,2342300488,
pN,x86,pl-pl,c/upgr,947f434e5f736374f797083686d156ac31f61cc1,2126498562,c/upgr,44d11c4f07f54617067a5c50a37f23047b260ad1,2363883710,CpN,d/upgr,4f18a0dd7858f2a27f6d054cb872415462abbd0b,2364715788,
pN,x86,pt-pt,c/upgr,76f04e40fda45dccb6d056d3a3ed629f3574f0c1,2128468318,c/upgr,53e8e14cfd0703bfd4d529e4a6caac2352d117da,2357325274,CpN,d/upgr,7848cb49896f5c9ac248659c60d797a644ff244b,2357224282,
pN,x86,ro-ro,d/upgr,c399fc45669d57ea42a650cfa1ef9cff42aa6315,2099203004,c/upgr,672763eea048eabf9d2561532a051eecd3447d93,2328716638,CpN,d/upgr,9a0b9a28dd06a6584a7fae9f3ccbe2b65429841b,2329047470,
pN,x86,sk-sk,d/upgr,24cc2caaa234990688701aa259fc99740f6cf625,2096757828,c/upgr,b5764a025eb14227a8d48a23fb53c9af2e0e2032,2329998398,CpN,c/upgr,3cc2f4b65af5387c3f9c9169714d9c256ff049d1,2330095914,
pN,x86,sl-si,d/upgr,0bab0901bdd35b2e1bfa11db4d31aa835a79d39b,2094438534,c/upgr,3de28a415bf6d3424387b91e5e8d54219785fa7f,2325483758,CpN,d/upgr,1829b26d6be936b1cfca2f76f528c63e85d4f5c0,2325368658,
pN,x86,sv-se,d/upgr,7b3ac33040f23a1d3ca949124aae5035270f0e0f,2129967952,c/upgr,d226b50b2dd9f995d4080b98030bbabcdafe76d6,2341328688,CpN,c/upgr,20d1a6957b75a81781f67e489edc7ee3e25ed84e,2341691454,
u,x64,ar-sa,d/upgr,ad209ddde42bb7c0dbe62aeaa56c9edb1e21374d,2956949156,c/upgr,75bf847f81faae21d85ce27bc2ea5081df25cdfc,3251847572,
u,x64,bg-bg,c/upgr,d5c152271d498675f400eb335c7f20c8f05cff0d,2913342796,c/upgr,c6ead57dcc61d87f3c43b78526fdbbe78d912377,3206626386,
u,x64,cs-cz,d/upgr,abb6ab1ab0b5a9f9c715d1cf91aa473e410eb958,2917449894,d/upgr,031224c662881365f2a971dfe42ea342c9448796,3207310586,PPI,d/upgr,416a9c7f6984bd4bdd689f578dad2441c2c9bf98,4548356804,
u,x64,da-dk,d/upgr,4641e22dd93423212b5b465db1c4b720921ff737,2945166370,d/upgr,60aba504f24ddbb177c94edf837ca85c21662fe0,3226462806,PPI,d/upgr,84a9c32249752a1d44f39e2909eba97d0f5dfcd6,4543049620,
u,x64,de-de,c/upgr,352e4a7510e0ceaf1d97f03db3579af3e0344938,3018157658,d/upgr,fad7f186a2e646d16a6a6b56f11b01ee0cc14f1f,3327083894,
u,x64,el-gr,c/upgr,93eadcdc4ea4b3c9464de64898fc172284ba3d24,2934720002,c/upgr,c51af64f28ae99c28a3f453365195ded29aeeb2e,3226390944,PPI,d/upgr,7354b7c16f2521830c5927ec261ea27765d9ebc0,4543950584,
u,x64,en-gb,d/upgr,d363257e8203c0b46c98bfbaeac8e50d6d762f91,3001730482,d/upgr,d2fd393536a0910ce1d69eb94dba465e24a545fe,3282224232,PPI,c/upgr,6a5b2316baa889e08b1065726b78d82c137dae46,4528836062,
u,x64,en-us,c/upgr,01e49055b446024d37bdd3ad1711a8b529bc98df,3014778678,d/upgr,5fcec6f04b988820c7a7c9324e1d8a78e897efd2,3283493420,PPI,c/upgr,2908f21c68c72d4d24a1039731d181d09ca7098b,4522789872,
u,x64,es-es,d/upgr,8b396b404a5e68b22570bd9d2c7bc23e0cc2fa89,2999917512,d/upgr,c2cf0c41654a9f36b7788210ccc07b98d353b63a,3293989448,
u,x64,es-mx,c/upgr,b16befdf9f8905fed73836a03a1505968b2aa583,2940854936,d/upgr,9f9d726cd46235d4ec471c8ade9a0144a01512e2,3255353974,PPI,c/upgr,030452666eb4a3df5dd8e3aec6f630e21a6f21aa,4572260638,
u,x64,et-ee,c/upgr,6edcaa2167c569b5e3dac218f90161f686eb4ea0,2890533510,c/upgr,8bc1d88e96a8b5563bc153cc3fd2ec1e558eeb70,3173983282,
u,x64,fi-fi,d/upgr,88e07bcb494c2973a37eb32c11c6b2f6f313d6cf,2936951164,c/upgr,9d0403b9310263edb3fa8e4926c033288d5d77dd,3211676114,
u,x64,fr-ca,d/upgr,99dff3ff2faac319c38b67adbbf7df11b996e2f0,2972513666,c/upgr,1afa5bfa09a0bfa82187f93ebeb72327c8babb75,3267937290,PPI,d/upgr,8d4eb6e58cb4d98a92f5d9b68e4c81fb152b5137,4557086200,
u,x64,fr-fr,d/upgr,c4aa11238240f052fc155a69add5aaee5a8fa2c1,2993414936,d/upgr,c13e3a943e43a78b77954fd490ca9fddd613e36b,3280449890,PPI,d/upgr,7c528cd07616e8652621f4f9e12e334d2dd3cc93,4554598918,
u,x64,he-il,c/upgr,ccd6fcf5bba100f8bd7416b8368ae88986d42719,2919856152,d/upgr,35fcaf72f58e39dfef29d1bc2ef909e18e4e3e8e,3211561870,PPI,d/upgr,946812132d589339dbb1dde48550b1a83af309a0,4549637696,
u,x64,hr-hr,d/upgr,373e5f74e3bf90e1e40597b2907a705cf7947ab6,2893579680,d/upgr,371dc050f05b667eb0ddd07f4628a6e2f6d8bbd8,3187910322,
u,x64,hu-hu,c/upgr,9c2f593daf664ef8b2424c9b85ec981d957b96b2,2914578404,c/upgr,4dff1276e483c996460413fde34f4ddb2d82ec2b,3198669702,PPI,c/upgr,051060f65e82b25aa31191d3d78026db17193fb7,4550039936,
u,x64,it-it,d/upgr,be99f0766321e460a071d50083a758dfacc64923,2966090488,d/upgr,1281c83d18b4a3f896b12d503fb8c04e574b579c,3252699004,PPI,c/upgr,62ba4a6d61577defd06ca0ba4fafa8b55e3150a7,4571989764,
u,x64,ja-jp,d/upgr,02e4b9da921626da3d03c0a413ae76148dc0f9cc,3061128986,c/upgr,5d61c365a23b3b1af2e52064b8d9403225f98d38,3380955790,
u,x64,ko-kr,c/upgr,77018ee745ebdc581693dcaa9ec8697b5605dd3b,2966153026,d/upgr,72ec8182516a922a2790559421e3dd7a12076588,3263151432,PPI,c/upgr,615f2ad896a72907eb2afde8f2be1ca85c096752,4580290718,
u,x64,lt-lt,c/upgr,afacc60cf3c558d94d01691f896a303cd3455651,2886584406,c/upgr,91811ee67098cfc971e0beca22b204f61638cfab,3171495573,PPI,c/upgr,7f6abcc66dca645a16f869dbe38643a639de57ed,4532439648,
u,x64,lv-lv,c/upgr,f36bada74914782fe174d92bf82222e7d5d61488,2884763892,c/upgr,17663ddefe2473ed47e1ab3021aecb49a2911957,3170436086,PPI,c/upgr,4168d53ab886e3a419196d2215e368af86064449,4531734468,
u,x64,nb-no,c/upgr,330597e50d041b5f9e1798671aa0857ff9dc2e3a,2918231688,c/upgr,36959196b44da127aea969a96024af7e09de1032,3205527402,PPI,c/upgr,2e56ab66aa5d83322b563a7e55e5b482e90ddd9a,4547929462,
u,x64,nl-nl,d/upgr,5fd638867eae87b871fa1d0e393866698eda8514,2929881030,d/upgr,4f802d5a36d6d129446419d00faf96c60f574ba3,3209719614,
u,x64,pl-pl,c/upgr,3e48dfc45ec6551ba7b67ae6c965351e5b0c6263,2930550878,c/upgr,169ea673afe3d895dde85efbee23ddce221f44f6,3228161764,
u,x64,pt-br,c/upgr,5e453b92f20a8713b7ca6ecc5c2f2577cc67b58a,2952864672,c/upgr,9c8ee58f9ecc4c5748166e10788b7aef771491ad,3242537098,PPI,d/upgr,63804777d9ff572e99c7706bbadc19f66fd55842,4558119204,
u,x64,pt-pt,d/upgr,6135ad949cdfc76b4ebd0375f83ffd49ea09d80c,2928144706,d/upgr,c02515d94fbd41341f59025a2c89ebf87dabfd29,3229372742,PPI,d/upgr,2ceaa41f83bd2eb80988163f8f44183720abc3e9,4565740874,
u,x64,ro-ro,c/upgr,1d231962d9263ea94c7a094565cae9e22f95e645,2904204054,d/upgr,0407c402d5a3c1c83d4b8a30cfb01747f72385e4,3185051694,PPI,d/upgr,317e038a8cde297b39b1aef9d207217ebec34952,4531929842,
u,x64,ru-ru,c/upgr,c5496123d5f1ed75a8511ea6c71c958bc38915c8,2957672236,d/upgr,0a35728822997a3290ced87d63dd0da3f20435fa,3247965106,
u,x64,sk-sk,d/upgr,07e05be074dc12e411b3d1c5cd144a210b70e869,2893555152,c/upgr,5fd6a7c13e5ad9dd90df492087ec24d814958abc,3193305246,
u,x64,sl-si,d/upgr,6236323d5ddce9c6d1e5673c13ad2232d8d8f1a3,2884411810,d/upgr,dd4fc454cf52c17cc1d3c65cadad865ec39cf331,3180336710,PPI,c/upgr,08e47862ade27725b4ff46b2902f151ed1ec0fe1,4534668306,
u,x64,sr-latn-rs,c/upgr,534d4a85ae9a935f7ede65e352252ad27e90f21f,2891648167,d/upgr,1b5296f5a5974bf00111a4e566ef945c831ad420,3186224050,
u,x64,sv-se,c/upgr,67ee08ce7dcdb02cb063a40129afae15a5e7e774,2942914320,c/upgr,95250cfc844f35e2882f32671ae1de8c976c4fe5,3201626294,
u,x64,th-th,c/upgr,c341908be3ecdbe7150a763b900cca194befe662,2909426878,d/upgr,ba005f9b74ee05f93746bce839dc877360e28922,3201916226,PPI,d/upgr,192f0c67a4abd6a6d89742ff91ef487a57dcde26,4538268360,
u,x64,tr-tr,c/upgr,3cef4a469646dd673562a2990c6fc99c1d57af3d,2917813760,d/upgr,257208062c06e87b315007769087170d277d4a69,3204014662,
u,x64,uk-ua,c/upgr,e7e3090d392bc59e15da7a49be08772a15d5c2c7,2913314734,d/upgr,b843e99042a296e35f0821816a2ad619a5395c3d,3206768732,PPI,c/upgr,29b48d5782dcb2945023ae9a260d8b579f973b34,4545946308,
u,x64,zh-cn,d/upgr,120476969142efd3701de14d140be47cf84d92ab,3137548350,c/upgr,2a825c67608ded61192a63bec775096213aa5205,3448766646,PPI,d/upgr,7a6b954573493599cd6059466885436a82ca91c6,4627039326,
u,x64,zh-tw,c/upgr,57c2708dc6583a3ba6005e04934bc07541626da2,3058815872,c/upgr,0ac1ba13c4ec709fd6edfacd6584adcefa626aee,3384825764,
u,x86,ar-sa,d/upgr,d7e56ec015c48a9ad24671c6ef1d80daea27f189,2254502852,c/upgr,4cf10443f278587cb72900324884908d8441c407,2492824508,
u,x86,bg-bg,c/upgr,225b91d09bd7a639fdabe14b7a82bfbb7abf5ba9,2227290394,c/upgr,f48b253b765dff39881651030268c09392de1555,2449636070,
u,x86,cs-cz,d/upgr,dbde988b353a76740e0576b53005cbd5861ef1c7,2213609352,d/upgr,3e56ca36104feac70f46cf7ea0a8853b1b500b3d,2447727068,
u,x86,da-dk,d/upgr,2a892143d6eaa1dcadc8720eb890a1db7a03b28d,2249489774,d/upgr,ef137301727174a08df1fb84743469139bc4e925,2467425384,
u,x86,de-de,c/upgr,a691d8569c4dd10f4831d8ab9c9bd87d7b3b918e,2319600702,d/upgr,d1f9c856dee75466ecd396f027aabaf640fc2122,2576555370,
u,x86,el-gr,c/upgr,6c7b921c6798ff2a8128bcd6130962f923064642,2226151718,c/upgr,535d32d74692fba745c4f3241549b949d76e5d68,2467105860,
u,x86,en-gb,d/upgr,6542537ae4a5b1d76c2f7658b91ccfdc84005dfe,2303122652,d/upgr,0673fd68d4acd8c079a35a2213b06b318e05ff07,2540526024,S,d/Upgr,9d92ec014d1dcc4d1968b33e9cc9bc0748e07bcd,2546331272,
u,x86,en-us,c/upgr,fe55e8afdcc571f8e8fd5a42cfccf14790d89cbc,2305264922,d/upgr,6e18fed58e3ca6097828e0b85cb9d71a6e812b47,2541035512,S,d/Upgr,9d92ec014d1dcc4d1968b33e9cc9bc0748e07bcd,2546331272,
u,x86,es-es,d/upgr,6aaf073db8890a7c6aa6214633bb345cbe9a82cf,2297447302,d/upgr,0d30a4ee2fff7affecb4bdff17eb67e9bc935a7f,2546176642,
u,x86,es-mx,c/upgr,79d8fa9f21f4f689ff2315d669e584058c407b69,2245392276,d/upgr,5024e49e1c0ab3b0d7db5405dc1a835c5e82529e,2493052572,
u,x86,et-ee,c/upgr,7b4c97f368a2673f751a9e1c98a79a65ec846b74,2190464570,c/upgr,20605729c6933a0d6e4dc02a03df3d404c9923ed,2429343544,
u,x86,fi-fi,d/upgr,44c3d9b0f171337f3e83cd4b16b9fb04875b47c5,2232027472,c/upgr,152a5599fdde049965f043ef4cd3594f725177a0,2443850910,
u,x86,fr-ca,d/upgr,01a686ce606798e63eee51111ba600f832cb867a,2268537776,c/upgr,b9eef07b0f4c8d398b452a02e400e2004e1060ee,2520135272,
u,x86,fr-fr,d/upgr,e9e686f6bb0e5a2bb463969aee1ea0bec3cafa16,2298742674,d/upgr,6d2c95ab1708554903effed98043384c07009ce1,2541782742,
u,x86,he-il,c/upgr,135c9d913514fb9ce8c0e3a11365c1f7ec96f7d4,2225234406,d/upgr,ccaa33207aed1be2676b952e216b70c27b0d44bd,2457389036,
u,x86,hr-hr,d/upgr,a97c9fd5d866cb6b49f5224c0e227923335b071b,2203786466,d/upgr,d47d0ef940827000c610141a20244be8db49e093,2432051490,
u,x86,hu-hu,c/upgr,24e79499a39c3f658a4721f0e64fc99f80eb71e5,2219026456,c/upgr,3f21594fcd99429f43a134b2ad705a39a6e93a23,2443321470,
u,x86,it-it,d/upgr,907c1dba70eca9011e7a4c087b76edd7d4ead76f,2247919526,d/upgr,2cdf05c94907e814f86875c69a33fdb3f4afa56f,2499266318,
u,x86,ja-jp,d/upgr,6511fc807e5213138c36abe22ca4b9e7c9e43dfd,2356394260,c/upgr,4c232d7187a7deae3b7a442becf86e83aa92585b,2619755766,
u,x86,ko-kr,c/upgr,9e869188c0d903fd0d982f93076960383d6b608e,2259563116,d/upgr,60598d7cb17d96b714e8c1e46331e8477ddfde26,2510631222,
u,x86,lt-lt,c/upgr,593f59fabf626765463001023aff98a29c98e713,2195909696,c/upgr,cdeeab36d55a0697a857988ba3539b5889a0b667,2428993596,
u,x86,lv-lv,c/upgr,d520a5c393fd148b7e0af4fafca9e7381b5981f7,2194102206,c/upgr,621cb2345a0bb589f11aff848467e52a64b4aa5c,2428345960,
u,x86,nb-no,c/upgr,98468450afb526f4f16f5c791ecad934f1ad99ce,2217842192,c/upgr,a58a554d48058666f6ed04f656e7679cfeb69532,2445596626,
u,x86,nl-nl,d/upgr,1b68236863ec2782377eb23c4897fc371e5d082f,2227957810,d/upgr,cb9d8986c2d5d3a5845aac14e311133228184854,2451085940,
u,x86,pl-pl,c/upgr,d2e0f7a4d26c8f52d136d7bdae162075edf70757,2226921692,c/upgr,454e63ac6d99ea6627d7841bc0410875b5ebcc6e,2472848030,
u,x86,pt-br,c/upgr,34066ad64f0066280ebde3b7833f89c7e468212b,2254176436,c/upgr,2425c7a1c1d5f265c67fa7c06b5ce4459b305214,2503136758,
u,x86,pt-pt,d/upgr,fe0f33f8faeffba3c3a059660802d9c44936c801,2228686892,d/upgr,84fe29af7992ee44492f232c4be3682d03c86ca8,2470097536,
u,x86,ro-ro,c/upgr,3787c9449e922cff784347f436f0e10b11c83588,2203396506,d/upgr,a197a2dae04fb628ef7d26afa7fb916168425a5b,2433381486,
u,x86,ru-ru,c/upgr,e01b56432419748e3420926222512f8b464509ca,2261036400,d/upgr,71d32106405319b240dcf070f7685b3d1832e77e,2499430086,
u,x86,sk-sk,d/upgr,703136264909e5333044aec874ad6fb14790eedb,2197058184,c/upgr,9cc504744b4aa015b221185332454ef7b16ab7be,2433557044,
u,x86,sl-si,d/upgr,a92efb6ebe2225fffca570d46b9bde4dcba732f9,2195839708,d/upgr,f8bed0bf249db18ef548358975e522cd5058ce80,2429463296,
u,x86,sr-latn-rs,c/upgr,8d504ce35fb48d0e43e4b0129f80157991f93727,2201558184,d/upgr,cee1f8554f96a20ab6f2cafbf97ec64fc8ab0cb0,2430903936,
u,x86,sv-se,c/upgr,5b7f3a60a484b8ab7ea57629974a6df187bdae48,2230458544,c/upgr,bdb42eeac01c6f273523b5acf72eef383a0c74b4,2445395424,
u,x86,th-th,c/upgr,df73d20b5559e717b965b762741795630a253877,2216567444,d/upgr,8d24243de4efadbae4ad505b7d3ac9a911215675,2446891086,
u,x86,tr-tr,c/upgr,e53d36d75762b89914ee1787e220ac10dfb5c5f8,2215387172,d/upgr,419b90478352a0ffb34a4acda6ad65b8c3007a44,2445522614,
u,x86,uk-ua,c/upgr,b70d87de530267e650ae34b5b29b5a316d69cde6,2220722110,d/upgr,92d482a317102c5c9c0d82c633dc2224a2e9d27a,2451238526,
u,x86,zh-cn,d/upgr,32e7d27d988f97b5b77e2a371035c9b80ee23b48,2421638284,c/upgr,1c5b9c6233824e29683eab03a330597043be909d,2692947978,
u,x86,zh-tw,c/upgr,2237f1fb22a928df1615afffacf3bd916a188728,2359003730,c/upgr,6d88e81c026f66d3873622cd852f59b511031388,2620904612,
uN,x64,bg-bg,c/upgr,7a3b8f8df4d678a1e7a34e341fc7d5618ec9a246,2779059020,c/upgr,a9b6ef650c85369e3a4f3f7232fdc7749ad0bd47,3062413646,
uN,x64,cs-cz,c/upgr,ccf1326afdb7d2641360f79e096e49c6a38ffa32,2776622382,c/upgr,9e43e3051c6142fe660ab4bb3c9318750cc7de93,3062757590,
uN,x64,da-dk,c/upgr,7406eda1d78d6f3a7e8a1bb6370daeff8a28821c,2798017588,d/upgr,aeea7197285823c6c337af2d71ce8f922ff03bbc,3063187452,
uN,x64,de-de,d/upgr,64b3d9d55cbda469d5228ccc9156cd0fc23e04d4,2887254906,c/upgr,fb0ebc0aa2ec1df782f6d5a5f18202df98907153,3174260636,
uN,x64,el-gr,d/upgr,6d69df40a7294e47c4e1ed4dd97407df71e3b579,2797909794,c/upgr,d4185e6aa65f5679fae8ae794ca94e75ea843016,3067640890,
uN,x64,en-gb,d/upgr,1178f5a038534a6db054c0587795827c8174a3b7,2856936794,d/upgr,0d11ae99ec511df9f9e61f860737dd1fe30b4206,3137052746,S,d/Upgr,7e8eae476222bbb48de04862a8ac85bdd563461c,3315033420,
uN,x64,en-us,c/upgr,9f9054a5831a86799435742b96589d35556e0b33,2861204596,d/upgr,d534aa4085bf14c3df828c5af83032b79cec8bf9,3139755962,SN,c/Upgr,e69925fec9aebc5fbf3852086ecb4c3fe00dfc2e,3144657572,
uN,x64,es-es,d/upgr,9ce4a7149f1c83547a093c77e3a054be2facd930,2851148850,d/upgr,233790bf41149c751d40811dbfa9c64f83553d8e,3146456906,
uN,x64,et-ee,d/upgr,1ed1164e84604f09732a9837adbcd27b45742d16,2747120942,d/upgr,643c5c146cfa48609ab76e718b08049fe371100a,3031709940,
uN,x64,fi-fi,d/upgr,9798bf4f02717618f71ab3ec9919e4c304b24ea8,2798444234,c/upgr,41898f06c71bba38c74c5c501f4eae437ec41695,3061874646,
uN,x64,fr-fr,d/upgr,b80067fe56f542be1e2262fd1f93ed9bf45de7e6,2851527218,c/upgr,340507bd08c569ad54e992eaa20bc5b094887bab,3132546598,
uN,x64,hr-hr,c/upgr,35d1a05b4f329e42e0d16930b6cde4122c40f765,2768580546,c/upgr,1af71d7b368e2f0fa31bdc415f9a59fc7d1490df,3032743718,
uN,x64,hu-hu,d/upgr,1a108c29a93bc32e4a1fd28c73e99ca88c5fc1c0,2782140028,c/upgr,2ae5ec7d0ce1566d5f1981d2e5b0c8f19b4bd24e,3055842566,
uN,x64,it-it,d/upgr,7521153898da230759cbc5a3b7b6534d3a378ef0,2811926886,d/upgr,ef21e54b4149b2fcd67805d966fff614ec6a23fe,3099583308,
uN,x64,lt-lt,d/upgr,f0385e16fa913fa76719383e850d1d35070a92a8,2757803852,d/upgr,bb5814b37ad1c338ab6fc73446d255e4a0134ab9,3028908668,
uN,x64,lv-lv,d/upgr,7792ef1b2b8bc3c5b8c217d0748da5b8a23eea07,2756086022,c/upgr,0ef2a40575f7cf5110609b53d454e203145132f9,3028644192,
uN,x64,nb-no,c/upgr,ff125d34aecdf49b9d1540d6061cab57dc7e39a3,2773327388,c/upgr,66f8d9a1a6a8070eef3f80d00df333d9df61fc43,3058575164,
uN,x64,nl-nl,d/upgr,e4d76ea47cccc8d3c917d5d86325903a9759e1f4,2777477440,d/upgr,48c9f2807b869bb00a9ba1241424a38f95612ebe,3062067296,
uN,x64,pl-pl,c/upgr,b15363bc8841f93b28d285220a9ad7786e1ca9a1,2781418062,d/upgr,25becb5821e972dd606bd9155740a99ae7180a1f,3080456656,
uN,x64,pt-pt,d/upgr,b7810c3c8ca4c1be162ea5cacb8eecf5f90161c8,2792216100,c/upgr,fcb4cc8a9defc6f31971aa681bdd04ee735487a7,3076125224,
uN,x64,ro-ro,d/upgr,cabebb3cdc5c3e11f839942ce96f76ebc24f14a0,2764183386,d/upgr,ec31c6800ea132e93dff86efd58a7843b05f20be,3029460788,
uN,x64,sk-sk,d/upgr,3abdf61dec10498ecd12df2570bffe4d11109e3b,2757427958,d/upgr,d3f1058d8bbbc21e81f1047a75b48b4cee0630e9,3035148714,
uN,x64,sl-si,d/upgr,e5b73905ef2020efc1bc646abe87a3ddd7dd7bf6,2758340722,c/upgr,e89e7e320308935f183c2b7a7e2e7cf7172511e1,3024798576,
uN,x64,sv-se,d/upgr,fd2fcdd512f2b38c3791426b3f8421b1041a9e0f,2788498688,d/upgr,0c40567e9a5e8d720ed6edf05a0cde9a17bb0415,3061608074,
uN,x86,bg-bg,c/upgr,66cc95cd28f00e40caee6bec7d5d70a8fb5e773f,2111252165,c/upgr,76ec0c3816f8ade33ffeee9615450467af80ec7f,2343495134,
uN,x86,cs-cz,c/upgr,f1a9bd1559dc919bc370f4166ef8ad86f10d73b6,2110545610,c/upgr,8ad87a656634d89236a6b32418e615418d5045d1,2339079508,
uN,x86,da-dk,c/upgr,497b443d71e65f6a63f01fb7ec61c53b8bfbdb6d,2144210086,d/upgr,2dc2a60636d961a67eb9496cb621113dcb582ef8,2359142738,
uN,x86,de-de,d/upgr,9213ab89e0c17890d3a9151fc79932a587f3ac52,2219606526,c/upgr,f4a2ca4545ba6a8166d4c3421849b6cc1fcb35d9,2468099010,
uN,x86,el-gr,d/upgr,94e7d1affe714552cd0d5dbacbd49eb48f3f1fbc,2124151984,c/upgr,d26d6de6ed08658921e5b702920370090e8b9592,2355660782,
uN,x86,en-gb,d/upgr,3eb8ee29ddf22f0347e51c2dc0b6e244c988c9e8,2200062104,c/upgr,14a1c43e4c7d7cf5a169257307395af0ef2e879d,2426880828,S,d/Upgr,9d92ec014d1dcc4d1968b33e9cc9bc0748e07bcd,2546331272,
uN,x86,en-us,c/upgr,3245de6b32dac4fe753a29d77c4d5276f752a9cb,2200128810,d/upgr,88743dd5e4c3b6d8ff2f6339c7a59d535f776b90,2430993824,SN,c/Upgr,0fcc1248ab6ac55cae7ec24be5b21ff163d34fc1,2437732564,
uN,x86,es-es,d/upgr,4ed9dcd6d9402c53b7c0d7ddadf29732ccd47ef3,2196419238,d/upgr,22593039f6029ebce3946a1a37292545b45071ae,2439392666,
uN,x86,et-ee,d/upgr,1edea61b5c9f927bb86adc4eb4b64e65f565f5ed,2096054254,d/upgr,cc868eb008d71ca38fc236e745cf5e27548c4bd6,2317447208,
uN,x86,fi-fi,d/upgr,8299144245d06af58bfb1787897e2601a4346bd7,2136693992,c/upgr,b5ed3b76897eecb07038496eb78dd05b032dce97,2341874174,
uN,x86,fr-fr,d/upgr,d67758e1aab4ba26e563c94c9e71f02bc8b457ce,2198063086,c/upgr,2ed1bf3706a82495959874e91b2a3a06e0a9e7b3,2435002592,
uN,x86,hr-hr,c/upgr,d9037e29d6981d000643004ac770e5e1eccfcfb7,2099953642,c/upgr,c18c5d1e09f39c547cc4e4639915f78f3161fe0b,2321673434,
uN,x86,hu-hu,d/upgr,f45cf9ff9c019ecaa9b9de14252aa950bdfeed91,2116985906,c/upgr,55751ed59fb161d34ddc3644f3722ae15dc424aa,2341763976,
uN,x86,it-it,d/upgr,e12aaf53fb3b43731394a90b052d522e53d4c3c8,2145186280,d/upgr,0e57750ad4aecb20870e58d35c0df1f76d494ddc,2384149974,
uN,x86,lt-lt,d/upgr,e5d410dee7dc702f1951f7a7a8a86590f605b302,2095722632,d/upgr,5d7619d4af7279b02bce8d4fe835205ffe470ffe,2326483892,
uN,x86,lv-lv,d/upgr,e41ce56ea65c5a80aae7aae51409c8353c89de3d,2095036762,c/upgr,6b430483aa0af8073b3a79f3ec217a71c8e394f3,2324302588,
uN,x86,nb-no,c/upgr,d0fb7c0f30e00ed68322a56f83502a84ca512b7e,2113411140,c/upgr,eb0d9b5b9a8325b13f264b14f7e7e1f6b99eb766,2337167608,
uN,x86,nl-nl,d/upgr,a71e61b4fb3a53e6346cdfae4d0a509b2c59b712,2122186926,d/upgr,146caf1f3bebf1be99c72c759ae57d033b159da8,2341747004,
uN,x86,pl-pl,c/upgr,e03523eb6a1426ac02da0db90e90da9ce24f242f,2121400542,d/upgr,6533b22e8d6ccb7867d3d97a01b5cc9e49e33541,2364261192,
uN,x86,pt-pt,d/upgr,af38dc63a255f96722417a390bb29625bd5f2c0d,2129997546,c/upgr,0fafeb7203697a8d61a0deea890321b3f0d89d16,2357048280,
uN,x86,ro-ro,d/upgr,7fde1bd5b650f7bd1b39da2c27a6cfce05cb58f2,2098687326,d/upgr,fc2cb8041993259d5472a13b561edcdcf213e54a,2329099636,
uN,x86,sk-sk,d/upgr,f77f86e70b997ef156cdafa5e3927c24d020751f,2096928490,d/upgr,07d3014138819d9681c48c5687be4bf2d75f26d4,2330490226,
uN,x86,sl-si,d/upgr,c1319abf345baf4c95a35dfbedcc0e3b9c206a59,2096845220,c/upgr,f25df37d61c88d58a7d746d6ba6159db712a70f4,2321416078,
uN,x86,sv-se,d/upgr,19d90b982ec2d963667561718642d3dcf2497cd4,2130648134,d/upgr,ae6dd7d66db41d7683af5157459bec97824535a3,2340666742,
"@
#: parameters specific to 1607 or 1703 expected via command line: $release $build $date $code
$url = 'http://fg.ds.b1.download.windowsupdate.com/'
$edi = @{e='Enterprise';eN='EnterpriseN';p='Professional';pN='ProfessionalN';u='Education';uN='EducationN'}
[xml]$p = Get-Content './products.xml'
foreach ($e in @('e','eN','p','pN','u','uN')){
  $n = $e.Replace('e','p');
  [Object]$csve = $csv | Where-Object {$_.Edition -eq $e}
  [Object]$files = $p.MCT.Catalogs.Catalog.PublishedMedia.Files.File | Where-Object {$_.Edition -eq $edi[$n]}
  foreach ($f in $files){
    $name = $build + $code + '_client' + $edi[$e].tolower();
    if($e -like 'p*'){ $name += 'vl' };
    $name += '_vol_' + $f.Architecture + 'fre_' + $f.LanguageCode
    $csvesd = $csve | Where-Object {$_.Arch -eq $f.Architecture -and $_.Lang -eq $f.LanguageCode }
    $sha1 = $csvesd.$($release + 'sha1'); $size = $csvesd.$($release + 'size'); $dir = $csvesd.$($release + 'dir')
    $c = $f.Clone()
    $c.FileName = $name + '.esd'
    $c.Size = $size
    $c.Sha1 = $sha1
    $c.FilePath = $url + $dir + $date + $name + '_' + $sha1 + '.esd'
    $c.Edition = $edi[$e]
    $c.Edition_Loc = 'Windows 10 VL ' + ($edi[$e] -creplace 'N',' N')
    $c.IsRetailOnly = 'False'
    $c.RemoveAttribute('id')
    $nul=$p.MCT.Catalogs.Catalog.PublishedMedia.Files.AppendChild($c)
  }
}
$p.Save('./products.xml')
:ps_xmlhackery: snippet end
#^_^#
