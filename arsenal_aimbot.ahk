; Credits to Ruso(wooodza) and JoseGaming for improvements
; tested on 0.52 roblox sensitivity (could work with other sens)
If !WinExist("Roblox")
	ExitApp
#NoEnv
#SingleInstance Force
#Persistent
#HotKeyInterval 1
#MaxHotkeysPerInterval 1024
V:=3.43
SetMouseDelay,-1
SetWinDelay,-1
SendMode InputThenPlay
SetDefaultMouseSpeed,0
SetBatchLines,-1
ListLines,0
CoordMode,Pixel,Relative
CoordMode,Mouse,Relative
PID:=DllCall("GetCurrentProcessId")
Process,Priority,%PID%,High
EC:=0xE600E6
FX:=A_ScreenWidth/20
FY:=A_ScreenHeight/16
TG:=0
S:=1.5
Loop{
	If TG&&WinActive("Roblox"){
		MouseGetPos,CX,CY
		SL:=CX-FX
		ST:=CY-FY/2
		SR:=CX+FX
		SB:=CY+FY
		CG(1,SL,ST,1,SB-ST,"Yellow")
		CG(2,SL,ST,SR-SL,1,"Yellow")
		CG(3,SR,ST,1,SB-ST,"Yellow")
		CG(4,SL,SB,SR-SL,1,"Yellow")
		Tooltip,%S%,%SL%,%ST%,1
		WinSet,Trans,90,% "ahk_id"WinExist("ahk_class tooltips_class32")
		PixelSearch,,,CX-1,CY+1,CX+1,CY-2,EC,1,Fast
		If ErrorLevel{
			PixelSearch,APX,APY,SL,ST,SR,SB,EC,1,Fast
			If !ErrorLevel{
				AX:=APX-CX+2
				AY:=APY-CY+5
				S+=0.25
				If(Abs(AX)>5)
					S:=1.55
				DX:=(AX>0)?1:-1
				DY:=(AY>0)?1:-1
				MX:=(AX*DX)**(1/S)*DX
				MY:=(AY*DY)**(1/S)*DY
				DllCall("mouse_event",uint,1,int,MX,int,MY)
			}
		}
	}Else{
		Tooltip,,,,1
		Loop,4
			Gui,%A_Index%:Hide
	}
}
CG(n,x,y,w,h,c){
	WinGet,active_id,ID,Roblox
	Gui,%n%:-Caption +Owner%active_id% +Disabled
	Gui,%n%:Color,%c%
	Gui,%n%:Show,NA x%x% y%y% w%w% h%h%
}
`::
	If WinExist("Roblox")
		TG:=!TG
	Else
		ExitApp
Return
[::Reload
Return