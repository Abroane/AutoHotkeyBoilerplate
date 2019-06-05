; ======================================================================================================================
; Name:           AHKBAN 
; Description:    a Boxxle (Sokoban) clone 
; Topic:          https://autohotkey.com/boards/viewtopic.php?f=19&t=49383
; Sript version:  1.6
; AHK Version:    1.1.24.03 (A32/U32/U64)
; Tested on:      Win 7 (x64)
; Author::        SpeedMaster
; Tileset:        from Project 2D by TheDewd 

; How to play:    The goal of the game is to push all of the barrels onto the goals. 
;                 The player can only push one barrel at a time and is not able to pull them. 
;                 A level is solved when each barrel is on a goal.
; ======================================================================================================================

#SingleInstance force
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

gosub, boxxlelevels
gosub, extract_tiles

tooltip, Loading Game... Please wait

BoardCols:=30
BoardROWS:=22

MOVES:=0
PUSH:=0

record:=[]
forward:=[]

MAP_WIDTH:=BoardCols
MAP_HEIGHT:=BoardROWS

TILE_TYPE:=[]
TILE_TYPE[0]:= [ ""                          , true  , false, "empty"       ] 
TILE_TYPE[1]:= [ "boxxeltiles\01.png"        , true  , false, "Rock_floor"  ] 
TILE_TYPE[2]:= [ "boxxeltiles\02.png"        , false , false, "Wall"        ] 
TILE_TYPE[3]:= [ "boxxeltiles\goal.png"      , true  , false, "Goal"        ] 
TILE_TYPE[4]:= [ "boxxeltiles\03.png"        , true  , false, "stair"       ]
TILE_TYPE[6]:= [ "boxxeltiles\06.png"        , true  , false, "player_up"   ]
TILE_TYPE[7]:= [ "boxxeltiles\07.png"        , true  , false, "player_down" ]
TILE_TYPE[8]:= [ "boxxeltiles\08.png"        , true  , false, "player_left" ]
TILE_TYPE[9]:= [ "boxxeltiles\09.png"        , true  , false, "player_right"]
TILE_TYPE[12]:=[ "boxxeltiles\barrel.png"    , false , true , "barrel"      ] 
TILE_TYPE[13]:=[ "boxxeltiles\barrel_red.png", false , true , "red barrel"  ] 
TILE_TYPE[14]:=[ "boxxeltiles\14.png"        , true  , false , "blue_floor" ]

emptytile:=0
rock_floor:=1
wall:=2
goal:=3
stair:=4
closed_door:=5
open_door:=6
barrel:=12
redbarrel:=13
currentlevel:=1
playerpicup:=TILE_TYPE[6].1
playerpicdown:=TILE_TYPE[7].1
playerpicleft:=TILE_TYPE[8].1
playerpicright:=TILE_TYPE[9].1



lvselect:=new layergrid(ctr:="radio",clln:="5_",cmj:="true", gpx:=10, gpy:=10, cols:=10, rows:=11, wsp:="50", hsp:="20", opt:="gselectlv", fill:="aindex", "Mselect")

Layer_background :=new layergrid(ctr:="pic",clln:="1_",cmj:="true", gpx:=10, gpy:=10, cols:=BoardCOLS, rows:=BoardROWS, wsp:="32", hsp:="32", opt:="gclickcell BackGroundTrans disabled", fill:=TILE_TYPE[14].1, "1")
Layer_items      :=new layergrid(ctr:="pic",clln:="2_",cmj:="true", gpx:=10, gpy:=10, cols:=BoardCOLS, rows:=BoardROWS, wsp:="32", hsp:="32", opt:="gclickcell BackGroundTrans disabled", fill:=TILE_TYPE[0].1, "1")
Layer_characters :=new layergrid(ctr:="pic",clln:="3_",cmj:="true", gpx:=10, gpy:=10, cols:=BoardCOLS, rows:=BoardROWS, wsp:="32", hsp:="32", opt:="gclickcell BackGroundTrans disabled", fill:=TILE_TYPE[0].1, "1")
Layer_debug :=new layergrid(ctr:="text",clln:="4_",cmj:="true", gpx:=10, gpy:=10, cols:=BoardCOLS, rows:=BoardROWS, wsp:="32", hsp:="32", opt:=" w32 h32 0x201 -border BackGroundTrans ", fill:=" ", "1")


gui, font, s26 bold, consolas
gui, add, picture, x310 y200 vtitle backgroundtrans, boxxeltiles\Project_2D.png
gui, add, picture, xp+30  y+10 vstart backgroundtrans, boxxeltiles\PRESS_ENTER_TO_START.png
gui, add, picture, xp+60  yp vcongratulation hidden backgroundtrans, boxxeltiles\congratulation.png

gui, font, s12 italic, consolas
gui, add, text, x825 y685 cred backgroundtrans, by SpeedMaster

gui, font
gui, font, s14 bold, consolas


Gui, Add, text, x20 y25 w400 h50 hidden vcLV backgroundtrans cwhite,  % "Level:" currentlevel

gui, add, button, x20 yp+30 w30 h30 hidden vlevel_down10 glevel_down10, <<
gui, add, button, x+2 yp w30 h30 hidden vlevel_down glevel_down, <
gui, add, button, x+2 yp w30 h30 hidden vnextlevel gnextlevel, >
gui, add, button, x+2 yp w30 h30 hidden vlevel_up10 glevel_up10, >>


Gui, Add, text, x20 yp+45 w400 h50 hidden backgroundtrans vundo cwhite, Undo / Redo

gui, add, button, x20 yp+30 w30 h30 hidden vgoback10 ggoback10, <<
gui, add, button, x+2 yp w30 h30 hidden vgoback ggoback, <
gui, add, button, x+2 yp w30 h30 hidden vgoforth ggoforth, >
gui, add, button, x+2 yp w30 h30 hidden vgoforth10 ggoforth10, >>

gui 1: add, button, x+2 yp w30 h30 hidden vf_1_1 , focus


gui, add, text, x20 y+30 w124 h30 cyellow hidden vmoves -border backgroundtrans , % "Moves:" 0
gui, add, text, xp yp+30 w124 h30 cyellow hidden vpush -border backgroundtrans , % "Pushes:" 0


tooltip,

;---------------------------------------CHECK IF INI EXIST IF NOT CREATE IT--------------------------------------------------------

iniFile := SubStr( A_ScriptName, 1, -3 ) . "ini"
Ini_File=%A_WorkingDir%\%iniFile%      
ifnotexist,%Ini_File%
 {
  iniContent =
  (
  [Game]
  lastplayed=1
  )

  replaceFile(iniFile, iniContent)
 }

; call replace file function
replaceFile(File, Content)
{
	FileDelete, %File%
	FileAppend, %Content%, %File%
}

;------------------------------------Read the ini file and store its content to variables----------------------------------------------
;Read ini file 
IniRead, currentlevel, % iniFile, game, lastplayed

if !(currentlevel) || (currentlevel>108)
  currentlevel:=1

;----------------------------------------------------------------------------------------


	Gui, Mselect: +LastFound -Resize ;+OwnDialogs
	Gui, Mselect: Margin, 10, 10
	Gui, Mselect: Show, Hide AutoSize, Level Select


Menu, GameMenu, Add, &Retry`tR, Retry
Menu, GameMenu, Add, &Level Select`tF2, selectlevel
Menu, GameMenu, Add, &Exit`tESC, exit

Menu, HelpMenu, Add, &How to play, howtoplay
Menu, HelpMenu, Add, &Shortcuts, help
Menu, HelpMenu, Add, &About, about

Menu, MyMenuBar, Add, &Game, :GameMenu

; Create the menu bar by attaching the sub-menus to it:
Menu, MyMenuBar, Add, &Help, :HelpMenu

; Attach the menu bar to the window:
Gui 1: Menu, MyMenuBar

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Gui, show, AutoSize, AHKBAN v1.6 - by Speedmaster
return

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

retry:
retry()
return

selectlv:
gotolv:=( agmove(a_guicontrol, "EY")*10 ) - ( 10 - agmove(a_guicontrol, "EX"))
currentlevel:=gotolv
Gui, submit
Gui 1:Default
solved:=0
if !(play){
  hidecell("title")
  hidecell("start")
  showcell("cLV")
  showcell("moves")
  showcell("push")
  showcell("goback")
  showcell("goback10")
  showcell("goforth")
  showcell("goforth10")
  showcell("nextlevel")
  showcell("level_up10")
  showcell("level_down")
  showcell("level_down10")
  showcell("undo")

}
levelclear()
loadlevelb(currentlevel)
drawchar("cLV","Level:" currentlevel)
Gui, 1: Show,, AHKBAN v1.5 - Level %CurrentLevel%
return

about:
vabout=
(
AHKBAN v1.5

by SpeedMaster
)

msgbox, % vabout
return

selectlevel:
Gui, Mselect: Show
GuiControl, Mselect: , % "5_" (currentlevel - ((currentlevel//10)*10)) "_" (currentlevel//10)+1 , 1
guicontrol, Mselect: hide1, 5_9_11
guicontrol, Mselect: hide1, 5_10_11
return

howtoplay:
msgbox, How to play:`n`nThe goal of the game is to push all of the barrels onto the goals.`nThe player can only push one barrel at a time and is not able to pull them.`nA level is solved when each barrel is on a goal.

~enter::
start:
if !(play)
{
  hidecell("title")
  hidecell("start")

  showcell("cLV")
  showcell("moves")
  showcell("push")

  showcell("goback")
  showcell("goback10")
  showcell("goforth")
  showcell("goforth10")

  showcell("nextlevel")
  showcell("level_up10")
  showcell("level_down")
  showcell("level_down10")

  showcell("undo")

  loadlevelb(currentlevel)
  drawpic(player, playerpicdown)
  drawchar("cLV","Level:" currentlevel)
  
  play:=1

}
  Gui, 1: Show,, AHKBAN v1.5 - Level %CurrentLevel%
return


z::
w::
up::
player:=AGMove(player,"y",-1)
dirprev:=dir
dir=up
deltax:=0
deltay:=-1
gosub, check_if_passable

return

s::
down::
player:=AGMove(player,"y",1)
dirprev:=dir
dir=down
deltax:=0
deltay:=1
gosub, check_if_passable
return

a::
q::
left::
player:=AGMove(player,"x",-1)
dirprev:=dir
dir=left
deltax:=-1
deltay:=0
gosub, check_if_passable

return

d::
right::
player:=AGMove(player,"x",1)
dirprev:=dir
dir=right
deltax:=1
deltay:=0
gosub, check_if_passable
return


pgup::
nextlevel:
if (currentlevel>107)
return

level_up:
currentlevel++
drawchar("cLV","Level:" currentlevel)
solved:=0
levelclear()
loadlevelb(currentlevel)

if (currentlevel>108)
showcell("congratulation")

Gui, 1: Show,, AHKBAN v1.5 - Level %CurrentLevel%
return

^pgup::
level_up10:
if (currentlevel=108) || (currentlevel=109)
return

currentlevel +=10
if (currentlevel>108) 
currentlevel:=108
drawchar("cLV","Level:" currentlevel)
levelclear()
loadlevelb(currentlevel)

Gui, 1: Show,, AHKBAN v1.5 - Level %CurrentLevel%
return


pgdn::
level_down:
if (currentlevel<=109)
hidecell("congratulation")

if (currentlevel=1)
return 
currentlevel--
drawchar("cLV","Level:" currentlevel)
levelclear()
loadlevelb(currentlevel)
Gui, 1: Show,, AHKBAN v1.5 - Level %CurrentLevel%
return

^pgdn::
level_down10:

if (currentlevel<=109)
hidecell("congratulation")

currentlevel -=10

if (currentlevel<1)
currentlevel:=1

drawchar("cLV","Level:" currentlevel)
levelclear()
loadlevelb(currentlevel)
Gui, 1: Show,, AHKBAN v1.5 - Level %CurrentLevel%
return

help:
  msgbox,  Shortcuts: `n`n Backspace = Rewind`n Right Control = Forward `n R = Retry `n==============`n PgUp = Next Level `n PgDn = Previous Level `n Ctr PgUp = Next level +10 `n Ctr PgDn = Previous Level -10  `n==============`n F2 = Select Level `n F3 = Debug layer1 `n F4 = Debug layer2
return


clickcell:
msgbox, % a_guicontrol
return

exit:
guiclose:
esc:: 
IniWrite, % currentlevel, % iniFile, game, lastplayed
exitapp 
return

check_if_passable:

forward:=[]

if ispassable(nx, ny)  ; nx= new pos x  ; ny= new pos y 
{

  if !(solved)
  record.push(player ":" dir ":" previous ":" dirprev)

  if (mvo) {
    push++
    record[record.length()] .= ":" free ":" obstacle
    drawchar("push", "Pushes:" push)
    mvo:="" 
  }



  ;// Draw the player to the new position
  drawpic(player, playerpic%dir%)

  ;clear previous position of player
  clear_previous_playerpos()
 

  ; report wat there is at current player position
  lookdata() 

  if checkwin() 
     drawchar( "moves"  , "Moves:" . record.length())

  ongoal()


  if !checkwin() {
     for i, r in datagrid1
       for j, c in r {
          datagrid2[i][j]:=0
          solved:=1
        }
      Drawtile(exitlevel, stair)
  }

; if player go to stair
  if (Datagrid1[nX][ny]=stair) {
     gosub, level_up
   }
}
else {
  ;// Don't move the player >> restore previous player postition
  player:=previous
  if !(dir=dirprev)
    drawpic(player, playerpic%dir%)
}
return


IsPassable(npX, npy)   ; npx =new pos x , npy =new pos y
{
global
    ;// Store the value of the tile specified 
    tilevalue1:= Datagrid1[npX][npy]        ;npx = new pos x   npy = new pos y
    tilevalue2:= Datagrid2[npX][npy]

    ;// Before we do anything, make sure that the coordinates are valid
    if % (npX < 1 || npX > MAP_WIDTH || npy < 1 || npy > MAP_HEIGHT)
        return false

    ;if there is an obstacle that player can move 
    if ismovable(npX, npy)
    {
    MoveObstacle()
    return true
    }
    ;// Return true if it's passable
     if Tile_type[TileValue1].2 ;check if there is an obstacle at grid 1 (layer1) background
     if Tile_type[TileValue2].2 ;check if there is an obstacle at grid 2 (layer2) items
        return true

     ;// If execution get's here, it's not passable
        return False
}


IsMovable(npX, npy)   ; npx =new pos x , npy =new pos y
{
 global
  tilevalue2:= Datagrid2[npX][npy]
  tilevalue1:= Datagrid1[npX][npy]
  ;// check if there is a movable item a current location
   if Tile_type[TileValue2].3 
    {
      ;// if true check if there is an obstacle at next postition
      next1:= Datagrid1[npx+deltax][npy+deltay] 
      next2:= Datagrid2[npx+deltax][npy+deltay]
      if Tile_type[next1].2
      if Tile_type[next2].2
        return true
        else 
        return false
    }
}


moveobstacle()
{
 global 
 obstacle:="2_" . nx . "_" . ny
 free:="2_" . (nx+deltax) . "_" . (ny+deltay)
 drawtile(free, barrel)
 drawtile(obstacle, emptytile)
 mvo:=1
}

lookdata()  ; report wat there is at current player position in data grids 
{
 global
 savedprevious:=previous
 currenttilevalue:= Datagrid2[nX][nY]  
 previous:=savedprevious  
}

Drawtile(cellname, value)
{
 global
 stringsplit, drp, cellname, _
 Datagrid%drp1%[drp2][drp3]:=value
 GuiControl, , %cellname%, % TILE_TYPE[value].1
}

clear_previous_playerpos(){
global
  for i, r in datagrid2
    for j, c in r {
if (("3_" i "_" j) != player)
      drawpic("3_" i "_" j, "")
}
}



;--------------------------------------------------------------------------------

~r::
retry()

retry(){
 global 
 solved:=push:=0
 record:=[]
 forward:=[]
 drawchar("push","Pushes:" push)
 drawchar("moves","Moves:" moves)

 drawpic(player, empty)
 for i, r in datagrid1
   for j, c in r {
         datagrid2[i][j]:=0
         drawpic("2_" i "_" j, empty)

    }

 player:=startpos
 DrawDataMap(maplayer2,2,"drawtile")
 drawpic(player, playerpicdown)
 dir:="down"
 solved:=0
 Drawtile(exitlevel, rock_floor)


 if (currentlevel>108) {
    hidecell("congratulation")
    currentlevel:=108
    loadlevelb(108)
    drawchar("cLV","Level:" currentlevel)
  }
}

return


bs::
goback:
if (solved)
return
back:=record.pop()
if !(back)
return

forward.push(back)

bk:=strsplit(back, ":")
previous:=bk.1
player:=bk.3
clear_previous_playerpos()
dir:=bk.4
drawpic(player, playerpic%dir%)


if (bk.5) {
  push--
  drawchar( "push"  , "Pushes:" . push)

  drawpic(bk.5, empty)
  bpx:=strsplit(bk.5, "_").2
  bpy:=strsplit(bk.5, "_").3
  Datagrid2[bpx][bpy]:=0
  bpx:=[]
  bpy:=[]

  drawpic(bk.6, TILE_TYPE[barrel].1) ;draw barrel at is previous position
  bpx:=strsplit(bk.6, "_").2
  bpy:=strsplit(bk.6, "_").3
  Datagrid2[bpx][bpy]:=barrel
  bpx:=[]
  bpy:=[]
}

ongoal() ; draw a red barrel if barrel is on target

drawchar( "moves"  , "Moves:" . record.length())
GuiControl, Focus, f_1_1

return

goback10:
loop, 10 {
gosub, goback
sleep, 10
GuiControl, Focus, f_1_1

}
return

~RCtrl::
goforth:
forth:=forward.pop()
if !(forth)
return
record.push(forth)

ft:=strsplit(forth, ":")
previous:=ft.3
player:=ft.1
clear_previous_playerpos()
dir:=ft.2
drawpic(player, playerpic%dir%)

if (ft.5) {
  push++
  drawchar( "push"  , "Pushes:" . push)

  drawpic(ft.6, empty)
  bpx:=strsplit(ft.6, "_").2
  bpy:=strsplit(ft.6, "_").3
  Datagrid2[bpx][bpy]:=0
  bpx:=[]
  bpy:=[]

  drawpic(ft.5, TILE_TYPE[barrel].1) ;draw barrel at is previous position
  bpx:=strsplit(ft.5, "_").2
  bpy:=strsplit(ft.5, "_").3
  Datagrid2[bpx][bpy]:=barrel
  bpx:=[]
  bpy:=[]
}

ongoal() ; draw a red barrel if barrel is on target

drawchar( "moves"  , "Moves:" . record.length())

GuiControl, Focus, f_1_1
return

goforth10:
loop, 10 {
gosub, goforth
sleep, 10
}
GuiControl, Focus, f_1_1
return

f3::
debuglayer1:=!debuglayer1

if (debuglayer1) {
  
 for i, r in datagrid1
  for j, c in r {
         drawpic("1_" i "_" j, TILE_TYPE.14.1)
         drawchar("4_" i "_" j, c, "red")
    } 
}
else
  for i, r in datagrid1
    for j, c in r {
      drawtile("1_" i "_" j, c)
      drawchar("4_" i "_" j, " ")
    }


return

f4::
debuglayer2:=!debuglayer2

if (debuglayer2) {
  
 for i, r in datagrid2
  for j, c in r {
         drawpic("2_" i "_" j, empty)
         drawchar("4_" i "_" j, c, "fuchsia")
    } 
}
else
  for i, r in datagrid2
    for j, c in r {
      drawtile("2_" i "_" j, c)
      drawchar("4_" i "_" j, " ")
    }
return



return
;-------------------------------------------------------------------------


class layergrid
{
	__New(ctr:="pic", clln:="", cmj:="true", gpx:=10, gpy:=10, cols=30, rows:=20, wsp:="32", hsp:="32", opt:="BackGroundTrans  -disabled", fill:=".\boxxeltiles\14.png", guiname:="1" )
  {
  global
    this.guiname:=guiname, this.clln:=clln, this.cmj:=cmj, this.gpx:=gpx, this.cols:=cols, this.rows:=rows, this.wsp:=wsp, this.opt:=opt, this.fill:=fill
    
    r:=0,  c:=0, ai:=0
     While r++ < rows {
      ++ai
        while c++ < cols{

             gui  %guiname%: add, % ctr, % opt " v" ((cmj) ? clln c "_" r : clln r "_" c) " Hwnd" clln  r "_" c ((c=1 && r=1) ? " x"gpx " y"gpy " section"
                  : (c!=1 && r=1) ? " xp+"wsp " yp" : (c=1 && r!=1) ? " xs" " yp+"hsp : " xp+"wsp " yp"), % (fill="aindex") ? ai : fill 
             ai++
          } c:=0
             ai--
     } r:=c:=ai:=0,      
  }
}

ObjFullyClone(obj)
{
	nobj := obj.Clone()
	for k,v in nobj
		if IsObject(v)
			nobj[k] := A_ThisFunc.(v)
	return nobj
}

loadlevelb(number) {
 global

 map:=[]

 loop, parse, level_%number%, !
 map.push(strsplit(a_loopfield ))
 mpc:= map.1.length()
 mpr:= map.length()
  exitlevel:=""
  maplayer1:=[]
  maplayer2:=[]
  record:=[]
  forward:=[]
  push:=0

  for i, r in map
    for j, c in r {

     if (c="@")
      player:="3_" (cols-mpc)//2+j "_" (rows-mpr)//2+i
     if (c="e")
      exitlevel:="1_" (cols-mpc)//2+j "_" (rows-mpr)//2+i    
          
     if !(c="#") &&  !(c=".") &&  !(c="*")    
      maplayer1[(cols-mpc)//2+j,(rows-mpr)//2+i]:=1
     if (c="#")    
      maplayer1[(cols-mpc)//2+j,(rows-mpr)//2+i]:=2 
     if (c="X")    
      maplayer1[(cols-mpc)//2+j,(rows-mpr)//2+i]:=14
     if (c=".") ||  (c="*")  
      maplayer1[(cols-mpc)//2+j,(rows-mpr)//2+i]:=goal
     if !(c="$") &&  !(c="*")  
      maplayer2[(cols-mpc)//2+j,(rows-mpr)//2+i]:=0
     if (c="$")    
      maplayer2[(cols-mpc)//2+j,(rows-mpr)//2+i]:=barrel
     if (c="*")    
      maplayer2[(cols-mpc)//2+j,(rows-mpr)//2+i]:=13
    } 
  startpos:=player 
  datagrid1:=maplayer1
  datagrid2:=ObjFullyClone(maplayer2)
  DrawDataMap(datagrid1,1,"drawtile")
  DrawDataMap(datagrid2,2,"drawtile")
  drawpic(player, playerpicdown)
  dir:="down"

  if !(exitlevel)
   exitlevel:=agmove(player, "z", -2)

  drawchar("moves", "Moves:" . record.length())
  drawchar("push",  "Pushes:" . record.length())
}


levelclear(){
global    
drawpic(player, empty)
for i, r in datagrid1
  for j, c in r {
        drawpic("1_" i "_" j, TILE_TYPE.14.1)
        drawpic("2_" i "_" j, empty)
    }
}


DrawDataMap(datagrid, gridnumber:=1, function_name:="", Bypass_Values_List:="")
{

global
  For i, r In datagrid
   For j, c In r
    {
     cell_to_draw=%gridnumber%_%i%_%j%
     %function_name%(cell_to_draw, c)
    }
}

HideCell(cell_to_hide)
{
guicontrol, hide1, %cell_to_hide%
}

ShowCell(cell_to_show)
{
guicontrol, hide0, %cell_to_show%
}

disablecell(cell)
{
global
guicontrol, disable, %cell%
GuiControl, MoveDraw, % cell
}

DrawPic(cellname, object)
{
global
GuiControl, , %cellname%, %object%
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


AGMove(Varname,axes,value1:=1,value2:=1,value3:=1)
{
global
AGM(varname,value1,value2,value3)
StringSplit, ar, varname , _
if axes = z
  {
  nz:=value1+ar1
  ny:=ar3
  nx:=ar2
  }
if axes = x
  {
  nz:=ar1
  nx:=value1+ar2
  ny:=ar3
  }
if axes = y
  {
  nz:=ar1
  nx:=ar2
  ny:=value1+ar3
  }
if axes = xy
  {
  nz:=ar1
  nx:=value1+ar2
  ny:=value2+ar3
  }
if axes = zxy
  {
  nz:=value1+ar1
  nx:=value2+ar2
  ny:=value3+ar3
  }
if axes = EZ
return ar1
if axes = EX
return ar2
if axes = EY
return ar3
if axes = SX
{
nz:=ar1
nx:=value1
ny:=ar3
return % nz . "_" . nX . "_" . nY
}
if axes = SY
{
nz:=ar1
nx:=ar2
ny:=value1
return % nz . "_" . nX . "_" . nY
}

if axes = SZ
{
nz:=value1
nx:=ar2
ny:=ar3
return % nz . "_" . nX . "_" . nY
}

return % nz . "_" . nX . "_" . nY

}

;AGM is ASCII GAMING MAIN FUNCTION
AGM(varname,NewZ:="1",NewX:="0", NewY:="0")
{
global Previous, nx, ny, nz
nx:=0
ny:=0
nz:=NewZ
previous:=varname
StringSplit, ar, varname , _
nx:=newX+ar2
ny:=newY+ar3
return % nz . "_" . nX . "_" . nY
}

;f8::
;Drawtile(exitlevel, stair)
;return

checkwin(){
global
for i, r in datagrid1
   for  j, c in r 
    if (c=Goal) {
       if (datagrid2[i,j]=redbarrel){
         continue
         }
         else {
            return true
            break, 1
        }         
    }
}
return

ongoal(){
global
for i, r in datagrid1
   for  j, c in r 
    if (c=3) {
       if (datagrid2[i,j]=barrel){
             Drawtile("2_" i "_" j, 13)
         }  
     }
}


boxxlelevels:

level_1:="x#####xxx!x#   ####!x#   #  #!x##    .#!### ###.#!# $ #x#.#!# $$#x###!#@  #xxxx!#####xxxx!"
level_2:="xx#######x!xx#     #x!xx# $ @ #x!##### # #x!# $     #x!#  #$## ##!#..$  #  #!#..      #!##########!"
level_3:="######!#..*.#!#.$  #!## $ #!##$ ##!#@$ #x!##  #x!x####x!"
level_4:="########!#.   $ #!#.$  # #!#.# #  #!### # ##!x# $  #x!x#@ ###x!x#####xx!"
level_5:="x########x!##..#   #x!# ..# $ ##!# @ $  $ #!##$###   #!x#     ###!x#######xx!"
level_6:="x#######xxx!x#     ####!x# ###.   #!##    # # #!# .#$ $ # #!# #  *  # #!# # $ $#. #!# # #    ##!#   .### ##!####      #!xxx#####  #!xxxxxxx#@ #!xxxxxxx####!"
level_7:="#########x!#.....  #x!### $ # ##!xx# $##  #!xx#$ $ $ #!xx#   #  #!xx##  # @#!xxx#######!"
level_8:="xxxx#####x!#####   #x!#.. $ $ ##!#..$ $  @#!##. $## ##!x###    #x!xxx######x!"
level_9:="###########!#     # @ #!# $  $  $ #!## #...# ##!x# #...# #x!x#$ ### $#x!x#   $   #x!x#  ##   #x!x#########x!"
level_10:="xxx####x!####  #x!# $...##!#@ $.. #!###$$$ #!xx#    #!xx######!"
level_11:="x##########x!##    # @ ##!#  $.... $ #!# $ ####$  #!##  #xx#   #!x####xx#####!"
level_12:="xxxx########xxxxxxxx!xxxx#      #########!##### #### #@##  ..#!# $  $           ..#!#   # ### #####  ..#!### # ### #xxx######!xx#  $  $ #xxxxxxxxx!xx###  $###xxxxxxxxx!xxxx#$  #xxxxxxxxxxx!xxxx#   #xxxxxxxxxxx!xxxx#####xxxxxxxxxxx!"
level_13:="xx#####x!xx#   ##!### *$ #!#  .$. #!#  $. ##!###  @#x!xx#####x!"
level_14:="xx########xxxxxxxxxx!xx#      #xxx######x!xx#$ $ $ #xxx#  ..#x!###  $  $#####  ..##!#  $$$   $      ...#!# #  $ ####@##  ..##!# #  $ #xx####  ..#x!#    ###xxxxx######x!######xxxxxxxxxxxxxx!"
level_15:="########!#  @   #!#  #$$ #!## $  ##!x#  $.#x!x## .##x!xx#..#xx!xx####xx!"
level_16:="#########xxxxxxxxxxx!#   #   ##xxxxxxxxxx!# $$#$$ @#xxxxxxxxxx!#    $  ##xxxxxxxxxx!#   # ##############!####  $ #     #....#!xxx# $$ #$ $ $#....#!xxx#  $     $ #....#!xxx# $$$#$  $ #  ..#!xxx#    #  $ $   ..#!xxx############  ..#!xxxxxxxxxxxxxx#  ..#!xxxxxxxxxxxxxx######!"
level_17:="xxx#######!xxx#  @  #!#### # $ #!#...$#$ ##!#... $   #!### $ ## #!xx# $    #!xx#    ###!xx######xx!"
level_18:="xxxxxx####!#######@ #!#   #    #!#   $  $ #!## ##$# ##!x#  $ #*.#!x##  $...#!xx#   #. #!xx########!"
level_19:="x########!x# @    #!##  ..$ #!#  #..###!# $$$##xx!#    #xxx!######xxx!"
level_20:="########!#  #   #!# $..$ #!#@$.* ##!# $..$ #!#  #   #!########!"
level_21:="xxx#####xx!#### @ ###!#    #   #!# $$  #$ #!#  $#$ $ #!###...$###!x#.... #xx!x#######xx!"
level_22:="x###xx####xxxxxx!##.####  ##xxxxx!#...  #  @###xxx!##..     $  #xxx!#...  # $ $ #xxx!##.###### ######!x###xxxx# $ $  #!xxxxxxx## $ $# #!xxxxxxx#   $   #!xxxxxxx#  $ $# #!xxxxxxx# # # # #!xxxxxxx#       #!xxxxxxx#########!"
level_23:="#######!#  #@ #!# $$$ #!#  $  #!# $$$ #!#..#..#!#..$..#!#######!"
level_24:="########xxxxxxxx!#  ##  #xxxxxxxx!#  ##$ #xxxxxxxx!#  $   ##xxxxxxx!## #    ##xxxxxx!x# ## #  #xxxxxx!x# $ $## #xx####!## ##    ####..#!# $ #$ #$##  ..#!#      $     ..#!########@##  ..#!xxxxxxx#########!"
level_25:="xx######!xx#  @ #!xx# $  #!#### $ #!# .#$ ##!#..# $#x!#..$  ##!#.. $  #!####$  #!xxx#   #!xxx#####!"
level_26:="xxxxxxx#####xxxxx!xxxxxx##   #xxxxx!xxxxxx#  $ #####x!xxxxxx# $ $    #x!xxxxxx### #### ##!x######## $    @#!##...  ## $$## ##!#....       ## #x!##...  #### ## #x!x######## $ $  #x!xxxxxxxx#  $ $ #x!xxxxxxxx#      #x!xxxxxxxx########x!"
level_27:="x########!x#  #  @#!x#$  $  #!x# ## $ #!##...$ ##!# ...# #x!# #$$  #x!#      #x!########x!"
level_28:="xx######xx!xx#....#xx!xx#  ..#xx!###$$#####!# $   $ @#!#   $ $  #!###   ####!xx#####xxx!"
level_29:="x#######xx!x#     ##x!x# $  $ #x!x## # #@#x!xx#.# $ #x!###..$ ##x!#  ..# #xx!# #.*# ###!#  #.$$$ #!##   # # #!x###     #!xxx#######!"
level_30:="xx####xxxxxxxxxxxxx!xx#  ####xxx####xxx!xx#     #####  #xxx!xx#  $$$       #xxx!xx## #  #  # # #xxx!xxx#$ $ ####$# #xxx!xxx# $####     #xxx!####  #  #  ## ####!# @$$    ## # ....#!# #  $$ ### # ....#!# $ $  $    # ....#!# ## $  ##  # ....#!#    $  ###########!######  #xxxxxxxxxx!xxxxx####xxxxxxxxxx!"
level_31:="xx############!xx#    #     #!xx# $  $ $ $ #!###### ##$ $ #!#..  # #  $ ##!#..    @ ##  #!#..  #$####  #!#..  # $  $  #!#..  #     ###!############xx!"
level_32:="xxxxxx#######x!xxxxx##@#   #x!xxxx##  # $ #x!x####  # $  #x!x#    # $ # ##!x#   # $  #  #!x#  # $  #   #!x# # $  #    #!##  $  ### # #!#  $  ##...# #!#   ##.....  #!########  ####!xxxxxxx####xxx!"
level_33:="########xxxxxxxxx!#....  ##########!##...    $  $   #!#....  ## $  $  #!######### $ # ###!xxxxxxxx##$ $ #xx!xxxxxxxx# $  $#xx!xxxxxxxx# $#$ ##x!xxxxxxxx#     @#x!xxxxxxxx########x!"
level_34:="############xxx!#...#  @#  ##xx!#...#$$  $  #xx!#...   ##  $#xx!#   # ##    ###!#####  $ #$$  #!xx# $ $       #!xx#   #########!xx#####xxxxxxxx!"
level_35:="xxx#########!xxx#  ##   #!xxx# $  $  #!xxx#  $# $ #!#### $ #$  #!#..### # $ #!#..  # # $ #!#..     $$ #!#..  ###   #!#..  #x##@##!######xx###x!"
level_36:="xxxxxxxxxx#########!########x##   #   #!#...#  ###  $  $  #!#...#    @ # ### ##!#...    # ##  #   #!#  ### $#$  $  $  #!##      # #  ## ###!x#### #$$ ## ##  #x!xxxx#   #   $    #x!xxxx#####  #  ####x!xxxxxxxx#######xxxx!"
level_37:="xxxxxxxxxxx#####!x###########   #!x#     $    ...#!x#$$#  #####...#!##  #$ #   #...#!#  $   #   #...#!#@#$$ ##   #...#!# $    #   #...#!##  $$ ######.##!x# $ $ #   #   #!x#$ $ $ $ $    #!x#  ## #  $$# ##!x#     ###    #x!x#######x######x!"
level_38:="############!###..##    #!##....#  $ #!#.....# $# #!####.. $ #@#!#   ..# ####!# $# $#    #!#  #  #  $ #!#   # # $ ##!# $$$ # ####!#   $ #    #!#### ## $$ #!##   $   $ #!##     ##  #!############!"
level_39:="xxxxxxxx####xxxxx!xxxxxxxx#  #xxxxx!xxxxxxxx#  #xxxxx!xxxxxxxx#  #xxxxx!xxxxx#### ###xxxx!xxxxx# $    #xxxx!###### $$ $ #####!#@ $  $    $  $ #!##   #$ $   #   #!x#####  $ $ #####!xxxxx# $$$ ##xxxx!xxxxx### ########!xxxxxx## ##  ...#!xxxxxx#  ##  ...#!xxxxxx#      ...#!xxxxxx#####  ...#!xxxxxxxxxx#  ...#!xxxxxxxxxx#######!"
level_40:="####xxxxxx####!#..########..#!#.*.*.....*.*#!#$ $ $ $ $ $ #!# $ $ $ $ $ $#!#$ $ $@$ $ $ #!# $ $ $ $ $ $#!#*.*.....*.*.#!#..########..#!####xxxxxx####!"
level_41:="xxx####xxxxxxx!xxx#  #####xxx!x###$ $   ###x!x#  $ #  $  #x!x#    ## ## ##!x#  ###  ##  #!x# #  $ $ ## #!x#$  $ $ $#  #!## ###  $    #!#     #$ ##$ #!# ....#  #  ##!##....# # @##x!x#.#.#  $ ##xx!x#....   ##xxx!x#########xxxx!"
level_42:="xxxx######xxxxx!xxxx#....####xx!xxxx#....#  #xx!xxxx#...  $ #xx!#####   #   #xx!#   #####$####x!#   #      # #x!## $  $#     #x!x#$ ## # $ $ #x!x#  $   ####$##!x# # #  ####  #!## $       $  #!#@  ########  #!#####xxxxxx####!"
level_43:="######xxxxxxxxxxxxx!#    ######xx####xx!# $  $ #  ####  ##x!#  $   # $$      #x!##   $$#  ### #  #x!x# $#  ## ##  #  #x!x#$ $  $@$ # ##  ##!x#  #  #   # #....#!x# $ $ ##$## #....#!x##   #x#  # #....#!xx#####x#  $ #....#!xxxxxxxx#  # ######!xxxxxxxx######xxxxx!"
level_44:="xxxxxx####xxx!xxxxxx#  #xxx!xxxxxx#$ ###x!xxxxxx#   ###!x######$ $  #!x#... # $   #!x#....  $$ ##!x#....#   $#x!x#....#$ $ #x!#### ##   $#x!#@$ $ # $  #x!## $  ## ###x!x##     $#xxx!xx#####  #xxx!xxxxxx####xxx!"
level_45:="xxxx#########xxxx!xxxx#.......#xxxx!xxxx#.......#xxxx!xxxx#.......#xxxx!xxxx#### $###xxxx!xxxxx#  $  ##xxxx!xxxxx# $ $  #xxxx!x###### # # ###xx!x#  ## $ $ $  #xx!## $$         #xx!#   #####$##$##xx!#   $     $ $ ###!######## $#     #!xxxxx#  $ #  #  #!xxxxx#   @#$  $ #!xxxxx## $ $   $ #!xxxxxx########  #!xxxxxxxxxxxxx####!"
level_46:="######xxxxxxxxxxx!#....#xxxxxxxxxxx!#....#xxxxxxxxxxx!##   ############!x#   #  #   #   #!x## ## $ $ $$   #!xx#    @# # #####!xx#  ##$# $  #xxx!xx####   $   #xxx!xx#  $   #####xxx!xx#      #xxxxxxx!xx########xxxxxxx!"
level_47:="xxxxxxx#######xxx!########.....#xxx!# $   $ .....####!#  $ $ #.....   #!##  ## #.....#  #!x#  $  ###$### ##!x# $  $  $   $ #x!x#$####  $   $ #x!x#   #  $# #####x!x###   $$ $ $  #x!xxx#### $  $   #x!xxxxx#@  #######x!xxxxx#####xxxxxxx!"
level_48:="xxx#####xxxxxxxxxx!xxx#...#xxxxxxxxxx!xxx#...##xxxxxxxxx!xxx#....####xxxxxx!x####......####xxx!x#  #....     #xxx!##  ###  ###$ #xxx!# $ $ #$#  #  #xxx!# $    $  $## ####!#  #  # #   $$$  #!##  $## #$ $     #!x#$  $  # $ $#  ##!x#  $# $ $   ####x!x##  ## @#   #xxxx!xx#  #########xxxx!xx####xxxxxxxxxxxx!"
level_49:="xxx#####x!xxx#   ##!xxx# #  #!x### $  #!##   # ##!# .#.#  #!# ..*$$ #!# *#.#  #!##  ##$##!x#$ @  #x!x#  ####x!x####xxxx!"
level_50:="xxxxxx########x!xxxxxx#      ##!x######  ##$$@#!##  #  $$ #   #!##$       $ $ #!#   # $########!#  $#  #... .#x!# $ #$$ ...  #x!#  $#  #...  #x!##  #  #...###x!x#  #  #####xxx!x#######xxxxxxx!"
level_51:="xxxxxxxxxxxx#####!xxxxx########   #!######@#   ## # #!#   ##   $      #!#...   ## ### ###!#..## ##    # #xx!#..#  ##$#### ##x!#..# $$     #  #x!#..#  ## $  $  #x!#####  #  $ #  #x!xxxx#$$ $$# ####x!xxxx#       #xxxx!xxxx#########xxxx!"
level_52:="########xxxxxxxxxxxx!#      ######xxxxxxx!# ####      #xxxxxxx!# #  ### ## #xxxxxxx!#     $   # #xxxxxxx!# #  #    # #xxxxxxx!# #$ ### #  #x######!# # #### # #### ...#!# #   # $$ #  #  ..#!# #   #   ##$    ..#!#  $$ #     $ #  ..#!###   #   ##$ ######!xx##########@ #xxxxx!xxxxxxxxxxx####xxxxx!"
level_53:="#####xxxxxx!#@  #######!# #$#  #  #!# $    $$ #!### ##$#  #!x#  # .# ##!x#  $..   #!x#  #..## #!x#####.   #!xxxxx######!"
level_54:="xxxxxx#####xxxx!xxxxx##   #####!x##### $  #...#!x#   # # ##...#!x# #   # #.. .#!x#   ##   ....#!####  $$$ $#  #!#  # ##  $ ####!#  # ## $  #xxx!# $$$ $  $$#xxx!## #@##    #xxx!## #### #  #xxx!#       ####xxx!#       #xxxxxx!#########xxxxxx!"
level_55:="xxxxxxxxxxxx########!xxxxxxxx#####   #  #!xxxxxx###   #$ $ $ #!xxxxx## #     $ $  #!x#####    # #$ # $ #!x#  #  # ## #   #  #!x#    ##### ### #$ #!x# $## ...# ##  $  #!x## ## ...#  #    ##!x#  ###...   ######x!x#  $ ....####xxxxxx!x#  #######xxxxxxxxx!### $ #xxxxxxxxxxxxx!#@$   #xxxxxxxxxxxxx!##  ###xxxxxxxxxxxxx!x####xxxxxxxxxxxxxxx!"
level_56:="xxx######xxxxxxxxxxx!x###    ###xxxxxxxxx!x#        ####xxxxxx!x# #$$$## #  #xxxxxx!x# #    # #  #######!x# #    # # $   ...#!x# #$#$## #$    ...#!##         $$###...#!#  #$$$## #$   #...#!# #     # #    #...#!# #  $  # # ## #...#!#  #$#$##  #   #...#!##       $   $ #...#!x# #$$$# ####$##.###!x# # @ #  #  $   #xx!x#  ###   # $$ ###xx!x##     ###    #xxxx!xx#######x######xxxx!"
level_57:="####xxxxxxxxxxxxxx!# @#xxxxxxxxxxxxxx!# $#####xxxxxxxxxx!#  $   ##xxxx#####!#   $#  #xxxx#   #!##   $  #xxxx# $ #!x##$# $ #######  #!xx#   #$    #  ..#!xx# # # $## # #..#!xx#      $     ..#!xx###########  ..#!xxxxxx#     #$#..#!xxxxxx# $      ..#!xxxxxx#     #   ##!xxxxxx###########x!"
level_58:="xxxxxx#####xxxxxxx!xx#####   #######x!xx#@$    $   $  #x!x#### #$#  ##$  #x!x#  #  $  $ #   #x!x#  ### ##  # ####!x#  $ # $  #  $  #!x#        ### $  #!#######$ ##  $ ###!#.....#  #  $  #xx!#.....## $ #$  #xx!#....     $   ##xx!#...   ########xxx!########xxxxxxxxxx!"
level_59:="#######xxxxxxxxx!#     #xxxxxxxxx!# ### ###xxxxxxx!# #  $  #xxxxxxx!# # $ $ ##xxxxxx!# #@ #$  #######!# # $# $$#  ...#!# #$ #   #  ...#!# #  #$     ...#!# #$ #  $#  ...#!#   $ $  #  ...#!###  $  $#######!xx### ## #xxxxxx!xxxx#    #xxxxxx!xxxx######xxxxxx!"
level_60:="xxxx###########!x####.........#!x#   .*******.#!x# ###.......##!## # #.$$$$$.#x!#@ ####     ##x!# $  ## $$$ #xx!# $ $  #   ##xx!# $ $ $    #xxx!# $ $ $  ###xxx!# $ $  ###xxxxx!# $  ###xxxxxxx!#  ###xxxxxxxxx!####xxxxxxxxxxx!"
level_61:="x###xxxxxxxxxxxx!##@#########xxxx!# $#   ##  #xxxx!#      $   #xxxx!# $##$###  ##xxx!#  ## ### ###xxx!#####.###   #xxx!xxxx#....#  #xxx!xxxx#....#  #xxx!xxxx#....## ##xx!xxx### ####  #xx!xxx#         #xx!xxx#   #### ####!xxx#####  $ $  #!xxxxxxx# $ $   #!xxxxxxx# $$$$$ #!xxxxxxx#       #!xxxxxxx#########!"
level_62:="####xx####!#  ####  #!#   @    #!# $$$$$$ #!##      ##!# $$$$$$ #!#        #!#  $$$$  #!###    ###!x# $$$$ #x!x#      #x!x#  $$  #x!x###..###x!x#..**..#x!x#......#x!x#..##..#x!x#......#x!x########x!"
level_63:="xx###########xx!xx#....   ..#xx!xx# .......##xx!### .#....#####!#  #$##..##   #!#     #### $  #!# $$  #  #  $ #!##  $$#   $$ ##!x#$  $   #$  #x!x# $$ #  #  $#x!x# $ $#### $ #x!x#       #  ##x!x#### $  # ##xx!xxxx### ## #xxx!xxxxx# $   #xxx!xxxxx#@ #  #xxx!xxxxx#######xxx!"
level_64:="xxx######xxxxxxx!xxx#    #xxxxxxx!#### ## #######x!# @$  $   #   ##!# # $  $  # $  #!#  $  ##### #  #!#### ##  #### ##!xx#  #  ##  #  #!xx#            #!xx#######  #  ##!xxx#..  #  ####x!xxx#..      #xxx!xxx#..  #   #xxx!xxx##########xxx!"
level_65:="#######xxxxxxxxxxxx!#.....#xxxxxxxxxxxx!#...#.#xxxxxxxxxxxx!#.. ..#x####xxxxxxx!#.    ###  ########!#### ## $         #!####    #  $$ #   #!x#   $ #  # $ #####!x# # $ $$ # ###xxxx!x#  #$##     #xxxxx!x##  $ $$## ##xxxxx!xx##   @  $  #xxxxx!xxx###  ###$ #xxxxx!xxxxx####x#  #xxxxx!xxxxxxxxxx####xxxxx!"
level_66:="xxxxxxx#########!xxxxxxx#  ##   #!xxxxx### $     #!xx#### @$  ##$##!###  #### ### #x!#  $ # #.*..# #x!# #   $ ....# #x!#    # #....$ #x!###  # #####  #x!xx####    $   #x!xxxxx###$  $ ##x!xxxxxxx# $$ ##xx!xxxxxxx#   ##xxx!xxxxxxx#  ##xxxx!xxxxxxx####xxxxx!"
level_67:="##################!#   ##       $...#!# $ $ $#$ ####  .#!# $$#$       @...#!# $   #$##$$ #...#!# $ $$#    $ #...#!#         ## #...#!##################!"
level_68:="x#######xxxxxxxxx!x#     #xxxxxxxxx!x# $ $ #xxxxxxxxx!x# $ ####xxxxxxxx!## $##  #########!#   #  $  ......#!# *##  #$ #  $  #!#.....*.  ## $  #!#.###   ##  ##$ #!###x######      #!xxxxxx#@$  $ $$ #!xxxxxx###   #   #!xxxxxxxx#########!"
level_69:="xxxxxxxxxxxxxx####xx!xxxxxxxxxxxxx##  ###!##############  $  #!#........... #   $ #!#.# #######. #$ $###!#.# ####### ##   ##x!#..           $$$@#x!#  ######## ##    #x!####xxx#   $$ #####x!xxxxxxx# $    $ #xxx!xxxxxxx## $$  $ #xxx!xxxxxxxx##  $$  #xxx!xxxxxxxxx##     #xxx!xxxxxxxxxx##   ##xxx!xxxxxxxxxxx#####xxxx!"
level_70:="xxxxxx#######x!xx#####     #x!###   # ##$ ##!# $   #      #!# $# ##$# #$ #!#@ # # $  #  #!# $# # $###$ #!# $  $    # ##!## # $# #    #!# $#  ..##. .#!#  ### ..#.# #!#   ## ......#!##############!"
level_71:="xxxxxxxx#######xx!xxxxxxxx#     #xx!xxxx#####     ###!#####   ## ##...#!#     # ## ##...#!# ###$$$ $ ##...#!# #   $ $  ##...#!# # #$ $ $###...#!# #   $@$   ## ##!# #  $ $ $ $#  #x!# # ######     #x!#              #x!################x!"
level_72:="xxxxxxxxxxxxx####x!xxxxxx########  #x!xxxxxx#     #   #x!xxxx### ###   # #x!#####     $   # #x!#   $ $ ###$$ # #x!#  $ $$$  # $## #x!#  #$   #  $  # #x!##   #### ### #$##!x# ###......     #!x#   $......## # #!x# ###......##   #!x#$$ #   #########!x#     # $@$ #xxxx!x#######     #xxxx!xxxxxxx#######xxxx!"
level_73:="xxxx####xxxxx####xxx!xx###  #######  ##xx!xx#  ........... #xx!xx# $ ##### ### $##x!x####  $ $ #   $  #x!x#  #  # # #$# @# ##!x#         #   $ $ #!x#   ##   # $$$#   #!##  #     #      ###!#    # ##  #  ####xx!#         #   #xxxxx!########  #####xxxxx!xxxxxxx####xxxxxxxxx!"
level_74:="xx#####xxxx!xx#   #xxxx!###$# ###xx!# $...  ###!# #.#*#   #!# $.#.$   #!#  ## ## ##!## @ $ $ #x!x###   ###x!xxx#####xxx!"
level_75:="xxxxxxxxxx####x####!xxxxxxxxxx#  ###  #!xxxxxxxxxx#  $    #!xxxxxxxxxx# # $ $ #!xxxxxx##### # #  ##!xxxxxx#.....# $$$#x!xxxxxx#....* $   #x!xxxxxx#*..*.# #$##x!#######....*# $  #x!#     $*.*..#    #x!#  $$ # ##$###$$ #x!#    $   #      ##x!#####$ $ ####  ##xx!x#@# $        ##xxx!x#    ######  #xxxx!x######xxxx####xxxx!"
level_76:="xxxxxx#####xxxxxxxx!xxxxx##   ##xxxxxxx!xxxx##  *  ##xxxxxx!xxx##  * *  ##xxxxx!xx##  * * *  ##xxxx!x##  * * * *  ####x!##  * * * * *  # ##!#  * * * * * *    #!# * * * . * * *@$ #!#  * * * * * *    #!##  * * * * *  # ##!x##  * * * *  ####x!xx##  * * *  ##xxxx!xxx##  * *  ##xxxxx!xxxx##  *  ##xxxxxx!xxxxx##   ##xxxxxxx!xxxxxx#####xxxxxxxx!"
level_77:="xx########!x##..    #!x#...$ $ #!###.## ###!#   ##$ #x!#  $@$  #x!##$ ##  #x!x#  #####x!x####xxxxx!"
level_78:="xx####xxxxxxxx!xx#  #xxxxxxxx!xx#  #########!xx# $$ #.....#!xx#    #.*...#!x###   $..##.#!x#  #$##$  #.#!x# $  ## ## .#!x#  ##  $ $ ##!###@ #$    ##x!#  $$ $   $#xx!# $  ####  #xx!#    #xx####xx!#   ##xxxxxxxx!#####xxxxxxxxx!"
level_79:="###xxxxxxxxxxxxx!# ##xxxx####xxxx!#  ######  ###xx!#   # $ $$ $ ###!#  $ @ $    $  #!# $ # #$  $    #!#  ## # ### ####!# ##    #  $  #x!###... ## $ $ #x!##....##   $  #x!#....## $  $###x!#...###  $  #xxx!#...#x#  ####xxx!#####x####xxxxxx!"
level_80:="xxxxxxxxxxx####x!xxxxxx######  #x!xxxxxx#   $   #x!xxxxxx# $$ $  #x!xxxxxx## # $  #x!x######   $ # #x!x#      $ $ $ ##!x# ## #######  #!x# $  ##...##$ #!##   ##...#.#  #!# $ $ #.....$$ #!#    $$.....#  #!##$   #..#..#$##!x# $#$####### #x!x#    #       #x!x#### # # #####x!xxxx#   #@#xxxxx!xxxx#######xxxxx!"
level_81:="xxxx######xxx!xxxx#    #xxx!x#### ##$###x!x#         #x!x# #....#  #x!## #....#$$#x!#   ....#  #x!# ##....   ##!# ##....#$$ #!#  $....#   #!# $#### #   #!#  $  $$$$$##!##$    $   #x!x# $$# #   #x!x#  $ $ $$$#x!x# $   $   #x!x#@##   ####x!x########xxxx!"
level_82:="x####xxxxxx!x#  #######!x#$  $    #!x#   # #$ #!x# #. .# ##!x# $...  #x!##$#...# #x!#   $## $#x!#     $  #x!####### @#x!xxxxxx####x!"
level_83:="x#####xxxxxxxxxxxxxx!x#   #xxxx##########!x#$  ######    ##  #!## $$  $   $  $... #!# $ ##   #  #$#.#. #!#    ##  ##$ $ ... #!# $#    $ # # #.#. #!#  ## #$  #    ... #!# #  $#@$## # #.#. #!#  $$ #$ #  #  ... #!###      #  #   ####!xx###   ##  #####xxx!xxxx#########xxxxxxx!"
level_84:="xxx#####x!xxx#   #x!xxx# #$#x!####   #x!#  #.# ##!#  *.* @#!#  #.#  #!## # #$##!#  # #  #!#    $  #!#  ###  #!####x####!"
level_85:="xxxxx#####xxxxxxx!######   #xxxxxxx!#  #     #xxxxxxx!# $$  #  #xxxxxxx!#   ### #######xx!##  #.....#   #xx!x#  $...*. $# ###!x# $#.....# #   #!x## ####$##     #!x#  #      $ ####!x#  # @ $ # $#xxx!x#  $  ##$   #xxx!x### #$   ####xxx!xxx#  $ $ #xxxxxx!xxx##  #  #xxxxxx!xxxx####  #xxxxxx!xxxxxxx####xxxxxx!"
level_86:="xxx####xxxxx!xxx#  #####x!x###$     #x!x#     .# #x!x# ## #.  #x!x# $  #*####!## ####.   #!#  #  @.#  #!# $  #$.#$##!###    . $ #!xx######   #!xxxxxxx#####!"
level_87:="xxxxxxxxxx#########!xxxxxxxxxx#       #!xxxxxxxxxx# ### # #!xxxxx####x# #...# #!######  ###  ...  #!#         # #...# #!#  $#  $  # ## ## #!##  #### ##$      #!x# ##### #  #$ ####!x# #### $    $ #xxx!x# $ ##$ ###   #xxx!x#      $@######xxx!x# # ######xxxxxxxx!x#   #xxxxxxxxxxxxx!x#####xxxxxxxxxxxxx!"
level_88:="####xxxxxxxxx!# @#xxx####xx!#  #####..###!#  # $  $...#!##   #  ... #!x#$$  ###$# #!##  # ### $ #!# $   $   # #!#    ####   #!######xx#####!"
level_89:="xxxx########xxxxxxxx!x####  ....#xxxxxxxx!x# #  $....######xxx!x# $  #....## ..####!x#  $$## #### ....##!####    $ @## .....#!#    $ $$ #### #####!# #$$$$# $$ $  #xxxx!#       # $ ## #xxxx!###  ## $  $  $#xxxx!xx# $   $      #xxxx!xx####  $ ### $#xxxx!xxxxx###  #x#  #xxxx!xxxxxxx####x####xxxx!"
level_90:="xxxxx#####!######   #!#   ## # #!#        #!##$###*###!## #.@.##x!#  *.#  #x!# # $ $ #x!#   ##  #x!#########x!"
level_91:="xxxxx#####xx!xx####   #xx!xx#    #@#xx!xx# ###  #xx!xx# #  $ ###!xx# # # $$ #!xx# # $$   #!### #   #$ #!#   # $$ $ #!# $ $      #!##$#########!# ....#xxxxx!# ....#xxxxx!# ....#xxxxx!#######xxxxx!"
level_92:="#########xxxxx#####x!#       #######   #x!# # # # #         #x!#   $ $ # ###### ##x!#####$#$# #  ..  ###!xx#  @$  $   ..# $ #!xx# #$#$# ###... $ #!xx#       ##...#   #!xx##################!"
level_93:="x####xxxx!x#  #xxxx!x#  ###xx!x# $  ###!## ##.  #!# $$..# #!#  #*.$ #!## #. ###!x#   @#xx!x#$ ###xx!x#  #xxxx!x####xxxx!"
level_94:="xxxxxxx#####xxxxxx!####xx##   #######!#  #xx#  $   $   #!#  #### $ $ $ #  #!#... $ $  #$#$## #!#...# $ $        #!#..# $ $ $########!#...$ $ $@##xxxxxx!###### $ $ ###xxxx!xxxxx# ##  ..#xxxx!xxxxx# #  ...#xxxx!xxxxx#    ...#xxxx!xxxxx#########xxxx!"
level_95:="xxxx#####xx!xxxx#   #xx!##### # #xx!#   $   #xx!#   #$#####!##$## $ $ #!x# ...#   #!x# #..*   #!x# @ ######!x#####xxxxx!"
level_96:="xxxx#######xxx!xxx##     ##xx!xxx#  ###  #xx!x###$##. # ###!##    #..$   #!#  $$ #..#   #!# $$@ #.*# ###!#  $#$#*.# #xx!##     ..# #xx!x###$##  # #xx!xxx#   ##  #xx!xxx###    ##xx!xxxxx######xxx!"
level_97:="x######x######xxxxxx!x#    #x#    #xxxxxx!## ## ### $  #xxxxxx!# $$     $$  #xxxxxx!#  $ ## ## # #xxxxxx!# # $ $    # #xxxxxx!# $  $  # ## #######!#  # #$   ## ##    #!#### #  #### ## ## #!x#  $ $##  #       #!x# $ $     # ## ####!## ## ###  #   ....#!#   # ###   ## ....#!#   $$#       .....#!#   #    #@####....#!############xx######!"
level_98:="xx#########xxx!xx#.......#xxx!xx#.......###x!xx#         #x!xx##  ##### #x!xxx# ##   # #x!xxx# #   $  #x!xxx#  $ $ ###x!xx##$#   $ @#x!xx#  ## # $##x!###$  $$#  ###!#       #$   #!# # $ $ $  $ #!# ###### #  ##!#        ####x!##########xxxx!"
level_99:="#########xxxxxxxx!#....   #xxxxxxxx!#....   #xxxxxxxx!#.#... ##xxxxxxxx!#....#  ########x!######$$   #   #x!xxx#    ## $$# #x!xxx#  #  ##  $ #x!xxx## $ $   ## #x!xxx#   # $   # #x!xxx#   $ #$  # #x!xxx## ## # $ # ##!xxxx#$ #$#  ## @#!xxxx#  # #$$ $  #!xxxx#          ##!xxxx############x!"
level_100:="xx####xxxxxxxxxxxx!xx#  #######xxxxxx!###$       #######!# $  $$  $ ##....#!#  $# ###$$   ...#!# #    @  #   ...#!# #$$ $ $$#$##...#!#   ## ##   ##...#!##  $      $ #####!x#########  ##xxxx!xxxxxxxxx####xxxxx!"
level_101:="#############!#@$ $ $ *...#!#  $ $ $.*..#!# $ $ $ *...#!#  $ $ $.*..#!# $ $ $ *...#!#  $ $ $.*..#!# $ $ $ *...#!#  $ $ $.*..#!# $ $ $ *...#!#  $ $ $.*..#!#############!"
level_102:="xxxxx#####xxxx#####x!######   ######...##!#   ## $ #  ##.... #!# $$   $ #   #.. . #!#   ### ## $ #....##!### #     $  #....#x!x## #   ### #####$#x!x## ###   # ##    #x!x# $  @$$ # ##$$$ #x!x# $ ##   # ## $  #x!x#   ##### $## # ##x!x#####xx#     $ $ #x!xxxxxxxx#   #     #x!xxxxxxxx###########x!"
level_103:="xx####xxxxxx######x!xx#  #xxxxxx#    ##!xx#  ###xxx##     #!xx#$   #xxx#   #  #!xx# $# #####      #!xx#   $   # # #####!###$$   # # # # #xx!# $   $   # #   #xx!# @$ $ ###  # # ##x!#  ## #          #x!####...#  #    # #x!xxx#..*.# # # $  #x!xxx##..*.# # #$ ##x!xxxx##..* $    $ #x!xxxxx##..    #   #x!xxxxxx############x!"
level_104:="###################!#  #   #   #   #  #!#  $   $  $    $  #!# $########## ##$ #!## ## *.*..*.* # ##!#  ## ..*..... # ##!#  ### ######### ##!#  #      $ #   $ #!## #   $#$#@  #   #!## # #       ######!# $  #########xxxxx!#   ##xxxxxxxxxxxxx!#####xxxxxxxxxxxxxx!"
level_105:="xxxxxx####xx!#######  #xx!#  #     #xx!# $$ $#  #xx!#  ##.# ####!## ##.#  $ #!## # . $ # #!#   *..#   #!#  # . # ###!## ##.##$#xx!x#     $@#xx!x#  ######xx!x####xxxxxxx!"
level_106:="x##########!##  ..... #!#  #..... #!# $ #### ##!# $  @   #x!## $ $ $ #x!x# $$$$$ #x!x#   #   #x!x#########x!"
level_107:="##############!#     #      #!# $$$    $$$ #!##   $$$$   ##!x#$ $    $ $#x!x#   $$$$   #x!x#$$$    $$$#x!x# $ $$$$ $ #x!x#          #x!######..######!#..*.****.*..#!#..*......*..#!##.********.##!x#..........#x!x######@#####x!xxxxxx###xxxxx!"
level_108:="xxxxx#####!######   #!# $ .. $ #!#@$$.. $##!# $ ..  #x!#########x!"
return

extract_tiles:

01 :="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAgMAAAAOFJJnAAAACVBMVEV3fnlqcWyBiIOsuk0QAAAAJklEQVQY02MIhQIEI2oVGCxFYixgAAIuZAYDGAwtBrovMH2KGRoAC+Y5HfX3uBIAAAAASUVORK5CYII="
02 :="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAaVBMVEWhoaFtbW3CwsKUlJSpqalGRkZpaWnExMTn5+esrKykpKRlZWVdXV2RkZG6urpLS0vJycm9vb2ZmZmWlpa0tLRwcHC/v7+cnJzi4uKLi4t/f391dXXW1taPj49ZWVk9PT3Q0NCFhYVSUlJG8PdqAAAAyElEQVQ4y7WS2Q6DIBBFB1QsUAFZ3Je2//+R9ckMNtQ0puftkpMZYAZuMd3U4WQsTIZGNDgoS8D4PE07aqAc0mSkgDq/KjRnLSi/XOH/QvlFEDYU4NssiZu3CsNIMCHgxJYVCMPIjSi/oMRQ3juFD3wPNJ7/4B94QfgAh/mTJlqQTIKI382o4eid8/34MbKmWKg+BZUQUIszocx/bHH9kuKsghAou1gQ+SZYh+bfM6ZUW+3ZPhcgGHaXIgtsz0FqKDBaayI1zusbvUAPDjfZlaMAAAAASUVORK5CYII="
03 :="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAGFBMVEWAjoVjdGsjLiswPTg3R0JMX1VXbGNAT0hiWm0fAAAATElEQVQoz2MgAigpKRkDgQsYGGMXAPLggGwBiIgxCGAVAIqAQSgI4BBQAvMFQQCXgFJ5eTl+gfK0tDTKBIyN0QScnVEFgG4eDAKEAABvSVUhkHq4BgAAAABJRU5ErkJggg=="
06 :="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAHlBMVEUAAABwAABUAAIAAACMAAKoAADEAAD//wD/AAD+//8MEF22AAAAAXRSTlMAQObYZgAAALJJREFUKM+NksENwyAMRZEi9f4DC+As4JSoPSOcDTJLzx2j49alkDqn5h2IeHoOEsI1UnIHBhE+iGXdyuVpghxyuL9MABGUhw1EcriZAOsGlF3MGmji9wkAIrqwEYARcxf+vCCKwEj0K9To3o6Qso8MoAa4Cc1Tmig2saDjSw0EQSqA8CfI+Brot9QAIrkvrJcDQ2A344D/KyZ3RUO6iP1/UEYVBAPpsRTNvgpLqg/BwO4NnCcsqnHHktMAAAAASUVORK5CYII="
07 :="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAPFBMVEUAAAAAAABwAABUAAKMAAKQkJD/qFT/gADEZAC0tLT/xIzg4OCoVACoAACMSAD/4MTEAAD/AAD//wD+//9DRHj9AAAAAXRSTlMAQObYZgAAASBJREFUOMt10o2SgjAMBGA3oY0UQfTe/11vk9xNB213tDjuN/yk3K4BcxvndXq/MBj3P+/T+32fiPNtOxaRxb8Ygdd9j34qdu8zYwGI6F+G4gH2XXwB3MFiLhIg4/QTQAhQyrptaymIU3wBFH7WlSuF6AdQApihFF8noB61AY2HGUCtZrViCjYcZsc2ABCCagesNQOMQgUXwKcwXqC2Vv2I63NiAQEMwPPJhf1lx+Bb/IhBFcSiARb0PsFaIivYp+h9ApRtKwjQBdgHEP0fNfuMA+RPBFD4DSTIgCAkQ0HDln1eN4EG4ACCqrfAwnTAwLdA8s+YhWTUgQYwIxAv0Ig7oGDACBMgR814kSBfw0yeTZnomWg7oPB0QJHRS+Bh/wtxFAmIq2JcwQAAAABJRU5ErkJggg=="
08 :="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAKlBMVEUAAABwAAAAAABUAAKMAAL/qFSQkJD/gAD/xIy0tLTg4OD/4MSoAACMSAA3i+TNAAAAAXRSTlMAQObYZgAAAONJREFUKM9V0LEOAUEQBmDZNxg8gJ1lHaK42ydw2VJ1yYVGs4VEK7moNBKhViiUColWq1V6KCNYM3+3X/7J7mztE4VYE2l7L0SNnw/fEoURQM4K3oMADe8044xyFAGIaFI2o07XeXAcFke0VIkzyoZyJWCTzErDZtSkKiR012cJyW5YFQT1H0y3VblMoZH9YHBLJhpyF28JNiwB8iwuZ+cHDcA+pH85AEEeoXekAq/YoOWHoCagRGhrEKBGVKdzg4Oms4lAWyA93DHAu8nMH1JI9hvjOHTKwqUu+0MdDV/fffOGFwpEMehnU7P3AAAAAElFTkSuQmCC"
09 :="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAPFBMVEUAAABwAAAAAABUAAKMAAL/qFSQkJDEZAD/xIz/gAC0tLSoAACoVADg4ODEAAD/4MT/AAD//wD+//+MSADOJxWtAAAAAXRSTlMAQObYZgAAANdJREFUOMt90tGugyAQhOHuICsLVdtz3v9dO2tqmhaW/8aL+QyRePsO3i0MWLxQ+NwYRbCLtzDMwGN3Mdn/njsfCMH+tJYYgj3tj7WBBYBvtqZ12yqiXQForRoCuyNDyYY7QV6RC1CmIJvlGcC/GX6BeL47sFI6kNIpYASWS+ERnTiPga0AjmNwUQ4Y1vMjFaO/QbwVVXW8f8C2IXqf4LzqAZAPgGoP5OoOCDAFIlh6kN77QsA6gXSREFA4AYHXAwpXB4AIOCnMQUK/i4vMAiCMgskQ/HaBF8TGBvfnTrgxAAAAAElFTkSuQmCC"
14 :="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAgMAAAAOFJJnAAAACVBMVEUyTGg1UW4sQ1xHLJp8AAAAMklEQVQY02NYBQUIxtJQMIhCYgQwAAErMoMBDEhnsAagMwJY8TIwdZFpO6YvMH2KGRoAgEI9GTLd3iEAAAAASUVORK5CYII="
barrel:="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAABSlBMVEUAAABTUFAjHRwuKikiHh1kZGQfGhkhGhktJSNpaWkxMDAkHBp4eHhgYGBycnEsJSRRUVEhHx9NTEwzLi1+f358fHxHRkZRUFBoZ2cyLCspIR9NTExpaGg4NzeOjYxeXV2KiopQT0+RkZCYl5ZCPz8cHBydnZxoaGhgYGAuLS14eHg3LSorIyFMPzolJCMuKyp4YFZyWlEcHBxCPz6bemqNcGNYRkA9My9KSEhBNjIxKCWCgH9dS0SRc2ZuWE8sJyUnIR6WdmiEaV6AZluJbGAzMC+JiIdVRD9IPTg8NzY3MzIiHx5GOTSenp2Tk5JlY2JiVE9pVExYT0tlUUghHBsXFxdxb22ffWxqaWgTEBB9fX12dnVfXl5cWllVVFNOTUxhTkdHREOOjo19ZVpNREJSRD5GOziZmZd6eXhvamhkX11sY2AICAd+cm6BgtSGAAAAK3RSTlMACekXN7Hrn+vYtYVYWDYwJ93c2tCxsa+QiWMz5+fW08m7rZN1dWNjQEAqHypdNQAAAqRJREFUOMuNk1dzm0AUhaXYktztuJf0nuwCC0ggOgIhqnqxrN5d8/9fswpS7GT8kG+YHWbOuZezl93IU35sbW1tb2/vRZ4junN09CaXy0mSdBiL7UT/1b+8y900u33Xojy22CgUDr/+ZYl+zN+wLiBsbg7BDzsF6TT6RP+Q73g8lmW5SmNUWXAbo5NHx06hzRMDVaVpZGZTWfwYyM61Lv4Y1vOTKW1kFSWVSSaTmfmiZO/yb5f6yvqIJWSaNo1UyjDGuA9CdLlyvb6yMGz2ChNVSSoZXHt5icsv5ysaDTcXERPutSSbWFeyarlcRTiEkho3WlYijLlaA8X8PY37mzJSMopaxa+oJPVhbTU0kLxwe32DW5gohZCZonGUhtSnxIUh4buOUCwUpJ8lA4dIKnTpvtnsaxAyid+GFzU8pGqlOMrncxgJ0+hRIoT+Qzw0+BRrj02nUum2W61Wu5NmLSgCSNavXoQGoHmdEhqYaOAQRCCIgBCAONfh0hBQ6eatjcYqR5dtjhcIACmsAyo0xDWBnw27zbvSwCkPpgSwKBLLdR1ooWGNcUHZZtP9NIZlLc33rx6udJySjC8MFqhmOZlgPYqiSKZe93UA5ymYsMM53kUFyYapEhgeAF2Y8RBgvXYeTlIkrU6JMA0kq3SVswPgBADqJOMvJrm7Bqh0sVlSq5yqljlOADyAGq6H8d3wd57xwGO7xW5lYsuy4/DAwjIDob65PDAHwCHcYRozZN15TobxNVF/uRJZ8MkT5KkwYy0qVElN00Wd+RxZsrLPBkTAyTMgCPj7IgCirpNhg5CL/bQLCG4aOAEhiFDEe7AOwoTLHu9fFScVFvB4DJpGkt7rjbD+kW+n7bbUuL3r9dI91jv7/tz13YvFYifHxxsbe9HI//MLLqOoHBWFZtMAAAAASUVORK5CYII="
barrel_red:="iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAABnlBMVEUAAAAtFxFhYV8yHxthYV8tFxFJR0c6KyhFQkJ5eXcdHRx5eXcdHRxpaWcwGRQbGBYwLSxDHRaVk5FtbWswFg+ioqBtbWtTUlE7ODeRj41+fXtKIRYtFxFYV1VFQkKUlJJ6enhmZmQ0MTC1cE+mXT+YSi8jIiFYKBVkLRhSJhQ4NjV8Nh90Mh03GhC4dFOfUzdEIhI9HRGKiYaEOiEdHRwxHhYtFw+DgoCwakyKRS2QRCkqKCc1JSFlOSmdnZuWl5VoaGatZUhuMRxpMBo0IBkWFhV8e3lubWxQTkyZUTiJQig8LCZcMyRQLyQnHRo+IxaJcWdHRENQQj6iWDyTSS88Jx04IBZMJhONd2xyYltbU09YTEdBPj5CNDJCLypILiZ5OyWPPiQuJCJ2OCBeKxZLIRWRj413dXNZWFZVVFJyV01jUkyIVkJ+SDNePC1/Pyg4KiU+JSBNKh1HJx0jGhckEgsOCQiioqCQioZ/dG98bWhkYF2AZlxrWlWbZ1KWXERmS0J8UEGcWT1UPDZzRjUwLi1RNSsZDQqFdW6LW0reKr2QAAAAI3RSTlMAVVU5qqpVVTmqqlVVOePGqqo5HBzj4+PjxsbGxqqqjo6OjqddB5cAAAK6SURBVDjLbZN1dxpBFMUpSSAuTeredZbNKgu7LO7uEkESIO7u3rT91h2yAdI2d8/ZP+b+3sy778xonmp8YGBAq9WOa55XX987juPMZvP77u7/3ZdfOPPi6XQpopTTAb+d+zr0j/9qYbm0HXUbgdzR7Rm//fVfxNAhV951kyTPhxGgLLlTcgR6nx5vT+PGcFiSs6EMDHQTklYdnzq+ljvGwjTscrksEARZoMlJyLLGmXUdwLFar8kIDTdFI01J1SmHtg1EFlZJGGqWT4Ji9e9a4ZQ24PUf3WWay5aQJEkwZAHo5XHA1PJ7qFt7kkdgOFuVXBZ4c5OGM+EVsyL2PAL9Oez88OwSglxZ0AGdQSDo4swfTFD9qj8xsuXBVuxc8WLtBoJAAOn3eWAxZWKUkYkH4IVojeHGq4DdfpRMFovFZNLvX4okqITv4IUKUKjBJtPuq6lfCw6Hg1s8TUcogjGhB9QjwOas0+vwZkgyRjc2Nu63mTrBECbU95N9BLz1RMp5XQXdkfKc0UjgHizhRX37TF4FBlGcuE85p9bkOTctkySBEbn5Zn3BOqjuIGzlSVs6uLw0E7XZojuKFfX5DkSGUgR1B33cqtToatQwO2swGH6gqODbF0WCEdE9FegaBilCchYJV8qVSs4r7mN1ggVdCsNd6qTGTCAFH6JpcGFIjwdjjDhB5VFhrzXqMcabct6tIwgvIzJP4gW8mUIwUS2gq4EpIMU1aeTnQEysgYEUwKfACao+4ETsIYXNZovt7M5bUSHuZcSPmpb0uwTpjnVSCIKJZdi9QU1bn2M4ifO18lYkosTjJqLAslS8X9NRbzCGEzXejeFgzGyhwLBi3Kp20CLeTN9iICEOPpbKi1bDW9XvEN+cJyczlUaDzc+XQCvf235H3d3g4QaczmBwdFTzvMDT1+l0ev3TtT/trapAD1uiwQAAAABJRU5ErkJggg=="
goal:=" iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAV1BMVEVhTTxYRDRmUkGdAAA+BSf+AgHfAADAAAD/W1j/Ly14BSdvBSf5AADzAADlAACwAACUAABYAABSAAD/xsb/Pz/CISL/Ih/XAACmAACTAACFAAB4AABkAACMPgk4AAAAa0lEQVQ4y9XTRw6AMAwEQINTIJ3Qy//fyQdwCOQCex7JsuyF6iY5oE4kH8BFngAg8legEHUKjM3A3UYD1fYNt5KRAHk7ceE7EqzWGCGRBlq4WWKgR8C+eAxHak0WI4Ov3+IFKP/q8maVt/sEcfYFF7Qkxh8AAAAASUVORK5CYII="
PRESS_ENTER_TO_START :="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"
Project_2D :="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"

congratulation:="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"

FileCreateDir, boxxeltiles

tileset=01,02,03,06,07,08,09,14,barrel,barrel_red,goal,PRESS_ENTER_TO_START,Project_2D,congratulation

loop, parse, tileset, "`,"
{
 if !fileexist(a_scriptdir . "\boxxeltiles\" . a_loopfield . ".png")
 extract_tile(%a_loopfield%, a_scriptdir . "\boxxeltiles\" . a_loopfield . ".png")
}

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

return
