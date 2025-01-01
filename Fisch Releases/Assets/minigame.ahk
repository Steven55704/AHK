;1
#Include %A_MyDocuments%\Macro Settings\main.ahk
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
			If(FarmLocation=="cryo"&&A_TickCount>=StopFarmingAt)
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
			If(!WasFishCaught&&SendScreenshotFL)||(WasFishCaught&&Mod(CatchCount,SendScreenshotEveryN)=0&&NotifyImg){
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
		If(FarmLocation=="cryo"&&A_TickCount>=StopFarmingAt)
			Gosub backUp
		Goto RestartMacro
	}
Return