;TY El Ruso(wooodza) for some improvements
;0.52 roblox sensitivity
init:
#NoEnv
#SingleInstance Force
#Persistent
#HotKeyInterval 1
#MaxHotkeysPerInterval 512
V:=3.42
traytip,%V%,Running,1,1
Menu,tray,NoStandard
Menu,tray,Tip,Sharpshooter %V%
Menu,tray,Add,Sharpshooter %V%,r
Menu,tray,Add,Exit,exit
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
CX:=A_ScreenWidth/2
CY:=A_ScreenHeight/2
FX:=A_ScreenWidth/34
FY:=A_ScreenHeight/24
SL:=CX-FX
ST:=CY-FY/2
SR:=CX+FX
SB:=CY+FY
TG:=0
S:=1.5
CG(1,CX-2.5,CY+7.5,5,5,"Red")
CG(2,SL,ST,2,SB-ST,"Yellow")
CG(3,SL,ST,SR-SL,2,"Yellow")
CG(4,SR,ST,2,SB-ST,"Yellow")
CG(5,SL,SB,SR-SL,2,"Yellow")
US(0)
Loop{
	If TG{
		PixelSearch,,,CX-2,CY-1,CX+2,CY+1,EC,1,Fast
		If ErrorLevel{
			PixelSearch,APX,APY,SL,ST,SR,SB,EC,1,Fast
			AX:=APX-CX+2
			AY:=APY-CY+5
			If(Abs(AX)>6)
				S:=1.4
			DX:=(AX>0)?1:-1
			DY:=(AY>0)?1:-1
			MX:=(AX*DX)**(1/S)*DX
			MY:=(AY*DY)**(1/S)*DY
			pMX:=Abs(MX)
			S+=0.01
			If(pMX>10)
				MX:=10*MX/pMX
			MouseGetPos,X,Y
			If(Y>CY/2-2)
				DllCall("mouse_event",uint,1,int,MX,int,MY)
		}
	}
}
CG(n,x,y,w,h,c){
	Gui,%n%:-Caption +AlwaysOnTop +ToolWindow
	Gui,%n%:Color,%c%
	Gui,%n%:Show,x%x% y%y% w%w% h%h%
}
US(r){
	c:=r?"Lime":"Red"
	Gui,1:Color,%c%
}
`::US(TG:=!TG)
r:
goto,init
exit:
ExitApp