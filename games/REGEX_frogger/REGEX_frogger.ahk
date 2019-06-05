; =================================================================================================================================
; Name:           REGEX FROGGER 
; Description:    A CLASSIC FROGGER GAME CLONE
; Topic:          https://www.autohotkey.com/boards/viewtopic.php?f=6&t=60902  
; Sript version:  1.7
; AHK Version:    1.1.24.03 (A32/U32/U64)
; Tested on:      Win 7 (x64)
; Author::        SpeedMaster

; How to play:     The object of the game is to help your character (the frog " @ ") cross from the bottom of the screen to the top.
; The player guides a frog which starts at the bottom of the screen, to his home in one of 5 slots at the top of the screen. 
; The lower half of the screen contains a road with motor vehicles  speeding along it horizontally.
; The upper half of the screen consists of a river with logs moving horizontally across the screen. The very top of the screen contains 
; five "frog homes" which are the destinations for each frog.
;
; ==================================================================================================================================
version:=1.7

#SingleInstance force
#KeyHistory, 0
ListLines, Off
SetControlDelay, -1
setbatchlines, -1
Process, Priority,, High
SetWorkingDir, %a_scriptdir%
DetectHiddenWindows, On 
SendMode, Input
OnExit("MidiShutdown")
gosub, makefile

gui, font, s18 cwhite bold, courier

gui, -dpiscale
loop, 17
gui, add, text, % "x10 " ((a_index=1) ? "y10 " : "yp+20 ") " v1_1_" a_index " h22 c5F574F -border BackGroundTrans left", % "                    "  ; borders
loop, 17
gui, add, text, % "x10 " ((a_index=1) ? "y16 " : "yp+20 ") " v2_1_" a_index " h22 cblue -border BackGroundTrans left"  , % "                    "  ; river
loop, 17
gui, add, text, % "x10 " ((a_index=1) ? "y10 " : "yp+20 ") " v3_1_" a_index " h22 cgreen -border BackGroundTrans left" , % "                    "  ; gras
loop, 17
gui, add, text, % "x10 " ((a_index=1) ? "y14 " : "yp+20 ") " v6_1_" a_index " h22 cgray -border BackGroundTrans center"  , % "                    "  ; street 
loop, 17
gui, add, text, % "x10 " ((a_index=1) ? "y10 " : "yp+20 ") " v4_1_" a_index " h22 cwhite -border BackGroundTrans left" , % "                    "  ; moving frames

loop, 17
gui, add, text, % "x10 " ((a_index=1) ? "y10 " : "yp+20 ") " v5_1_" a_index " h22 clime -border BackGroundTrans left"  , % "                    "  ; frog layer

gui, add, text, % "x10 y350 w120  vc_1_1 h22 clime -border BackGroundTrans left "  , % "         "  ; remaining frogs

gui, font, s10 , arial
gui, add, text, % "x+5 y350 w132  vc_2_1 h22 csilver -border BackGroundTrans 0x200 right"  , % "LEVEL : 1"   ; level HUD

gui, font, s9 italic, arial
gui, add, text, % "x10 y+5 w120   cwhite -border BackGroundTrans left "  , % "REGEX FROGGER"  ; title
gui, add, text, % "x+20 yp w120   csilver -border BackGroundTrans right "  , % "by Speedmaster "  ; autor

rawmapbg=
(
####################
##..##..##..##..#..#
#~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~#
#::::::::::::::::::#
#::::::::::::::::::#
#_  _  _  _  _  _  #
#_  _  _  _  _  _  #
#_  _  _  _  _  _  #
#_  _  _  _  _  _  #
#                  #
#::::::::::::::::::#
#::::::::::::::::::#
####################
)

rawmap=
(
####################
##..##..##..##..#..#
#WWW    WWWWWW   WW#
#   WWWWWW   WWWWW #
#WWW   WWWWWW     W#
#          WWWWWWWW#
#  WW     WWW  WWWW#
#                  #
#                  #
#         :[HH     #
#   [=+            #
#   -(o-     -(o-  #
# >>    >>   >>    #
#  O   O   O   O   #
#                  #
#         @        #
####################
)

rawmap2=
(
####################
##..##..##..##..#..#
#WWW    WWWWWW   WW#
#   WW WW    WW WW #
#       WWWWWW     #
#          WWWWWWWW#
#  WW     WWW  WWWW#
#                  #
#                  #
#         :[HH     #
#   [=+            #
#   -(o-     -(o-  #
# >>    >>   >>    #
#  O   O   O   O   #
#                  #
#         @        #
####################
)

hopnote:=69
reset:=0
level:=1
maxfrogs:=5


; Midi Startup
hMidi := DllCall("Kernel32.dll\LoadLibrary", "Str", "Winmm.dll")
VarSetCapacity(strh_MIDIOut, (A_PtrSize = 8 ? 24 : 16), 0)
DllCall("Winmm.dll\midiOutOpen", "UInt", &strh_MIDIOut, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0, "UInt")
h_MIDIOut := NumGet(strh_MIDIOut)
MidiVolume := (100 / 100) * 0xFFFF
DllCall("Winmm.dll\midiOutSetVolume", "UInt", h_MIDIOut, "UInt", MidiVolume | MidiVolume << 16)

start:

CellFont("c_1_2", "italic")
cellfont("c_1_2", "s10 cRed Bold" ,"arial")
cellfont("c_1_3", "s9" ,"arial")
drawchar("c_1_2", "", "red")
drawchar("c_1_3", "")
cellfont("6_1_15", "s10" ,"arial")
cellfont("6_1_16", "s9" ,"arial")

if (frogs<=0) {
	frogs:=""
	drawchar("5_1_2", "")
	level:=1
	MidiSound(72)
	soundPlay, Intro.mp3
}

loop, 15
	if (a_index>2) {
		drawchar("5_1_" a_index, "")   ; clear frog layers
	}

frogs?:frogs:=maxfrogs

map:=strsplit(rawmap, "`n", "`r")

	if (youwin) {
		level++
		drawchar("c_1_2", "")
		drawchar("c_1_3", "")
		youwin:=0
		soundplay, LevelUp.mp3
	}
	
if (level=1)
levelspeed:=0
if (level=2) {
map:=strsplit(rawmap2, "`n", "`r")	
levelspeed:=20
}
if (level>=3) {
	map:=strsplit(rawmap2, "`n", "`r")
	levelspeed:=28
}

if (reset) {
	map.2:=frogstate.pop()
	map[2]:=regexreplace( map[2] ,"@","#") ; 
}	

drawchar("c_2_1", "LEVEL : " . level)
drawchar("5_1_2", sliceword(map.2, "OK"), "lime")

mapbg:=strsplit(rawmapbg, "`n", "`r")
MovingChars:="O|\.|W|>|\+|o|-|\(|\[|=|H|:"

frogx:=11
frogy:=16

for k, v in map {
	drawchar("4_1_" k, sliceword(v, MovingChars))
}
   
  
 for k, v in mapbg {
	drawchar("1_1_" k, sliceword(v, "#"))
    drawchar("2_1_" k, sliceword(v, "~")) 	
	drawchar("3_1_" k, sliceword(v, ":"))
	drawchar("6_1_" k, sliceword(v, "_"))
}	

	drawchar("5_1_16", sliceword(map.16, "@"))
	drawchar("c_1_1", livestochars(frogs))



gui, color, black
gui, +resize
gui, show, w280 h400, REGEX FROGGER V%version%

ColorCell("4_1_11", "red")
ColorCell("4_1_14", "FFA300") ;orange
ColorCell("4_1_12", "yellow")
ColorCell("4_1_13", "FF77A8") ;pink
ColorCell("4_1_10", "aqua")

ColorCell("4_1_7", "AB5236") ; brown
ColorCell("4_1_6", "8B4513") ; brown
ColorCell("4_1_5", "bb6d3e") ; brown
ColorCell("4_1_4", "905424") ; brown
ColorCell("4_1_3", "AB5236") ; brown

loop, 17
  ColorCell("5_1_" a_index, "lime")


hiddencontrols:=["2_1_1", "2_1_2","2_1_8","2_1_9","2_1_10","2_1_11","2_1_12","2_1_13","2_1_14","2_1_15","2_1_16","2_1_17","3_1_1","3_1_2","3_1_3","3_1_4","3_1_5","3_1_6","3_1_7","3_1_10","3_1_11","3_1_12","3_1_13","3_1_14","3_1_17","4_1_1","4_1_8","4_1_9","4_1_15","4_1_16","4_1_17"]

for k, v in hiddencontrols
hidecell(v)

settimer, moverow14, % 240 - ((240*LevelSpeed)//100), on
settimer, moverow13, % 220 - ((220*LevelSpeed)//100), On
settimer, moverow12, % 240 - ((240*LevelSpeed)//100), On
settimer, moverow11, % 65 - ((65*LevelSpeed)//100), On    ;speed car
settimer, moverow10, % 230 - ((230*LevelSpeed)//100), On

settimer, moverow7, 200, On
settimer, moverow6, 130, On
settimer, moverow5, 100, On
settimer, moverow4, 250, On
settimer, moverow3, 230, On

reset:=0
dead:=0
frogstate:=[]

return

moverow14:
if (dead) || (youwin)
	return

if (frogs<0) {
	frogs:=maxfrogs
	drawchar("5_1_2", "")
	level:=1
	}	

if (youwin)
	return

if dead {
ColorCell("5_1_" frogy, "red")
	return
}

if instr(map.14, "@O", 1) {
	dead()
}

map.14:=regexreplace( map.14, "@ ", " @")

map.14:=regexreplace(map.14, "(.)(.)(.{17})(.)", "$1$3$2$4")
drawchar("4_1_" 14, sliceword(map.14 . "`n", "O"))
return

moverow13:
if (dead) || (youwin)
	return

RegExMatch(map[frogy], "\>@") ? dead() 

map.13:=regexreplace( map.13, " @", "@ ")
map.13:=regexreplace(map.13, "(.)(.{17})(.)(.)", "$1$3$2$4")
drawchar("4_1_" 13, sliceword(map.13 . "`n", ">"))
return


moverow12:
if (dead) || (youwin)
	return

RegExMatch(map[frogy], "@-") ? dead() 

map.12:=regexreplace( map.12, "@ ", " @")
map.12:=regexreplace(map.12, "(.)(.)(.{17})(.)", "$1$3$2$4")
drawchar("4_1_" 12, sliceword(map.12 . "`n", movingchars))
return


moverow11:
if (dead) || (youwin)
	return

RegExMatch(map[frogy], "\+@") ? dead() 

map.11:=regexreplace( map.11, " @", "@ ")
map.11:=regexreplace(map.11, "(.)(.{17})(.)(.)", "$1$3$2$4")
drawchar("4_1_" 11, sliceword(map.11 . "`n", movingchars))
return

moverow10:
if (dead) || (youwin)
	return

instr(map.10, "@:", 1) ? dead() 

map.10:=regexreplace( map.10, "@ ", " @")
map.10:=regexreplace(map.10, "(.)(.)(.{17})(.)", "$1$3$2$4")
drawchar("4_1_" 10, sliceword(map.10 . "`n", movingchars))
return


moverow7:
if (dead) || (youwin)
	return

map.7:=regexreplace(map.7, "(.)(.)(.{17})(.)", "$1$3$2$4")
drawchar("4_1_" 7, sliceword(map.7 . "`n", movingchars))

(frogy=7) ? drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))

RegExMatch(map.7, "@#") ? dead() 

return



moverow6:
if (dead) || (youwin)
	return

map.6:=regexreplace(map.6, "(.)(.)(.{17})(.)", "$1$3$2$4")
drawchar("4_1_" 6, sliceword(map.6 . "`n", movingchars))

(frogy=6) ? drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))

RegExMatch(map.6, "@#") ? dead() 

return


moverow5:
if (dead) || (youwin)
	return

map.5:=regexreplace(map.5, "(.)(.{17})(.)(.)", "$1$3$2$4")
drawchar("4_1_" 5, sliceword(map.5 . "`n", movingchars))

(frogy=5) ? drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))

RegExMatch(map.5, "#@") ? dead() 

return

moverow4:
if (dead) || (youwin)
	return

map.4:=regexreplace(map.4, "(.)(.)(.{17})(.)", "$1$3$2$4")
drawchar("4_1_" 4, sliceword(map.4 . "`n", movingchars))

(frogy=4) ? drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))

RegExMatch(map.4, "@#") ? dead() 

return

moverow3:
if (dead) || (youwin)
	return

map.3:=regexreplace(map.3, "(.)(.{17})(.)(.)", "$1$3$2$4")
drawchar("4_1_" 3, sliceword(map.3 . "`n", movingchars))

(frogy=3) ? drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))

RegExMatch(map.3, "#@") ? dead() 

return

#IfWinActive REGEX FROGGER

~enter::

loop, 17
	if (a_index>2) {
		drawchar("5_1_" a_index, "")   ; clear frog layers
	}
drawchar("c_1_2", "")
drawchar("c_1_3", "")
drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))

if (dead) || (youwin) {
	dead:=0
	resetgame()
}
return


Z::
W::
~up::

if (dead) || (youwin) {
	return
}

frogx:=instr(map[frogy], "@")

if ispassable(0,"-1") {
	if ((frogy<=7) && (frogy>2))
		map[frogy]:=regexreplace(map[frogy] ,"@", "W") 
	
	map[frogy]:=regexreplace(map[frogy] ,"@"," ") ; clear previous position in data map
	drawchar("5_1_" frogy, "") ; clear frog screen layer  (layer 5)
	frogy:=frogy-1
	map[frogy]:=regexreplace( map[frogy] ,".","@",,1,frogx)

	if (frogy=2) {
		map[frogy]:=regexreplace( map[frogy] ,"#@\.","#OK",rema,1) ; succes
		map[frogy]:=regexreplace( map[frogy] ,"#\.@","#OK",remb,1) ; scces
		if (rema || remb) {
			rema:=remb:=0
			MidiSound(84)
			soundPlay, athome.mp3
			}
	}
	
	if (frogy=2) {
		drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "OK"))
		frogy:=16
		map[frogy]:="#         @        #"
		drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))
		checkwin()
	
		if youwin {
			gosub, endgame
			return
		}
	}	

	if (frogy!=2)
	drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))

}	
else {
	if (frogy<=7) {
		map[frogy]:=regexreplace(map[frogy] ,"@", "W")
		drawchar("4_1_" frogy, sliceword(map[frogy] . "`n","W")) 
		}
	drawchar("5_1_" frogy, "") ; clear frog screen layer  (layer 5)		
	frogy:=frogy-1
	map[frogy]:=regexreplace( map[frogy] ,"#| |O|>|-|o|\(|\+|=|\[|H","@",,1,frogx)
	drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"), "red")
	dead()	
}

MidiSound(hopnote)

return

s::
down::
if (frogy=16)
	return

if (dead) || (youwin)  {
	return
}

frogx:=instr(map[frogy], "@")

if ispassable(0,"1")  {
		map[frogy]:=regexreplace(map[frogy] ,"@", (frogy>7) ?  " " : "W") 
	drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))
	frogy:=frogy+1

	map[frogy]:=regexreplace( map[frogy] ,".","@",,1,frogx) 
	drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))
}
else {
	if (frogy<=7) {
		map[frogy]:=regexreplace(map[frogy] ,"@", "W")
		drawchar("4_1_" frogy, sliceword(map[frogy] . "`n","W")) 
		}
	drawchar("5_1_" frogy, "") ; clear frog screen layer  (layer 5)		
	frogy:=frogy+1
	map[frogy]:=regexreplace( map[frogy] ,"#| |O|>|-|o|\(|\+|=|\[|H|:","@",,1,frogx)
	drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"), "red")
	dead()
}
MidiSound(hopnote)
return

q::
a::
~left::

if (dead) || (youwin)  {
	return
}

if RegExMatch(map[frogy], "O@|-@|H@| @W") {
	frogx--
	map[frogy]:=regexreplace( map[frogy] ,".@","@ ")
	map[frogy]:=regexreplace( map[frogy] ,"@ W","@WW")
	dead()
	return
}

map[frogy]:=regexreplace(map[frogy], " @", "@ ")
map[frogy]:=regexreplace(map[frogy], "W@", "@W")

drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))
MidiSound(hopnote)
return

d::
~right::

if (dead) || (youwin)  {
	return
}

if RegExMatch(map[frogy], "W@ ") {
	frogx++
	map[frogy]:=regexreplace( map[frogy] ,"@."," @")
	map[frogy]:=regexreplace( map[frogy] ,"W @","WW@")	
	dead()
	return
}

map[frogy]:=regexreplace(map[frogy], "@ ", " @")
map[frogy]:=regexreplace(map[frogy], "@W", "W@")

drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"))
MidiSound(hopnote)
return

endgame:
drawchar("5_1_16" , "")
drawchar("3_1_15", "")
drawchar("3_1_16", "")
drawchar("6_1_15", "CONGRATULATION !", "lime")
drawchar("6_1_16", "PRESS ENTER TO CONTINUE", "silver")
return

return
guiclose:
~esc::
ExitApp
return


ispassable(dx,dy) {
	global
	
if  (substr( map[frogy+dy],instr(map[frogy],"@")+dx, 1) = a_space)  && (frogy>8)  && (dy<0)	
	return true

if  (substr( map[frogy+dy],instr(map[frogy],"@")+dx, 1) = a_space)  && (frogy>=8)  && (dy>0)	
	return true

if  (substr( map[frogy+dy],instr(map[frogy],"@")+dx, 1) = a_space)  && (frogy=7)  && (dy>0)	
	return true


if (substr( map[frogy+dy],instr(map[frogy],"@")+dx, 1) = "W")	
	return true

if (substr( map[frogy+dy],instr(map[frogy],"@")+dx, 1) = ".")	
	return true
}	

resetgame() {
global
loop, 15
drawchar("5_1_" a_index, "")
drawchar("4_1_2", "", "white")
dead:=0
gosub, start	
}

dead() {
	global 
	dead:=1

	(frogy<8) ? drawchar("4_1_" frogy, sliceword(map[frogy] . "`n", "W"))
	(frogy=2) ? drawchar("4_1_2", sliceword(map.2, "OK"), "lime")
	drawchar("5_1_" frogy, sliceword(map[frogy] . "`n", "@"), "red")

	if (frogy>2)
	map[frogy]:=RegExReplace(map[frogy], "@", " ")

	frogs--
	if (frogs) {
		drawchar("3_1_15", "")
		drawchar("3_1_16", "")
		drawchar("6_1_15", "YOU ARE DEAD !", "red")
		drawchar("6_1_16", "PRESS ENTER TO TRY AGAIN", "silver")
	}
	else {
		drawchar("3_1_15", "")
		drawchar("3_1_16", "")	
		drawchar("6_1_15", "GAME OVER ", "red")	
		drawchar("6_1_16", "PRESS ENTER TO PLAY AGAIN", "silver")
	}

if (frogs>0)
	reset:=1
    frogstate.push(map.2)

MidiSound(39)


}

livestochars(num) {
	 loop, % num-1
		out .= "@"
return out	
}

drawchar(varname, chartodraw:="@", color:="")
{
 global
guicontrol,, %varname%, %chartodraw%
if (color)
colorcell(varname, color)
}

ColorCell(cell_to_paint, color:="red")
{
 GuiControl, +c%color%  , %cell_to_paint%
 GuiControl, MoveDraw, % cell_to_paint
}

hidecell(cell_to_hide) {
guicontrol, hide, % cell_to_hide
}	

CellFont(cell, params:="", fontname:="")
{
 Gui, Font, %params%, %fontname% 
 GuiControl, font , %cell% 
 guicontrol, movedraw, %cell%
}
	

SliceWord(text, words) {
X:=1, output := ""

if (text) && (!words)
return regexreplace(text, "(?!\v).", " ")

while (X := RegExMatch(text, "(.*?)(" words "|\v)", M, X+StrLen(M)))
	output .= Spaces(StrLen(M1)) M2
return output
}

Spaces(x)
{
	Loop %x%
		Result .= " "
	return Result
}

checkwin() {
	global map, youwin
if !(instr(map.2, "."))
	youwin:=1

}

MidiSound(Note) { 
	Global 
	Static Channel := 9, Velocity := 100
	DllCall("Winmm.dll\midiOutShortMsg", "UInt", h_MIDIOut, "UInt", 0x90 | Channel | (Note << 8) | (Velocity << 16), "UInt")
}

MidiShutdown() {
	DllCall("Winmm.dll\midiOutClose", "UInt", h_MIDIOut)
}


makefile:
AtHomeData=
(
 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
)

IntroData=
(
 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
)
IntroData=%IntroData%
(
 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
)
IntroData=%IntroData%
(
 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qgSavbklt4BaUtJrWZepS9n0VPVX19TTeG52QqWc/7deMxCyzMPl30iPxlwzshE8QSSlUsSRfOBprndUYkt60cT+2qP7bU5r7fJVGQaDkEJHxhgY//NIZOML1XEYz2gjB4AAA0gAAAAAAF3lcrUh52gKIxIF1QRAR8SBVIjJXFFWJrMA/GlFkA6QZEhoQovQHJgAlZg1doZAjCZH3fQplKalGkx5O8TWQIEx54WgF80ecQJk5hDngMd4jmTaQEEQYnudKMT2yydXQgggTKQ5CQvTCZwIiT32u6jLt6bc9EESadoP//NIZM4JJSkcz1Ajj4AAA0gAAAAASBoOkgejpA0nSCvh5iDY94UPTEFNRTMuOTkuNVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUJxuS2W227cClO0vRvmad+vyU7R1nV/JLnv7895Lt+6Vcp6itNf88S1uEQlDWtTEFNRTMuOTku//NIZP8SwY72B3UmKoAAA0gAAAAANVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUGq/3JLLeA9P5xi5kLigYKHLxhRCWsy8mXkLliiEHL1yE+s2hjY9VDD46hjXgejW8poqcBFNS1rho5YnWyse+yD58Hz6qFTEFNRTMuOTku//NIZLIFuAMrLzQjAQAAA0gAAAAANVVVVVVVVR6ubbkk4ISANARqpQBE4YCaqrUBEkzHWbVVgEBEzNVXZSgEBCqFAT1KMdChm1Utj43VXZV2Y9S1XjN1jqrsxxm1Uoy7M1VSUBWBgIUYUCFH/PZm1Vdl2Y6q6hVKM3+q+x/6quwEpRj1LEsqTEFNRTMuOTku//NIZMoIsAcgzzwjAQAAA0gAAAAANaqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqkckkskltoACsssqGKAQwUEDCBww/FQWCQsJA/4qKior+LCyvioqKs/U3+KitTEFNRTMuOTku//NIZO8NRZEUfyRjAQAAA0gAAAAANVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTMuOTku//NIZLEFlCKbLwxCMAAAA0gAAAAANVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//NIZIQAAAGkAAAAAAAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
)

LevelUpData=
(
 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
)
LevelUpData=%LevelUpData%
(
 5iMIl/qR50//+s4JKQkkV/+kPddX/ziP/9Y+m3/+Z/1nhKEEuA//////T////9f8j+h6UNdPLBmQyyiPzOuyYDMixKUkMAsQ9nXZTlHIp5v/nhoB44pFSRYbfcLCzNRW//NIZI4KDW1hL+a0AQVoAUgXwBAAdFuw0EkBZb/+PAN/7Pyv//CAuav/4QJ//KE//9hlv/5D//UhQcoCEA3EgwoRyi7nc2SrSZjkovXTZSNpi4QSJczV2/lkcBC7J/ogyCy393YwoeCCN1X/2ha//xeZ/654DxItW/8R2v/+O//4jF//8n/iGepMQU1FMy45//NIZKMJsZFlLzwnAQAAA0gAAAAAOS41qqqqqqqqqqqqqqqqCFkYh74y0bAUTBFE2OLBLOhcCWGt7Nb40FoAV5Zs91fdASkoHlLYzq9TqETUn3mqjZi4I4QL/+w/gqEXb6kUq5NPf/RqDuRjN1tvoMmywqS2/9c6Uv/ozgYjif/7Fn/+otrqAJWKAGyWkSL4//NIZNAJsWtCymJqOgAAA0gAAAAArVf5AKkHEX5+t2reuX9WspBXMAR74hmYVtfdcZhgy+ikkt01oK0DAfxIKV/ss+TQN4tDiSKr/qMBPVrdfqvyssb/7rCol9j9tq/QGFs//yeYf9XWPYbLf/l7+WCZCMTao5cEAQwcOZcEHaPf04IBh+U/+Jwf1g///wQd//NIZOcMSY1FL0EtJgAAA0gAAAAAlAx/Ln+D9RQFh2pRRRSAPg2RwfwNohYm1Tw3RsvZfPXtYN0WpofSNyizEDQJmccWJHfbiTcI+jkIanfxmSFE9KnREQiJll//VG6U9HJYXaPQvd1LS+GyNaNjW4U22f//7zSWLT7UqOprMSlsMESBqjykS9s2+cRrf4g0//NIZP8MkWs2Kqy0AAl4BcWzQBgA1//XX+Kb8fcfe54ER5Xcf6guv/C1921r/5m+v9f/G/u+vHzt5qHHVbzX//kEfg7Jmf4Tk3////1mGEBen/////////4gcsT38c1ttltkrVkkgAQvf0itOk6uLkLWU7v0i7KZPV2nKcSGwu4OweQjxEwN4QkkQAhBsiTQ//NIZO8TtZE8usw8AAbZHjABgjgAJi1YIVm5dWO0L3qWFw6g57F0Ygt5wzRE2Bel40phDzEfG86SPrkt9RDPSSE4JpoS5qezp7VTzrbVJUkh5TEd5okv1GmRX/TTaSJu03VvUjWcP1zn5/L71TX9Csisr/9AL1BAX6lb/+3/sYMK////////6rmVFV9JJGZQ//NIZLEScY1vL8w0AQVg5jwBghAAA7HFJFdQsW+FfXX/z/U+XUFl1X+LYhOmz3P/fUdEBxrfgvAOO/sBT//9SolP+poLS/+PE///8v/0/////cj/qJDuMGAH///////////wVgr+Cqp1FtVetVpF0Cgx4wM7ossTyvbrBpNSYbzdXUN8RQGCFB72/4KW/w9Z//NIZIMJWXtrL+ecAQPYAdwHwBACfly4eAKnf//qNP+I3/l///6v/1/6f//6lv9Bn9FMQU1FMy45OS41VVVVVWAAhAMcAYIHp90DZNQX7ZVdTMwZySZcN/0RmL/9At/54XIWVT9widv//oNW/mhuFK5nqYK4+S3//Yqn+gqP/lH///q3/FzKTEFNRTMuOTku//NIZKMInX1hLzTKgQAAA0gAAAAANaqqqqqqqqqqqqqqqqqqqqqaKZ6e2e2SUFFa1tYPDHlrsXW6pepWFCL45BlrJRTXOCHlhBcuucRX1p2psRRYaLdFQdB4/nh4hEgGwSJSOUFVf/Ihft+dB0o0u9ZWUHW3//nT3948/+cP///zp7/kinj6EicNzmLO2HIB//NIZMsIzX1I2UAKkAAAA0gAAAAAU+eE97JHhYDNiQ9Z1AxV8borT0ZWy37PglcTmi/A0phnX/re+9AFtNEnXakgDeN10u6RIgeJrZKvZv66iE/9QzH1fzEot//+tv+WL/zI///+smt/xzePdZsyajUomgMDpN6txSq/21OV6u7/Rd9HU7Zx320/wx0K//eT//NIZOUMEXthL2FtCQAAA0gAAAAA1QQpEFIpk0lwPaQwEhYshP8EcZH5+vjows99pcki57mUlG07ulQCgFgoKGJP/w3Iue55b7tX9uAcNoEkEECAMGSgIBhS/E73vcygSN/v/KAh+J/1gh+pxREPqn7l+BMo4oHxA4PrfiB/LvKdQY/iCLv/R//3hj/6w+r9//NIZP8MAXtJPz2NZgk4Be5WAEQAP/pVMiaB1Aya1VltK4IEInnan5VTU1NTZZY/+qzcb+WWOOOOOOOOOv0860qqzMzWzQBZ13e0Nqqqqho6Z1VflmYweCdujpzFKIhv/6sJ//6B03q39D1//Ggb8u78QpNyVtx2R+BSjdWCmJErBQldlgEKxMVOqwaKjDwN//NIZPUK6J1PLzEJaglABoWcAEQASvLeJZL7P/8sWDvqf/IqZNcYirrbEguk4sg3y7cIWSpYjrt8tyw9sioBLmnKn8LgBALDJWe7J501A+i39uumolBZA6i4pX/0w3j97/8ii+l/+gOEt//0v/+f/p/u/vXoS3AiZuOlOcELWrapprdUzt49r4rqj/8ZUSAo//NIZPMLXUtKZWEFlgrgWqZcGYZGp/+Ktf//oX//9XoqTEFNRTMuOTkuNaqqqqqqqqqqquf6Yq82wjAPQikg8+aCzFYXRivf017zP4bNF3po7L+YiIGSfcwZR5fZaAgovvPMq7pTh8T4+Hc879/6xEN/+sikJv/qWLj//7f/6zb//OP/f/laTEFNRTMuOTku//NIZOcKBS1TLmDtPQnIBhp+CEQANaqqqqqqqqqqqqqqqqqqqqqqjMlqs091LUBGTEM96rbgN8miRLG+xiS2JcJUJo+b66vcaAWk4do0HV61DtFPPPNUszPEmMUeQK4Nyy7VWgrZ4sABbKjVlOuks2O3iqR//6QlxZ//v//nTT//Kv5X+SsqE7RQikaAgoJy//NIZNcKUU1U32HtCwAAA0gAAAAAj1Le7Kg3lZ86stfUtNGvMEmEBzVbpouft84QpEzc2UYl9aFWtE0FSSnkEENBA4WTQmANwdpgVlnlGTJmKjU6ovhq43spVq71x///2Gua//6H//Pf0fz36mpAEckA7T/tf//Rvv/soiaHNSYNfmkudNGXaP6qTVcrk0sk//NIZOQL6UtZL2TNNQAAA0gAAAAAjUBMm5TYS+rmqrT1lS1LPcL9bdi1qxtplvDpVlLoeht4UYBYL0QRAH5EQMLValVEACauTT2IbmEbGsA6WZKddphUFPTr9xHHP/3UWS971/oK9Nv6ULf/5Vv53+9YcttiT/pI0Yne4ME4nLjgxZWfnIPicPRA7ynEFOoz//NIZP8MSS1E3mDRNQbSHSAeAEWk+UcXP8p/g//9Zrwx/8QO8pVRAiiiWiiiggAjjDQ2S8FSp1rYjcnh5a5qB/y2fXQyyOouFs8XQOsAbic2UkUSmcYojMDoGQImWuYo2dA4XBzy+T5WfmDbJm4sgskTIO6C+pCfQZR5GOeOeT5BCoeS1t0T+d6diKE4Xxyx//NIZPwMVU1RL6woAQuwAgZXQBACxkENP1epqb7JNo6E3TTN0GIoeX1+t/1UV23UhXvLhcNDdN3WsZgnEMHsB4E/1v+v/UAw///////6Uf//oW6mP8yrLndH7Y1k8kABLzjERsyK05FlgYqiFafWPvtIs8b4H0H42F0X4hQ1zEFeMkVBVWogpWXS7OB58bus//NIZOUSQZE+ysxEAAUwAmgBghAASg1TA0FZKoIRUKbnVxqIdALAvFKko8MG/x2fUS6MZyktiQMzBGYlujMcwLc/NTVSSA/JRjjAmpl6jXK2/WfyampZi05ROm6DDOMhNKf/bZGqh+vOOBhAAhgBAAIXiF7P7L/f/zPBCv/1Mb//R83//mKymKVP///6Sov///NIZLkSVY1dL8w0AAt6imhVgRAB//+WoYJ9CTW+yRFSXt9tloROcaxegGM15yzHS51a1l++c+IrlHjOVf/8daIrRGRRNCccOJa21o6Q7gtZdSdW6ZOBvB6LymqUQimGIAACjAlGjv//Fu/6jgQRx/sxWSj2b//URSE/+OxL/nv//3Kj/+kMGbfzypopTc4a//NIZHMNwY9rP+w0AQAAAcABwAAAy2yXgJyJ6KKHp/rj06k3nNs56IB1EMewVrX/wcey4qNaa46YVF6FA6vYnghTueb4bYtm+kkPwL5///3YiiZJq+pEEfGS/8xFH//+V/7qC/7e41///cPDvXqBIv5SxZV1l1Z+pVxtwFHbknuN5ZjMFcCZe2JZ5IHwIIFk//NIZIAMaZFjPz2qnQAAA0gAAAAAoEvpQQcZo1jAqLMoj1UzehLi9qqT9Y2t/TDqh+UEBVANolyWZP//nRsX+sxAvSGz21TgcNSv//Jp7/WMIl/rLP//5U3+cHb5Ekp+i4ISn2/1aoCtkuZHWcO0LQM93sdHScC4jJC047ee2gCebbraJut1LvWvH4LWgzv0//NIZJcMrX1XL2HtHwAAA0gAAAAATonIUqj1FOismgiMlf/92MSQCxZD60AMIknb6iIdZf//VKyxX7yX/89///U3/L3gXAAADjgAf+3/////+ZMf/zNAjyJERR1cwtdz1hTF0rlz//fLlRD5q89T5b6l0AaQwytavcxlTc8G6e3zARDV/uTCABdO257TnOV1//NIZKwMMXtPP0WNHgQYAbx+AEQCZDAqDd+61PBfE16PtFw7b//5Ut/yR/9S3//92/41+CDuoEAx/4IcH4IBgSO/+UB+X//WD/uBwEPD//Lh9RbmWjWELN/E5ZZYxWM3DlHDCL3LVDJswYjIyHEXkRJABYAzERgTVJy8bqCRjeSgCLSMlokqyqkgKGUyTJfU//NIZLULAXs+fKwoAAegAfQBQRAAPxTWXak0sEIDmFAnCWDwLzpWqO7p4nZIEofOl8uF7KzO5eoqs+06blxjclDElyU+ipRxv1q0frUgiX0x7kuft9XSfv+p6/qLg9DRyQJQeeXrivO4Th9Yyv/udrfc3+c/R7P/yHrVJQA3pAKEx+2+skJiQADzPMTO0PGo//NIZLkRyYk4AMy0AAVAElQBgxAAUqH7V3JF0v7arTUWpM1FIWsayyLFOtiKljPzoX5aljHICKRiJiUOcADeamCkARQDUppmDZAXSjwVonGpwxCJLVDCu6YcAnbj20gaDa8iDckpIyEhkQj8zM8qHXWTR16h9RRRkgf+ZPzL9Hzrc4WOjOG3UXOo91HvT6z3//NIZJASbZFTL8w0AASwBggBgAAAUe6zjvt//lf1Wf0f+KL/+16P/9qp1CpERWCDPuQDBXlF9b74HYqkNXca2Pu9N/wanRG35v/igRJprJ/OUKwUpt3+cchKVDFX//HwFdm/T5QPzk/9kHo2/lv7f5L+f/uVcNmzs81tSdBWU3en6SiHYhU+Z14j5gGgrb9f//NIZGQJHPFPLueoAAAAA0gBwAAAxGEGF0VQs7G/RxkH2/9HYZAGDZV/+VBaP/76oHTf/zwwJv53+79f8r/Ec+osxyKmvVskC089IttOzaJgaWlL2dh8aNH3o0vysQpsktabN6kkhsqYrL16SCRuwb8OBA4p0/e+O3//WS//+Xj3/+///Pf1/0/01QRC2Gs///NIZJYIzO9jLzzKNQAAA0gAAAAAJARAUVrz3Z/OhKp1Qioaix9TFHnss9AB27i4b1s5gRREJrGOp3fWYJD+HlBj6t31HUSRBHUzJPoVb1k4LNJf+7M5WL//6jgfSj//mv/9ZxH//Qf//Mf4knAALbQP///////6On/6DRl1Jg1/5MyafQbMqhUDMchHGzDl//NIZMoJJS9XLjxwNQAAA0gAAAAAFUsZCBcJvyvC3zPDvPz3riwtWvxB73vaYiclA3m80obskxFG09QU1Cm2kaCofTXera6zYfwqVBFabrTWnWpIZxudk1ezqWtY5Sn//Uf//zh9//5x//8y//55AOpWwJXCgxLggGMkXB9+H9YPny/rBwEEf/If5D/y7//y//NIZPsLuWtBL2FtLgZYBbweAAQChz//T/VVFmOBE0a8b+WAq7EKGHrkDmWNcx7iGJC+ah+PqSSA0x4DNFAJCHSnEjiJcBvQNIDLYlFBLMnWb4g8PkFBCDBc57smprJrHCKDImJ8TMNc7uyvIoQAcBME6RM11+t7p1p2YjBZAywYoFKDNkoKUMvQ9Xqa/uoq//NIZP4MOYs4fKw0AAmYBhmXQBAAl8ukHIoKXMyJiyCo5T1epvf+1tb455E0TiBgUxzxzSeIIONIvgWAAABAjLABoFLtljmkMeFjH0lP8P/5yn/o///f///0Kg1J5yaaWjxVdPUiiY0ROr5ImpimsSnLEJsDIOBCQVFxEgpjphvyVg5p64gfqnxS3i2+MI4d//NIZPATPZE4AM1QAAgQHnmJggAAD/jQUXjFYloxFmJxxqiaMWBzUVVLjuf0iE+sgKllIbxqgWWINYh5CVkWSJDF+eyWW61LQLyaI1KkfMiqs6TRo/1lt5TJGoudWaJrKaTLk79RipZGlpmkv+W6zxrOB1tltR/pO/Lu+oz//+zd/8td//66dasUXslkbVB///NIZLASRZFIAMzIAAUYBowBgRAAM3e4+ZcVKS3r8W3jDMYqGxf/zRYg3FhVY90/rmkIIBzfcqFKB0lb7iCAbb//5wuFdv1IQWRt/jJV///Knf8ev63/8n5b08qGyrv//4K/4K//2S0S7p7+JQ2JTs9/iLrO/pnaIBFFlQMECGh+eZyamQFzLy6lJqSREZhS//NIZIQJ3SdnL+eoAQcoAbABwAAAT89+NrZ+AE6La1NV2vr3MBPWZ39IHglf2pidf//1Ed/1nA7Or9ROLX//+xNb/ji/51///8//yC/IkjUHQY5ZLxoOANSz83aUeQGOuJY3wrGOZal1wqGTyYtacHTyntevqG7/UJsW/rNRigpDVo1M3/zMvf1xxnv+W/////NIZJMKQX1G1kmNYgAAA0gAAAAAzrf8x/63///qP/6iH4M1TEFNRTMuOTkuNVVVVVVVVVUwIQWrsBhQm7q7Lscqa1cQf9KkyrJhBiGoOGFvYBkwV3KzKXbd15UKRra1hLC0b85yAAjv//5Ucb9lAok7P+RjZV//+VLf6CUn+r///yj/8k9aTEFNRaoksRfZ//NIZLwJ7XtRPzVtHgAAA0gAAAAA+QYA86cJnVItYspfNxdy3l+LkBaFZNA/ZSJkF+kpROKMkknc+kjO1nh6ATUxTNze1BYN0+yXuWiGBmNkkW//ekw8b/WoQIpI/uTzRX//62/5N/63///Ucf/UdfrAEAgoAoH//y//8Mf/l31z//////wxsVrttittttks//NIZNYKNXtC2mIKNAAAA0gAAAAAtlttgAFw3SgMuLXxyRNzgR1C75EG/Xn5QXyZaKqblEumiwTwFgaEB0EzREtAiAAZgBwB4VaXkDp9issBaA5ATcQCpixU+kfSPlMPZ04fMAWx/zem2gFkSJafJEOeZp89tqRRanlwvqHoZmI9hyFL6Pf0K3eYKm4XQkx2//NIZPoMCXtE3qe0AAVoBbx/QBAAj8MgrHMRhyjBjCE7++r92m/vXmZcIhGSUZrNFqNi4qgSzXBvh1tL/5X9tl/slB1f3fFTzf6jDHSyLRF/0/7VBqMVBCTEkAFRlRvmrCZIRSdg6+/8Z3/CTwArQmL3odOfSRCFJW//F42/+ccRBbFk5P/YhFZ9VN/yn/84//NIZP8UaZFjL8w0AQiAAgQBghAA4M9TWt/OI1Q7/6kn/9CccDX4e/vXyVP8qdz3b+Gun9Z4sHSXI8RHuoGvw6JXfqDvwWBo9I/iJ6g00rYBjiRmw7kolvrNigSy7h4yluruBYLB//5kPM2ZTf1LYTUUntq1Op1lYJ6brf/8eLf/zj//rRKJb//cq2//Pf/5//NIZLQJvU1OaueoAAkABdwBwAAAW3/9j38WuZBf//zXm///+uMyv///rBlnV9jG2ezb1itMQU1FMy45OUxG2EY4WdsCwq5YrShGqPFE5W1VmSWpRTUKTZn/niGJ+u26KaQhFfvRWZ0FwYP//KArf/+j//1Bg5Ov/EDv/9G//yr//5M3/+WqTEFNRTMuOTku//NIZL0JGWtU3jytNQZJITAEAESwNVVVVVVVVVVVVVVVVRyAKMYeIK2XabtrOwXmRgiEa3lzvM8MOfYmwOGnxztbpWIQDAyfa7F/VTASyhw0Hyiqo3KkxoATFDHf+4zBE7T363ZFGQp//IHDYPji1mal0zQWlVv+ijIv/9Jw4FtX//Hv8Q3qTEFNRUzZYW9M//NIZM4JQY1VLj2qRQAAA0gAAAAA67JADKtkTRo/joLAhFFTIGqC9RWoL109v6AyQ8EOgXoEyjn8y0gBNMNt1t91pgkG4jKf/81Ccsmih9e9R//9aAfTU+ihtv1IiYoa1LUv9RHdv/qGgpLf/8vIf/opFtcAYwwH8b//v///7aEN//7wGKzVCqAvDcWZDEJg//NIZOkMjWtAjmDqeAAAA0gAAAAAh2wtChDN0uNLlvWVirLrr1QKajsRg/ZmtepSkkTQaBOz6SSkvSSeXhoG5P/nWMTICmLXZKp/2JwilsyT+iz1HCEi3/mKI2Dqbt2tbWkOb/7ayl/+tEYzv//Lp38TREw9KAOJ8hDMvLurD5RxPD/k+IDnUcy5/5Q5/+IC//NIZPsMfY1ZLzVtlQSw4UAeAARcjuf//9bv8P/nJBWZjbz+AaQ5kxGsctiDAUHSF8GKGJImPT83NyABCkt0BaCTKhWI4UiHIA39NboE4tjwGoEA3AJISJ/UitGpZsaID+Gqz/Ymyom/FFMtOh1vUdJ91PEfmwasC445pWGO/nS2y0lp1M4wS2TRMlIiw6zc//NIZP8MxWsyFay0AAoIAd4PQBgA20FN/RoN1X84Sp8aY7CLm5amWpv+1fqam7IKaSpeKRdOThFDY6OeKovGn8wbzneUEK//5//zs5v//////////rv/RggUalGjW3rO7XXQHMoo0tIL17EbRdH2/3sGL8+DT9vMkAUR6qJIScuhwnnUp/99Y4QuhsanslVf//NIZOsTTZE+Zc1QAAbSWlgBgBABRUiXSzOkp6jISYhJJG+itFKkMYN+p1v9/qWsihwLSV//rGlE0R//1pJJGAvof//pnv9EkLthr///6lKV5S///////////6lKAgICAgICGBp4lBUGvy2RFSAaLKRRsC7ENGtDdQsOecAudQd2714gxK/4FgRvklYlG869//NIZLANcX1lL+e0AQfaIiwBwBAAZF8fHUX8wBKyL/9zEnnqNSaCZSQGRbzocWT2YMjpqTLhFwXiuifRSqf/pzQNJQdX/7MkKERJZv//aPgYaP/W36iySOrqcwE8opeo4fmCnFf8Yz/9vs4p1ev/9TOKGurr0BUk///UMITYOiykugZnd9HxMxNbGFuTeMQa//NIZKAOSY1VLz1wXYYoBaQACAAAz1g1/+BsENtrRYeMfCRcVEzKskOzfpBDf3Lpkp2Nz6RBycJ2lU7HQMkdNRYtTImU2DCJYtBBlqddBf5xhCBupM//94VM4Rn///Kh1V//9ys9/UmF6r/PrgyDIDIqlPsDUubjyLqRfeCSs9bUCYTEE+wH4laKQU0GliQo//NIZJANmY9RLjwtkQAAA0gAAAAAlhWJKX0n4EoADuvj95RSjSlsViZfOAFweKR7/UdES3qVNFP6k0IQQX82Q/9T1KUA3B6Dovf//lQ3I///WTW/rMQsT+sC1XGnaXrMrZZQDIs0NS1RMLh8TsqZplzEWz/iMHaaqGlEU4SzzDzXS72XX2cAlprpz1Z3cm57//NIZJ4NBXtNLjUNhwAAA0gAAAAAF2alvxWL57K2k0RgGWfevr72EoIjyv/9zSACIZG3//+MgtL//+MX/sgU7MyRGBgCwD///+l3/93////5j/80Z/oVdicjesqmtoAoYDpgY4dsxaqHVvjefve8f5yng1oPxGcsRHlMc1LGp5QJu9H167f+Vf/5Qu/qa7Jn//NIZLAMUX1bL0VqTwTwBYAeAEQCJ1ZADqW//OgAjin///QeF3//8dO/zxRtkvcp35QMKDHrd1vJ8H/4n/Lvn//Ur8Hz8/4ng///yBcPqisNgPFY6ddCNJaV1pXVNSPEjmt6sPs2GmUyCEeOeRMG6oWPEKWLkTKpPk+FLwWKikhEPQQatyP5FPrdTNiPDc1K//NIZLQKQX1fL6ecAQgIBfABQBAAKBPpKRNfUgVD6BoTpBh8iXhYgMqUUvr1v20y6ZEcRBNJEmCa84//ZzdBOm1fHMMhzg2xMhhVb/zvr7V9qa7TM4tNFRE1LSJkcgNCgBAABgAAAWD4+BDmA+r0fqp////9BYYQRUi5aS/NFHGwFcdUbdcwT9SyJe1pWuLb//NIZLwRSZE+AM1QAAaYApY5ghAAxu8DtX/IQOf7kQKxIG5E41LG+6GhRAdNUfzVNSQkrEg+BwiZt0O0UehmxP//QZCaa3/pEtf/6Df8XBej0lOShELJbf/WL3//oSP//QlI3AkmpSlL7eUv0MGAg////yWdiX5U7Pf/v8t/WCv//gqCquKmAqqy3QKAxSP1//NIZJIMuY9jL+eoAQgoclATwggAiJITAig7Wx5N+6226PRXz7wuArqC/5FCrDDx9Lh9SvnHOCs8pLpNY648yWIYJOUTj1szH0EzRYckbyZ//iCC83/WtbDxKf/9Zc/OCLIR5F8XDO2r/jSQ1//z//+o+RT4FAoAH/8W////////VZDZuy/NXZpADwun3dUX//NIZIYNVY9O3j2NKQNABfBmAEQCRsRUvG7aDzY6XI4HL3JBe///RGgLFpoTHn6Mf+N4c9lbbtj2NIA3AlXt8/u7s5AghSJX/+iLh5H/UtS4jlf/5J/lY1JlF1nkRZBnOX/qzIqFupf/5qr//NiRNloSZgKOot6COzqWmaDuSjBCrr/WtbtS/V/1MmS/Zp/r//NIZIkNNZFhL0FtXwAAA0gAAAAAX+VwXFshxJZoW7f/EJ8ZozdVGgqP31TykAAnXbpzFKAPDwd//wYOO/+iEw0//0/YFI1Whxihs3v/OBgm//x9//uSCQNESMkaDrscdTAMii1R3tXjYaPd6Kzvv73wxkOssMRas+pWxOFMvGVTL/oDSNqqv6k0DogZYdVV//NIZJoMgZFM3jzKsQAAA0gAAAAA9jyw2xakz/+wzH3/+6hdPP//K7eRBKy0wQTcyIpLHff9cQYwW3/6P//YnEH/////92tOn6WbBv9jv//39FaHU6IQBiiIAjjAEC7o6CsQHSB7Iamd6tvHL7+OGTfVLVcOgJ6fUpdSs6MMyNS1frURSxrf13Ygm7/Ukk5e//NIZLEMQY9TL0WNCwUwAagAAEYAhsmpr//kQpP/+xdP//5l9nEyVtcmmin/+tM8//8y//1Jmy0A4AWVjFwACEEMhDC3/E5/k/xAU/d/iM//RJl//ygY//TVlttstdrdstttFlkFoAahpPBQQTPqWxWiljKEkQxl+b+bLSstYxOlxowolowo9rrMDyaBkFGZ//NIZLULmY84eqw0AAhYBi29QRAAGLdR0+Sh03JUwMTwcxvdjM3WXzcTUeI7iRPDV1mWb3WnjmLCouoF4fP+tNZfTMzdONZeRQL04XDv2W3rvm++6jKovHFJUnJ3//3Tp6mQdWO82c2NjInGqK9AfEgiK7IyaxhHU85FdH8hJsq/MdP/1u/Lu9QQeQJrIxp0//NIZLER9YVrL800AYaQQlQBhRAACZKqf1+L20MXdfreqs09pPrGq8xDlJDmS/b/SJIKui74+kqYkqXZiXTU1Z9QkEVsv//UmIo283orQ31rUXgmQXsul4//+kkkkdFFFH//5EFtf//1Cyv//6RuSaOVBUqGsSvKhpP///2wVDXkSyw0WPA0e8Ff/ZVtBywa//NIZIIMXZFU3+e0AQagAfgBwBAAvySOUEgxNvfzWOkGU5+/d9FTM2tmv8E2gdw04YrNhlx8fwYgRTdV1LHnLd6es6QjgrzKkr/6p04ChDsX0FVa6vqe4/BDuz//6k2DVqT//4shX/+r9Qjix01f/8pE01AH9Ryf//////+oWFcVY//pVhu1Hr8ds2AQbEkp//NIZH8MMY9ZLzFtawRggUwkCAQYjiD5BnNPlwNKJ0Dubcn5bCeHiWSJrmlna6L9YnP+m6dBSbm6Ckgsk2//+YiIZfpf/UTwc036//vJgcKL//7VjGFN//R9SkQ2hITyT//XWSxidRltPs8u02ADBPFwg6ni/S1ta2ZuPn+Qgw/sXcaLk6raPOBf/qdT9qqW//NIZIcLnY9fLyzNNwAAA0gAAAAATRkN//7xUBaUnbW7KR+pSbB3HoYpGv//Ng0F1JanX//oCKf/2/NhBiAkyX/9Z0li69UtFSw2SxyOwDaxNhn1aDNKUnPiudQwOfH5wY8qYrQYzXt+pAaw2i+pFv1vqWpJjgO1lIv//sNQpur//47RWZv/+pxZFq2//+cE//NIZKULZZFfLzUNOwAAA0gAAAAAV/61fsPw26v/6iaeUKAP////8iRIqpJ4PgtIjNqmwpZVfkiJc5Kbdqx9/Vv8P3+tqWiS4BLLM0jBSC07XvbUiHNTvrTto7LTzhHf//02hzlrq12r6l1OYjxe/+/uqVFq2//3WgTBbf//Vc9/xL/8oc+D4f6P/+IATD////NIZMQKtY9TLzxtNwIgASQYAARy9QIAgoEAxlwfD/BAMf/ggGP/y74eIWWcgwIfEUBhWWwwIEAzUoxEEv2GXz7jOEgi4rQkCLjkg1mbuRVpBC4XBZZYI4gwdXnHHGmXC4eDai8YmIu3V5cLjJl83DnmySJREJH+uggX0jRMn7KFeJG36+aM/N5ikMDlAhn3//NIZOAK7Wk2Fay0AAhYAdgBQBAA/6DMyEzef3LqKTKNSsml//stNTJppmiDJvnllgrppIplVFFSZbwcQo0o03FzlLyIIUtplgBDGKstJEBAEaUTlvNWEISYxfVa91//rHy9qjI37G1ZvUKhALjls1PmCkNHf85DhsAGNXO/+UAiRb/6IDG/9MCZq//yX9P9//NIZOIRkZE+AM1MAAOgZjgBhRAAn89/cUWCsj8qGix5TyrsGg7/7Kw1/KuEv+e/yvErpXiUNf5UFfX8sDWIJzhjv1QDCcFxZtRqWSoWane4Q0pE48HhxNt/7C1Hiy0UE6PrYmiRW7dfrkuDZKTnUKur4yv/6yYIn/17DtL//+a//8//Ifzv9yvAACMoBAhI//NIZMIJcQ1RL+ecAAkYAfABwAAA8Of/+oc/+2G//b/ahUxBTUUzLjk5LjVVVVVVVVVVVYzpcpNPJE1QTohmWbsfpokKaLG4ab7trlQl4mL93e9XFwOWTkWQupXnZgKTTzq+cLxHCuCTJdv65iHA3/6x8HT/+sWB///Nv/86r//We/nv1PLqTEFNRTMuOTku//NIZM0JWS1LLjxtNATwDS2QEIQANaqqqqqqqqqqqqqqqqqqqkjJKoq9LAlAUN5RYbu6SWqOBFu03cj0Mh6DIAC54v85/1YNDWQp41hZ6P/LiACT8vuPbKr3kCIEG+WUqGy2vRE2BjLhy17tSWimLIgm3/VUsS4s//2//1nv/863/+Y/54rVBDVgj63sCMBW//NIZNcKTU1bL2DNNQAAA0gAAAAAi5Z7R6vMOU4Bw21dPKo0VXLP6AnpnPv2Q9bbYNI4FV+c2d/6QuDdZRtZNF0TjolICoMsd5icOy9JtE+mecEiPv/S1sLJG3/0hZnv/83//5Rb/+dX//nP5KwDoxs2NUHykaQde0x8dFTbH/Wn/9g1j/3/0v/345AskV/8//NIZOYMJW1TL2FtTwAAA0gAAAAAdGoIVtnLz75xgB5bN1mfQz1Po+O/k1f0zS+4nT2/2dBqvrHiswYvrdBuvGohOyF1My3qSLwVI+g62vbegRQ8oKfUu11JKGYtsu2vWuw9T/5J/2CF35n+S/nXLaZGBZGnHxPqQJI57MbzHA/9QgAABEP97+rVy+U5yoZ///NIZP8MQWtBL2GNLgjoAcW0AEQA1ef/0ej7qup3L/VVHgk2hPec8IYBBozuXgoGMlDVHOeuuLorM6SWsQUEoClCoKGBqU8DKhwurJNYUvA1AGqHy+bni+bzUvF8NqS9ZPpy4ggQ40mCh+/kHMicEEyfNzoggUiFBQMbMa/8vm6DeXxZxkcZrjaKH/71GBUI//NIZPQK8O1FL6e0AAsonh5fQRAAOXzcuGjJ6ZkMeKYXkpxIo///TsmmmbnDQnF5Fjk0WgZjvpB7ZUNikQhV8AOSp9s+c4cf////////lCDz7//6w2qkdg1nJxxUAA2EqNkV6TmQmZq2ykkVsj1DuCmNkjIkWExMVsg6O3q8ofLpqpJJReMUjKPbOE38LePZ//NIZOoS1ZFAAM1QAAYwJlgBghAA7ffQF5Fl60V3b11mImo5Gr/9StELaXCxH//7EUoM3//rOv/ojkR8l/yoKnf/FgaPf/9YKgr/////EoKgssFQVcWPV+IvFuIqsHJEaoaaQcBovIKgiae6lAWK5/8dxx62ziWZCgeVfsk2zQbnjbeuQw7J1LGoJOhPv9A6//NIZLUMNX1c3+a0AQf4AfABwRAAXTMcp08XdQ3P1LEBLM1SqqOrOh0BaWf//3H0UNX/+cCiOFn//7CxG1v//onSO1G2iTgWs5X6ikuVlWFezqWWUEbIy8iwanJJx+AF93sa+9SfGsF5FSIiGC1jhGUUSamSbMhqQU1RPAbyaZ7qYzOmCzqiWm1jpz8TQ1e///NIZK4NYY9K3jwtkQAAA0gAAAAA+Tg9u337LSfdy4BEoKV//UoDDGYo1//+kGkRKC/+h/PEf/OiBX+s2MYtBRAVmlS3ChuqLCX1LMtci6bb6wHsFateuP7cQUxq/Cj3AUjC1RLJ9bILdvoi0b2zIiF9A0STJEuaxtv1BbiP/1qMxOrL5dT0l6dM8XwYAnJs//NIZL4NeY9bL2FtCwAAA0gAAAAAot/9uoJoVP//+mLoyW///OH/+OX6alEXaHrM7XFACJkvlSP7z05g6rnF3RkXJN/kRRq1kwqzqI7kTZS30y3vtKpcRALsu7/iWqo1B+TlRwvu11LB7HkyjUyffYQUOZU32+o+vEGEWtm//ugMGSR///9Y+kb//+p/+UvU//NIZM0M6X1LLmHtHwAAA0gAAAAAAMPgB///////o//9Jk09TTD//zMEthbPCaWgAKJw/NUzI0TTCbOcVdq1o9awrSU4lNAosRzTSrmPZ0s9VOArHsqXMnTp5jIdoTfiJbb+aVClZPS7OjZ9TgrAePt/+hh4FowHf//4kjX//9BkTOrUohGGhYm6V/5CN1kA//NIZOAMnXtVLz1tTwUAAaweAAQCwM+IAQct5R3h7///7OH//W8EHfL//5qIOtVEiXmFHkQMDlkRrkRUEMeDMmFape6yZXC6bJstg9AXAOwdoxw8LSdRJDkRJSXiIZ+snlMnlMlAhSVUmJ4/wq5JDkLw4B4B4PGRiTg565l7rc8o0NyQPmKIk5BR/7lw3MED//NIZOIMOX1C36aoAAegUfQBQhAAhpL6Kh9NS4zj4TPV/L5uX0jQpnEEmsbIsdH9mSlZfb//5PL7l9I0N7IN0CebrsgnSXM9lUTScYUWd1CTwof+ZPf///////FVjfuz0++tjdAA6FLE8uiTIZyWx8j5FwmNM2Teaok7HJtUhZkPlQlIlJImt2V1JE4zEmAc//NIZNwScZFCAM00AAVAHpQBghAAJRRQd/y6ajSDkEqRRrd+rWiJQr/+RSN//jWa//2OHvxN/Df9396zCEK/ifkIThCEPS2Zqp5bHQoCeBX/+W////8SjwVcsVmyr991
)
LevelUpData=%LevelUpData%
(
 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
)

tileset=AtHome,Intro,LevelUp

loop, parse, tileset, "`,"
{
 if !fileexist(a_scriptdir . "\" . a_loopfield . ".mp3")
 extract_tile(%a_loopfield%Data, a_scriptdir . "\" . a_loopfield . ".mp3")
 %a_loopfield%Data:=""
}

return

extract_tile(var,filename)
{
nBytes := Base64Dec(var, Bin )
File := FileOpen(filename, "w")
File.RawWrite(Bin, nBytes)
File.Close()
}

Base64Dec( ByRef B64, ByRef Bin ) {  ; By SKAN / 18-Aug-2017
Local Rqd := 0, BLen := StrLen(B64)                 ; CRYPT_STRING_BASE64 := 0x1
  DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
         , "UInt",0, "UIntP",Rqd, "Int",0, "Int",0 )
  VarSetCapacity( Bin, 128 ), VarSetCapacity( Bin, 0 ),  VarSetCapacity( Bin, Rqd, 0 )
  DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
         , "Ptr",&Bin, "UIntP",Rqd, "Int",0, "Int",0 )
Return Rqd
}

