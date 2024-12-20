#NoEnv
#SingleInstance Force
#Persistent
SetKeyDelay,-1
SetMouseDelay,-1
SetWinDelay,-1
SetBatchLines,-1
ListLines 0
SetTitleMatchMode 2
CoordMode,Pixel,Relative
CoordMode,Mouse,Relative
configFooter:="sv01"
recConfg:=" F1 F2 F3 \ Click 1 1 1 1 1 1 1 0 600 750 100 300 35 0 1 1 "configFooter
defConfg:="0 0 0" recConfg
DirPath:=A_MyDocuments "\Macro Settings"
SettingsPath:=DirPath "\general.txt"
MinigamePath:=DirPath "\minigame.txt"
If !FileExist(DirPath)
	FileCreateDir,%DirPath%
If !FileExist(SettingsPath)
	FileAppend,%defConfg%,%SettingsPath%
FileRead,configs,%SettingsPath%
ar:=parseSettings(configs)
If(ar[25]!=configFooter){
	AskUser("Settings file outdated","Regenerate settings file?")
	IfMsgBox Yes
	{
		FileDelete,%SettingsPath%
		recovered:=ar[1] " " ar[2] " " ar[3]
		FileAppend,% recovered recConfg,%SettingsPath%
		ShowMsg("Settings successfully updated! (set to default)")
		Reload
	}Else
		ar:=parseSettings(defConfg)
}
PrivateServer:=(ar[1]=0)?"":ar[1]
WebhookURL:=(ar[2]=0)?"":ar[2]
UseWebhook:=ar[3]
StartHotkey:=ar[4]
ReloadHotkey:=ar[5]
ExitHotkey:=ar[6]
NavigationKey:=ar[7]
ShakeMode:=ar[8]
NotifyOnFailsafe:=ar[9]
NotifEveryN:=ar[10]
AutoLowerGraphics:=ar[11]
AutoZoomInCamera:=ar[12]
AutoLookDownCamera:=ar[13]
AutoBlurShake:=ar[14]
AutoBlurMinigame:=ar[15]
ShutdownAfterFailLimit:=ar[16]
RestartDelay:=ar[17]
RodCastDuration:=ar[18]
CastRandomization:=ar[19]
WaitForBobber:=ar[20]
ShakeDelay:=ar[21]
ShakeOnly:=ar[22]
AutosaveSettings:=ar[23]
GuiAlwaysOnTop:=ar[24]
AutoGraphicsDelay:=20
AutoZoomDelay:=30
AutoCameraDelay:=5
AutoLookDelay:=50
AutoBlurDelay:=25
StabilizerLoop:=16
SideBarRatio:=0.8
SideBarWait:=1.84
RightMult:=2.5747
RightDiv:=1.8962
RightAnkleMult:=1.23
LeftMult:=2.9863
LeftDiv:=4.5227
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
SendStatus(st,info:=0){
	Global WebhookURL,NotifyOnFailsafe,runtime2
	Try{
		If StrLen(WebhookURL)>100{
			payload:=""
			FormatTime,ct,,hh:mm:ss
			elapsed:=GetTime(runtime2)
			req:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
			req.Open("POST",WebhookURL "?wait=true",0)
			req.SetRequestHeader("Content-Type","application/json")
			switch st
			{
			case 0: req.Send("{""content"":"""",""embeds"":[{""color"":5066239,""fields"":[],""title"":""Starting UI"",""footer"":{""text"":"""ct """}}]}")
			case 1: req.Send("{""content"":"""",""embeds"":[{""color"":65280,""fields"":[],""title"":""Starting Macro"",""footer"":{""text"":"""ct """}}]}")
			case 2:
				tc:=info[1]
				req.Send("{""content"":"""",""embeds"":[{""color"":16711680,""fields"":[{""name"":""Runtime"",""value"": """elapsed """},{""name"":""Total Catches"",""value"":"""tc """}],""title"":""Exiting Macro"",""footer"":{""text"":"""ct """}}]}")
			case 3:
				fc:=info[1]
				fl:=info[2]
				d:=info[3]
				s:=info[4]
				ratio:=fc " / "fl " ("RegExReplace(fc/(fc+fl)*100,"(?<=\.\d{3}).*$") "%)"
				dur:=RegExReplace(d,"(?<=\.\d{3}).*$")
				caught:=s?"Fish took "dur "s to catch.":"Spent "dur "s trying to catch the fish."
				req.Send("{""content"":"""",""embeds"":[{""color"":15258703,""fields"":[{""name"":""Catch Rate"",""value"":"""ratio """},{""name"":""Fish was "(s?"Caught!":"Lost.") """,""value"":"""caught """},{""name"":""Runtime"",""value"": """elapsed """}],""footer"":{""text"":"""ct """}}]}")
			case 4:
				FailsafeMessage:=info[1]
				Occurences:=info[2]
				If NotifyOnFailsafe
					req.Send("{""content"":"""",""embeds"":[{""title"":""Failsafe Triggered! ("Occurences ")"",""description"":"""FailsafeMessage """,""color"":0,""fields"":[],""footer"":{""text"":"""ct """}}]}")
			}
		}
	}catch e
	{}
}
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
	SendStatus(2,[CatchCount])
	Sleep 25
	ExitApp
Return
MoveGui:
	x:=WW-455
	y:=WH-200
	WinMove,Fisch V1 by 0x3b5,,%x%,%y%
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
		AutoZoomDelay*=5
		Sleep AutoZoomDelay
	}
	PixelSearch,,,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,0xFFFFFF,5,Fast
	UpdateTask("Current Task: Enable Camera Mode")
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
	}
	Goto RestartMacro
Return
RestartMacro:
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
	FishX:=GetFishPos()
	If FishX&&!WasFishCaught{
		PixelSearch,,,WW/1.6525,WH/1.1024,WW/1.644,WH/1.1,0xCECECE,98,Fast
		WasFishCaught:=!ErrorLevel
	}
Return
CShakeMode:
	FailsafeCount:=0
	ClickCount:=0
	CShakeRepeatBypassCounter:=0
	MemoryX:=0
	MemoryY:=0
	ForceReset:=False
	SetTimer,Failsafe1,1000
	Loop{
		If ForceReset
			Goto RestartMacro
		Sleep ShakeDelay
		PixelSearch,,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		If !ErrorLevel{
			SetTimer,Failsafe1,Off
			Sleep 200
			Goto BarMinigame
		}Else{
			PixelSearch,ClickX,ClickY,CShakeLeft,CShakeTop,CShakeRight,CShakeBottom,0xFFFFFF,1,Fast
			If !ErrorLevel{
				If(ClickX!=MemoryX&&ClickY!=MemoryY){
					CShakeRepeatBypassCounter:=0
					ClickCount++
					MouseMove,ClickX,ClickY
					Sleep ShakeDelay
					Click,ClickX+10,ClickY
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
		If ForceReset
			Goto RestartMacro
		Sleep ShakeDelay
		PixelSearch,,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		If !ErrorLevel{
			SetTimer,Failsafe1,Off
			Sleep 200
			Goto BarMinigame
		}Else{
			Sleep 1
			Send s
			Sleep 1
			Send {Enter}
		}
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
		If ForceReset
			Goto RestartMacro
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
	LastPos:=WW/2
	DirectionalToggle:="Disabled"
	MaxLeftToggle:=False
	MaxRightToggle:=False
	ProgressBarColor:=0x000000
	WasFishCaught:=False
	MaxLeftBar:=FishBarLeft+WhiteBarSize*SideBarRatio
	MaxRightBar:=FishBarRight-WhiteBarSize*SideBarRatio
	GetFishPos(){
		Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,ResolutionScaling
		PixelSearch,FishX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		If ErrorLevel
			Return False
		Else
			Return FishX+14*ResolutionScaling
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
		If FB
			Return BX
		Else
			Return False
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
			If(BarX<FishX){
				Difference:=Scale(FishX-BarX)*ResolutionScaling*RightMult
				CounterDifference:=Difference/RightDiv
				Send {LButton down}
				Stabilize(1)
				If(DirectionalToggle=="Left"){
					Stabilize(1)
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
				DirectionalToggle:="Right"
			}Else{
				Difference:=Scale(BarX-FishX)*ResolutionScaling*LeftMult
				CounterDifference:=Difference/LeftDiv
				Send {LButton up}
				Stabilize(1)
				AnkleBreakDelay:=0
				If(DirectionalToggle=="Right"){
					Stabilize(1)
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
				DirectionalToggle:="Left"
			}
		}
		Goto MinigameLoop
	}Else{
		If WasFishCaught
			FishCaught++
		Else
			FishLost++
		If(UseWebhook&&Mod(CatchCount,NotifEveryN)=0)
			SendStatus(3,[FishCaught,FishLost,(A_TickCount-MinigameStart)/1000,WasFishCaught])
		CatchCount++
		SetTimer,Track,Off
		Sleep RestartDelay
		Goto RestartMacro
	}
Return
Calculations:
	WinGetActiveStats,T,WW,WH,WL,WT
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
	LookDownX:=WW/2
	LookDownY:=WH/4
	Scale(x){
		c:=2.53266
		e:=0.747526
		Return c*x**e
	}
Return
InitGui:
	Gui -MinimizeBox -MaximizeBox +AlwaysOnTop
	Gui Add,Tab3,vTabs x0 y0 w450 h176,Info|Main|Webhook|Miscellaneous|Credits
	Gui Tab,1
	Gui Font,s10
	Gui Add,Text,x5 y22 w72 h16 +0x200,Gui Runtime
	Gui Font
	Gui Add,Text,vTRT1 x6 y38 w56 h13 +0x200,0h 00m 00s
	Gui Font,s10
	Gui Add,Text,x5 y54 w90 h16 +0x200,Macro Runtime
	Gui Font
	Gui Add,Text,vTRT2 x6 y70 w56 h13 +0x200,0h 00m 00s
	Gui Add,Text,vTTask x5 y87 w162 h14 +0x200,Current Task: Idle
	Gui Font
	Gui Add,Text,vTFC x5 y102 w100 h13 +0x200,Fish Count: 0/0
	Gui Tab,2
	Gui Font,w600
	Gui Add,GroupBox,x2 y21 w140 h84,Shaking
	Gui Font
	Gui Add,Text,x9 y35 w64 h13 +0x200,Shake Mode:
	Gui Add,Text,x9 y53 w75 h13 +0x200,Navigation Key:
	Gui Add,Text,x9 y70 w64 h13 +0x200,Shake Delay:
	Gui Add,Text,x9 y87 w58 h13 +0x200,Shake Only:
	ListVal:=(ShakeMode=="Click")?"Click||Navigation|":"Click|Navigation||"
	Gui Add,DropDownList,vSMDD gSubAll x74 y31 w65,%ListVal%
	Gui Add,Edit,vNK gSubAll x85 y53 w54 h16,%NavigationKey%
	Gui Add,Edit,vSD gSubAll x74 y70 w65 h16 Number,%ShakeDelay%
	SHO:=Chkd(ShakeOnly)
	Gui Add,CheckBox,vCBSO gSubAll x125 y87 w13 h13 %SHO%,Shake Only:
	Gui Font,w600
	Gui Add,GroupBox,x2 y104 w140 h71,Hotkeys
	Gui Font
	Gui Add,Text,x9 y116 w67 h13 +0x200,Start Fisching:
	Gui Add,Text,x9 y136 w70 h13 +0x200,Reload Macro:
	Gui Add,Text,x9 y155 w54 h13 +0x200,Exit Macro:
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
	Gui Add,CheckBox,vCBBS gSubAll x148 y80 w103 h14 %ABlS%,Blur When Shake
	Gui Add,CheckBox,vCBBM gSubAll x148 y95 w116 h14 %ABlM%,Blur When Minigame
	Gui Add,CheckBox,vCBSF gSubAll x148 y110 w128 h14 %ASF%,ShutdownAfterFailLimit
	Gui Font,w600
	Gui Add,GroupBox,x144 y126 w134 h48,Game
	Gui Font
	Gui Add,Button,gJG x152 y138 w120 h17,Join Game
	Gui Add,Text,x148 y156 w41 h13 +0x200,PS Link:
	Gui Add,Edit,vPSL gSubAll x189 y155 w86 h16,%PrivateServer%
	Gui Font,w600
	Gui Add,GroupBox,x280 y21 w168 h95,Delays
	Gui Font
	Gui Add,Text,x284 y36 w64 h14 +0x200,Restart Delay
	Gui Add,Text,x284 y56 w68 h14 +0x200,Hold Rod Cast
	Gui Add,Text,x284 y76 w94 h14 +0x200,Cast Randomization
	Gui Add,Text,x284 y96 w78 h14 +0x200,Wait For Bobber
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
	Gui Add,Text,x5 y24 w73 h14 +0x200,Webhook URL
	Gui Add,Edit,vWURL gSubAll x3 y36 w120 h21,%WebhookURL%
	UWH:=Chkd(UseWebhook)
	Gui Add,CheckBox,vCBWH gSubAll x4 y59 w100 h14 %UWH%,Enable Webhook
	Gui Add,Text,x4 y76 w56 h13 +0x200,Notify every
	Gui Add,Edit,vWHSK gSubAll x60 y74 w22 h18 Number,%NotifEveryN%
	Gui Add,Text,x83 y76 w40 h13 +0x200,catches.
	Gui Font,w600
	Gui Add,GroupBox,x125 y21 w322 h153,Options
	Gui Font
	NOF:=Chkd(NotifyOnFailsafe)
	Gui Add,CheckBox,vCBNF gSubAll x129 y35 w98 h14 %NOF%,Notify on Failsafe
	Gui Add,Text,x136 y52 w177 h23 +0x200,Out of ideas atm, more features soon!
	Gui Tab,4
	AOT:=Chkd(GuiAlwaysOnTop)
	Gui Add,CheckBox,vCBOT gSubAll x9 y24 w90 h14 %AOT%,Always On Top
	Gui Tab,5
	Gui Add,Link,x6 y22 w259 h14,This macro is based on <a href="https://www.youtube.com/@AsphaltCake">AsphaltCake</a> Fisch Macro V11
	Gui Add,Text,x6 y40 w257 h14 +0x200,Gui, modified minigame, polishing, and webhook by me.
	Gui Add,Link,x6 y58 w102 h14,Check out my <a href="https://github.com/LopenaFollower">GitHub</a>
	Gui Show,w450 h175,Fisch V1 by 0x3b5
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
		ShakeMode:=SMDD
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
		WinSet,AlwaysOnTop,%CBOT%,Fisch V1 by 0x3b5
		If CBAS{
			FileDelete,%SettingsPath%
			s:=""
			For i,v In [PrivateServer,WebhookURL,UseWebhook,StartHotkey,ReloadHotkey,ExitHotkey,NavigationKey,ShakeMode,NotifyOnFailsafe,NotifEveryN,AutoLowerGraphics,AutoZoomInCamera,AutoLookDownCamera,AutoBlurShake,AutoBlurMinigame,ShutdownAfterFailLimit,RestartDelay,RodCastDuration,CastRandomization,WaitForBobber,ShakeDelay,ShakeOnly,AutosaveSettings,GuiAlwaysOnTop,configFooter]
				s.=v " "
			FileAppend,%s%,%SettingsPath%
		}
	Return
	STRS:
		AskUser("Reset Settings","Are you sure?")
		IfMsgBox Yes
		{
			FileDelete,%SettingsPath%
			FileAppend,%defConfg%,%SettingsPath%
			Reload
		}
	Return
	STSV:
		AskUser("Save Settings","Overwrite old settings?")
		IfMsgBox Yes
		{
			FileDelete,%SettingsPath%
			s:=""
			For i,v In [PrivateServer,WebhookURL,UseWebhook,StartHotkey,ReloadHotkey,ExitHotkey,NavigationKey,ShakeMode,NotifyOnFailsafe,NotifEveryN,AutoLowerGraphics,AutoZoomInCamera,AutoLookDownCamera,AutoBlurShake,AutoBlurMinigame,ShutdownAfterFailLimit,RestartDelay,RodCastDuration,CastRandomization,WaitForBobber,ShakeDelay,ShakeOnly,AutosaveSettings,GuiAlwaysOnTop,configFooter]
				s.=v " "
			FileAppend,%s%,%SettingsPath%
		}
	Return
	JG:
		Gui Submit,NoHide
		PS:="roblox://placeID=16732694052"
		If StrLen(PSL)>32
			PS:=PSL
		Run % PS
	Return
Return
;Function dump
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
GuiClose:
	Goto ExitMacro
