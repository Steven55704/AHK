;10
#Include %A_MyDocuments%\Macro Settings\main.ahk
CreateBound(n,x1,y1,x2,y2){
	colors:={CameraCheck:"Yellow",FishBar:"Lime",ProgBar:"Red",LvlCheck:"Blue",SellProfit:"Aqua",CameraMode:"Fuchsia",SellButton:"Navy"}
	w:=x2-x1
	h:=y2-y1
	Gui %n%:Destroy
	Gui %n%:-Caption +AlwaysOnTop +ToolWindow
	Gui %n%:Color,% colors[n]
	Gui %n%:Show,x%x1% y%y1% w%w% h%h%,%n%
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
	ReadBnd(tmp,"Top","CameraCheck")
	msng:=!tmp
	If msng{
		WriteBnd("Left",WW//2.15,"CameraCheck")
		WriteBnd("Right",WW//1.85,"CameraCheck")
		WriteBnd("Top",WH//1.105,"CameraCheck")
		WriteBnd("Bottom",WH//1.077,"CameraCheck")
	}
	ReadBnd(tmp,"Top","FishBar")
	msng:=!tmp
	If msng{
		WriteBnd("Left",0.2981543095*WW,"FishBar")
		WriteBnd("Right",0.7018456905*WW,"FishBar")
		WriteBnd("Top",WH//1.172,"FishBar")
		WriteBnd("Bottom",WH//1.16,"FishBar")
	}
	ReadBnd(tmp,"Top","ProgBar")
	msng:=!tmp
	If msng{
		WriteBnd("Left",0.391298225298586024*WW,"ProgBar")
		WriteBnd("Right",0.608701774701413976*WW,"ProgBar")
		WriteBnd("Top",WH//1.1,"ProgBar")
		WriteBnd("Bottom",WH//1.0965,"ProgBar")
	}
	ReadBnd(tmp,"Top","LvlCheck")
	msng:=!tmp
	If msng{
		WriteBnd("Left",WW//1.05,"LvlCheck")
		WriteBnd("Right",WW//1.0035,"LvlCheck")
		WriteBnd("Top",WH//1.085,"LvlCheck")
		WriteBnd("Bottom",WH//1.049,"LvlCheck")
	}
	ReadBnd(tmp,"Top","SellProfit")
	msng:=!tmp
	If msng{
		WriteBnd("Left",WW//1.09,"SellProfit")
		WriteBnd("Right",WW//1.006,"SellProfit")
		WriteBnd("Top",WH//1.21,"SellProfit")
		WriteBnd("Bottom",WH//1.145,"SellProfit")
	}
	ReadBnd(tmp,"Top","CameraMode")
	msng:=!tmp
	If msng{
		WriteBnd("Left",WW//1.025,"CameraMode")
		WriteBnd("Right",WW//1.01,"CameraMode")
		WriteBnd("Top",20,"CameraMode")
		WriteBnd("Bottom",46,"CameraMode")
	}
	ReadBnd(tmp,"Top","SellButton")
	msng:=!tmp
	If msng{
		WriteBnd("Left",WW//2.9,"SellButton")
		WriteBnd("Right",WW//2.47,"SellButton")
		WriteBnd("Top",WH//1.62,"SellButton")
		WriteBnd("Bottom",WH//1.56,"SellButton")
	}
	For i,j in boundNames
		For k,v in ["Left","Right","Top","Bottom"]
			ReadBnd(%j%%v%,v,j)
	CShakeLeft:=WW/4.6545
	CShakeRight:=WW/1.2736
	CShakeTop:=WH/14.08
	CShakeBottom:=WH/1.3409
	ResolutionScaling:=2560/WW
	LookDownX:=WW/2
	LookDownY:=WH/2
	ToolTipY:=WH/1.0626
	CatchCheck:=(ProgBarRight+3*ProgBarLeft)/4
	CameraModeX:=(CameraModeRight+CameraModeLeft)/2
	CameraModeY:=(CameraModeBottom+CameraModeTop)/2
	SellPosX:=(SellButtonRight+SellButtonLeft)/2
	SellPosY:=(SellButtonBottom+SellButtonTop)/2
Return
SaveBounds:
	For i,j in boundNames
		For k,v in ["Left","Right","Top","Bottom"]
			WriteBnd(v,%j%%v%,j)
Return
ShowBounds:
	For i,v in boundNames
		CreateBound(v,%v%Left,%v%Top,%v%Right,%v%Bottom)
Return
HideBounds:
	For _,v in boundNames
		Gui %v%:Destroy
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