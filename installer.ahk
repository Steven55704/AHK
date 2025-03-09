#NoEnv
#SingleInstance Force
#Persistent

; added as debug
global versionUrl:="https://raw.githubusercontent.com/Steven55704/AHK/refs/heads/main/Fisch%20Releases/version.txt"
global DownloadUrl:="https://raw.githubusercontent.com/Steven55704/AHK/refs/heads/main/Fisch%20Releases/main.ahk"
global AssetsUrl:="https://raw.githubusercontent.com/Steven55704/AHK/refs/heads/main/Fisch%20Releases/Assets/"

global SkinDllUrl:=AssetsUrl "SkinHu.dll"
Gui -MaximizeBox -MinimizeBox
Gui, Font, Segoe UI s8 Norm
Gui Add, Text, x16 y20 vPathText, % "Install Directory: "
Gui Add, Edit, x16 y40 h20 w220 vMainPath, % A_ScriptDir
Gui Add, Button, x245 y35 w70 h30 vChange gChangePath, % "Change"
Gui Add, Checkbox, x16 y69 vRunMacro, % "Run macro after install" ; nice
GuiControl,, RunMacro, 1
Gui Add, Button, x245 y165 w70 h26 vContinue gContinue, % "Continue"
Gui Add, Button, x172 y165 w70 h26 vCancel gCancel, % "Cancel"
Gui, Show, w330 h200, Installer
Return

progressmode() { ; stuff for progress bar becuz it looks cool and so the user doesnt think the installer isnt working
	global
	things := ["PathText","MainPath","Change","RunMacro","Continue","Cancel"]
	for _,v in things {
		GuiControl, Hide, % v
	}
	Gui, Font, s10 Norm Segoe UI
	Gui Add, Text, x16 y16, % "Installation Progress"
	Gui, Font, s8 Norm
	Gui Add, Text, x16 y45 w298 vInstallFile
	Gui Add, Progress, x16 y70 w298 h25 cGreen vProgressBar, 0
}
setprogresstext(file,percent) {
	GuiControl,Text, InstallFile, % "Currently installing " file
	GuiControl,, ProgressBar, +%percent%
}
ChangePath:
	FileSelectFolder, folder, A_MyDocuments
	GuiControl,, MainPath, % folder
Return
Cancel:
	; progressmode()
	ExitApp
Return
Continue:
	GuiControlGet, folder,,MainPath
	If !FileExist(folder) {
		FileCreateDir, % MainPath
	} Else {
		download()
	}
Return

download() {
	progressmode()
	req:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	req.Open("GET",versionUrl,1)
	req.Send()
	req.WaitForResponse()

	instructions:=StrSplit(req.ResponseText,"`n")
	res:=StrSplit(RegExReplace(instructions[1],"[^0-9. ]")," ")
	latest_ver:=res[1]
	latest_build:=res[2]
	fileList:="8bit.she`nadamant.she`nAero.she`nAeroPink.she`nalien.she`nartist.she`nasus.she`nbetter.she`nbetterblack.she`nblack.she`nblackandwhite.she`nblackwhitedark.she`nblue.she`nbluehint.she`nbluehintdark.she`nbrownday.she`nbumblebee.she`ncalmwhite.she`nchina.she`nclouds.she`ncompact.she`ndarken.she`ndarkpinky.she`ndarkroyale.she`ndarktech.she`ndeepforest.she`ndogmax.she`nelegance.she`nenjoy.she`nfisch.she`nfishing.she`ngem.she`nhlong.she`nhomestead.she`nidkwhatthisis.she`ninsomnia.she`nitunes.she`nkankan.she`nlonghorn.she`nminimal.she`nmodern.she`nmoderngray.she`nocean.she`noffice2007.she`nOffice2007_New.she`noldred.she`nopen.she`nouframe.she`npaperscribble.she`npastalpink.she`nPerQQ2009.she`npf.she`npinkflowers.she`npiss.she`npixos.she`npositive.she`npuplewhite.she`npurplewhite.she`nQQ2008.she`nqqgame.she`nQQGame2009.she`nredflee.she`nroyale.she`nskinh.she`nslime.she`nsmoothblue.she`nsmoothred.she`nstorm.she`nTVB.she`numwtf.she`nvista.she`nwarm.she`nwarmblack.she`nwarmeyes.she`nwave.she`nwhite.she`nWinAjuda.she`nwish.she`nwtfisthis.she`nXenes.she`nxmp.she`nXunlei5.she"
	fileCount := 92
	percentPerFile := 100/fileCount
	GuiControlGet, DirPath,,Mainpath
	DirPath:=DirPath "\Macro Settings"
	MainPath:=DirPath "\main.ahk" 
	LibPath:=DirPath "\Lib"
	GdipPath:=LibPath "\Gdip_All.ahk"
	SkinDllPath:=LibPath "\SkinHu.dll"
	MGPath:=DirPath "\Minigame"
	SkinsPath:=DirPath "\skins"
	VersionPath:=DirPath "\ver.txt"
	;Check folders
	FileCreateDir,%DirPath%
	FileCreateDir,%LibPath%
	FileCreateDir,%MGPath%
	FileCreateDir,%SkinsPath%
	;Check if main ahk exists
	If FileExist(VersionPath){
		FileRead,localver,%VersionPath%
		lvsp:=StrSplit(localver," ")
		local_ver:=lvsp[1]
		local_build:=lvsp[2]
		If(latest_ver!=local_ver||latest_build!=local_build){
			FileDelete,%VersionPath%
			If FileExist(MainPath)
				FileDelete,%MainPath%
		}
	}
	Loop,Parse,fileList,`n
	{
		fileName:=A_LoopField
		setprogresstext(fileName,percentPerFile)
		if(fileName!=""&&!FileExist(SkinsPath "\"fileName)){
			fileURL:=AssetsUrl "skins/"fileName
			URLDownloadToFile,%fileURL%,% SkinsPath "\"fileName
			if ErrorLevel
				MsgBox,16,Error,Failed to download: %fileName%
		}
	}
	If !FileExist(SkinDllPath)
		setprogresstext("SkinHu.dll",percentPerFile)
		UrlDownloadToFile,%SkinDllUrl%,%SkinDllPath%
	If !FileExist(MainPath){
		Loop,%DirPath%\*.ahk
			FileDelete,% DirPath A_LoopFileName
		UrlDownloadToFile,%DownloadUrl%,%MainPath%
	}
	If !FileExist(GdipPath)
		setprogresstext("Gdip_All",percentPerFile)
		UrlDownloadToFile,https://raw.githubusercontent.com/marius-sucan/AHK-GDIp-Library-Compilation/refs/heads/master/ahk-v1-1/Gdip_All.ahk,%GdipPath%
	For k,v in instructions{
		If(k>1&&Trim(v)!=""){
			setprogresstext(v,percentPerFile)
			spl:=StrSplit(v," - ")
			path:=LibPath "\"spl[1]
			If !FileExist(path)
				UrlDownloadToFile,% AssetsUrl spl[1],%path%
			Else{
				lv:=spl[2]
				FileReadLine,cur,%path%,1
				If(";"lv!=cur){
					UrlDownloadToFile,% AssetsUrl spl[1],%path%
				}
			}
		}
	}
	GuiControlGet, runMacro,, RunMacro
	if (runMacro) {
		Run % MainPath
	}
	ExitApp
}