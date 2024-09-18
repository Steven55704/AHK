init:
#NoEnv
#SingleInstance Force
#Persistent
#HotKeyInterval 1
#MaxHotkeysPerInterval 256
ver = 3.28
traytip, %ver%, Running, 1, 1
Menu, tray, NoStandard
Menu, tray, Tip, Sharpshooter %ver%
Menu, tray, Add, Sharpshooter %ver%, r
Menu, tray, Add, Exit, exit
SetKeyDelay,-1, 1
SetControlDelay,-1
SetMouseDelay,-1
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines 0
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High
eCol = 0xE600E6
CX := A_ScreenWidth / 2
CY := A_ScreenHeight / 2
FX := A_ScreenWidth // 14
FY := A_ScreenHeight // 9
SL := CX - FX
ST := CY - FY // 3
SR := CX + FX
SB := CY + FY
intensity = 1.5
tolerance = 7
toggle = 0
createGui(1,0,A_ScreenHeight-5,5,5,0xFF0000)
createGui(2,5,A_ScreenHeight-5,5,5,0xFF0000)
w := SR - SL
h := SB - ST
createGui("lf",SL,ST,2,h,0xFFFF00)
createGui("tf",SL,ST,w,2,0xFFFF00)
createGui("rf",SL+w,ST,2,h,0xFFFF00)
createGui("bf",SL,ST+h,w,2,0xFFFF00)
updateStatus(0)
Loop{
	if toggle{
		PixelSearch, AimPixelX, AimPixelY, CX - 3, CY - 1, CX, CY + 1, eCol, 1, Fast
		if ErrorLevel{
			PixelSearch, AimPixelX, AimPixelY, SL, ST, SR, SB, eCol, 1, Fast
			AimX := AimPixelX - CX + 2
			AimY := AimPixelY - CY + 7
			if(Abs(AimX) > 4){
				intensity := 1.5
				tolerance := 15
			}
			DirX := -1
			DirY := -1
			if(AimX > 0){
				DirX := 1
			}
			if(AimY > 0){
				DirY := 1
			}
			AimOffsetX := AimX * DirX
			AimOffsetY := AimY * DirY
			MoveX := (AimOffsetX ** ( 1 / intensity )) * DirX
			MoveY := (AimOffsetY ** ( 1 / 1.7 )) * DirY
			if(tolerance * .65 > .3){
				tolerance*=.695
			}
			pMoveX := Abs(MoveX)
			Sign := MoveX/pMoveX
			Gui, 2:Color, Red
			if(pMoveX > tolerance){
				Gui, 2:Color, Lime
				intensity += 0.125
				MoveX := tolerance * Sign
			}
			DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
		}
	}
}
createGui(id,x,y,w,h,c){
	Gui, %id%:Destroy
	Gui, %id%:-Caption +AlwaysOnTop +ToolWindow
	Gui, %id%:Color,%c%
	Gui, %id%:Show, x%x% y%y% w%w% h%h%
}
updateStatus(r){
	color = 0x00FF00
	if !r{
		color = 0xFF0000
		Gui, 2:Color, %color%
	}
	Gui, 1:Color, %color%
}
`::updateStatus(toggle := !toggle)
r:
goto, init
exit:
ExitApp