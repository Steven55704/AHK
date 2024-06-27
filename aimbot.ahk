init:
#NoEnv
#SingleInstance, Force
#Persistent
#HotKeyInterval 1
#MaxHotkeysPerInterval 256
ver = 2.7
TrayTip, Sharpshooter v%ver%, Running!, 1, 32
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
ListLines Off
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, H
;0x0BD700
EnCol = 0xE600E6
CenterX := A_ScreenWidth // 2
CenterY := A_ScreenHeight // 2
FovX := A_ScreenWidth // 8
FovY := A_ScreenHeight // 6
ScanL := CenterX - FovX
ScanT := CenterY - FovY // 4
ScanR := CenterX + FovX
ScanB := CenterY + FovY
sm = 1.5
toggle = false
updateStatus(false)
Loop{
	if toggle{
		PixelSearch, AimPixelX, AimPixelY, CenterX - 2, CenterY - 2, CenterX, CenterY, EnCol, 1, Fast

		if !ErrorLevel{
			PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EnCol, 1, Fast
			AimX := AimPixelX - CenterX
			AimY := AimPixelY - CenterY + 12
			if(Abs(AimX) > 100){
				sm = 1.4
			}
			if(Abs(AimX)>10 && sm>2.4){
				sm -= .5
			}
			DirX = -1
			DirY = -1
			if(AimX > 0){
				DirX = 1
			}
			if(AimY > 0){
				DirY = 1
			}
			AimOffsetX := AimX * DirX
			AimOffsetY := AimY * DirY
			MoveX := Floor(AimOffsetX**(1/sm))*DirX*1.5
			MoveY := Floor(AimOffsetY**(1/2))*DirY
			if(Abs(MoveX) < 1.75){
				MoveX = 0
			}else if(sm < 5){
				sm += 0.05
			}
			DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
		}
	}
}
updateStatus(b){
	color = 0x00ff00
	if !b{
		color = 0xff0000
	}
	y := A_ScreenHeight - 5
	Gui, 1:Destroy
	Gui, 1:-Caption +AlwaysOnTop +ToolWindow
	Gui, 1:Color, %color%
	Gui, 1:Show, x0 y%y% w5 h5
}
`::
	updateStatus(toggle:=!toggle)
	Sleep, 50
	Click
return
r:
goto, init
exit:
ExitApp