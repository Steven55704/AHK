init:
#NoEnv
#SingleInstance Force
#Persistent
#HotKeyInterval 1
#MaxHotkeysPerInterval 256
V=3.4
traytip,%V%,Running,1,1
Menu,tray,NoStandard
Menu,tray,Tip,Sharpshooter %V%
Menu,tray,Add,Sharpshooter %V%,r
Menu,tray,Add,Exit,exit
SetKeyDelay,-1,1
SetControlDelay,-1
SetMouseDelay,-1
SetWinDelay,-1
SendMode,InputThenPlay
SetBatchLines,-1
ListLines 0
CoordMode,Pixel,Screen
CoordMode,Mouse,Screen
PID:=DllCall("GetCurrentProcessId")
Process,Priority,%PID%,High
EC=0xE600E6
CX:=A_ScreenWidth/2
CY:=A_ScreenHeight/2
FX:=A_ScreenWidth/30
FY:=A_ScreenHeight/24
SL:=CX-FX
ST:=CY-FY/2
SR:=CX+FX
SB:=CY+FY
S=1.5
T=50
TG=0
SC=.4
INC=.0025
CG(1,CX-2.5,CY+7.5,5,5,"Red")
CG(2,SL,ST,2,SB-ST,"Yellow")
CG(3,SL,ST,SR-SL,2,"Yellow")
CG(4,SR,ST,2,SB-ST,"Yellow")
CG(5,SL,SB,SR-SL,2,"Yellow")
US(0)
Loop{
	if TG{
		PixelSearch,APX,APY,CX-2,CY-1,CX,CY+2,EC,1,Fast
		if ErrorLevel{
			PixelSearch,APX,APY,SL,ST,SR,SB,EC,1,Fast
			AX:=APX-CX+1.7
			AY:=APY-CY+3.5
			if(Abs(AX)>6){
				S=1.5
				T=70
			}
			DX=-1
			DY=-1
			if(AX>0)
				DX=1
			if(AY>0)
				DY=1
			MX:=(AX*DX)**(1/S)*DX
			MY:=(AY*DY)**(1/S)*DY
			if(T>0)
				T*=SC
			pMX:=Abs(MX)
			SG:=MX/pMX
			if(pMX>T){
				S+=INC
				MX:=T*SG
			}
			MouseGetPos X,Y
			if(Y>CY/2-5)
				DllCall("mouse_event",uint,1,int,MX,int,MY,uint,0,int,0)
		}
	}
}
CG(n,x,y,w,h,c){
	Gui,%n%:Destroy
	Gui,%n%:-Caption +AlwaysOnTop +ToolWindow
	Gui,%n%:Color,%c%
	Gui,%n%:Show,x%x% y%y% w%w% h%h%
}
US(r){
	c=Lime
	if !r
		c=Red
	Gui,1:Color,%c%
}
`::US(TG:=!TG)
r:
goto,init
exit:
ExitApp