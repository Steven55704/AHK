;Credits to Ruso(wooodza) and JoseGaming for improvements
; tested on 0.36 roblox sensitivity (could work with other sens)
If WinExist("Roblox")
	Goto init
Else
	ExitApp
init:
#NoEnv
#SingleInstance Force
#Persistent
#HotKeyInterval 1
#MaxHotkeysPerInterval 1024
V:=3.42
SetMouseDelay,-1
SetWinDelay,-1
SendMode InputThenPlay
SetDefaultMouseSpeed,0
SetBatchLines,-1
ListLines,0
CoordMode,Pixel,Screen
CoordMode,Mouse,Screen
PID:=DllCall("GetCurrentProcessId")
Process,Priority,%PID%,High
EC:=0xE600E6
MouseGetPos,CX,CY
FX:=A_ScreenWidth/10
FY:=A_ScreenHeight/10
SL:=CX-FX
ST:=CY-FY/2
SR:=CX+FX
SB:=CY+FY
CG(1,SL,ST,1,SB-ST,"Yellow")
CG(2,SL,ST,SR-SL,1,"Yellow")
CG(3,SR,ST,1,SB-ST,"Yellow")
CG(4,SL,SB,SR-SL,1,"Yellow")
Loop,4
	HG(A_Index)
TG:=0
S:=1.5
Loop{
	If TG&&WinActive("Roblox"){
		MouseGetPos,CX,CY
		FX:=A_ScreenWidth/20
		FY:=A_ScreenHeight/16
		SL:=CX-FX
		ST:=CY-FY/2
		SR:=CX+FX
		SB:=CY+FY
		CG(1,SL,ST,1,SB-ST,"Yellow")
		CG(2,SL,ST,SR-SL,1,"Yellow")
		CG(3,SR,ST,1,SB-ST,"Yellow")
		CG(4,SL,SB,SR-SL,1,"Yellow")
		PixelSearch,,,CX-3,CY-2,CX+3,CY+2,EC,1,Fast
		If ErrorLevel{
			PixelSearch,APX,APY,SL,ST,SR,SB,EC,1,Fast
			AX:=APX-CX+2
			AY:=APY-CY+5
			If(Abs(AX)>7)
				S:=1.4
			DX:=(AX>0)?1:-1
			DY:=(AY>0)?1:-1
			MX:=(AX*DX)**(1/S)*DX
			MY:=(AY*DY)**(1/S)*DY
			S+=0.0125
			DllCall("mouse_event",uint,1,int,MX,int,MY)
		}
		If !TG
			Loop,4
				HG(A_Index)
	}
}
CG(n,x,y,w,h,c){
	WinGet,active_id,ID,Roblox
	Gui,%n%:-Caption +E0x8000000 +Owner%active_id% +Disabled
	Gui,%n%:Color,%c%
	Gui,%n%:Show,NA x%x% y%y% w%w% h%h%
}
HG(n){
	Gui,%n%:Hide
}
`::
	If WinExist("Roblox")
		TG:=!TG
	Else
		ExitApp
Return
[::
reload
return