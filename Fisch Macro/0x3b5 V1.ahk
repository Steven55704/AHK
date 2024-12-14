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
parseSettings(s){
	a:=StrSplit(s," ")
	For i,v in a
		If v is Number
			a[i]:=v+0
	return a
}
If !FileExist("settings.txt")
	FileAppend,F1 F2 F3 \ Click 0 0 0 1 1 1 1 1 1 0 600 750 100 300 35,settings.txt
FileRead,configs,settings.txt
ar:=parseSettings(configs)
StartHotkey:=ar[1]
ReloadHotkey:=ar[2]
ExitHotkey:=ar[3]
NavigationKey:=ar[4]
ShakeMode:=ar[5]
PrivateServer:=(ar[6]=0)?"":ar[6]
WebhookURL:=(ar[7]=0)?"":ar[7]
UseWebhook:=ar[8]
NotifEveryN:=ar[9]
AutoLowerGraphics:=ar[10]
AutoZoomInCamera:=ar[11]
AutoLookDownCamera:=ar[12]
AutoBlurShake:=ar[13]
AutoBlurMinigame:=ar[14]
ShutdownAfterFailLimit:=ar[15]
RestartDelay:=ar[16]
RodCastDuration:=ar[17]
CastRandomization:=ar[18]
WaitForBobber:=ar[19]
ShakeDelay:=ar[20]
AutoGraphicsDelay:=20
AutoZoomDelay:=30
AutoCameraDelay:=5
AutoLookDelay:=50
AutoBlurDelay:=25
StabilizerLoop:=14
SideBarRatio:=0.79
SideBarWait:=1.84
RightMult:=2.458
RightDiv:=1.8914
RightCounter:=0.21
RightAnkleMult:=1.57
LeftMult:=2.964
LeftDiv:=2.9726
LeftCounter:=0.29
LeftAnkleMult:=0
LeftDeviation:=25
ShakeFailsafe:=7
BarDetectionFailsafe:=3
FailsInARow:=0
RepeatBypassLimit:=10
BarColor:=0xF8F8F8
BarCalcColor:=0xF0F0F0
ArrowColor:=0x868483
FishColor:=0x5B4B43
ManualBarSize:=0
Test1:=0
Test2:=0
MSD:=320
MAD:=275
SS:=1
FishCaught:=0
FishLost:=0
CatchCount:=0
UpdateStatus(fc,fl,d,s){
	Global WebhookURL
	If StrLen(WebhookURL)>100{
		ratio:=fc " / "fl " ("RegExReplace(fc/(fc+fl)*100,"(?<=\.\d{2}).*$") "%)"
		dur:=RegExReplace(d,"(?<=\.\d{3}).*$")
		caught:=s?"Fish took "dur "s to catch.":"Spent "dur "s trying to catch the fish."
		FormatTime,ct,,hh:mm:ss
		req:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		req.Open("POST",WebhookURL "?wait=true",0)
		req.SetRequestHeader("Content-Type","application/json")
		req.Send("{""content"":"""",""embeds"":[{""color"":15258703,""fields"":[{""name"":""Catch Rate"",""value"":"""ratio """},{""name"":""Fish was "(s?"Caught!":"Lost.") """,""value"":"""caught """}],""footer"":{""text"":"""ct """}}]}")
	}
}
Gosub InitGui
;Auto Join
WinActivate,Roblox
If WinActive("Roblox")
	WinMaximize,Roblox
Hotkey % "$"StartHotkey,StartMacro
Hotkey % "$"ReloadHotkey,ReloadMacro
Hotkey % "$"ExitHotkey,ExitMacro
Send {LButton up}
Send {RButton up}
Send {Shift up}
Return
ReloadMacro:
	Reload
Return
ExitMacro:
	Send {LButton up}
	Send {RButton up}
	Send {Shift up}
	ExitApp
Return
StartMacro:
	WinMaximize,Roblox
	Sleep 100
	Gosub Calculations
	Gosub MoveGui
	SetTimer,running,1000
	If AutoLowerGraphics{
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
		Sleep AutoZoomDelay
		Loop,20{
			Send {WheelUp}
			Sleep AutoZoomDelay
		}
		Send {WheelDown}
		AutoZoomDelay*=5
		Sleep AutoZoomDelay
	}
	PixelSearch,,,CameraCheckLeft,CameraCheckTop,CameraCheckRight,CameraCheckBottom,0xFFFFFF,0,Fast
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
	RestartMacro:
		Click,LookDownX,LookDownY
		If AutoLookDownCamera{
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
			MouseMove,LookDownX, LookDownY
			Sleep AutoLookDelay
		}
		If AutoBlurShake{
			Sleep AutoBlurDelay
			Send m
			Sleep AutoBlurDelay
		}
		Send {LButton down}
		Random,RCD,0,CastRandomization*2
		Sleep RodCastDuration-(RCD-CastRandomization)
		Send {LButton up}
		Sleep WaitForBobber
		If(ShakeMode=="Click")
			Goto CShakeMode
		Else
			Goto NShakeMode
		CShakeFailsafe:
			ClickFailsafeCount++
			If(ClickFailsafeCount>=ShakeFailsafe){
				SetTimer,CShakeFailsafe,Off
				ForceReset:=true
			}
		Return
		CShakeMode:
			ClickFailsafeCount:=0
			ClickCount:=0
			CShakeRepeatBypassCounter:=0
			MemoryX:=0
			MemoryY:=0
			ForceReset:=false
			SetTimer,CShakeFailsafe,850
			Loop{
				If ForceReset{
					FailsInARow++
					Goto RestartMacro
				}
				Sleep ClickScanDelay
				PixelSearch,,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
				If !ErrorLevel{
					SetTimer,CShakeFailsafe,Off
					Sleep 200
					Goto BarMinigame
				}Else{
					PixelSearch,ClickX,ClickY,CShakeLeft,CShakeTop,CShakeRight,CShakeBottom,0xFFFFFF,1,Fast
					If !ErrorLevel{
						If(ClickX!=MemoryX&&ClickY!=MemoryY){
							CShakeRepeatBypassCounter:=0
							ClickCount++
							MouseMove,ClickX,ClickY
							Sleep 5
							Click,ClickX+14,ClickY
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
		NShakeFailsafe:
			NavigationFailsafeCount++
			If(NavigationFailsafeCount>=ShakeFailsafe){
				SetTimer,NShakeFailsafe,Off
				ForceReset:=true
			}
		Return
		NShakeMode:
			NavigationFailsafeCount:=0
			NavigationCounter:=0
			ForceReset:=false
			SetTimer,NShakeFailsafe,1000
			Send {%NavigationKey%}
			Loop{
				If ForceReset{
					FailsInARow++
					Goto RestartMacro
				}
				Sleep ShakeDelay
				PixelSearch,,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
				If !ErrorLevel{
					SetTimer,NShakeFailsafe,Off
					Sleep 100
					Goto BarMinigame
				}Else{
					NavigationCounter++
					Sleep 1
					Send s
					Sleep 1
					Send {Enter}
				}
			}
		BarDetectionFailsafe:
			BarCalcFailsafeCounter++
			If(BarCalcFailsafeCounter>=BarDetectionFailsafe){
				SetTimer,BarDetectionFailsafe,Off
				ForceReset:=true
			}
		Return
		BarMinigame:
			If AutoBlurMinigame
				Send m
			ForceReset:=false
			BarCalcFailsafeCounter:=0
			SetTimer,BarDetectionFailsafe,1000
			Loop{
				Sleep 1
				If ForceReset{
					FailsInARow++
					Goto RestartMacro
				}
				PixelSearch,SBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarCalcColor,1,Fast
				If !ErrorLevel{
					SetTimer,BarDetectionFailsafe,Off
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
			HalfBarSize:=WhiteBarSize/2
			SideDelay:=0
			AnkleBreakDelay:=0
			LastPos:=WW/2
			DirectionalToggle:="Disabled"
			MaxLeftToggle:=false
			MaxRightToggle:=false
			ProgressBarColor:=0x000000
			WasFishCaught:=False
			MaxLeftBar:=FishBarLeft+WhiteBarSize*SideBarRatio
			MaxRightBar:=FishBarRight-WhiteBarSize*SideBarRatio
			GetFishPos(){
				Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor
				PixelSearch,FishX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
				If ErrorLevel
					Return False
				Else
					Return FishX
			}
			GetBarPos(){
				Global FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarColor,UnstableColorX,UnstableColorY,HalfBarSize
				FB:=false
				PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,BarColor,9,Fast
				If !ErrorLevel{
					BX:=TBX+HalfBarSize
					FB:=true
				}
				If !FB{
					PixelGetColor,UC,UnstableColorX,UnstableColorY
					PixelSearch,TBX,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,UC,21,Fast
					If !ErrorLevel{
						BX:=TBX+HalfBarSize
						FB:=true
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
							FB:=true
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
			SetTimer,track,25
			Goto MinigameLoop
			track:
				FishX:=GetFishPos()
				If FishX&&!WasFishCaught{
					PixelSearch,,,WW/1.645,WH/1.102,WW/1.644,WH/1.1,0xFFFFFF,10,Fast
					If ErrorLevel{
						PixelSearch,,,WW/1.645,WH/1.102,WW/1.644,WH/1.1,0x9E9E9E,10,Fast
						WasFishCaught:=!ErrorLevel
					}Else
						WasFishCaught:=True
				}
			Return
			MinigameLoop:
				Sleep 1
				FishX:=GetFishPos()
				If FishX{
					FailsInARow:=0
					If(FishX<MaxLeftBar){
						If !MaxLeftToggle{
							DirectionalToggle:="Right"
							MaxLeftToggle:=true
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
							MaxRightToggle:=true
							Send {LButton down}
							Sleep 1
							Send {LButton down}
							Sleep Min(MSD,SideDelay)
							AnkleBreakDelay:=0
							SideDelay:=0
						}
						Goto MinigameLoop
					}
					MaxLeftToggle:=false
					MaxRightToggle:=false
					BarX:=GetBarPos()
					If BarX{
						Dist:=Abs(FishX-BarX)
						If(Dist<WhiteBarSize*.2){
							Stabilize()
						}
						If(BarX<FishX){
							Difference:=Scale(Dist)*ResolutionScaling*RightMult
							CounterDifference:=Difference/RightDiv
							Send {LButton down}
							Stabilize(1)
							If(DirectionalToggle=="Left"){
								Sleep Min(MAD,AnkleBreakDelay)
								Stabilize(1)
								Send {LButton down}
								AnkleBreakDelay:=0
							}Else{
								AnkleBreakDelay:=AnkleBreakDelay+(Difference-CounterDifference)*RightAnkleMult
								SideDelay:=AnkleBreakDelay/RightAnkleMult*SideBarWait
							}
							Sleep Difference+LeftDeviation
							DST:=Abs((NP:=GetBarPos())-LastPos)*ResolutionScaling*RightCounter
							LastPos:=NP
							Send {LButton up}
							FishX:=GetFishPos()
							If(FishX<MaxLeftBar||FishX>MaxRightBar)
								Goto MinigameLoop
							If(BarX<FishX)
								DST:=0
							Sleep CounterDifference+DST
							DirectionalToggle:="Right"
						}Else{
							Difference:=Scale(Dist)*ResolutionScaling*LeftMult
							CounterDifference:=Difference/LeftDiv
							Send {LButton up}
							Stabilize(1)
							AnkleBreakDelay:=0
							If(DirectionalToggle=="Right"){
								Sleep MAD
								Stabilize(1)
								Send {LButton up}
							}
							Sleep Difference-LeftDeviation
							DST:=Abs((NP:=GetBarPos())-LastPos)*ResolutionScaling*LeftCounter
							LastPos:=NP
							Send {LButton down}
							FishX:=GetFishPos()
							If(FishX<MaxLeftBar||FishX>MaxRightBar)
								Goto MinigameLoop
							If(BarX>=FishX)
								DST:=0
							Sleep CounterDifference+DST
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
						UpdateStatus(FishCaught,FishLost,(A_TickCount-MinigameStart)/1000,WasFishCaught)
					CatchCount++
					SetTimer,track,Off
					Sleep RestartDelay
					Goto RestartMacro
				}
Calculations:
	WinGetActiveStats,T,WW,WH,WL,WT
	CameraCheckLeft:=WW/2.8444
	CameraCheckRight:=WW/1.5421
	CameraCheckTop:=WH/1.28
	CameraCheckBottom:=WH
	CShakeLeft:=WW/4.6545
	CShakeRight:=WW/1.2736
	CShakeTop:=WH/14.08
	CShakeBottom:=WH/1.3409
	FishBarLeft:=WW/3.32
	FishBarRight:=WW/1.43
	FishBarTop:=WH/1.1712
	FishBarBottom:=WH/1.1658
	BarHeight:=WH/1.0626
	ResolutionScaling:=2560/WW
	UnstableColorX:=WW/3.463
	UnstableColorY:=WH/1.168
	LookDownX:=WW/2
	LookDownY:=WH/4
	GetTime(t,f:="{:}h {:02}m {:02}s"){
		Local H,M,S,A:=60,B:=A*A
		Return Format(f,H:=t//B,M:=(t:=t-H*B)//A,t-M*A,S:=H,S*A+M)
	}
	; To understand why, compare the graph with a linear graph, espasially x=0 to 200
	Scale(x){
		c:=0.966222
		e:=0.925282
		Return c*x**e
	}
Return
running:
	If(ShutdownAfterFailLimit&&FailsInARow>14){
		SetTimer,running,Off
		Shutdown,1
		ExitApp
	}
	;TT(GetTime(SS++),3)
Return
InitGui:
	Gui -MinimizeBox -MaximizeBox +AlwaysOnTop +ToolWindow
	Gui Add,Tab3,x0 y0 w450 h176,Main|Webhook|Credits
	Gui Tab,1
	Gui Font,w600
	Gui Add,GroupBox,x2 y21 w140 h80,Shaking
	Gui Font
	Gui Add,Text,x9 y36 w64 h13 +0x200,Shake Mode:
	Gui Add,Text,x9 y56 w75 h13 +0x200,Navigation Key:
	Gui Add,Text,x9 y79 w64 h13 +0x200,Shake Delay:
	If(ShakeMode=="Click")
		Gui Add,DropDownList,vSMDD gSubAll x74 y32 w65,Click||Navigation|
	Else
		Gui Add,DropDownList,vSMDD gSubAll x74 y32 w65,Click|Navigation||
	Gui Add,Edit,vNK gSubAll x85 y54 w54 h21,%NavigationKey%
	Gui Add,Edit,vSD gSubAll x74 y76 w65 h21 Number,%ShakeDelay%
	Gui Font,w600
	Gui Add,GroupBox,x2 y101 w140 h73,Hotkeys
	Gui Font
	Gui Add,Text,x9 y114 w67 h13 +0x200,Start Fisching:
	Gui Add,Text,x9 y134 w70 h13 +0x200,Reload Macro:
	Gui Add,Text,x9 y154 w54 h13 +0x200,Exit Macro:
	Gui Add,Hotkey,vCSHK gSubAll x81 y112 w57 h18,%StartHotkey%
	Gui Add,Hotkey,vCRHK gSubAll x81 y132 w57 h18,%ReloadHotkey%
	Gui Add,Hotkey,vCEHK gSubAll x81 y152 w57 h18,%ExitHotkey%
	Gui Font,w600
	Gui Add,GroupBox,x144 y21 w134 h106,Options
	Gui Font
	ALG:=AutoLowerGraphics?"Checked":"",AZC:=AutoZoomInCamera?"Checked":"",ALD:=AutoLookDownCamera?"Checked":"",ABlS:=AutoBlurShake?"Checked":"",ABlM:=AutoBlurMinigame?"Checked":"",ASF:=ShutdownAfterFailLimit?"Checked":""
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
	Gui Add,Edit,vPSL x189 y155 w86 h16,%PrivateServer%
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
	Gui Font, w600
	Gui Add,GroupBox, x280 y115 w168 h59, Settings
	Gui Font
	Gui Add,Button,gSTRS x284 y135 w80 h26,Reset Settings
	Gui Add,Button,gSTSV x366 y135 w80 h26,Save Settings
	Gui Tab,2
	Gui Add,Text,x5 y24 w73 h14 +0x200,Webhook URL
	Gui Add,Edit,vWURL gSubAll x3 y36 w120 h21,%WebhookURL%
	UWH:=UseWebhook?"Checked":""
	Gui Add,CheckBox,vCBWH gSubAll x4 y59 w119 h14 %UWH%,Enable Webhook
	Gui Add,Text,x4 y76 w56 h13 +0x200,Notify every
	Gui Add,Edit,vWHSK gSubAll x60 y74 w22 h18 Number,%NotifEveryN%
	Gui Add,Text,x83 y76 w40 h13 +0x200,catches.
	Gui Tab,3
	Gui Add,Link,x6 y22 w259 h14,This script is based on <a href="https://www.youtube.com/@AsphaltCake">AsphaltCake</a> Fisch Macro V11
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
		If StrLen(PSL)>10
			PrivateServer:=PSL
		If Trim(CSHK)!=""&&CSHK!=CRHK&&CSHK!=CEHK
			StartHotkey:=CSHK
		Else{
			GuiControl,,CSHK,%StartHotkey%
			MsgBox Hotkey in use
		}
		If Trim(CRHK)!=""&&CRHK!=CSHK&&CRHK!=CEHK
			ReloadHotkey:=CRHK
		Else{
			GuiControl,,CRHK,%ReloadHotkey%
			MsgBox Hotkey in use
		}
		If Trim(CEHK)!=""&&CEHK!=CSHK&&CEHK!=CRHK
			ExitHotkey:=CEHK
		Else{
			GuiControl,,CEHK,%ExitHotkey%
			MsgBox Hotkey in use
		}
		ShakeMode:=SMDD
		AutoLowerGraphics:=CBLG
		AutoZoomInCamera:=CBZC
		AutoLookDownCamera:=CBLD
		AutoBlurShake:=CBBS
		AutoBlurMinigame:=CBBM
		ShutdownAfterFailLimit:=CBSF
		UseWebhook:=CBWH
	Return
	STRS:
		MsgBox,4,Reset Settings,Are you sure?
		IfMsgBox Yes
		{
			FileDelete,settings.txt
			FileAppend,F1 F2 F3 \ Click 0 0 0 1 1 1 1 1 1 0 600 750 100 300 35,settings.txt
			Reload
		}
	Return
	STSV:
		MsgBox,4,Save Settings,Overwrite old settings?
		IfMsgBox Yes
		{
			FileDelete,settings.txt
			s:=""
			For i,v In [StartHotkey,ReloadHotkey,ExitHotkey,NavigationKey,ShakeMode,PrivateServer,WebhookURL,UseWebhook,NotifEveryN,AutoLowerGraphics,AutoZoomInCamera,AutoLookDownCamera,AutoBlurShake,AutoBlurMinigame,ShutdownAfterFailLimit,RestartDelay,RodCastDuration,CastRandomization,WaitForBobber,ShakeDelay]
				s.=v " "
			FileAppend,%s%,settings.txt
		}
	Return
	JG:
		Gui Submit,NoHide
		PS:="roblox://placeID=16732694052"
		If StrLen(PSL)>0
			PS:=PSL
		Run % PS
	Return
Return
MoveGui:
	x:=WW-455
	y:=WH-205
	WinMove,Fisch V1 by 0x3b5,,%x%,%y%
Return
GuiClose:
	ExitApp
