;1
#Include %A_MyDocuments%\Macro Settings\main.ahk
CreateBound(n,x1,y1,x2,y2){
	colors:={CameraCheck:"Yellow",FishBar:"Lime",ProgBar:"Red",LvlCheck:"Blue"}
	w:=x2-x1
	h:=y2-y1
	Gui %n%:Destroy
	Gui %n%:-Caption +AlwaysOnTop +ToolWindow
	Gui %n%:Add,Text,x0 y0 w%w% h%h%,
	Gui %n%:Color,% colors[n]
	Gui %n%:Show,% "x"x1 "y"y1 "w"w "h"h,%n%
}
WriteBnd(k,v,s){
	Global BoundsPath
	IniWrite,%v%,%BoundsPath%,%s%,%k%
}
ReadBnd(ByRef out,k,s){
	Global BoundsPath
	IniRead,temp,%BoundsPath%,%s%,%k%
	out:=temp+0
}
Calculations:
	WinActivate,Roblox
	WinMaximize,Roblox
	WinGetActiveStats,T,WW,WH,WL,WT
	If !FileExist(BoundsPath){
		WriteBnd("Left",WW//2.15,"CameraCheck")
		WriteBnd("Right",WW//1.85,"CameraCheck")
		WriteBnd("Top",WH//1.105,"CameraCheck")
		WriteBnd("Bottom",WH//1.077,"CameraCheck")
		WriteBnd("Left",WW//3.32,"FishBar")
		WriteBnd("Right",WW//1.43,"FishBar")
		WriteBnd("Top",WH//1.172,"FishBar")
		WriteBnd("Bottom",WH//1.16,"FishBar")
		WriteBnd("Left",WW//2.547,"ProgBar")
		WriteBnd("Right",WW//1.644,"ProgBar")
		WriteBnd("Top",WH//1.1,"ProgBar")
		WriteBnd("Bottom",WH//1.0965,"ProgBar")
		WriteBnd("Left",WW//1.05,"LvlCheck")
		WriteBnd("Right",WW//1.0035,"LvlCheck")
		WriteBnd("Top",WH//1.085,"LvlCheck")
		WriteBnd("Bottom",WH//1.049,"LvlCheck")
	}
	For i,j in ["CameraCheck","FishBar","ProgBar","LvlCheck"]
		For k,v in ["Left","Right","Top","Bottom"]
			ReadBnd(%j%%v%,v,j)
	CShakeLeft:=WW/4.6545
	CShakeRight:=WW/1.2736
	CShakeTop:=WH/14.08
	CShakeBottom:=WH/1.3409
	ResolutionScaling:=2560/WW
	ResolutionScaling:=2560/WW
	UnstableColorX:=WW/3.463
	UnstableColorY:=WH/1.168
	LookDownX:=WW/2
	LookDownY:=WH/4
Return
SaveBounds:
	For i,j in ["CameraCheck","FishBar","ProgBar","LvlCheck"]
		For k,v in ["Left","Right","Top","Bottom"]
			WriteBnd(v,%j%%v%,j)
Return
ShowBounds:
	For i,v in ["CameraCheck","FishBar","ProgBar","LvlCheck"]
		CreateBound(v,%v%Left,%v%Top,%v%Right,%v%Bottom)
Return
HideBounds:
	Gui FishBar:Destroy
	Gui ProgBar:Destroy
	Gui CameraCheck:Destroy
	Gui LvlCheck:Destroy
Return
ResetBounds:
	FileDelete,%BoundsPath%
	Gosub Calculations
	Gosub ShowBounds
	If Trim(SelectedBound)!=""
		Gosub SelectBound
Return
SelectBound:
	x1=%SelectedBound%Left
	x2=%SelectedBound%Right
	y1=%SelectedBound%Top
	y2=%SelectedBound%Bottom
	x:=%x1%
	y:=%y1%
	w:=%x2%-x
	h:=%y2%-y
	CreateBound(SelectedBound,%x1%,%y1%,%x2%,%y2%)
	GuiControl,,UDX,%x%
	GuiControl,,UDY,%y%
	GuiControl,,UDW,%w%
	GuiControl,,UDH,%h%
Return
ApplyBnd:
	Gui Submit,NoHide
	If Trim(SelectedBound)!=""{
		WinMove,%SelectedBound%,,%UDX%,%UDY%,%UDW%,%UDH%
		%SelectedBound%Left:=UDX
		%SelectedBound%Top:=UDY
		%SelectedBound%Right:=UDX+UDW
		%SelectedBound%Bottom:=UDY+UDH
		Goto SaveBounds
	}
Return