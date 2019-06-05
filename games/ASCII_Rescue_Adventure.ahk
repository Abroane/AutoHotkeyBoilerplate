
;ASCII Game Adventure v1.7
;autor: Speedmaster
;topic: https://autohotkey.com/boards/viewtopic.php?f=19&t=43403&p=196934#p196934
; This game is based on the "Beginner’s Guide to Roguelikes in C/C++" by Craig Stickel 
; tutorial: https://web.archive.org/web/20130305014438/http://www.kathekonta.com/rlguide/index.html
; source code in c++  https://ideone.com/fork/DEmy5u

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force

pico8:={black:"000000", dark_blue:"1D2B53", dark_purple:"7E2553", dark_green:"008751", brown:"AB5236", dark_gray:"5F574F", light_gray:"C2C3C7", white:"FFF1E8", red:"FF004D", orange:"FFA300", yellow:"FFEC27", green:"00E436", blue:"29ADFF", indigo:"83769C", pink:"FF77A8", peach:"FFCCAA"}

;walls, doors, floor, tree, grass, etc..
World=
(
11911111111111111111111111111
10000001008000000000000000001
10000001000000000000000000001
10000001111111112211111711001
10000006000000100001000001001
10000001000000100001000001001
10000001000000100001000001001
11111111000000000001000001001
10000001000000000001116111001
1000000a000000000000000001001
10000001000000000000000001001
10055006000000000000000001001
10000001000000000000000001001
10000001000000000000000001001
10000001111111122111111111001
10000001000000000000000000001
1000000a000000000000000000001
11111111111111111111111111111
)

;// Item map, overlaid on top of the world map

;potions, books, scrolls, armure, amulet, etc..
Items=
(
#############################
#000000#00000000000000000000#
#000000#00000000000000000000#
#000000###################00#
#000100#00000000000#00000#00#
#000000#00000000000#00300#00#
#000000#000000#0000#00000#00#
########000000#0000#00000#00#
#010000#000000#0000#######00#
#000000#00000000000000000#00#
#004000#00000000000000000#00#
#000000#00000000000000000#00#
#000000#00000001000000000#00#
#000000#00000000000000000#00#
#000000###################00#
#000000000000001000000000000#
#000000000000000000000005000#
#############################
)

Inventory=
(
1.|
2.|
3.|
4.|
5.|
6.|
7.|
8.|
9.|
0.|
)

virtualconsole:="You are in middle of nowhere...`nBeware! there are hungry monsters (M,J) `nsneaking around you (@) `nFind a way to get the key ("  chr(0165) ") `nUnlock the blue door (+)  `nand rescue Princess ASHKA (@)." 


Hotkeys=
(
KEYS

U: USE
G: GET
D: DROP
O: OPEN
C: CLOSE
)

;// create the Playing area (grid 1)
gui, font,, consolas
PutGridText(10,10,30,18,18,18,14,,-5,-3,"center 0x201 -border") 

gui, font,s12
gui,add, text, xp-70 yp+20 vplayerhp csilver, HP: 200


;// crate Player Inventory  (grid 2)
PutGridText(430,30,2,10,100,18,13,"silver",,,"left 0x201") 

;//schrink the first colum of the inventory grid
loop, %MaxRows_Grid2%
{
guicontrol,move, 2_1_%a_index%, w30  ; shrink the first column
guicontrol,move, 2_2_%a_index%, x459 ; move the second column at correct position
}


gui, font,italic, Lucida Console
gui, font,s10
gui,add, text, x435 yp+30  cqua caqua,  
gui,add, text, x435 yp+20 caqua, ASCII Rescue Adventure 
gui,add, text, x435 yp+20 cyellow, by SpeedMaster
gui,add, text, x435 yp+20 csilver, 
gui,add, text, x435 yp+20 csilver, 

;// create the virtual console  (grid 3 = fake console)
gui, font,, Lucida Console
putgridtext(10,300,1,10,500,18,10,"silver",,,"left -border") 

gui, font, normal
;// Grid showing player controls (grid 4)
PutGridText("580",10,1,10,100,18,13,"silver",,,"left -border 0x201")



gui, font,s12, Lucida Console
gui,add, text, x435 y10 csilver, INVENTORY



;// World Map
;// note: this function create an object DataWorld:{} from a variable
AgLoadDataMap("world")

;// Item map, overlaid on top of the world map
;// note: this function create an object DataItems:{} from a variable
AgLoadDataMap("items")

;// Draw Inventory slots on grid 2
AgLoadVarMap(Inventory,2, "|")  ;draw directly from a variable

;// Draw the virtual txt console (grid 3 = fake console)
AgLoadVarMap(virtualconsole,3, "|")  ;draw directly from a variable



AgLoadVarMap(hotkeys,4,"`r")  ;draw directly from a variable


;// Tile Types
TILE_ROCKFLOOR  := 0
TILE_WALL       := 1
TILE_CLOSEDDOOR := 2
TILE_OPENDOOR   := 3
TILE_GRASS      := 4
TILE_TREE       := 5
TILE_LOCKEDDOOR  := 6    ;// <-- NEW TILE!
TILE_CRACKED_WALL:= 7    ;// <-- NEW TILE!
TILE_HOLE        := 8    ;// <-- NEW TILE!
TILE_EXITDOOR    := 9    ;// <-- NEW TILE!
TILE_SWITCH      := "a"  ;// <-- NEW TILE!
TILE_LOCKEDDOOR_B:= "b"    ;// <-- NEW TILE!


TILE_TYPE:={ 0:[  "."  ,pico8.dark_gray  ,true  , "Rock_floor"  ]
            ,1:[  "#"  ,pico8.red        ,false , "Wall"        ]
            ,2:[  "="  ,pico8.orange     ,false , "Closed door" ]
            ,3:[  "/"  ,pico8.orange     ,true  , "Open Door"   ]
            ,4:[  "."  ,pico8.green      ,true  , "Grass"       ]
            ,5:[  "T"  ,pico8.green      ,false , "Tree"        ]
            ,6:[  "+"  ,pico8.orange     ,false , "Locked Door" ]
            ,7:[  "#"  ,pico8.red        ,false , "Cracked Wall"]
            ,8:[  "."  ,pico8.dark_gray  ,true  , "Hole"        ]
            ,9:[  "+"  ,"aqua"             ,false  ,"Exit Door" ]
            ,a:[  "#"  ,pico8.red        ,false  ,"Switch !","1_9_10","1_7_17"] }



;// Item Types
ITEM_NONE   := 0
ITEM_POTION := 1
ITEM_ROCK   := 2
ITEM_KEY    := 3     ;// <-- New item
ITEM_PICKAXE    := 4     ;// <-- New item
ITEM_SCROLL    := 5     ;// <-- New item

ITEM_TYPE:={ 0:[  " "     ,pico8.dark_gray  ,"empty"     ]
            ,1:[  "!"     ,pico8.blue       ,"Potion", 60]
            ,2:[  "*"     ,pico8.light_gray ,"Rock"      ] 
            ,3:[chr(0165) ,pico8.light_gray ,"Key", "You find an old key. It's dirty and rusty, but it looks like it would still work."]
            ,4:[  "("     ,pico8.brown      ,"Pickaxe"   ] 
            ,5:[  "?"     , "green"         ,"Scroll"    ] }


;// Specify the limit of the palying area
MAP_WIDTH  := 30
Map_HEIGHT := 18


;// The player's location on the current map
PLAYER:="1_16_10"  ;Player is on grid 1 col 16 row 10


;// The player's health
HP:=200

;// The player's inventory
Inventory:=[0,0,0,0,0,0,0,0,0,0]


;// Draw the world map
;AgDrawDataMap(dataworld)   ;  call the function drawtile to draw from the previously created object DataWorld:{}  
AgDrawDataMap(dataworld,1,"Drawtile")

;// Draw the Items
AgDrawDataMap(dataItems,1,"drawitem",0) ; call the function drawtitem to draw from the previously created object DataItems:{}  


;// DrawMap Function & DrawItem Function //////////////////////////////////////////////////////////////////////
;//
;//	This function draws the entire map to the screen.
;//

AgDrawDataMap(datagrid, gridnumber:=1, function_name:="", Bypass_Values_List:="")
{

global
 ;funtion_name is the function to call for drawing the datas
  For Col, Rows In datagrid
   For Row, value In Rows
    {
     cell_to_draw=%gridnumber%_%col%_%row%
     if value is xdigit
    if value not in %Bypass_Values_List%
        %function_name%(cell_to_draw, value)
    }
}

;//////////////////////////////////////////////////////////////////////////
;//
;//	Draws a map tile for the map coordinates specified. (in cellvar)
;//

 DrawTile( cellvar, TILE_Value)
{
global
    drawchar(cellvar, TILE_TYPE[TILE_Value].1)
    colorcell(cellvar, TILE_TYPE[TILE_Value].2)
    DataWorld[draw2][draw3]:=TILE_Value
}


;//////////////////////////////////////////////////////////////////////////
;//
;//	Draws an item on the map at the coordinates specified (in cellvar).
;//

 DrawItem( cellvar, Item_Value)
{
global
    drawchar(cellvar, Item_TYPE[Item_Value].1)
    colorcell(cellvar, Item_TYPE[Item_Value].2)
    dataItems[draw2][draw3]:=Item_Value
}

;////////////////////////////////////////////////////////////////////////////////////////////



gui, color, black
;gui, color, yellow
gui, +resize
gui, show,, ASCII Rescue Adventure v1.7 ;w800 h800


;// Draw the a Non Playing Character (NPC) = Princess ASHKA
Npc:=New actor
;// Changes how the actor appears in the game world
npc.setappearance( "@", pico8.pink)
;// Changes the position of the actor
;npc.setpos( 1,28,15)
npc.setpos( 1,5,7)
;// Give a name to NPC
npc.setname("ACHKA")
;// restore HP
npc.setdamage(1)
;// Draws the actor to the screen
npc.draw()

;// Now all we need to do is get the computer to draw the ' @ ' character 
;   at that precise location on the grid 1. To do that we need the following code.

; // Draw the player to the screen
drawchar(player, "@", pico8.green)
lookdata()


MAX_ACTORS:=20

;// List of actors
ActorList:=[]           ;     <--- List declaration added here
loop, %MAX_ACTORS%
{
if a_index < Max_Actors
;// Initialize the list to be empty
ObjRawSet(ActorList, A_index, 0)
}


;// Create a bunch of actors
loop, 12  ; create 12 "orc" monsters
{
;// Draw the a Non Playing Character (NPC)
Orc%a_index%:=New actor

orc%a_index%.setname("orc" . a_index)

;// Changes how the actor appears in the game world
orc%a_index%.setappearance( "M", pico8.dark_green)

orc%a_index%.setdamage(-50)


;//keep trying until we find a set of coordinates that is passable
loop,
   {
   Random, PX, 1, %MAP_WIDTH%
   Random, PY, 1, %MAP_HEIGHT%
   posm:="1_" px "_" py
   if ispassable(Px, Py)
   if  (posm != player)
   break
   }

;// Changes the position of the actor
orc%a_index%.setposx(PX)
orc%a_index%.setposy(PY)
;// add actor to the list
AddActorToList("orc" . a_index)
}


loop, 8 ; create 8 "J" Monster
{
;// Draw the a Non Playing Character (NPC)
Jmonster%a_index%:=New actor

Jmonster%a_index%.setname("Jmonster" . a_index)

;// Changes how the actor appears in the game world
Jmonster%a_index%.setappearance( "J", pico8.yellow)

Jmonster%a_index%.setdamage(-80)


;//keep trying until we find a set of coordinates that is passable
loop,
   {
   Random, PX, 1, %MAP_WIDTH%
   Random, PY, 1, %MAP_HEIGHT%
   posm:="1_" px "_" py
   if ispassable(Px, Py)
   if  (posm != player)
   break
   }

;// Changes the position of the actor
Jmonster%a_index%.setposx(PX)
Jmonster%a_index%.setposy(PY)
;// add actor to the list
AddActorToList("Jmonster" . a_index)
}


for each, val in actorlist

       ; // draw each NPC
        if val != 0
        {
            i:=a_index
            ;// If so, use it!
            ActorList[i].draw()
        }



updatelist()
{
global
for each, val in actorlist

       ; // Update and draw each NPC
        if val != 0
        {
            i:=a_index
            ;// If so, use it!
            ActorList[i].Update() 
            ActorList[i].draw()
            ActorList[i].hitplayer()
        }
}




AddActorToList(Name)
{
global
     for each, val in actorlist

       ; // Found an open slot?
        if val=0
        {
            FREE_Val:=a_index
            ;// If so, use it!
            ActorList[FREE_Val] := %name% ;:= New Actor 
            
            ;// Finished! Report success
            return true 
        }
    ;// Couldn't find a free slot. Report failure.
    return false
}


RemoveActorFromList(Name)
{
global
   ; // Run through the list, looking for the specified actor instance.
     for each, val in actorlist
    {
       ; // Is this the actor?
        if ( ActorList[a_index] = %Name% )
        {
            ;// clear actor from the screen
            %name%.clear()

            ;// If so, deallocate it!
            ;delete Actor;
            ActorList.Delete(a_index)
          
            ;// Clear the slot, allowing it to be used again.
            ActorList[a_index] := 0
           
            ;// Finished! Report success
            return true
        }
    }
    
    ;// Couldn't find the actor in the list. Report failure.
    return false
}

;--------------------------------------------------------------

;//////////////////////////////////////////////////////////////////////////////
;//
;// Player movements
;//

~up::
if gameover
return

;// save currenttilevalue and currentitemvalue
lookdata()

;// Look ahead to see if we can enter this location
player:=agmove(player,"y",-1)
gosub, check_if_passable

;// Prevents key from executing more than once
keywait, up 
return

~down::
if gameover
    return

;// save currenttilevalue and currentitemvalue
lookdata()

;// Look ahead to see if we can enter this location
player:=agmove(player,"y",1)
gosub, check_if_passable

;// Prevents key from executing more than once
keywait, down
return

~left::
if gameover
    return

;// save currenttilevalue and currentitemvalue
lookdata()

;// Look ahead to see if we can enter this location
player:=agmove(player,"x",-1)
gosub, check_if_passable

;// Prevents key from executing more than once
keywait, left
return

~right::
if gameover
    return

;// save currenttilevalue and currentitemvalue
lookdata()

;// Look ahead to see if we can enter this location
player:=agmove(player,"x", 1)
gosub, check_if_passable

;// Prevents key from executing more than once
keywait, right
return


;---------------------------------------------------------------------

check_if_passable:
;// See if the player can move to the new position
if ispassable(nx, ny)  ; nx= new pos x  ; ny= new pos y
{
    global player
;// Draw the player to the new position
drawchar(player,"@", pico8.green)


;Draw the previously saved tile value to the previous position 
drawtile(previous, currenttilevalue)

;; // Is there an item present at this location?
if CurrentItemValue != % ITEM_NONE
if CurrentItemValue is xdigit           ; is number or hexadecimal number
drawitem(previous, currentitemvalue)

lookdata() ; update current item an tile value

;// virtural console report
if % Item_TYPE[currentitemvalue].3 != "empty"
consoledrawline(4, pico8.yellow, Item_TYPE[currentitemvalue].3) ;if player stands on item report item
else
consoledrawline(4,pico8.yellow," ") ; clear console line 4

  if % Item_TYPE[currentitemvalue].3 = "key"    {
    consoleclear()
    consoledrawline(2, "silver", "You find an old key. It's dirty and rusty,")
    consoledrawline(3, "silver", "but it looks like it would still work.") 
    }
   else if % Item_TYPE[currentitemvalue].3 = "pickaxe"    {
    consoleclear()
    consoledrawline(2, "silver", "You find a pickaxe under an old, ")
    consoledrawline(3, "silver", "mossy oak tree.") 
    }
        else
        consoleclear()
    
    
}
else
{
savedprevious:=previous

;// report obstacle to the user
lookdata()
consoledrawline(4, pico8.yellow, TILE_TYPE[currenttilevalue].4)
settimer, consoleclearline4, -1000 ; clear console line 4 after 1 sec



;// Don't move the player >> restore previous player postition
previous:=savedprevious
player:=previous
lookdata()




if (dataworld.8.5 = 6) 
if (player="1_9_5") 
    {
    consoleclear()
    consoledrawline(2, "silver", "This door is locked. If only you had the key,")
    consoledrawline(3, "silver", "you might be able to save the princess..") 
    }

}

;update monsters
updatelist()

;update princess
npc.Update()
npc.hitplayer()
npc.draw()

              
;//This secret tile location opens the blue door 
if (currenttilevalue=8) ;if player stands on this tile (8)
{
    tile_type.9.3:=true   ; make this tile passable
    tile_type.9.1:="/"    ; open the blue door
    drawchar("1_3_1", "/")
}
else ; if player don't stand on this tile (8)
{
       if  (tile_type.9.3=true)
       if (dataitems.11.2 != 2) ; and if there is not item rock on this location
    {
        tile_type.9.3:=false ; make this tile not passable
        tile_type.9.1:="+"   ; close the blue door
        drawchar("1_3_1", "+")
    }
}

if (dataitems.11.2=ITEM_ROCK) ; if player drop a rock on this tile location (1_11_2) 
{
    if (tile_type.9.3 != true)  
    {
      tile_type.9.3:=true      ; make this tile passable
      drawchar("1_3_1", "/")   ; open the blue door
    }      
}



;one way tile
if (player=tile_type.a.5) || (player=tile_type.a.6)
tile_type.a.3:=true   
else
tile_type.a.3:=false



check_if_Win:
if (player="1_3_1") 
    victory()


check_if_gameover:
if (hp<=0)
   gameover()
return

waitmessage:
consoleclear()
return

ConsoleClearLine4:
consoledrawline(4, pico8.yellow, " ") ;clear the line
if % Item_TYPE[currentitemvalue].3 != "empty"
consoledrawline(4, pico8.yellow, Item_TYPE[currentitemvalue].3) ;if player stands on item report item
return


;// Hokeys
;----------------------------------------------------------------------

;// Open door
~o::
    ;// @@@ do stuff @@@
    OpenDoorCommand()
    return

;// Close door
~c::
    ;// @@@ do stuff @@@
    CloseDoorCommand()
    return

;// Ûse Item
~u::
UseItemCommand()
return

;// Get Item
~g::
GetCommand()
return

;// Drop Item
~d::
DropCommand()
return


;// Click on grid
clickcell:
msgbox, % a_guicontrol
return


guiclose:
esc:: 
exitapp 
return


;²::
;listvars
;return


;// OpenDoorCommand Function //////////////////////////////////////////////////////////////
;//
;//  User command function which and then attempts to convert a closed door to an open one
;//  at the tile specified by the user.
;//
  OpenDoorCommand()
{
global
consoleclear()

    ;// Draw some notification to the user
consoledrawline(1, pico8.white, "Open Door: Which direction?")


    ;// Let the user decide where to look
    Suspend on ; suspend others hotkeys

    ;// detect with errorlevel selected direction
    Input, selected_direction, L1, {UP}{down}{left}{right} ; set a MatchList of admissible characters
    if ErrorLevel = EndKey:Up
{
     ;// NORTH
     deltaY=-1
     deltaX=0
}
else if ErrorLevel = EndKey:Down
{
     ;// SOUTH
     deltaY=1
     deltaX=0
}
else if ErrorLevel = EndKey:Left
{
     ;// WEST
     deltaY=0
     deltaX=-1
}
else if ErrorLevel = EndKey:Right
{
     ;// EAST
     deltaY=0
     deltaX=1
}

    ;// Verify that this is a valid direction
else  if ErrorLevel = MAX
    ;// Complain to the user (Errorlevel has no EndKey so the user typed the wrong key)
       {
       colorcell("3_1_1", pico8.red)
       drawchar("3_1_1", "Not a valid direction")
       sleep, 2000
       clearcell("3_1_1")
       Suspend off ; enable hotkeys
       return ;Arbort
       }

    Suspend off ; enable hotkeys

    ;// Is there a closed door present in the direction specified?
    if   (  DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_CLOSEDDOOR )
    {
        ;// If there is a closed door, change it to an open one
         nextX:=PlayerX+deltax
         nextY:=Playery+deltay
         nextXY=1_%nextX%_%nextY%
         drawtile(nextxy, TILE_OPENDOOR)
         DataWorld[PlayerX+deltaX][PlayerY+deltaY] := TILE_OPENDOOR

        ;// Report message to the console
        consoledrawline(2,pico8.green, "You opened the door")
        settimer, waitmessage, -2000

    }
    else if (DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_LOCKEDDOOR ) || if (DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_EXITDOOR )
    {
    ;// Complain to the user "You need a key"
    consoledrawline(2,pico8.red, "Try to unlock the door first")
    settimer, waitmessage, -2000
    }
    else
    {
    ;// Complain to the user "No closed door present"
    consoledrawline(2,pico8.red, "No closed door present at this direction")
    settimer, waitmessage, -2000
    }
}


;// CloseDoorCommand Function //////////////////////////////////////////////////////////////
;//
;//  User command function which and then attempts to convert a open door to an Close one
;//  at the tile specified by the user.
;//
  CloseDoorCommand()
{
global
    ;// Draw some notification to the user
    drawchar("3_1_1", "Close Door: Which direction?", pico8.white)

    ;// Let the user decide where to look
    Suspend on ; suspend others hotkeys

    ;// detect with errorlevel selected direction
    Input, selected_direction, L1, {UP}{down}{left}{right} ; set a MatchList of admissible characters
    if ErrorLevel = EndKey:Up
{
     ;// NORTH
     deltaY=-1
     deltaX=0
}
else if ErrorLevel = EndKey:Down
{
     ;// SOUTH
     deltaY=1
     deltaX=0
}
else if ErrorLevel = EndKey:Left
{
     ;// WEST
     deltaY=0
     deltaX=-1
}
else if ErrorLevel = EndKey:Right
{
     ;// EAST
     deltaY=0
     deltaX=1
}

    ;// Verify that this is a valid direction
else  if ErrorLevel = MAX
    ;// Complain to the user (Errorlevel has no EndKey so the user typed the wrong key)
       {
       consoledrawline(2, pico8.red, "Not a valid direction")
       settimer, waitmessage, -2000
       Suspend off ; enable hotkeys
       return ;Arbort
       }

    Suspend off ; enable hotkeys

    ;// Is there a open door present in the direction specified?
    if   (  DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_OPENDOOR )
    {
        ;// If there is a open door, change it to an Close one
         nextX:=PlayerX+deltax
         nextY:=Playery+deltay
         nextXY=1_%nextX%_%nextY%
         drawtile(nextxy, TILE_CLOSEDDOOR)
         DataWorld[PlayerX+deltaX][PlayerY+deltaY] := TILE_CLOSEDDOOR

        ;// Report message to the console
         consoledrawline(2,pico8.green, "You Closed the door")
         settimer, waitmessage, -2000
    }
    else
    {
    ;// Complain to the user "No open door present"
    consoledrawline(1, pico8.red, "No open door present at this direction")
    settimer, waitmessage, -2000
    }
}



lookdata()  ; report wat there is at current player position in data grids 
{
global
PlayerX:=agmove(player,"ex")   ;ex= extract X position of player
PlayerY:=agmove(player,"ey")   ;ey= extract Y poisiotn of player
currenttilevalue:= DataWorld[PlayerX][PlayerY]  
currentItemvalue:= dataItems[PlayerX][PlayerY]   
}


;// GetCommand Function ///////////////////////////////////////////////////////////////////
;//
;//	User command function which attempts to pick up an item lying on the ground. 
;//

GetCommand()
{
global
    ; // First check to see if there's actually an item present
    if % (CurrentItemValue = ITEM_NONE  || currentItemValue = "#")            ;ITEM_NONE = item empty " " = 0
      {
       ;// Complain to the user "No open door present"
        consoledrawline(1, pico8.red, "nothing to pick up !")
        settimer, waitmessage, -2000
        ;msgbox, nothing to pickup !
        return
      }

    ;// Run through the inventory, checking for the first available slot
     for each, val in inventory

       ; // Found an open slot?
        if val = % ITEM_NONE
        {
            ;// If so, move the item to the slot and remove it from the world
            FREE_SLOT:=a_index
            Inventory[Free_Slot] := CurrentItemValue
            DataItems[PlayerX][PlayerY] :=  ITEM_NONE   ;remove it from the data Items grid
            
            ;// draw collected item to inventory grid 
            free_slot_grid = 2_2_%Free_Slot% ; >> grid (2) col (2) row (free_slot)
            drawchar(free_slot_grid, ITEM_TYPE[CurrentItemValue].3)
            colorcell(free_slot_grid, ITEM_TYPE[CurrentItemValue].2)
            
            ;//report success to the user
            consoleclear()
            consoledrawline(1,pico8.white,"You picked up a " . item_type[CurrentItemValue].3 )
            settimer, waitmessage, -1500
            settimer, consoleclearline4, -1 ; clear console line 4

            ;//update current tile and item value
            lookdata()

            ;// Finished the command
            return
        }

    ;// If execution gets here, it means that there is no open slots available. So
    ;// complain about it somehow and then abort
    msgbox, No open slot avialble in Inventory    
    return     ;// ABORT!

}


;// DropCommand Function //////////////////////////////////////////////////////////////////
;//
;//	User command function which drops a user-designated item to the ground.
;//
DropCommand()
{
global
    INVENTORY_SLOTS:="1,2,3,4,5,6,7,8,9,0"      ; set a MatchList of admissible input characters

    ;// Ask the user which inventory slot they're trying to drop
    Suspend on ; suspend others hotkeys
    consoledrawline(1, pico8.white, "Drop from which slot? 0-9")

    ;record:= record . "`r`n" . "__ed@"

    ;// Save the keypress in variable Slot
    Input, Slot, L1,, %INVENTORY_SLOTS%
    if slot=0   ;convert key press zero to slot 10
       slot=10

    Suspend off ; enable hotkeys

    ;// Verify that this is a valid slot
    if ErrorLevel != Match
       ;// if not, Complain to the user
       {
        consoledrawline(2, pico8.red, "Invalid slot")
        settimer, waitmessage, -2000  ;clear the console after 2 sec
       }

    ;// Verify that there actually is something present in this slot
    else if  Inventory[Slot] = ITEM_NONE  ; if inventory slot is empty
        ;// if not, Complain to the user
        {
        consoledrawline(2, pico8.red, "No item present on this slot")
        settimer, waitmessage, -2000  ;clear the console after 2 sec
        }

    ;// Verify that there's room on the ground to actually drop this
    else if % (CurrentItemValue != ITEM_NONE  and currentItemValue != "#")
        ;// if not, Complain to the user
        {
        consoledrawline(2, pico8.red, "No room to drop item")
        settimer, waitmessage, -2000  ;clear the console after 2 sec
        }
         

    else

       {
     ;// Place the item on the ground
        DataItems[PlayerX][PlayerY] :=  Inventory[Slot] ;update data items
     ;// report succes to the user 
        consoledrawline(1, pico8.green, "You droped a " . ITEM_TYPE[Inventory[Slot]].3)
        settimer, waitmessage, -2000  ;clear the console after 2 sec
        Inventory[Slot] := ITEM_NONE  ;clear inventory data slot
     ;// clear the slot on the inventory grid
        slot_grid_erase = 2_2_%Slot%
        drawchar(slot_grid_erase, " ") 
     ;//update current tile and item value
        lookdata() 
     ;// report current view to the player
        if % Item_TYPE[currentitemvalue].3 != "empty"
        consoledrawline(4, pico8.yellow, Item_TYPE[currentitemvalue].3)     
        }

       ;msgbox, % ErrorLevel

}

;// UseItemCommand Function ///////////////////////////////////////////////////////////////////////
;//
;//	User command function which uses a selected item.
;//
UseItemCommand()
{
global
    INVENTORY_SLOTS:="1,2,3,4,5,6,7,8,9,0"      ; set a MatchList of admissible characters

    ;// Ask the user which inventory slot they're trying to use
    Suspend on ; suspend others hotkeys
    consoleclear()
    consoledrawline(1, pico8.white,"Use which item?") 

    ;// Save the keypress in variable Slot
    Input, Slot, L1,, %INVENTORY_SLOTS%
    if slot=0   ;convert key press zero to slot 10
       slot=10

    Suspend off ; enable hotkeys

    ;// Verify that this is a valid slot
    if ErrorLevel != Match
       ;// if not,  Complain to the user
       {
        consoledrawline(1, pico8.red, "Invalid slot")
        settimer, waitmessage, -1500
       }

    ;// Verify that there actually is something present in this slot
    else if  Inventory[Slot] = ITEM_NONE  ; if inventory slot is empty
        ;// if empty, Complain to the user
        {
        ConsoleDrawLine(1, pico8.red, "No item present on this slot")
        settimer, waitmessage, -1000  ;clear the console after 1 sec
        }
        ;// The item selected is a potion
    else if  Inventory[Slot] = ITEM_POTION  ; if inventory slot is a potion
        {
        ;// Give a message to the user
        consoledrawline(1, pico8.Green, "You drink the potion.")
        consoledrawline(2, pico8.Blue, "*burp!*")
        consoledrawline(3, "fuchsia", "Health " ITEM_TYPE.1.4)

        ;// Wipe the screen
        settimer, waitmessage, -2000  ;clear the console after 2 sec

        ;// remove it from the inventory data
        Inventory[Slot] := ITEM_NONE

        ;// remove it from inventory grid
        slot_grid_erase = 2_2_%Slot%
        clearcell(slot_grid_erase)
        
        ;// increment Health Power
        hp:=hp + ITEM_TYPE.1.4    
        guicontrol,, playerhp, %hp%
        
        }

        ;// Item selected is a pickaxe
    else if  Inventory[Slot] = ITEM_PICKAXE
         UsePickaxe()  ; // <--- MUCH CLEANER!

        ;// Item selected is a key
    else if  Inventory[Slot] = ITEM_KEY
         UseKey()  ; // <--- MUCH CLEANER!

        ;// Item selected is a scroll
    else if  Inventory[Slot] = ITEM_SCROLL
    {
         UseScroll()  ; // <--- MUCH CLEANER!
        ;// remove it from the inventory data
        Inventory[Slot] := ITEM_NONE
        ;// remove it from inventory grid
        slot_grid_erase = 2_2_%Slot%
        clearcell(slot_grid_erase)
        settimer, waitmessage, -4000
     }


    ; // Don't know what the item is
    else if  Inventory[Slot] != ITEM_NONE  ; if inventory slot is not empty
        ; // Complain to the user
        {
        consoledrawline(1, pico8.red, "Don't know how to use this item!")
        settimer, waitmessage, -2000
        }        


} ; end else if



;// UsePickaxe Function ///////////////////////////////////////////////////////////////////////////
;//
;//	Invoked whenever the player requests to use a pickaxe. Destroys a wall and leaves a rock.
;//
UsePickaxe()
{

global
    ;// Draw some notification to the user
    consoledrawline(2, pico8.white, "Use pickaxe: which direction?")

    ;// Let the user decide where to look
    Suspend on ; suspend others hotkeys

 ;// Compute which tile the user specified

    ;// detect with errorlevel selected direction
    Input, selected_direction, L1, {UP}{down}{left}{right} ; set a MatchList of admissible characters
    if ErrorLevel = EndKey:Up
{
     ;// NORTH
     deltaY=-1
     deltaX=0
}
else if ErrorLevel = EndKey:Down
{
     ;// SOUTH
     deltaY=1
     deltaX=0
}
else if ErrorLevel = EndKey:Left
{
     ;// WEST
     deltaY=0
     deltaX=-1
}
else if ErrorLevel = EndKey:Right
{
     ;// EAST
     deltaY=0
     deltaX=1
}

    ;// Verify that this is a valid direction
else  if ErrorLevel = MAX
       ;// Complain to the user (Errorlevel has no EndKey so the user typed the wrong key)
       {
       consoledrawline(2, pico8.red, "Not a valid direction")
       settimer, waitmessage, -2000
       Suspend off ; enable hotkeys
       return ;Arbort
       }

    Suspend off ; enable hotkeys

    ;// if there is a rock wall change it to a rock floor
    if   (  DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_CRACKED_WALL)
    {
        ;// Change the selected tile from a wall to a rock floor
         nextX:=PlayerX+deltax
         nextY:=Playery+deltay
         nextXY=1_%nextX%_%nextY%
         drawtile(nextxy, TILE_ROCKFLOOR)   ;remove the wall
         drawItem(nextxy, ITEM_ROCK)

        ;// Report message to the console
         consoleclear()
         consoledrawline(1,pico8.green, "You smash the stones to pieces.")
         settimer, waitmessage, -2000
    }
    else
    ;// Abort if there isn't a rock wall present at the selected direction
    {
    ;// Complain to the user "No rock wall present"
    consoledrawline(1, pico8.red, "Can't use that item here!")
    settimer, waitmessage, -2000
    }


}

;// UseScroll Function ///////////////////////////////////////////////////////////////////////////////
;//
;//	the only item that can kill a monster
;// 
;//

UseScroll()
{
global pico8, actorlist
    consoledrawline(1, pico8.white, "You read the scroll... ")
    consoledrawline(2, pico8.blue, "Kill Neighbor Monsters !")

;playerN, S, E, W, NE, NW, SE, SW
neighbor:=[agmove(player,"y",-1),agmove(player,"y", 1),agmove(player,"X", 1),agmove(player,"X",-1),agmove(player,"xy", 1,-1),agmove(player,"xy",-1,-1),agmove(player,"xy", 1, 1),agmove(player,"xy",-1, 1)]


for each, val in neighbor
{
for i, j in actorlist
    for k, l in j
    if (l=val)
     {
      RemoveActorFromList(actorlist[i].name)
     }

}

}    



;// UseKey Function ///////////////////////////////////////////////////////////////////////////////
;//
;//	Invoked whenever the player requests to use a key. Converts a locked door to an open door,
;// 	and vice-versa.
;//

UseKey()
{
global
    ;// Draw some notification to the user
    consoledrawline(2, pico8.white, "Use key: which direction?")

    ;// Let the user decide where to look
    Suspend on ; suspend others hotkeys

 ;// Compute which tile the user specified

    ;// detect with errorlevel selected direction
    Input, selected_direction, L1, {UP}{down}{left}{right} ; set a MatchList of admissible characters
    if ErrorLevel = EndKey:Up
{
     ;// NORTH
     deltaY=-1
     deltaX=0
}
else if ErrorLevel = EndKey:Down
{
     ;// SOUTH
     deltaY=1
     deltaX=0
}
else if ErrorLevel = EndKey:Left
{
     ;// WEST
     deltaY=0
     deltaX=-1
}
else if ErrorLevel = EndKey:Right
{
     ;// EAST
     deltaY=0
     deltaX=1
}

    ;// Verify that this is a valid direction
else  if ErrorLevel = MAX
       ;// Complain to the user (Errorlevel has no EndKey so the user typed the wrong key)
       {
       consoledrawline(2, pico8.red, "Not a valid direction")
       settimer, waitmessage, -2000
       Suspend off ; enable hotkeys
       return ;Arbort
       }

    Suspend off ; enable hotkeys

   ;// If there's a locked door in the tile the user's specified, unlock it
    if   (  DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_LOCKEDDOOR )
    {
        ;// Change the selected tile from a Locked door to a Closed door
         nextX:=PlayerX+deltax
         nextY:=Playery+deltay
         nextXY=1_%nextX%_%nextY%

        ;// Unlock the door
         drawtile(nextxy, TILE_CLOSEDDOOR)  

        ;// Let the user know everything went well
         consoleclear()
         consoledrawline(1,pico8.green, "You unlock the door with the key.")
         settimer, waitmessage, -2000
    }

   ;// Lock an unlocked door
    else if (  DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_CLOSEDDOOR )
        {

        ;// Change the selected tile from a Unlocked door to a Locked door
         nextX:=PlayerX+deltax
         nextY:=Playery+deltay
         nextXY=1_%nextX%_%nextY%

         ;// Lock the door
         drawtile(nextxy, TILE_LOCKEDDOOR)  
        
         ;// Let the user know everything went well
         consoleclear()
         consoledrawline(1,pico8.green, "You lock the door.")
         settimer, waitmessage, -2000


        }

   ;// Catch when the user tries to lock an open door just to warn them
    else if (  DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_OPENDOOR )
         {
          ;// Warn the user
          consoledrawline(2, pico8.red, "Try closing the door first.")
          settimer, waitmessage, -2000
         }

   ;// Catch when the user tries to unlock the exit door to warn them
    else if (  DataWorld[PlayerX+deltaX][PlayerY+deltaY] = TILE_EXITDOOR )
         {
          ;// Warn the user
          consoledrawline(2, pico8.red, "You notice that this door has no lock.")
          settimer, waitmessage, -2000
         }



    else if (  DataWorld[PlayerX+deltaX][PlayerY+deltaY] != TILE_CLOSEDDOOR )
    ;// Abort if there isn't a door present at the selected direction
    {
    ;// Complain to the user
    consoledrawline(1, pico8.red, "Can't use that item here!")
    settimer, waitmessage, -2000
    }

}



;// IsPassable Function ///////////////////////////////////////////////////////////////////////////
;//
;//	This function analyzes the coordinates of the map array specified and returns
;//	true if the coordinate is passable (able for the player to occupy), false if not.
;//

IsPassable(npX, npy)
{
global
    ;// Store the value of the tile specified 
    tilevalue:= DataWorld[npX][npy]        ;npx = new pos x   npy = new pos y

    ;// Before we do anything, make sure that the coordinates are valid
    if % (npX < 1 || npX >= MAP_WIDTH || npy < 1 || npy >= MAP_HEIGHT)
        return false

    ;// Return true if it's passable
    ;if % ( TileValue == TILE_FLOOR || TileValue == TILE_GRASS || TileValue == TILE_OPENDOOR )
     if Tile_type[TileValue].3
        return true

     ;// If execution get's here, it's not passable
        return False

}


;//////////////////////////////////////////////////////////////////////////////////////////
;//
;//	Draw a message to the console (grid 3 simulate a console)
;//

consoledrawline(line:=1, color:="", message="")
{
    lineconsole=3_1_%line%
    drawchar(lineconsole, message, color)
}


;//////////////////////////////////////////////////////////////////////////////////////////
;//
;//	clear the console (grid 3 simulate a console)
;//
consoleclear()
{
    clearcell("3_1_1")
    clearcell("3_1_2")
    clearcell("3_1_3")
   ; clearcell("3_1_4")
    clearcell("3_1_5")
    clearcell("3_1_6")
}



;//////////////////////////////////////////////////////////////////////////////////////////
;//
;//	Game over message
;//
Gameover()
{
    global
    settimer, waitmessage, off
    gameover:=1
    consoledrawline(2, pico8.red, "OH NO ! YOU ARE DEAD !")
    consoledrawline(3, pico8.orange, "GAME OVER")
}


;//////////////////////////////////////////////////////////////////////////////////////////
;//
;//	Victory 
;//

Victory()
{
    global
    settimer, waitmessage, off
    gameover:=1
    npc.clear() ; clear princess
    npc.setpos( 1,3,2) ;move princess behind you
    npc.draw() ; draw the princess
    consoledrawline(2, pico8.Green, "CONGRATULATION !")
    consoledrawline(3, pico8.orange, "You saved Princess Ashka")
    sleep, 1500
    clearcell(player)
    npc.clear() ; clear princess
    npc.setpos(player) ;move princess behind you
    npc.draw()
    sleep, 1500
    npc.clear() ; clear princess
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

class Actor
{
    Name:= "Monster"

    ;// ASCII character code used to draw the actor to the screen
	DisplayChar := "X"
    ;// Color code for this actor
    ColorCode := "Green"
    ;// Grid number where the actor moves
    PosZ:=1
    ;// Horizontal coordinate of the actor, relative to the grid's origin
    PosX:=2
    ;// Vertical coordinate of the actor, relative to the grid's origin.
    PosY:=2
    ;//Position of the actor on grid
	Position := this.PosZ . "_" . this.PosX . "_" . this.PosY
    ;//Damage
    Damage:=0



        SetName(Name)
        {
         this.Name:=Name
        }   
      
        ;// Changes how the actor appears in the game world
        SetAppearance(DisplayChar, DisplayColor )
        {
         this.DisplayChar:=DisplayChar
         this.ColorCode:=DisplayColor
        }
        
        ;// Changes Damage
        SetDamage(Damage)
        {
         this.Damage:=Damage
        }

        ;// Changes the position of the actor
        SetPos( PosZ:="1" , PosX:="2" , PosY:="2" )
        {
         global MAP_WIDTH, MAP_HEIGHT

         ;// Don't change anything if the new coordinates are invalid
         if % (PosX < 1 || PosX >= MAP_WIDTH || PosY < 1 || PosY >= MAP_HEIGHT)
         return false

         ;// Move the actor to the coordinates specified
         this.position := PosZ . "_" . PosX . "_" . PosY
         this.Posz:=PosZ
         this.Posx:=PosX
         this.posy:=PosY
        }


        SetPosX( PosX:="1" )
        {
        this.SetPos( this.PosZ , PosX , this.PosY )
         }

        SetPosY( PosY:="1" )
        {
        this.SetPos( this.PosZ , this.PosX , PosY )
         }

        SetPosZ( PosZ:="1" )
        {
        this.SetPos( PosZ , this.PosX , this.PosY )
         }


        ;// Draw the actor as it wants to be drawn
        draw()
         {
          global MAP_WIDTH, MAP_HEIGHT
          drawchar(this.position,this.DisplayChar, this.colorcode)
              
         }


 IsPassable(DataWallX, DataWallY)
 {
  global

    ;// Store the value of the tile specified 
    tilev:= DataWorld[DataWallX][DataWallY]        ;nx = new x   ny = new y (global variables)
 

    ;// Before we do anything, make sure that the coordinates are valid
  if % (this.PosX < 1 || this.PosX >= MAP_WIDTH || this.PosY < 1 || PosY >= MAP_HEIGHT)
        return false 

    ;// Return true if it's passable
    ;if % ( TileValue == TILE_FLOOR || TileValue == TILE_GRASS || TileValue == TILE_OPENDOOR )
     if Tile_type[tilev].3
        return true

     ;// If execution get's here, it's not passable
        return False

}


 update()
 {
 global deltaX, deltaY, prv, tilev, Tile_type, item_type, savecurrenttilev, savecurrentItemv, dataworld, DataItems, Item_None, player, nl

 savecurrenttilev:=DataWorld[this.PosX][this.PosY] 
 savecurrentItemv:=DataItems[this.PosX][this.PosY]

 prv:=this.position

 ;// Generate a new set of deltas for this actor
 Random, DeltaX, -1, 1
 Random, DeltaY, -1, 1


 randomcell := this.PosZ . "_" . this.PosX+DeltaX . "_" . this.PosY+DeltaY

 
    ;// See if this new position is allowed
     if (%randomcell% != 1)
    if( this.IsPassable(this.PosX+DeltaX, this.PosY+DeltaY) )
    {
        Opencell:=this.position
        %opencell%:=0
        this.PosX :=this.PosX+ DeltaX
        this.PosY :=this.PosY+ DeltaY
        this.SetPos( this.PosZ , this.PosX , this.PosY )
        closedcell:=this.position
        %closedcell%:=1

        if (prv != player)
        drawchar(prv,Tile_type[savecurrenttilev].1, Tile_type[savecurrenttilev].2) ; = drawchar( previous position, charcter symbol, color)
        

        if savecurrentItemv is xdigit
        if (savecurrentItemv != Item_None)
        if  (prv != player)
        drawchar(prv,Item_type[savecurrentItemv].1, Item_type[savecurrentItemv].2)  ; = drawchar( previous position, charcter symbol, color)
    }

}

 hitplayer()
 {
   global player, playerhp, hp, pico8
   if % (this.position = player)
   {
      ; msgbox, monster hit you
      hp:=hp + this.damage
      
      guicontrol,, playerhp, %  "HP: " . hp
      ; msgbox, % hp
  
     if (this.damage < 0)
       {
         consoledrawline(2, pico8.red, "A Monster hits you")
         settimer, waitmessage, -1000 ; clear console lines  after 1 sec
       }
       
            if (this.damage > 0)
       {
         consoledrawline(4, pico8.yellow, "Princess Achka")
         consoledrawline(1, pico8.pink, "Help me please!")
         consoledrawline(2, pico8.pink, "*kiss!")
         consoledrawline(3, pico8.white, "HP+1")
         settimer, waitmessage, -2000 ; clear console lines  after 1 sec
       }
   }
}


 clear()
 {
  global
  savecurrenttilev:=DataWorld[this.PosX][this.PosY] 
  savecurrentItemv:=DataItems[this.PosX][this.PosY]
  drawchar(this.position,Tile_type[savecurrenttilev].1, Tile_type[savecurrenttilev].2)
 }
   
} ; end class actor



return




;/////////////////////////////////////////////////////////////////////
;// fonction to create a grid 
;//

 PutGridText(GridPosX="10",GridPosY=10, number_of_columns=3, number_of_raws=3, width_of_cell=100, height_of_cell=100,fontsize:=18,fontcolor:="red", XCellSpacing=0, YCellSpacing=0, options="center 0x200", fill:=" ")
{
 ; create a grid with borders
global

if gridnumber=
GridNumber:=0

GridNumber:=GridNumber+1
MaxCols_Grid%GridNumber%:=number_of_columns
MaxRows_Grid%GridNumber%:=number_of_raws

gui, font, s%fontsize%

gui, add, text,  hidden w0 h0 x%GridPosX% y%GridPosY% section


Row:=0 Col:=0

  loop, %number_of_raws% {
     Row:= ROw+1

     loop, %number_of_columns% {
           Col:= Col+1
           if Col=1
              gui, add, text, section   %options% c%fontcolor% 0x200 BackGroundTrans border hidden0    w%width_of_cell% h%height_of_cell% xs y+%YCellSpacing% v%GridNumber%_%Col%_%Row% gclickcell, %fill%
           else 
              gui, add, text,          %options% c%fontcolor% 0x200 BackGroundTrans border hidden0    w%width_of_cell% h%height_of_cell%  x+%XCellSpacing% ys v%GridNumber%_%Col%_%Row% gclickcell, %fill%
     }
      Col:=0

  }


}


AgLoadDataMap(InputGridMap:="Walls", colsep:="", cols:="maxcols_grid1", rows:="maxrows_grid1")
{
global
;create a col major data grid (note this function create a real 2d data matrix)
data%InputGridMap%:=[]

Loop, Parse, %InputGridMap%, `n
{
    Row := A_Index
    Loop, Parse, A_LoopField, %colsep% , %A_Space%%A_Tab%
    {
        Col := A_Index
        Data%InputGridMap%[Col,Row] := A_LoopField
    }
}


}


AgLoadVarMap(map,GridNumber:="1",ColSeparator:="", RowSeparator:="`r`n", startcol:="1", startrow:="1")
{
; Load a map from a variable directly to the grid
global 

Row:=0 Col:=0

if startrow>=0
srow:=startrow-1
else
srow:=startrow

if startcol>=0
scol:=startcol-1
else
scol:=startcol

row:=row+srow
col:=col+scol

loop, parse, map, %RowSeparator%
  {
     Row:= ROw+1
           loop, parse, a_loopfield, %ColSeparator%
              {
               Col:= Col+1
               guicontrol,, %GridNumber%_%Col%_%Row%, % a_loopfield
               }
               col:=0
               col:=col+scol
  }
}



drawchar(varname, chartodraw:="@", color:="")
{
 global
 stringsplit, draw, varname, _
 out:=  draw1 . "_" . draw2 . "_" . draw3
 guicontrol,, %out%, %chartodraw%
 colorcell(out, color)
}

ColorCell(cell_to_paint, color:="red")
{
 ;color the content of a cell for ex colorcell("2_5_9", "00ff00") will change the color of the cell of grid 2 column 5 row 9 to green
 GuiControl, +c%color%  , %cell_to_paint%
 GuiControl, hide  , %cell_to_paint%
 GuiControl, show  , %cell_to_paint%
}


ClearCell(parameters)
{
 DrawChar(parameters, " ")
}

;//////////////////////////////////////////////////////////////////////////////
;//
;// Fonction to move the player
;//

AGMove(Varname,axes,value1:=1,value2:=1,value3:=1)
{
global
; Increment Cell variable name in the grid for ex. if you are on cell 1_1_1 to go to the cell "1_2_1" do AGMove("1_1_1", "x", 1)
; for ex. if you are on cell 1_1_1 (=grid1 col1 row1) to jump to 2_1_3 (=grid2 col1 row3) do AGMove("1_1_1", "zxy", 1,0,2) 
; for ex. if you are on cell 1_1_1 to go to cell 1_2_2 do AGMove("1_1_1", "xy", 1,1)

;Call the main function AGM()
AGM(varname,value1,value2,value3)
StringSplit, ar, varname , _

;increment the grid number only
if axes = z
  {
  nz:=value1+ar1
  ;msgbox, % nz
  ny:=ar3
  nx:=ar2
  }

;increment column only
if axes = x
  {
  nz:=ar1
  nx:=value1+ar2
  ny:=ar3
  }

; increment row only
if axes = y
  {
  nz:=ar1
  nx:=ar2
  ny:=value1+ar3
  }

; increment column and row (add value1 to column and value2 to row)
if axes = xy
  {
  nz:=ar1
  nx:=value1+ar2
  ny:=value2+ar3
  }

; select a grid and increment column and row
if axes = zxy
  {
  nz:=value1+ar1
  nx:=value2+ar2
  ny:=value3+ar3
  }

;EZ = extract Z  (return the grid number) 
if axes = EZ
 return ar1

;EX = extract x  (return the column number) 
if axes = EX
 return ar2

;EY = extract y  (return the row number) 
if axes = EY
 return ar3

;SX = set x  (set the colum number) 
if axes = SX
{
 nz:=ar1
 nx:=value1
 ny:=ar3
 return % nz . "_" . nX . "_" . nY
}

;SY = set y  (set the row number) 
if axes = SY
{
 nz:=ar1
 nx:=ar2
 ny:=value1
 return % nz . "_" . nX . "_" . nY
}

;SZ = set Z  (set the Grid number) 
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
