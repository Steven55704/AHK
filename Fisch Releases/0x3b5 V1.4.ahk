#NoEnv
#SingleInstance Force
#Persistent
If !(A_IsUnicode=1&&A_PtrSize=4){
	SplitPath,A_AhkPath,,dir
	Run,%dir%\AutoHotkeyU32.exe "%A_ScriptFullPath%" 
	ExitApp
}
SetKeyDelay,-1
SetMouseDelay,-1
SetWinDelay,-1
SetBatchLines,-1
ListLines 0
SetTitleMatchMode 2
CoordMode,Pixel,Relative
CoordMode,Mouse,Relative
#Include %A_MyDocuments%\Macro Settings\Lib\Gdip_All.ahk
GuiTitle:="Fisch V1.4 by 0x3b5"
DirPath:=A_MyDocuments "\Macro Settings"
LibPath:=DirPath "\Lib"
DllCall("LoadLibrary","Str",LibPath "\SkinHu.dll")
MGPath:=DirPath "\Minigame"
SkinsPath:=DirPath "\skins"
SettingsPath:=DirPath "\general.txt"
DefMGPath:=DirPath "\Minigame\default.txt"
TesseractPath:="C:\Program Files\Tesseract-OCR\tesseract.exe"
VersionPath:=DirPath "\ver.txt"
If !FileExist(DirPath)
	FileCreateDir,%DirPath%
If !FileExist(LibPath)
	FileCreateDir,%LibPath%
If !FileExist(MGPath)
	FileCreateDir,%MGPath%
If !FileExist(DefMGPath)
	FileAppend,[Values]`nStabilizerLoop=40`nSideBarRatio=0.8`nSideBarWait=1.84`nRightMult=2.5821`nRightDiv=1.8961`nRightAnkleMult=1.36`nLeftMult=2.9892`nLeftDiv=4.6235,%DefMGPath%
If !FileExist(VersionPath)
	FileAppend,1.4 2,%VersionPath%
IniRead,configFooter,%SettingsPath%,.,v,NotFound
If(configFooter=="NotFound"){
	Gosub DefaultSettings
	IniWrite,yes,%SettingsPath%,.,v
}
ReadGen(ShakeMode,"ShakeMode")
ReadGen(NavigationKey,"NavKey")
ReadGen(ShakeDelay,"ShakeDelay")
ReadGen(ShakeOnly,"ShakeOnly")
ReadGen(StartHotkey,"StartHotkey")
ReadGen(ReloadHotkey,"ReloadHotkey")
ReadGen(ExitHotkey,"ExitHotkey")
ReadGen(AutoLowerGraphics,"LowerGraphics")
ReadGen(AutoZoomInCamera,"ZoomInCamera")
ReadGen(AutoLookDownCamera,"LookDown")
ReadGen(AutoBlurShake,"BlurShake")
ReadGen(AutoBlurMinigame,"BlurMinigame")
ReadGen(ShutdownAfterFailLimit,"ShutdownAfterFailLimit")
ReadGen(PrivateServer,"PrivateServer")
ReadGen(RestartDelay,"RestartDelay")
ReadGen(RodCastDuration,"CastDelay")
ReadGen(CastRandomization,"CastRandomization")
ReadGen(WaitForBobber,"WaitForBobber")
ReadGen(AutosaveSettings,"AutoSave")
ReadGen(WebhookURL,"WebhookURL")
ReadGen(UseWebhook,"WebhookEnabled")
ReadGen(NotifEveryN,"WebhookNotifyInterval")
ReadGen(NotifImg,"WebhookSendImg")
ReadGen(ImgNotifEveryN,"WebhookImgNotifyInterval")
ReadGen(NotifyOnFailsafe,"NotifyOnFailsafe")
ReadGen(SendScreenshotFL,"NotifyOnFishLost")
ReadGen(LvlUpMode,"LvlNotifyMode")
ReadGen(LastLvl,"LastLvl")
ReadGen(CheckLvlEveryN,"WebhookLvlNotifyInterval")
ReadGen(curMGFile,"SelectedConfig")
ReadGen(SelectedSkin,"SelectedTheme")
ReadGen(buyConch,"PurchaseConch")
ReadGen(GuiAlwaysOnTop,"AlwaysOnTop")
AutoGraphicsDelay:=50
AutoZoomDelay:=40
AutoCameraDelay:=25
AutoLookDelay:=50
AutoBlurDelay:=25
SendScreenshotEveryN:=10
If(SelectedSkin!="none"){
	sl:=SkinsPath "\"SelectedSkin
	If FileExist(sl)
		DllCall("SkinHu\SkinH_AttachEx","Str",sl)
}
If !FileExist(MGPath "\"curMGFile)
	curMGFile:="default.txt"
curMGConfig:=ImportMinigameConfig(curMGFile)
StabilizerLoop:=curMGConfig[1]
SideBarRatio:=curMGConfig[2]
SideBarWait:=curMGConfig[3]
RightMult:=curMGConfig[4]
RightDiv:=curMGConfig[5]
RightAnkleMult:=curMGConfig[6]
LeftMult:=curMGConfig[7]
LeftDiv:=curMGConfig[8]
LeftDeviation:=50
ShakeFailsafe:=8
BarDetectionFailsafe:=3
FailsInARow:=0
RepeatBypassLimit:=15
BarColor:=0xF8F8F8
BarCalcColor:=0xF0F0F0
ArrowColor:=0x868483
FishColor:=0x5B4B43
ManualBarSize:=0
Test1:=0
Test2:=0
MSD:=250
MAD:=200
SS:=1
FishCaught:=0
FishLost:=0
CatchCount:=0
runtime1:=0
runtime2:=0
cryoCanal:={farm:False,CFatC:False}
XOdebounce:=True
instructions:=FetchInstructions()
SetTimer,GuiRuntime,1000
Gosub InitGui
GuiControl,Choose,Tabs,2
WinActivate,Roblox
If WinActive("Roblox"){
	WinMaximize,Roblox
	Send {LButton up}
	Send {RButton up}
	Send {Shift up}
}
Hotkey % "$"StartHotkey,StartMacro
Hotkey % "$"ReloadHotkey,ReloadMacro
Hotkey % "$"ExitHotkey,ExitMacro
SendStatus(0)
Return
DefaultSettings:
	WriteGen("ShakeMode","Click")
	WriteGen("NavKey","\")
	WriteGen("ShakeDelay",35)
	WriteGen("ShakeOnly",0)
	WriteGen("StartHotkey","F1")
	WriteGen("ReloadHotkey","F2")
	WriteGen("ExitHotkey","F3")
	WriteGen("LowerGraphics",1)
	WriteGen("ZoomInCamera",1)
	WriteGen("LookDown",1)
	WriteGen("BlurShake",1)
	WriteGen("BlurMinigame",1)
	WriteGen("ShutdownAfterFailLimit",0)
	WriteGen("PrivateServer","")
	WriteGen("RestartDelay",800)
	WriteGen("CastDelay",750)
	WriteGen("CastRandomization",100)
	WriteGen("WaitForBobber",300)
	WriteGen("AutoSave",1)
	WriteGen("WebhookURL","")
	WriteGen("WebhookEnabled",0)
	WriteGen("WebhookNotifyInterval",1)
	WriteGen("WebhookSendImg",0)
	WriteGen("WebhookImgNotifyInterval",10)
	WriteGen("NotifyOnFailsafe",1)
	WriteGen("NotifyOnFishLost",1)
	WriteGen("LvlNotifyMode","Off")
	WriteGen("LastLvl",1)
	WriteGen("WebhookLvlNotifyInterval",1)
	WriteGen("SelectedConfig","default.txt")
	WriteGen("SelectedTheme","none")
	WriteGen("PurchaseConch",1)
	WriteGen("AlwaysOnTop",1)
Return
SaveSettings:
	WriteGen("ShakeMode",ShakeMode)
	WriteGen("NavKey",NavigationKey)
	WriteGen("ShakeDelay",ShakeDelay)
	WriteGen("ShakeOnly",ShakeOnly)
	WriteGen("StartHotkey",StartHotkey)
	WriteGen("ReloadHotkey",ReloadHotkey)
	WriteGen("ExitHotkey",ExitHotkey)
	WriteGen("LowerGraphics",AutoLowerGraphics)
	WriteGen("ZoomInCamera",AutoZoomInCamera)
	WriteGen("LookDown",AutoLookDownCamera)
	WriteGen("BlurShake",AutoBlurShake)
	WriteGen("BlurMinigame",AutoBlurMinigame)
	WriteGen("ShutdownAfterFailLimit",ShutdownAfterFailLimit)
	WriteGen("PrivateServer",PrivateServer)
	WriteGen("RestartDelay",RestartDelay)
	WriteGen("CastDelay",RodCastDuration)
	WriteGen("CastRandomization",CastRandomization)
	WriteGen("WaitForBobber",WaitForBobber)
	WriteGen("AutoSave",AutosaveSettings)
	WriteGen("WebhookURL",WebhookURL)
	WriteGen("WebhookEnabled",UseWebhook)
	WriteGen("WebhookNotifyInterval",NotifEveryN)
	WriteGen("WebhookSendImg",0)
	WriteGen("WebhookImgNotifyInterval",10)
	WriteGen("NotifyOnFailsafe",NotifyOnFailsafe)
	WriteGen("NotifyOnFishLost",SendScreenshotFL)
	WriteGen("LvlNotifyMode",LvlUpMode)
	WriteGen("LastLvl",LastLvl)
	WriteGen("WebhookLvlNotifyInterval",CheckLvlEveryN)
	WriteGen("SelectedConfig",curMGFile)
	WriteGen("SelectedTheme",SelectedSkin)
	WriteGen("PurchaseConch",buyConch)
	WriteGen("AlwaysOnTop",GuiAlwaysOnTop)
Return
GuiRuntime:
	runtime1++
	GuiControl,Text,TRT1,% GetTime(runtime1)
	GuiControl,Text,TRT2,% GetTime(runtime2)
	GuiControl,Text,TFC,% FishCaught " / "FishLost " ("RegExReplace(FishCaught/CatchCount*100,"(?<=\.\d{3}).*$") "%)"
Return
ReloadMacro:
	Reload
Return
ExitMacro:
	Send {LButton up}
	Send {RButton up}
	Send {Shift up}
	SendStatus(2,[FishCaught])
	Sleep 25
	ExitApp
Return
MoveGui:
	x:=WW-455
	y:=WH-200
	WinMove,%GuiTitle%,,%x%,%y%
Return
StartMacro:
	WinActivate,Roblox
	WinMaximize,Roblox
	SendStatus(1)
	Sleep 250
	Gosub Calculations
	Gosub MoveGui
	If GuiAlwaysOnTop
		GuiControl,Choose,Tabs,1
	SetTimer,Failsafe3,1000
	If AutoLowerGraphics{
		UpdateTask("Current Task: Lower Graphics")
		Sleep AutoGraphicsDelay/2
		Send {Shift}
		Loop,20{
			Send {Shift down}{F10}
			Sleep AutoGraphicsDelay
		}
		Send {Shift up}
		Sleep AutoGraphicsDelay/2
	}
	If AutoZoomInCamera{
		UpdateTask("Current Task: Zoom Camera")
		Sleep AutoZoomDelay
		Loop,20{
			Send {WheelUp}
			Sleep AutoZoomDelay
		}
		Send {WheelDown}
		Sleep AutoZoomDelay*5
	}
	UpdateTask("Current Task: Enable Camera Mode")
	PixelSearch,,,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,0xFFFFFF,1,Fast
	If !ErrorLevel{
		Sleep AutoCameraDelay
		Send 2
		Sleep AutoCameraDelay
		Send 1
		Sleep AutoCameraDelay
		Send {%NavigationKey%}
		Sleep AutoCameraDelay
		Loop,10{
			Send d
			Sleep AutoCameraDelay
		}
		Send {Enter}
		Sleep AutoCameraDelay
		Send {%NavigationKey%}
	}
	Goto RestartMacro
Return
RestartMacro:
	If(cryoCanal.farm&&!cryoCanal.CFatC){
		UpdateTask("Current Task: Walking To Cryogenic Canal")
		Click 0,500
		Loop,5{
			Send {WheelDown}
			Sleep AutoZoomDelay
		}
		Send {d up}{w up}{s up}{a up}{Space up}
		Sleep 100
		Send {d down}
		Sleep 1300
		Send {w down}
		Sleep 850
		Send {w up}{s down}
		Sleep 2700
		Send {d up}e
		Sleep 200
		Send {s up}e
		Sleep 200
		Loop,5{
			Send e
			Sleep 25
		}
		Sleep 200
		Send {Space down}{w down}{d down}e
		Sleep 1000
		Send {d up}
		Sleep 1000
		Send {Space up}
		Sleep 4250
		Send {d down}{Space down}
		Sleep 5600
		Send {w up}{Space up}
		Sleep 1450
		Send {Space down}
		Sleep 6000
		Send {d up}{Space up}
		Sleep 100
		Send {Space down}{a down}{s down}
		Sleep 4400
		Send {a up}
		Sleep 500
		Send {Space up}
		Sleep 3600
		Send {a down}{s up}
		Sleep 1500
		Send {w down}
		Sleep 200
		Send {w up}
		Sleep 5300
		Send {w down}
		Sleep 100
		Send {a up}
		Sleep 2650
		Send {w up}
		Sleep 500
		Loop,25{
			Send {WheelUp}
			Sleep AutoZoomDelay
		}
		Loop,3{
			Send {WheelDown}
			Sleep AutoZoomDelay
		}
		Sleep AutoZoomDelay*5
		StopFarmingAt:=A_TickCount+36*60000
		cryoCanal.CFatC:=True
	}
	MouseMove,LookDownX,LookDownY
	If AutoLookDownCamera{
		UpdateTask("Current Task: Look Down")
		Send {RButton up}
		Sleep AutoLookDelay
		MouseMove,LookDownX,LookDownY
		Sleep AutoLookDelay
		Send {RButton down}
		Sleep AutoLookDelay
		DllCall("mouse_event",uint,1,int,0,int,10000)
		Sleep AutoLookDelay
		Send {RButton up}
		Sleep AutoLookDelay
		MouseMove,LookDownX,LookDownY
		Sleep AutoLookDelay
	}
	If AutoBlurShake{
		UpdateTask("Current Task: Blur Camera")
		Sleep AutoBlurDelay
		Send m
		Sleep AutoBlurDelay
	}
	UpdateTask("Current Task: Cast Rod")
	Send {LButton down}
	Random,RCD,0,CastRandomization*2
	Sleep RodCastDuration-RCD+CastRandomization
	Send {LButton up}
	Sleep WaitForBobber
	UpdateTask("Current Task: Shake")
	If(ShakeMode=="Click")
		Goto CShakeMode
	Else
		Goto NShakeMode
Return
Failsafe1:
	FailsafeCount++
	If(FailsafeCount>=ShakeFailsafe){
		SetTimer,Failsafe1,Off
		FailsInARow++
		SendStatus(4,["Shaking failed.",FailsInARow])
		ForceReset:=True
	}
Return
Failsafe2:
	BarCalcFailsafeCounter++
	If(BarCalcFailsafeCounter>=BarDetectionFailsafe){
		SetTimer,Failsafe2,Off
		FailsInARow++
		SendStatus(4,["Bar not found.",FailsInARow])
		ForceReset:=True
	}
Return
Failsafe3:
	If(ShutdownAfterFailLimit&&FailsInARow>14){
		SetTimer,Failsafe3,Off
		SendStatus(4,["Failsafe triggered too many times, shutting down.",FailsInARow])
		Sleep 25
		Shutdown,1
		Goto ExitMacro
	}
	runtime2++
Return
Track:
	PixelSearch,x,,ProgBarRight,ProgBarTop,ProgBarLeft,ProgBarBottom,0xFFFFFF,3,Fast
	If !ErrorLevel
		ProgressX:=x
	Else{
		PixelSearch,x,,ProgBarRight,ProgBarTop,ProgBarLeft,ProgBarBottom,0x9F9F9F,3,Fast
		If !ErrorLevel
			ProgressX:=x
	}
Return
CShakeMode:
	FailsafeCount:=0
	CShakeRepeatBypassCounter:=0
	MemoryX:=0
	MemoryY:=0
	ForceReset:=False
	SetTimer,Failsafe1,1000
	Loop{
		If ForceReset{
			If(cryoCanal.farm&&A_TickCount>=StopFarmingAt)
				Gosub backUp
			Goto RestartMacro
		}
		Sleep ShakeDelay
		PixelSearch,,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		If !ErrorLevel{
			SetTimer,Failsafe1,Off
			Sleep 200
			Goto BarMinigame
		}Else{
			PixelSearch,ClickX,ClickY,CShakeRight,CShakeTop,CShakeLeft,CShakeBottom,0xFFFFFF,1,Fast
			If !ErrorLevel{
				If(ClickX!=MemoryX&&ClickY!=MemoryY){
					CShakeRepeatBypassCounter:=0
					MouseMove,ClickX,ClickY
					Sleep ShakeDelay
					Click ClickX,ClickY
					MemoryX:=ClickX
					MemoryY:=ClickY
				}Else{
					CShakeRepeatBypassCounter++
					If(CShakeRepeatBypassCounter>=RepeatBypassLimit){
						MemoryX:=0
						MemoryY:=0
					}
				}
			}
		}
	}
Return
NShakeMode:
	FailsafeCount:=0
	ForceReset:=False
	SetTimer,Failsafe1,1000
	Send {%NavigationKey%}
	Loop{
		If ForceReset{
			If(cryoCanal.farm&&A_TickCount>=StopFarmingAt)
				Gosub backUp
			Goto RestartMacro
		}
		Sleep ShakeDelay
		PixelSearch,,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		If !ErrorLevel{
			SetTimer,Failsafe1,Off
			Sleep 200
			Goto BarMinigame
		}Else
			Send s{Enter}
	}
Return
BarMinigame:
	If AutoBlurMinigame
		Send m
	ForceReset:=False
	BarCalcFailsafeCounter:=0
	SetTimer,Failsafe2,1000
	Loop{
		Sleep 1
		UpdateTask("Current Task: Calculating Bar Size")
		If ForceReset{
			If(cryoCanal.farm&&A_TickCount>=StopFarmingAt)
				Gosub backUp
			Goto RestartMacro
		}
		PixelSearch,SBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarCalcColor,1,Fast
		If !ErrorLevel{
			SetTimer,Failsafe2,Off
			If ManualBarSize{
				WhiteBarSize:=ManualBarSize
				Break
			}
			WhiteBarSize:=FishBarRight-SBX+FishBarLeft-SBX
			If !Test1
				Test1:=WhiteBarSize
			Else If !Test2{
				If(Test1=WhiteBarSize)
					Test2:=WhiteBarSize
				Else
					Test1:=0
			}Else If(Test1=Test2)
				WhiteBarSize:=Test2
			If(WhiteBarSize>0)
				Break
		}
	}
	UpdateTask("Current Task: Bar Minigame")
	HalfBarSize:=WhiteBarSize/2
	SideDelay:=0
	AnkleBreakDelay:=0
	DirectionalToggle:=""
	MaxLeftToggle:=False
	MaxRightToggle:=False
	ProgressX:=0
	MaxLeftBar:=FishBarLeft+WhiteBarSize*SideBarRatio
	MaxRightBar:=FishBarRight-WhiteBarSize*SideBarRatio
	GetFishPos(){
		Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,ResolutionScaling
		PixelSearch,FishX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		Return ErrorLevel?False:FishX
	}
	GetBarPos(){
		Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarColor,UnstableColorX,UnstableColorY,HalfBarSize
		FB:=False
		PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarColor,9,Fast
		If !ErrorLevel{
			BX:=TBX+HalfBarSize
			FB:=True
		}
		If !FB{
			PixelGetColor,UC,UnstableColorX,UnstableColorY
			PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,UC,21,Fast
			If !ErrorLevel{
				BX:=TBX+HalfBarSize
				FB:=True
			}
		}
		If !FB{
			PixelSearch,AX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,ArrowColor,1,Fast
			If !ErrorLevel{
				PixelGetColor,UC,AX+25,FishBarTop-5
				If(UC=FishColor)
					PixelGetColor,UC,AX-25,FishBarTop-5
				PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,UC,5,Fast
				If !ErrorLevel{
					BX:=TBX+HalfBarSize
					FB:=True
				}
			}
		}
		Return FB?BX:False
	}
	Stabilize(s:=0){
		Global StabilizerLoop
		Loop,StabilizerLoop{
			Send {LButton up}
			If s
				Sleep 1
			Send {LButton down}
		}
	}
	MinigameStart:=A_TickCount
	SetTimer,Track,100
	Goto MinigameLoop
Return
MinigameLoop:
	Sleep 1
	FishX:=GetFishPos()
	If FishX{
		If ShakeOnly
			Goto MinigameLoop
		FailsInARow:=0
		Stabilize(1)
		Stabilize()
		If(FishX<MaxLeftBar){
			If !MaxLeftToggle{
				DirectionalToggle:="Right"
				MaxLeftToggle:=True
				Send {LButton up}
				Sleep 1
				Send {LButton up}
				Sleep Min(MSD,SideDelay)
				AnkleBreakDelay:=0
				SideDelay:=0
			}
			Goto MinigameLoop
		}Else If(FishX>MaxRightBar){
			If !MaxRightToggle{
				DirectionalToggle:="Left"
				MaxRightToggle:=True
				Send {LButton down}
				Sleep 1
				Send {LButton down}
				Sleep Min(MSD,SideDelay)
				AnkleBreakDelay:=0
				SideDelay:=0
			}
			Goto MinigameLoop
		}
		MaxLeftToggle:=False
		MaxRightToggle:=False
		BarX:=GetBarPos()
		If BarX{
			If(BarX<=FishX){
				Difference:=Scale(FishX-BarX)*ResolutionScaling*RightMult
				CounterDifference:=Difference/RightDiv
				Send {LButton down}
				Stabilize()
				Send {LButton down}
				If(DirectionalToggle=="Left"){
					Stabilize()
					Send {LButton down}
					Sleep Min(MAD,AnkleBreakDelay)
					AnkleBreakDelay:=0
				}Else{
					AnkleBreakDelay:=AnkleBreakDelay+(Difference-CounterDifference)*RightAnkleMult
					SideDelay:=AnkleBreakDelay/RightAnkleMult*SideBarWait
				}
				Sleep Difference
				Send {LButton up}
				FishX:=GetFishPos()
				If(FishX<MaxLeftBar||FishX>MaxRightBar)
					Goto MinigameLoop
				Sleep CounterDifference
				Stabilize(1)
				Send {LButton up}
				DirectionalToggle:="Right"
			}Else{
				Difference:=Scale(BarX-FishX)*ResolutionScaling*LeftMult
				CounterDifference:=Difference/LeftDiv
				Send {LButton up}
				Stabilize()
				Send {LButton up}
				AnkleBreakDelay:=0
				If(DirectionalToggle=="Right"){
					Stabilize()
					Send {LButton up}
					Sleep MAD
				}
				Sleep Difference-LeftDeviation
				Send {LButton down}
				FishX:=GetFishPos()
				If(FishX<MaxLeftBar||FishX>MaxRightBar)
					Goto MinigameLoop
				Sleep CounterDifference
				Stabilize(1)
				Send {LButton down}
				DirectionalToggle:="Left"
			}
		}
		Goto MinigameLoop
	}Else{
		Duration:=(A_TickCount-MinigameStart)/1000
		WasFishCaught:=ProgressX>WW/2
		SetTimer,Track,Off
		CatchCount++
		If WasFishCaught
			FishCaught++
		Else
			FishLost++
		Sleep RestartDelay
		If UseWebhook{
			If(!WasFishCaught&&SendScreenshotFL)||(WasFishCaught&&Mod(CatchCount,SendScreenshotEveryN)=0){
				FormatTime,ct,,hh:mm:ss
				elapsed:=GetTime(runtime2)
				ratio:=FishCaught " / "FishLost " ("RegExReplace(FishCaught/CatchCount*100,"(?<=\.\d{3}).*$") "%)"
				dur:=RegExReplace(Duration,"(?<=\.\d{3}).*$")
				caught:=WasFishCaught?"Fish took "dur "s to catch.":"Spent "dur "s trying to catch the fish."
				CS2DC(0,0,A_ScreenWidth,A_ScreenHeight,"{""embeds"":[{""image"":{""url"":""attachment://screenshot.png""},""color"":15258703,""fields"":[{""name"":""Catch Rate"",""value"":"""ratio """},{""name"":""Fish was "(WasFishCaught?"Caught!":"Lost.") """,""value"":"""caught """},{""name"":""Runtime"",""value"": """GetTime(runtime2) """}],""footer"":{""text"":"""ct """}}]}")
			}Else If(Mod(CatchCount,NotifEveryN)=0)
				SendStatus(3,[FishCaught,FishLost,Duration,WasFishCaught])
			If(LvlUpMode!="Off"&&Mod(CatchCount,CheckLvlEveryN)=0)
				Gosub CheckStatistics
		}
		If(cryoCanal.farm&&A_TickCount>=StopFarmingAt)
			Gosub backUp
		Goto RestartMacro
	}
Return
backUp:
	cryoCanal.CFatC:=False
	Sleep 200
	If AutoBlurMinigame
		Send m
	PixelSearch,,,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,0xFFFFFF,1,Fast
	If ErrorLevel{
		Sleep AutoCameraDelay
		Send {%NavigationKey%}
		Sleep AutoCameraDelay
		Loop,10{
			Send d
			Sleep AutoCameraDelay
		}
		Send {Enter}
		Sleep AutoCameraDelay*5
		Send {%NavigationKey%}
	}
	Sleep 200
	If buyConch{
		Send {s down}
		Sleep 400
		Send {s up}{d down}
		Sleep 1500
		Send {d up}
		Sleep 300
		Send {Space down}
		Sleep 400
		Send {d down}
		Sleep 1000
		Send {Space up}{d up}{s down}e
		Sleep 200
		Send {s up}e
		Sleep 400
		Loop,5{
			Send {WheelDown}e
			Sleep AutoZoomDelay
		}
		Sleep 200
		Send e
		Sleep 400
		Click 830,600
		Sleep 400
	}Else
		Sleep 1000
	Send {9}
	Sleep 500
	Click 0,500
	Sleep 400
	Send {1}
	PixelSearch,,,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,0xFFFFFF,1,Fast
	If !ErrorLevel{
		Sleep AutoCameraDelay
		Send {%NavigationKey%}
		Sleep AutoCameraDelay
		Loop,10{
			Send d
			Sleep AutoCameraDelay
		}
		Send {Enter}
		Sleep AutoCameraDelay
	}
	Click 0,500
	Sleep 4000
Return
CheckStatistics:
	PixelSearch,,,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,0xFFFFFF,1,Fast
	If ErrorLevel{
		Sleep AutoCameraDelay
		Send {%NavigationKey%}
		Sleep AutoCameraDelay
		Loop,10{
			Send d
			Sleep AutoCameraDelay
		}
		Send {Enter}
		Sleep AutoCameraDelay
	}
	x:=WW-455
	WinMove,%GuiTitle%,,%x%,0
	Sleep 500
	If !CaptureScreen("capture.png",1820,995,95,30)
		RunWait,% TesseractPath " ""capture.png"" ""capture.png_out""",,Hide
	FileRead,lvl,capture.png_out.txt
	FileDelete,capture.png
	FileDelete,capture.png_out.txt
	lvl:=RegExReplace(lvl,"[^0-9]")
	If(lvl!=""&&lvl!=LastLvl){
		LastLvl:=lvl
		FileDelete,%SettingsPath%
		s:=""
		For i,v In [PrivateServer,WebhookURL,UseWebhook,StartHotkey,ReloadHotkey,ExitHotkey,NavigationKey,ShakeMode,NotifyOnFailsafe,NotifEveryN,AutoLowerGraphics,AutoZoomInCamera,AutoLookDownCamera,AutoBlurShake,AutoBlurMinigame,ShutdownAfterFailLimit,RestartDelay,RodCastDuration,CastRandomization,WaitForBobber,ShakeDelay,ShakeOnly,AutosaveSettings,GuiAlwaysOnTop,CheckLvlEveryN,curMGFile,SendScreenshotFL,LvlUpMode,LastLvl,SelectedSkin,configFooter]
			s.=v " "
		FileAppend,%s%,%SettingsPath%
		If(LvlUpMode=="Txt")
			SendStatus(5,[lvl])
		Else
			CS2DC(1844,995,1915,1025,"{""embeds"":[{""image"":{""url"":""attachment://screenshot.png""},""color"":4848188,""title"":""Level Up"",""footer"":{""text"":"""ct """}}]}")
	}
	Gosub MoveGui
	Sleep 250
	WinActivate,Roblox
	WinMaximize,Roblox
	Sleep AutoCameraDelay
	Send {Enter}
	Sleep AutoCameraDelay
Return
Calculations:
	WinGetActiveStats,T,WW,WH,WL,WT
	If(WW+WH-A_ScreenWidth-A_ScreenHeight)
		Send {F11}
	CameraCheckLeft:=WW/2.15
	CameraCheckRight:=WW/1.85
	CameraCheckTop:=WH/1.105
	CameraCheckBottom:=WH/1.077
	CShakeLeft:=WW/4.6545
	CShakeRight:=WW/1.2736
	CShakeTop:=WH/14.08
	CShakeBottom:=WH/1.3409
	FishBarLeft:=WW/3.32
	FishBarRight:=WW/1.43
	FishBarTop:=WH/1.172
	FishBarBottom:=WH/1.16
	BarHeight:=WH/1.0626
	ResolutionScaling:=2560/WW
	UnstableColorX:=WW/3.463
	UnstableColorY:=WH/1.168
	ProgBarLeft:=WW/2.547
	ProgBarRight:=WW/1.644
	ProgBarTop:=WH/1.1
	ProgBarBottom:=WH/1.0965
	LookDownX:=WW/2
	LookDownY:=WH/4
	Scale(x){
		c:=1.53519
		e:=0.867626
		Return c*x**e
	}
Return
InitGui:
	Gui -MinimizeBox -MaximizeBox +AlwaysOnTop
	Gui Add,Tab3,vTabs x0 y0 w450 h176,Info|Main|Webhook|Minigame|Locations|Miscellaneous|Credits
	Gui Tab,1
	Gui Font,s10
	Gui Add,Text,x5 y22 w72 h16,Gui Runtime
	Gui Font
	Gui Add,Text,vTRT1 x6 y38 w56 h13,0h 00m 00s
	Gui Font,s10
	Gui Add,Text,x5 y54 w90 h16,Macro Runtime
	Gui Font
	Gui Add,Text,vTRT2 x6 y70 w56 h13,0h 00m 00s
	Gui Add,Text,vTTask x5 y87 w162 h14,Current Task: Idle
	Gui Font
	Gui Add,Text,vTFC x5 y102 w100 h13,Fish Count: 0/0
	Gui Tab,2
	Gui Font,w600
	Gui Add,GroupBox,x2 y21 w140 h84,Shaking
	Gui Font
	Gui Add,Text,x9 y35 w64 h13,Shake Mode:
	Gui Add,Text,x9 y53 w75 h13,Navigation Key:
	Gui Add,Text,x9 y70 w64 h13,Shake Delay:
	Gui Add,Text,x9 y87 w58 h13,Shake Only:
	ListVal:=(ShakeMode=="Click")?"Click||Navigation":"Click|Navigation||"
	Gui Add,DropDownList,vDDSM gSubAll x74 y31 w65,%ListVal%
	Gui Add,Edit,vNK gSubAll x85 y53 w54 h16,%NavigationKey%
	Gui Add,Edit,vSD gSubAll x74 y70 w65 h16 Number,%ShakeDelay%
	SHO:=Chkd(ShakeOnly)
	Gui Add,CheckBox,vCBSO gSubAll x125 y87 w13 h13 %SHO%,Shake Only:
	Gui Font,w600
	Gui Add,GroupBox,x2 y104 w140 h71,Hotkeys
	Gui Font
	Gui Add,Text,x9 y116 w67 h13,Start Fisching:
	Gui Add,Text,x9 y136 w70 h13,Reload Macro:
	Gui Add,Text,x9 y155 w54 h13,Exit Macro:
	Gui Add,Hotkey,vCSHK gSubAll x81 y115 w57 h18,%StartHotkey%
	Gui Add,Hotkey,vCRHK gSubAll x81 y134 w57 h18,%ReloadHotkey%
	Gui Add,Hotkey,vCEHK gSubAll x81 y153 w57 h18,%ExitHotkey%
	Gui Font,w600
	Gui Add,GroupBox,x144 y21 w134 h106,Options
	Gui Font
	ALG:=Chkd(AutoLowerGraphics),AZC:=Chkd(AutoZoomInCamera),ALD:=Chkd(AutoLookDownCamera),ABlS:=Chkd(AutoBlurShake),ABlM:=Chkd(AutoBlurMinigame),ASF:=Chkd(ShutdownAfterFailLimit)
	Gui Add,CheckBox,vCBLG gSubAll x148 y35 w96 h14 %ALG%,Lower Graphics
	Gui Add,CheckBox,vCBZC gSubAll x148 y50 w98 h14 %AZC%,Zoom In Camera
	Gui Add,CheckBox,vCBLD gSubAll x148 y65 w98 h14 %ALD%,Look Down
	Gui Add,CheckBox,vCBBS gSubAll x148 y80 w104 h14 %ABlS%,Blur When Shake
	Gui Add,CheckBox,vCBBM gSubAll x148 y95 w118 h14 %ABlM%,Blur When Minigame
	Gui Add,CheckBox,vCBSF gSubAll x148 y110 w128 h14 %ASF%,ShutdownAfterFailLimit
	Gui Font,w600
	Gui Add,GroupBox,x144 y126 w134 h48,Game
	Gui Font
	Gui Add,Button,gJG x152 y138 w120 h17,Join Game
	Gui Add,Text,x148 y156 w41 h13,PS Link:
	Gui Add,Edit,vPSL gSubAll x189 y155 w86 h16,%PrivateServer%
	Gui Font,w600
	Gui Add,GroupBox,x280 y21 w168 h95,Delays
	Gui Font
	Gui Add,Text,x284 y36 w64 h14,Restart Delay
	Gui Add,Text,x284 y56 w68 h14,Hold Rod Cast
	Gui Add,Text,x284 y76 w94 h14,Cast Randomization
	Gui Add,Text,x284 y96 w78 h14,Wait For Bobber
	Gui Add,Edit,vDLRL gSubAll x387 y34 w58 h18 Number,%RestartDelay%
	Gui Add,Edit,vDLHR gSubAll x387 y54 w58 h18 Number,%RodCastDuration%
	Gui Add,Edit,vDLCR gSubAll x387 y74 w58 h18 Number,%CastRandomization%
	Gui Add,Edit,vDLWB gSubAll x387 y94 w58 h18 Number,%WaitForBobber%
	Gui Font,w600
	Gui Add,GroupBox,x280 y115 w168 h60,Settings
	Gui Font
	Gui Add,Button,gSTRS x284 y130 w80 h26,Reset Settings
	Gui Add,Button,gSTSV x366 y130 w80 h26,Save Settings
	ASS:=Chkd(AutosaveSettings)
	Gui Add,CheckBox,vCBAS gSubAll x286 y158 w120 h14 %ASS%,Autosave Settings
	Gui Tab,3
	Gui Add,Text,x5 y24 w73 h14,Webhook URL
	Gui Add,Edit,vWURL gSubAll x3 y36 w120 h21,%WebhookURL%
	UWH:=Chkd(UseWebhook)
	Gui Add,CheckBox,vCBWH gSubAll x4 y59 w100 h14 %UWH%,Enable Webhook
	Gui Add,Text,x4 y76 w56 h13,Notify every
	Gui Add,Edit,vWHSK gSubAll x60 y74 w22 h18 Number,%NotifEveryN%
	Gui Add,Text,x83 y76 w40 h13,catches.
	NSI:=Chkd(NotifyImg)
	Gui Add,CheckBox,vCBSI gSubAll x4 y92 w92 h14 %NSI%,Send Img every
	Gui Add,Edit,vSIEN gSubAll x97 y91 w22 h18,%ImgNotifEveryN%
	Gui Add,Text,x5 y106 w40 h13,catches.
	Gui Font,w600
	Gui Add,GroupBox,x125 y21 w322 h153,Options
	Gui Font
	NOF:=Chkd(NotifyOnFailsafe),SFL:=Chkd(SendScreenshotFL)
	Gui Add,CheckBox,vCBNF gSubAll x129 y35 w100 h14 %NOF%,Notify on Failsafe
	Gui Add,CheckBox,vCBSS gSubAll x129 y51 w114 h14 %SFL%,Send SS on fish lost
	ListVal:=(LvlUpMode=="Off")?"Off||Txt|Img":(LvlUpMode=="Txt")?"Off|Txt||Img":"Off|Txt|Img||"
	Gui Add,DropDownList,vDDSS gSubAll x129 y66 w42,%ListVal%
	Gui Add,Text,x174 y70 w84 h14,Notify on level up
	Gui Add,Text,x129 y87 w62 h13,Check every
	Gui Add,Edit,vCLEN gSubAll x190 y85 w26 h18 Number,%CheckLvlEveryN%
	Gui Add,Text,x218 y87 w40 h13,catches.
	Gui Tab,4
	cnfgoptions:=ScanForConfigs(curMGFile)
	Gui Add,DropDownList,vMGCF gMGCCF x2 y24 w100,% cnfgoptions[1]
	Gui Add,Button,gMGSave x103 y23 w40 h23,Save
	Gui Add,Button,gMGExport x143 y23 w70 h23,New Config
	Gui Add,Button,gMGOpen x213 y23 w70 h23,Open Folder
	Gui Add,Button,gMGRefresh x283 y23 w70 h23,Scan Folder
	Gui Font,w600
	Gui Add,GroupBox,x2 y46 w120 h52,Left
	Gui Font
	Gui Add,Text,x9 y58 w42 h14,Multiplier
	Gui Add,Text,x9 y77 w32 h14,Divisor
	Gui Add,Edit,vMGLM x68 y56 w52 h17 gNumberEdit,%LeftMult%
	Gui Add,Edit,vMGLD x68 y76 w52 h17 gNumberEdit,%LeftDiv%
	Gui Font,w600
	Gui Add,GroupBox,x2 y98 w120 h76,Right
	Gui Font
	Gui Add,Text,x9 y111 w42 h14,Multiplier
	Gui Add,Text,x9 y130 w32 h14,Divisor
	Gui Add,Text,x9 y150 w50 h14,Ankle Mult
	Gui Add,Edit,vMGRM x68 y108 w52 h17 gNumberEdit,%RightMult%
	Gui Add,Edit,vMGRD x68 y128 w52 h17 gNumberEdit,%RightDiv%
	Gui Add,Edit,vMGAM x68 y148 w52 h17 gNumberEdit,%RightAnkleMult%
	Gui Font,w600
	Gui Add,GroupBox,x124 y46 w128 h128,Other
	Gui Font
	Gui Add,Text,x128 y58 w68 h14,Stabilizer Loop
	Gui Add,Text,x128 y78 w64 h14,Sidebar Ratio
	Gui Add,Text,x128 y98 w62 h14,Sidebar Wait
	Gui Add,Edit,vMGSL x198 y56 w52 h17 gNumberEdit,%StabilizerLoop%
	Gui Add,Edit,vMGSR x198 y76 w52 h17 gNumberEdit,%SideBarRatio%
	Gui Add,Edit,vMGSW x198 y96 w52 h17 gNumberEdit,%SideBarWait%
	Gui Add,Text,x135 y116 w115 h55,Note: Make sure to `nselect the desired file`nname before changing`nany of these values.
	Gui Tab,5
	Gui Add,GroupBox,x2 y21 w223 h77,Cryogenic Canal
	CFH:=Chkd(cryoCanal.farm),CBC:=Chkd(buyConch)
	Gui Add,CheckBox,vCBCF gSubAll x7 y36 w64 h18 %CFH%,Farm here
	Gui Add,CheckBox,vCBBC gSubAll x7 y53 w70 h18 %CBC%,Buy Conch
	Gui Add,Text,x105 y29 w38 h14,Setup:
	Gui Add,Text,x115 y42 w94 h14,Set spawn at Grotto
	Gui Add,Text,x115 y55 w90 h14,Equip needed gear
	Gui Add,Text,x115 y68 w106 h14,Use conch, face north
	Gui Add,Text,x115 y81 w100 h14,Put conch at slot 9
	Gui Tab,6
	AOT:=Chkd(GuiAlwaysOnTop)
	Gui Add,CheckBox,vCBOT gSubAll x9 y24 w90 h14 %AOT%,Always On Top
	Gui,Add,Text,x4 y44 w44 h14,Themes:
	Gui,Add,ComboBox,vDDSL gChangeTheme x50 y40 w120 h100,
	Loop,%SkinsPath%\*.she
		GuiControl,,DDSL,% A_LoopFileName
	Gui Add,GroupBox,x302 y22 w146 h154,What is this for?
	Gui Font,s20
	Gui Add,Button,vX1Y1 gTTT x304 y33 w48 h48
	Gui Add,Button,vX2Y1 gTTT x351 y33 w48 h48
	Gui Add,Button,vX3Y1 gTTT x398 y33 w48 h48
	Gui Add,Button,vX1Y2 gTTT x304 y80 w48 h48
	Gui Add,Button,vX2Y2 gTTT x351 y80 w48 h48
	Gui Add,Button,vX3Y2 gTTT x398 y80 w48 h48
	Gui Add,Button,vX1Y3 gTTT x304 y127 w48 h48
	Gui Add,Button,vX2Y3 gTTT x351 y127 w48 h48
	Gui Add,Button,vX3Y3 gTTT x398 y127 w48 h48
	Gui Font
	Gui Tab,7
	Gui Add,Link,x6 y22 w276 h14,This macro is based on the <a href="https://www.youtube.com/@AsphaltCake">AsphaltCake</a> Fisch Macro V11
	Gui Add,Text,x6 y+4 w257 h14,Gui, modified minigame, polishing, and webhook by me.
	Gui Add,Text,x6 y+4 w257 h14,Image webhook provided by @lunarosity
	Gui Add,Text,x6 y+4 w257 h14,Themes and Lvl checker provided by @toxgt
	Gui Add,Link,x6 y+4 w102 h14,Check out my <a href="https://github.com/LopenaFollower">GitHub</a>
	Gui Show,w450 h175,%GuiTitle%
	Return
	TTT:
		Gui Submit,NoHide
		c:=A_GuiControl
		GuiControlGet,sym,,%c%
		If(sym==""&&XOdebounce){
			XOdebounce:=False
			GuiControl,,%c%,X
			Random,slp,250,400
			Sleep slp
			ncb:=["X1Y1","X2Y1","X3Y1","X1Y2","X2Y2","X3Y2","X1Y3","X2Y3","X3Y3"]
			cb:=""
			For _,v in ncb{
				GuiControlGet,s,,%v%
				cb.=(s=="")?"_":s
			}
			For k,v in instructions
				If(SubStr(v,1,9)==cb)
					bm:=StrSplit(SubStr(v,10))
			GuiControl,,% "X"bm[1] "Y"bm[2],O
			clb:=False
			XOdebounce:=True
			For _,v in ["100100100","010010010","001001001","111000000","000111000","000000111","100010001","001010100"]{
				won:=True
				For k,i in StrSplit(v){
					GuiControlGet,ns,,% ncb[k]
					If(ns!="O"&&i=="1")
						won:=False
				}
				If clb:=won
					Break
			}
			If !clb{
				clb:=True
				For k,v in ncb{
					GuiControlGet,ns,,% v
					If(ns=="")
						clb:=False
				}
			}
			Sleep 500-slp
			If clb
				For j,i in ncb
					GuiControl,,%i%,
		}
	Return
	ChangeTheme:
		Gui Submit,NoHide
		If(Trim(DDSL)!=""){
			sl:=SkinsPath "\"DDSL
			If FileExist(sl){
				SelectedSkin:=DDSL
				DllCall("SkinHu\SkinH_AttachEx","Str",sl)
			}
		}
	Return
	NumberEdit:
		c:=A_GuiControl
		GuiControlGet,inp,,%c%
		If !RegExMatch(inp,"^[0-9]*\.?[0-9]*$"){
			inp:=RegExReplace(inp,"[^0-9.]")
			parts:=StrSplit(inp,".")
			If(parts.MaxIndex()>2)
				inp:=parts[1] "."parts[2]
			GuiControl,,%c%,%inp%
		}
		Goto SubAll
	Return
	SubAll:
		Gui Submit,NoHide
		If StrLen(NK)=1
			NavigationKey:=NK
		If StrLen(SD)>0
			ShakeDelay:=SD
		If StrLen(DLRL)>0
			RestartDelay:=DLRL
		If StrLen(DLHR)>0
			RodCastDuration:=DLHR
		If StrLen(DLCR)>0
			CastRandomization:=DLCR
		If StrLen(DLWB)>0
			WaitForBobber:=DLWB
		If StrLen(WURL)>100
			WebhookURL:=WURL
		If StrLen(WHSK)>0
			NotifEveryN:=WHSK
		If StrLen(PSL)>32
			PrivateServer:=PSL
		If(CSHK!=StartHotkey){
			If Trim(CSHK)!=""&&CSHK!=CRHK&&CSHK!=CEHK{
				Hotkey % "$"StartHotkey,Off
				StartHotkey:=CSHK
				Hotkey % "$"CSHK,StartMacro
			}Else{
				GuiControl,,CSHK,%StartHotkey%
				ShowMsg("Hotkey in use")
			}
		}
		If(CRHK!=ReloadHotkey){
			If Trim(CRHK)!=""&&CRHK!=CSHK&&CRHK!=CEHK{
				Hotkey % "$"ReloadHotkey,Off
				ReloadHotkey:=CRHK
				Hotkey % "$"CRHK,ReloadMacro
			}Else{
				GuiControl,,CRHK,%ReloadHotkey%
				ShowMsg("Hotkey in use")
			}
		}
		If(CEHK!=ExitHotkey){
			If Trim(CEHK)!=""&&CEHK!=CSHK&&CEHK!=CRHK{
				Hotkey % "$"ExitHotkey,Off
				ExitHotkey:=CEHK
				Hotkey % "$"CEHK,ExitMacro
			}Else{
				GuiControl,,CEHK,%ExitHotkey%
				ShowMsg("Hotkey in use")
			}
		}
		ShakeMode:=DDSM
		AutoLowerGraphics:=CBLG
		AutoZoomInCamera:=CBZC
		AutoLookDownCamera:=CBLD
		AutoBlurShake:=CBBS
		AutoBlurMinigame:=CBBM
		ShutdownAfterFailLimit:=CBSF
		UseWebhook:=CBWH
		NotifyOnFailsafe:=CBNF
		ShakeOnly:=CBSO
		AutosaveSettings:=CBAS
		GuiAlwaysOnTop:=CBOT
		CheckLvlEveryN:=Max(5,CLEN)
		SendScreenshotFL:=CBSS
		NotifImg:=CBSI
		ImgNotifEveryN:=SIEN
		LvlUpMode:=DDSS
		cryoCanal.farm:=CBCF
		buyConch:=CBBC
		If(DDSS!="Off")
			downloadTesseract()
		WinSet,AlwaysOnTop,%CBOT%,%GuiTitle%
		If CBAS
			Goto SaveSettings
	Return
	STRS:
		AskUser("Reset Settings","Are you sure?")
		IfMsgBox Yes
			Goto DefaultSettings
	Return
	STSV:
		AskUser("Save Settings","Overwrite old settings?")
		IfMsgBox Yes
			Goto SaveSettings
	Return
	MGCCF:
		Gui Submit,NoHide
		curMGFile:=MGCF
		Gosub UpdateMGVals
		Goto UpdateDisplay
	Return
	MGSave:
		Gui Submit,NoHide
		SplitPath,MGCF,,,,FileName
		MGConfig:="[Values]`nStabilizerLoop="MGSL "`nSideBarRatio="MGSR "`nSideBarWait="MGSW "`nRightMult="MGRM "`nRightDiv="MGRD "`nRightAnkleMult="MGAM "`nLeftMult="MGLM "`nLeftDiv="MGLD
		path:=DirPath "\Minigame\"FileName ".txt"
		FileDelete,%path%
		FileAppend,%MGConfig%,%path%
		Goto MGCCF
	Return
	MGExport:
		Gui Submit,NoHide
		isvalid:=True
		Gui +OwnDialogs
		InputBox,FileName,File name,Enter file name.,,170,140
		chars:="\\/:*?""<>| "
		Loop,Parse,chars
			If InStr(FileName,A_LoopField)
				isvalid:=False
		If RegExMatch(FileName,"i)^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$")
			isvalid:=False
		If Trim(FileName)=""
			isvalid:=False
		If isvalid{
			isdupe:=False
			Loop %MGPath%\*.*{
				SplitPath,A_LoopFileName,,,,n
				If(n==FileName)
					isdupe:=True
			}
			MGConfig:="[Values]`nStabilizerLoop=10`nSideBarRatio=0.8`nSideBarWait=2`nRightMult=2.6`nRightDiv=1.4`nRightAnkleMult=1.2`nLeftMult=2.6`nLeftDiv=1.4"
			path:=DirPath "\Minigame\"FileName ".txt"
			If isdupe{
				AskUser("Duplicate Found","Overwrite this file?")
				IfMsgBox Yes
				{
					FileDelete,%path%
					FileAppend,%MGConfig%,%path%
				}
			}Else{
				FileDelete,%path%
				FileAppend,%MGConfig%,%path%
				newopt:=ScanForConfigs(FileName ".txt")
				GuiControl,,MGCF,|
				GuiControl,,MGCF,% newopt[1]
				Goto MGCCF
			}
		}Else{
			Gui +OwnDialogs
			MsgBox,16,Invalid,File name contains invalid character or is empty.
		}
	Return
	MGRefresh:
		Gui Submit,NoHide
		newopt:=ScanForConfigs(curMGFile)
		GuiControl,,MGCF,|
		GuiControl,,MGCF,% newopt[1]
		f:=(newopt[2]=1)?" file.":" files."
		ShowMsg("Found "newopt[2] f)
	Return
	MGOpen:
		Run % MGPath
	Return
	UpdateMGVals:
		cf:=ImportMinigameConfig(curMGFile)
		StabilizerLoop:=cf[1]
		SideBarRatio:=cf[2]
		SideBarWait:=cf[3]
		RightMult:=cf[4]
		RightDiv:=cf[5]
		RightAnkleMult:=cf[6]
		LeftMult:=cf[7]
		LeftDiv:=cf[8]
	Return
	UpdateDisplay:
		cf:=ImportMinigameConfig(curMGFile)
		GuiControl,,MGSL,% cf[1]
		GuiControl,,MGSR,% cf[2]
		GuiControl,,MGSW,% cf[3]
		GuiControl,,MGRM,% cf[4]
		GuiControl,,MGRD,% cf[5]
		GuiControl,,MGAM,% cf[6]
		GuiControl,,MGLM,% cf[7]
		GuiControl,,MGLD,% cf[8]
	Return
	JG:
		Gui Submit,NoHide
		PS:="roblox://placeID=16732694052"
		If StrLen(PSL)>32
			PS:=PSL
		Run % PS
	Return
Return
ImportMinigameConfig(name){
	Global MGPath
	path:=MGPath "\" name
	IniRead,StabilizerLoop,%path%,Values,StabilizerLoop
	IniRead,SideBarRatio,%path%,Values,SideBarRatio
	IniRead,SideBarWait,%path%,Values,SideBarWait
	IniRead,RightMult,%path%,Values,RightMult
	IniRead,RightDiv,%path%,Values,RightDiv
	IniRead,RightAnkleMult,%path%,Values,RightAnkleMult
	IniRead,LeftMult,%path%,Values,LeftMult
	IniRead,LeftDiv,%path%,Values,LeftDiv
	Return [StabilizerLoop,SideBarRatio,SideBarWait,RightMult,RightDiv,RightAnkleMult,LeftMult,LeftDiv]
}
ScanForConfigs(cur){
	Global MGPath
	opt:=cur "||"
	cnt:=1
	Loop %MGPath%\*.*{
		item:=A_LoopFileName
		If(item!=cur&&Trim(item)!=""){
			opt.=item "|"
			cnt++
		}
	}
	Return [opt,cnt]
}
UpdateTask(t){
	GuiControl,Text,TTask,%t%
}
parseSettings(s){
	a:=StrSplit(s," ")
	For i,v in a
		If v is Number
			a[i]:=v+0
	Return a
}
GetTime(t,f:="{:}h {:02}m {:02}s"){
	Local H,M,S,A:=60,B:=A*A
	Return Format(f,H:=t//B,M:=(t:=t-H*B)//A,t-M*A,S:=H,S*A+M)
}
ShowMsg(t){
	Gui +OwnDialogs
	MsgBox,%t%
}
AskUser(a,b){
	Gui +OwnDialogs
	MsgBox,4,%a%,%b%
}
Chkd(b){
	Return b?"Checked":""
}
FetchInstructions(){
	req:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	req.Open("GET","https://raw.githubusercontent.com/LopenaFollower/JavaScript/refs/heads/main/instructions.txt",1)
	req.Send()
	req.WaitForResponse()
	Return StrSplit(req.ResponseText,"`n")
}
SendStatus(st,info:=0){
	Global WebhookURL,NotifyOnFailsafe,runtime2,SendScreenshotFL
	If StrLen(WebhookURL)>100{
		payload:=""
		FormatTime,ct,,hh:mm:ss
		elapsed:=GetTime(runtime2)
		req:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		req.Open("POST",WebhookURL "?wait=true",0)
		req.SetRequestHeader("Content-Type","application/json")
		Switch st
		{
		case 0: req.Send("{""embeds"":[{""color"":5066239,""fields"":[],""title"":""Starting UI"",""footer"":{""text"":"""ct """}}]}")
		case 1: req.Send("{""embeds"":[{""color"":65280,""fields"":[],""title"":""Starting Macro"",""footer"":{""text"":"""ct """}}]}")
		case 2:
			tc:=info[1]
			req.Send("{""embeds"":[{""color"":16711680,""fields"":[{""name"":""Runtime"",""value"": """elapsed """},{""name"":""Total Catches"",""value"":"""tc """}],""title"":""Exiting Macro"",""footer"":{""text"":"""ct """}}]}")
		case 3:
			fc:=info[1]
			fl:=info[2]
			d:=info[3]
			s:=info[4]
			ratio:=fc " / "fl " ("RegExReplace(fc/(fc+fl)*100,"(?<=\.\d{3}).*$") "%)"
			dur:=RegExReplace(d,"(?<=\.\d{3}).*$")
			caught:=s?"Fish took "dur "s to catch.":"Spent "dur "s trying to catch the fish."
			req.Send("{""embeds"":[{""color"":15258703,""fields"":[{""name"":""Catch Rate"",""value"":"""ratio """},{""name"":""Fish was "(s?"Caught!":"Lost.") """,""value"":"""caught """},{""name"":""Runtime"",""value"": """elapsed """}],""footer"":{""text"":"""ct """}}]}")
		case 4:
			FailsafeMessage:=info[1]
			Occurences:=info[2]
			If NotifyOnFailsafe
				req.Send("{""embeds"":[{""title"":""Failsafe Triggered! ("Occurences ")"",""description"":"""FailsafeMessage """,""color"":0,""fields"":[],""footer"":{""text"":"""ct """}}]}")
		case 5:
			lvl:=info[1]
			req.Send("{""embeds"":[{""color"":4848188,""fields"":[{""name"":""Level Up"",""value"": ""You are now level "lvl """}],""footer"":{""text"":"""ct """}}]}")
		}
	}
}
downloadTesseract(){
	Global TesseractPath,GuiAlwaysOnTop,GuiTitle
	If !FileExist(TesseractPath){
		Gui +OwnDialogs
		MsgBox,48,Tesseract Not Found,This feature requires Tesseract OCR to be installed. The script will now download and install it.
		InstallerPath:=A_Temp "\tesseract-installer.exe"
		UrlDownloadToFile,https://github.com/tesseract-ocr/tesseract/releases/download/5.5.0/tesseract-ocr-w64-setup-5.5.0.20241111.exe,%InstallerPath%
		If !FileExist(InstallerPath){
			Gui +OwnDialogs
			MsgBox,16,Error,Failed to download the Tesseract installer. Please check your internet connection and try again.
			GuiControl,ChooseString,DDSS,Off
		}
		WinSet,AlwaysOnTop,0,%GuiTitle%
		RunWait,%InstallerPath% /SILENT,,Hide
		WinSet,AlwaysOnTop,%GuiAlwaysOnTop%,%GuiTitle%
		If FileExist("C:\Program Files\Tesseract-OCR\tesseract.exe")
			MsgBox,64,Installation Complete,Tesseract OCR has been successfully installed!
		Else{
			MsgBox,16,Installation Failed,Tesseract OCR installation failed. Please install it manually at https://github.com/tesseract-ocr/tesseract.
			GuiControl,ChooseString,DDSS,Off
		}
	}
}
CaptureScreen(path,x,y,w,h){
	If !pT:=Gdip_Startup()
		Return False
	If !pB:=Gdip_BitmapFromScreen(x "|"y "|"w "|"h){
		Gdip_Shutdown(pT)
		Return False
	}
	If !Gdip_SaveBitmapToFile(pB,path){
		Gdip_DisposeImage(pB)
		Gdip_Shutdown(pT)
		Return False
	}
	Gdip_DisposeImage(pB)
	Gdip_Shutdown(pT)
	Return True
}
CS2DC(x1,y1,x2,y2,payload){
	Global WebhookURL
	tempFile:=A_Temp "\screenshot.png"
	CaptureScreen(tempFile,x1,y1,x2-x1,y2-y1)
	New CreateFormData({file:[tempFile],payload_json:payload},pd,hd)
	HTTP:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	HTTP.Open("POST",WebhookURL,0)
	HTTP.SetRequestHeader("Content-Type",hd)
	HTTP.Send(pd)
	FileDelete,%tempFile%
}
WriteGen(k,v){
	Global SettingsPath
	IniWrite,%v%,%SettingsPath%,All,%k%
}
ReadGen(ByRef out,k){
	Global SettingsPath
	IniRead,temp,%SettingsPath%,All,%k%
	If temp is Number
		temp:=temp+0
	out:=temp
}
Class CreateFormData{
	__New(obj,ByRef rD,ByRef rH){
		Local CRLF:="`r`n",i,k,v,n,s,o,B28:="----------------------------"A_TickCount,B30:="--"B28
		this.L:=0,this.P:=DllCall("GlobalAlloc",uint,64,uint,1,"Ptr")
		For k,v in obj{
			If IsObject(v){
				For i,fn in v{
					n:=FileOpen(fn,"r").ReadUInt()
					this.SPutf8(s:=B30 CRLF "Content-Disposition:form-data;name="""k """;filename="""fn """"CRLF "Content-Type:"((n=0x474E5089)?"image/png":(n=0x38464947)?"image/gif":(n&0xFFFF=0x4D42)?"image/bmp":(n&0xFFFF=0xD8FF)?"image/jpeg":(n&0xFFFF=0x4949)?"image/tiff":(n&0xFFFF=0x4D4D)?"image/tiff":"application/octet-stream")CRLF CRLF)
					o:=FileOpen(fn,"r")
					this.P:=DllCall("GlobalReAlloc","Ptr",this.P,uint,this.L+=o.Length,uint,66)
					o.RawRead(this.P+this.L-o.length,o.length),o.Close()
					this.SPutf8(CRLF)
				}
			}Else
				this.SPutf8(s:=B30 CRLF "Content-Disposition:form-data;name="""k """"CRLF CRLF v CRLF)
		}
		this.SPutf8(B30 "--"CRLF)
		DllCall("RtlMoveMemory","Ptr",NumGet(ComObjValue(rD:=ComObjArray(16,this.L))+8+A_PtrSize),"Ptr",this.P,"Ptr",this.L)
		DllCall("GlobalFree","Ptr",this.P,"Ptr")
		rH:="multipart/form-data;boundary="B28
	}
	SPutf8(s){
		StrPut(s,(this.P:=DllCall("GlobalReAlloc","Ptr",this.P,uint,(this.L+=(R:=StrPut(s,"utf-8")-1))+1,uint,66))+this.L-R,R,"utf-8")
	}
}
GuiClose:
	Goto ExitMacro
