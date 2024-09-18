init:
#NoEnv
#SingleInstance Force
#Persistent	
#HotKeyInterval 1
#MaxHotkeysPerInterval 256
ver = 3.26
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
EnCol = 0xE600E6
CenterX := A_ScreenWidth / 2
CenterY := A_ScreenHeight / 2
FovX := A_ScreenWidth // 14
FovY := A_ScreenHeight // 9
ScanL := CenterX - FovX
ScanT := CenterY - FovY // 3
ScanR := CenterX + FovX
ScanB := CenterY + FovY
intensity = 1.5
tolerance = 7
toggle = 0
createGui(1,0,A_ScreenHeight-5,5,5,0xff0000)
createGui(2,5,A_ScreenHeight-5,5,5,0xff0000)
w := ScanR - ScanL
h := ScanB - ScanT
createGui("lf",ScanL,ScanT,2,h,0xffff00)
createGui("tf",ScanL,ScanT,w,2,0xffff00)
createGui("rf",ScanL+w,ScanT,2,h,0xffff00)
createGui("bf",ScanL,ScanT+h,w,2,0xffff00)
updateStatus(0)
Loop{
	if toggle{
		PixelSearch, AimPixelX, AimPixelY, CenterX - 4, CenterY - 1, CenterX - 2, CenterY + 1, EnCol, 1, Fast
		if ErrorLevel{
			PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EnCol, 1, Fast
			AimX := AimPixelX - CenterX + 2
			AimY := AimPixelY - CenterY + 7
			if(Abs(AimX) > 4){
				intensity := 1.5
				tolerance := 10
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
			if(tolerance * .7 > .5){
				tolerance*=.7
			}
			pMoveX := Abs(MoveX)
			Sign := MoveX/pMoveX
			Gui, 2:Color, Red
			if(pMoveX < .1 && pMoveX > 0){
				Gui, 2:Color, Yellow
				MoveX := .1 * Sign
			}else if(pMoveX > tolerance){
				Gui, 2:Color, Lime
				intensity += 0.125
				MoveX := tolerance * Sign
			}
			DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
			Sleep, 5
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
	color = 0x00ff00
	if !r{
		color = 0xff0000
		Gui, 2:Color, %color%
	}
	Gui, 1:Color, %color%
}
`::updateStatus(toggle := !toggle)
r:
goto, init
exit:
ExitApp