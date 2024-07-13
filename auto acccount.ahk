#SingleInstance Force
`::
doing := true
while(doing){
	PixelGetColor, c, 60, 180
	if(c = 0x0000FF){
		MouseClick, Left, 836, 414
		MouseClick, Left, 836, 463
		MouseClick, Left, 977, 414
		MouseClick, Left, 977, 463
		MouseClick, Left, 1100, 414
		MouseClick, Left, 1100, 840
		Sleep, 200
	}else if(c = 0x00AAFF){
		MouseClick, Left, 60, 180
		MouseClick, Left, 777, 508
		Send, ^v
		Sleep, 100
		Send, ^2
		Send, ^v
		Sleep, 100
		Send, {Tab}
		Send, {Enter}
		Sleep, 100
		Send, ^3
		Sleep, 200
	}else if(c = 0x00FFFF){
		MouseClick, Left, 60, 180
		MouseClick, Left, 777, 600
		Send, ^v
		Sleep, 100
		Send, ^2
		Send, ^v
		Sleep, 100
		Send, {Tab}
		Send, {Enter}
		Send, {Enter}
		Send, {Enter}
		Sleep, 100
		Send, ^3
		Sleep, 200
	}else if(c = 0x00FF00){
		doing := false
	}
	Sleep, 200
}
return