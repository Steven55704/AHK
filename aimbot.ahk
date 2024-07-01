init:
#NoEnv
#SingleInstance Force
#Persistent	
#HotKeyInterval 1
#MaxHotkeysPerInterval 256
ver = 2.74
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
;0x0BD700
EnCol = 0xE600E6
CenterX := A_ScreenWidth // 2
CenterY := A_ScreenHeight // 2
FovX := A_ScreenWidth // 10
FovY := A_ScreenHeight // 6
ScanL := CenterX - FovX
ScanT := CenterY - FovY // 4
ScanR := CenterX + FovX
ScanB := CenterY + FovY
intensity = 1.5
toggle = 0
updateStatus(0)
Loop{
	if toggle{
		PixelSearch, AimPixelX, AimPixelY, CenterX - 2, CenterY - 2, CenterX, CenterY, EnCol, 1, Fast

		if ErrorLevel{
			PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EnCol, 1, Fast
			AimX := AimPixelX - CenterX
			AimY := AimPixelY - CenterY + 15
			if(Abs(AimX) > 100){
				intensity := 1.4
			}
			if(Abs(AimX) > 10 && intensity > 2.4){
				intensity -= .5
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
			MoveX := Floor(AimOffsetX ** ( 1 / intensity )) * DirX * 1.5
			MoveY := Floor(AimOffsetY ** ( 1 / 2 )) * DirY
			if(Abs(MoveX) < 1.75){
				MoveX := 0
			}else if(intensity < 5){
				intensity += 0.05
			}
			DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
		}
	}
}
updateStatus(r){
	global ScanL, ScanT, ScanR, ScanB
	color = 0x00ff00
	if !r{
		color = 0xff0000
	}
	gy := A_ScreenHeight - 5
	Gui, 1:Destroy
	Gui, 1:-Caption +AlwaysOnTop +ToolWindow
	Gui, 1:Color, %color%
	Gui, 1:Show, x0 y%gy% w5 h5
	w := ScanR - ScanL
	rfx := ScanL+w
	h := ScanB - ScanT
	bfy := ScanT+h
	Gui, lf:Destroy
	Gui, lf:-Caption +AlwaysOnTop +ToolWindow
	Gui, lf:Color, Yellow
	Gui, lf:Show, x%ScanL% y%ScanT% w2 h%h%
	Gui, tf:Destroy
	Gui, tf:-Caption +AlwaysOnTop +ToolWindow
	Gui, tf:Color, Yellow
	Gui, tf:Show, x%ScanL% y%ScanT% w%w% h2
	Gui, rf:Destroy
	Gui, rf:-Caption +AlwaysOnTop +ToolWindow
	Gui, rf:Color, Yellow
	Gui, rf:Show, x%rfx% y%ScanT% w2 h%h%
	Gui, bf:Destroy
	Gui, bf:-Caption +AlwaysOnTop +ToolWindow
	Gui, bf:Color, Yellow
	Gui, bf:Show, x%ScanL% y%bfy% w%w% h2
}
`::
	updateStatus(toggle := !toggle)
	Sleep, 50
	Click
return
Pause:: pause
r:
goto, init
 
exit:
ExitApp