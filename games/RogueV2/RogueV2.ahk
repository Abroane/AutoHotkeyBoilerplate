; =================================================================================================================================
; Name:           Rogue V2
; Description:    A simple roguelike in AHK
; Topic:          https://gist.github.com/G33kDude/c0786b40cf4e462e1b53
; Sript version:  2
; AHK Version:    unknown  
; Author::        G33kdude

; How to play:
;
; ==================================================================================================================================

Width := 20, Height := 20
KeyMap := {"up": "up", "left": "left", "down": "down", "right": "right"}

Map := [], BlankSquares := []
Loop, % Width
{
	x := A_Index
	Loop, % Height
	{
		y := A_Index
		if (x == 1 || x == Width || y == 1 || y == Height)
			Map[x, y] := new Wall()
		else
			Map[x, y] := new Empty(), BlankSquares.Insert([x, y])
	}
}

RandElements := [Monster, Treasure, Food, Battery, Battery]
Loop, % Width*Height/4 ; 100 with a standard 20x20 board
{
	Pos := BlankSquares.Remove(Rand(1, BlankSquares.MaxIndex()))
	Element := RandElements[Rand(1, RandElements.MaxIndex())]
	Map[Pos*] := new Element()
}

Loop, 10
{
	Pos := BlankSquares.Remove(Rand(1, BlankSquares.MaxIndex()))
	Map[Pos*] := new Pit()
}

Loop, 5
{
	x := Rand(3, Width-2)
	y := Rand(3, Height-2)
	Vert := Rand(0,1)
	if Vert
		Map[x,y+1] := new Wall(), Map[x,y] := new Wall(), Map[x,y-1] := new Wall()
	else
		Map[x-1,y] := new Wall(), Map[x,y] := new Wall(), Map[x+1,y] := new Wall()
}

pX := Width//2, pY := Height//2
Map[px, py] := new Player(pX, pY)
Map[px, py].Tock(Map, pX, pY)

Gui, Font, s10, Consolas
Gui, Add, Edit, x0 y0 w160 h370 Disabled vDisplay -VScroll, % DrawMap(Map) "`n`nEnergy: 100`nLight: 5/10"
Gui, Show, w160 h370
Loop
{
	Out := "", Elements := []
	for x, Col in Map
		for y, Element in Col
			Elements[[x, y]] := Element
	for Pos, Element in Elements
		if !Element.Deleted && (Tmp := Element.Tick(Map, Pos*))
			Out .= "`n" Tmp
	for Pos, Element in Elements
		Element.Tock(Map, Pos*)
	
	GuiControl,, Display, % DrawMap(Map) . Out
}
ExitApp
return

GuiClose:
ExitApp
return

Rand(Min, Max)
{
	Random, Rand, Min, Max
	return Rand
}

class Monster
{
	Symbol := "X"
	Heals := -1
	Tagline := "Ow, a monster: -1 Energy"
	
	Tick(Map, x, y)
	{
		Dirs := [[0,-1],[0,1],[-1,0],[1,0]]
		if !Rand(0, Dirs.MaxIndex())
			return ; Don't move, chance is 1 in Dirs+1
		Loop, % Dirs.MaxIndex()
		{
			Dir := Dirs.Remove(Rand(1, Dirs.MaxIndex()))
			nx := x+Dir[1]
			ny := y+Dir[2]
			if (Map[nx, ny].Empty)
			{
				Map[nx, ny].Deleted := True
				Map[nx, ny] := this
				Map[x, y] := new Empty()
				return
			}
		}
	}
}

class Treasure
{
	Symbol := "$"
	Healthy := True
	Heals := 1
	Tagline := "Cool, Moneys: +1 Energy"
}

class Food
{
	Symbol := "#"
	Heals := 2
	Tagline := "Yum, food: +2 Energy"
}

class Wall
{
	Symbol := "+"
	Solid := True
}

Class Pit
{
	Symbol := "_"
	Heals := -999
	Tagline := "You fell into a bottomless pit"
}

Class Empty
{
	Empty := True
	Symbol := "."
}

Class Battery
{
	Symbol := "T"
	Fuel := 2
	Tagline := "Great, a battery: +2 Light"
}

class Player
{
	Symbol := "@"
	Energy := 100
	Torch := 5
	
	__New(PlayerX, PlayerY)
	{
		this.x := PlayerX
		this.y := PlayerY
	}
	
	Tick(Map, x, y)
	{
		global KeyMap
		static PID := DllCall("GetCurrentProcessId")
		Loop
		{
			sleep, 50
			if !WinActive("ahk_pid " PID)
				continue
			for Key, Bool in GetKeyStates(KeyMap*)
				if Bool
					break, 2
		}
		KeyWait, % KeyMap[Key], t0.2
		
		Pos := {"up": [x, y-1], "left": [x-1, y]
		, "down": [x, y+1], "right": [x+1, y]}[Key]
		Element := Map[Pos*]
		
		Out := Element.Tagline
		if (Element.Heals)
			this.Energy += Element.Heals
		if (Element.Fuel)
			this.Torch += Element.Fuel
		this.Energy -= 1
		this.Torch -= 0.5
		if this.Torch < 0
			this.Torch := 0
		if this.Torch > 10
			this.Torch := 10
		
		if this.Energy < 1
		{
			MsgBox, %Out%`nGame over
			ExitApp
		}
		
		if (!Element.Solid)
		{
			this.x := Pos[1], this.y := Pos[2]
			Map[Pos*].Deleted := True
			Map[Pos*] := this
			Map[x, y] := new Empty()
		}
		
		Out .= "`nEnergy: " this.Energy
		Out .= "`nLight: " Ceil(this.Torch) "/10"
		return Out
	}
	
	Tock(Map, ThisX, ThisY)
	{
		for x, Row in Map
		{
			for y, Element in Row
			{
				if (abs(this.x-x)+abs(this.y-y) > ceil(this.torch)-1)
					Element.Hidden := true
				else
					Element.Hidden := false
			}
		}
	}
}

GetKeyStates(Keys*)
{
	Out := []
	for Index, Key in Keys
		Out[Index] := GetKeyState(Key, "P")
	return Out
}

DrawMap(Map)
{
	Flip := []
	for x, Col in Map
		for y, Element in Col
			Flip[y,x] := Element.Hidden ? " " : Element.Symbol
	
	Buffer := ""
	for y, Row in Flip
	{
		for x, Char in Row
			Buffer .= Char
		Buffer .= "`n"
	}
	
	return Buffer
}