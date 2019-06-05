; =================================================================================================================================
; Name:           chess
; Description:    A super simple chess game
; Topic:          https://autohotkey.com/board/topic/114697-ahk-chess/
; Sript version:  unknown
; AHK Version:    unknown  
; Author::        floodindahood

; How to play:
;
;
;       To note: there is no castling nor en passant but, otherwise should work perfectly.
; ==================================================================================================================================

global sBoard,pBoard
yLoc := 0, cell := 30, sFEN := "rnbqkbnr/pppppppp/eeeeeeee/eeeeeeee/eeeeeeee/eeeeeeee/PPPPPPPP/RNBQKBNR"
stringsplit, pFenY, sFEN,`/
gui,font, % "s" cell/26, Lucida Console
loop, 8 {
	stringSplit, pFenX, pFenY%A_Index%
	yIndex := A_Index, xLoc := 0
	loop, 8 {
		sBoard .= pFenX%A_Index%
		name := yIndex A_Index
		gui,add,text, % ((mod(A_Index+yIndex,2) == 0) ? "0x4" : "0x5") " x" xLoc " y" yLoc " w" cell " h" cell
		gui,font, % (regexMatch(GetItem(yIndex,A_Index),"[PRNBQKBNR]")) ? "cwhite" : "cblack"
		gui,add,text, x%xLoc% y%yLoc% w%cell% h%cell% +center +BackgroundTrans v%name% gAction, % GetAscii(GetItem(yIndex,A_Index))
		xLoc += cell
	}
	yLoc += cell
}
pBoard := sBoard
active := (active == "W") ? "b" : "W"
gui, show, w%xLoc% h%yLoc%, Chess
return

Action:
y := substr(A_GuiControl,1,1), x := substr(A_GuiControl,2,1)
if (selected == "" && GetItem(y,x) != "e" && (regexMatch(GetItem(y,x),"[PRNBQKBNR]") == regexMatch(active,"[W]"))) { 
	gui, font, cYellow
	GuiControl, font, %A_GuiControl%
	selected := A_GuiControl
}
else if (selected != "") {
	if (CheckLegal(selected,A_GuiControl) && selected != A_GuiControl) {
		SetItem(GetItem(substr(selected,1,1),substr(selected,2,1)),y,x)
		SetItem("e",substr(selected,1,1),substr(selected,2,1))
		active := (active == "W") ? "b" : "W"
	}
	UpdateBoard(selected)
	selected := ""
	
	pBoard := sBoard
}
return

SetItem(i,y,x) {
	loop,parse,sBoard
	{
		if (A_Index == ((y-1)*8)+x)
			ret .= i
		else
			ret .= A_LoopField
	}
	sBoard := ret
}

GetItem(y,x,b = 0) {
	return % substr((b == 0) ? sBoard : pBoard,((y-1)*8)+x,1)
}

UpdateBoard(selected) {
	loop, 8 {
		yIndex := A_Index
		loop, 8 {
			name := yIndex A_Index, kingCheck .= (GetItem(yIndex,A_Index) == "k" || GetItem(yIndex,A_Index) == "K") ? GetItem(yIndex,A_Index) : ""
			if ((GetItem(yIndex,A_Index) != GetItem(yIndex,A_Index,1)) || (regexMatch(GetItem(yIndex,A_Index),"[PRNBQKBNR]") != regexmatch(GetItem(yIndex,A_Index,1),"[PRNBQKBNR]")) || (yIndex A_Index == selected)) {
				gui, font, % (regexMatch(GetItem(yIndex,A_Index),"[PRNBQKBNR]")) ? "cwhite" : "cblack"
				GuiControl, Font, %name%
				Guicontrol,,%name%, % GetAscii(GetItem(yIndex,A_Index))
			}
		}
	}
	if (kingCheck == "K" || kingCheck == "k")
		MsgBox % ((kingCheck == "K") ? "Black" : "White") " king died!`nWell played " ((kingCheck == "K") ? "white!" : "black!")
}

CheckLegal(i1,i2) {
	stringsplit,a,i1
	stringsplit,b,i2
	y := b1 - a1, x := b2 - a2
	piece := GetItem(a1,a2)
	col := regexMatch(piece,"[PRNBQKBNR]")
	StringUpper,piece,piece
	if (regexMatch(piece,"[PRBQ]")) {
		h := (abs(x) > abs(y)) ? abs(x) : abs(y)
		loop % h
			if (!Step(col,piece,(x > 0) ? x/h : (x < 0) ? x/h : 0,(y > 0) ? y/h : (y < 0) ? y/h : 0,i1,h))
				illegal := true
		return % (illegal) ? false : true
	}
	else
		return % Step(col,piece,x,y,i1)
}

Step(col,piece,x,y,i1,cycle = 1){
	x := round(x-mod(x,1)), y := round(y-mod(y,1))
	coll := CollisionCheck(i1,substr(i1,1,1)+y substr(i1,2,1)+x)
	legal := (!col && piece == "P" && ((substr(i1,1,1) == 2) ? (y*cycle == 2 || y*cycle == 1) : y*cycle == 1) && (((coll == "foe") && (x == -1 || x == 1)) || ((coll == "e") && (x == 0)))) ? true
		   : (col && piece == "P" && ((substr(i1,1,1) == 7) ? (y*cycle == -2 || y*cycle == -1) : y*cycle == -1) && (((coll == "foe") && (x == -1 || x == 1)) || ((coll == "e") && (x == 0)))) ? true
		   : (piece == "R" && (y == 0 || x == 0)) ? true
		   : (piece == "N" && ((abs(y) == 1 && abs(x) == abs(y)+1) || (abs(x) == 1 && abs(y) == abs(x)+1))) ? true
		   : (piece == "B" && (abs(y) == abs(x))) ? true
		   : (piece == "Q" && ((y == 0 || x == 0) || (abs(y) == abs(x)))) ? true
		   : (piece == "K" && (abs(y) <= 1 && abs(x) <= 1)) ? true : false
	return (legal && (coll == "foe" || coll == "e")) ? true : false
}

CollisionCheck(i1,i2) {
	stringsplit,a,i1
	stringsplit,b,i2
	return % (GetItem(b1,b2) == "e") ? "e" : (regexMatch(GetItem(a1,a2),"[PRNBQKBNR]") == regexMatch(GetItem(b1,b2),"[PRNBQKBNR]")) ? "friend" : "foe"
}

GetAscii(str) {
	StringUpper,str,str
	return % (str == "P") ? "`n`n`n`n`n___`n/   \`n\___/`n/____\`n|  |`n|__|`n(====)`n}===={`n(______)`n"
		   : (str == "R") ? "`n`n`n`n`n|'-'-'|`n|_____|`n|   |`n|   |`n|   |`n)___(`n(     )`n}     {`n(_______)`n"
		   : (str == "N") ? "`n`n`n`n(\=,`n//  .\`n(( \_  \`n))    `\_)`n(/    \`n|  _.-'|`n)_____(`n(=====)`n}====={`n(_______)`n"
		   : (str == "B") ? "`n`n`n()`n/\`n//\\`n(    )`n)__(`n/____\`n|  |`n|  |`n/____\`n(======)`n}======{`n(________)`n"
		   : (str == "Q") ? "`n`n()`n.-:--:-.`n\____/`n{====}`n)__(`n/____\`n|  |`n|  |`n|  |`n|  |`n/____\`n(======)`n}======{`n(________)`n"
		   : (str == "K") ? "`n_:_`n'-.-'`n__.'.__`n|_______|`n\=====/`n)___(`n/_____\`n|   |`n|   |`n|   |`n|   |`n|   |`n/_____\`n(=======)`n}======={`n(_________)`n" : ""
}

GuiEscape:
GuiClose:
Exitapp 