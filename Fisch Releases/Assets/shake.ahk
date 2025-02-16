;9
#Include ..\main.ahk
CShakeMode:
	FailsafeCount:=0
	CShakeRepeatBypassCounter:=0
	MemoryX:=0
	MemoryY:=0
	ForceReset:=False
	SetTimer,Failsafe1,1000
	Loop{
		If ForceReset{
			If(FarmLocation=="cryo"&&A_TickCount>=StopFarmingAt)
				Gosub backUp
			Goto RestartMacro
		}
		Wait(ShakeDelay)
		PixelSearch,,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		If !ErrorLevel{
			SetTimer,Failsafe1,Off
			Goto BarMinigame
		}Else{
			PixelSearch,ClickX,ClickY,CShakeRight,CShakeTop,CShakeLeft,CShakeBottom,0xFFFFFF,2,Fast
			If !ErrorLevel{
				If(ClickX!=MemoryX&&ClickY!=MemoryY){
					CShakeRepeatBypassCounter:=0
					MouseMove,ClickX,ClickY
					Wait(5)
					Click %ClickX%,%ClickY%
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
			If(FarmLocation=="cryo"&&A_TickCount>=StopFarmingAt)
				Gosub backUp
			Goto RestartMacro
		}
		Sleep ShakeDelay
		PixelSearch,,,FishBarLeft,FishBarTop,FishBarRight,FishBarBottom,FishColor,0,Fast
		If !ErrorLevel{
			SetTimer,Failsafe1,Off
			Goto BarMinigame
		}Else
			Send s{Enter}
	}
Return