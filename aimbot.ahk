init:
#NoEnv
#SingleInstance, Force
#Persistent
#InstallKeybdHook
#UseHook
#KeyHistory, 0
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
version = 2.6
traytip, %version%, Running!, 1, 1
Menu, tray, NoStandard
Menu, tray, Tip, Sharpshooter %version%
Menu, tray, Add, Sharpshooter %version%, return
Menu, tray, Add
Menu, tray, Add, Exit, exit
SetKeyDelay,-1, 1
SetControlDelay, -1
SetMouseDelay, -1
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines, Off
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High
;0x0BD700
EMCol := 0xE600E6
CenterX := (A_ScreenWidth // 2)
CenterY := (A_ScreenHeight // 2)
CFovX := (A_ScreenWidth // 7)
CFovY := (A_ScreenHeight // 6)
ScanL := CenterX - CFovX
ScanT := CenterY - CFovY // 3
ScanR := CenterX + CFovX
ScanB := CenterY + CFovY
NearAimScanL := CenterX - 2
NearAimScanT := CenterY - 2
NearAimScanR := CenterX
NearAimScanB := CenterY
intensity := 1.5
running := false
Loop, {
	if(running){
		PixelSearch, AimPixelX, AimPixelY, NearAimScanL, NearAimScanT, NearAimScanR, NearAimScanB, EMCol, 1, Fast RGB

		if (!ErrorLevel=0) {
			PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, 1, Fast RGB
			AimX := AimPixelX - CenterX
			AimY := AimPixelY - CenterY + 15
			if( Abs(AimX) > 20){
				intensity := 1.35
			}
			DirX := -1
			DirY := -1
			If ( AimX > 0 ) {
				DirX := 1
			}
			If ( AimY > 0 ) {
				DirY := 1
			}
			AimOffsetX := AimX * DirX
			AimOffsetY := AimY * DirY
			MoveX := Floor(( AimOffsetX ** ( 1 / intensity ))) * DirX * 1.5
			MoveY := Floor(( AimOffsetY ** ( 1 / 2 ))) * DirY
			if( Abs(MoveX) < 1.75 ){
				MoveX := 0
			}else{
				if( intensity < 4 ) {
					intensity += 0.05
				}
			}
			DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
		}
	}
}
updateStatus(r){
	color := 0x00ff00
	if(!r){
		color := 0xff0000
	}
	gy := A_ScreenHeight - 10
	Gui, 1:Destroy
	Gui, 1:-Caption +AlwaysOnTop +ToolWindow
	Gui, 1:Color, %color%
	Gui, 1:Show, x0 y%gy% w10 h10
}
`::
	running := !running
	updateStatus(running)
	Sleep, 50
	Click
return
Pause:: pause
return:
goto, init
 
exit:
exitapp