;Mahjong Solitaire - (Shangai Solitaire)
;version 1.8
;by Speeedmaster

gosub, extract_tiles

sfx:=1      ;sound effects
score:=0

z:=0

tiles:=["bam01","bam02","bam03","bam04","bam05","bam06","bam07","bam08","bam09"
,"cir01","cir02","cir03","cir04","cir05","cir06","cir07","cir08","cir09"
,"char01","char02","char03","char04","char05","char06","char07","char08","char09"
,"wind01","wind02","wind03","wind04"
,"dra01","dra02","dra03"

,"bam01","bam02","bam03","bam04","bam05","bam06","bam07","bam08","bam09"
,"cir01","cir02","cir03","cir04","cir05","cir06","cir07","cir08","cir09"
,"char01","char02","char03","char04","char05","char06","char07","char08","char09"
,"wind01","wind02","wind03","wind04"
,"dra01","dra02","dra03"

,"bam01","bam02","bam03","bam04","bam05","bam06","bam07","bam08","bam09"
,"cir01","cir02","cir03","cir04","cir05","cir06","cir07","cir08","cir09"
,"char01","char02","char03","char04","char05","char06","char07","char08","char09"
,"wind01","wind02","wind03","wind04"
,"dra01","dra02","dra03"

,"bam01","bam02","bam03","bam04","bam05","bam06","bam07","bam08","bam09"
,"cir01","cir02","cir03","cir04","cir05","cir06","cir07","cir08","cir09"
,"char01","char02","char03","char04","char05","char06","char07","char08","char09"
,"wind01","wind02","wind03","wind04"
,"dra01","dra02","dra03"

,"flow01","flow02","flow03","flow04"

,"sea01","sea02","sea03","sea04"]

for each, val in tiles
z:=z+1

stone_set:=["bam01","bam02","bam03","bam04","bam05","bam06","bam07","bam08","bam09"
,"cir01","cir02","cir03","cir04","cir05","cir06","cir07","cir08","cir09"
,"char01","char02","char03","char04","char05","char06","char07","char08","char09"
,"wind01","wind02","wind03","wind04"
,"dra01","dra02","dra03"
,"flow01"
,"sea01"
,"bam01","bam02","bam03","bam04","bam05","bam06","bam07","bam08","bam09"
,"cir01","cir02","cir03","cir04","cir05","cir06","cir07","cir08","cir09"
,"char01","char02","char03","char04","char05","char06","char07","char08","char09"
,"wind01","wind02","wind03","wind04"
,"dra01","dra02","dra03"
,"flow01"
,"sea01"]

WHITE_TILE=%a_scriptdir%\tiles\bla.png

sleep, 2000

PutGridPicture(122, 280, 1, 1, 54, 79, -6,-8, WHITE_TILE)
PutGridPicture(170, 30, 12, 8, 54, 79, -6,-8, WHITE_TILE)
PutGridPicture(308, 91, 6, 6, 54, 79, -6,-8, WHITE_TILE)
PutGridPicture(349, 152, 4, 4, 54, 79, -6,-8, WHITE_TILE)
PutGridPicture(390, 213, 2, 2, 54, 79, -6,-8, WHITE_TILE)
PutGridPicture(414, 245, 1, 1, 54, 79, -6,-8, WHITE_TILE)
PutGridPicture(750, 280, 2, 1, 54, 79, -6,-8, WHITE_TILE)

PutGridPicture(830, 90, 2, 1, 54, 79, 10,-8, WHITE_TILE)

gui, font, cC78358
gui, font, s10 bold, Helvetica

Gui, Add, text, -border  x800 y530  w250 h20 vtitle backgroundtrans, MAHJONG SOLITAIRE

gui, font, s10 italic, Helvetica
gui, add, text, xp yp+20 w170 h30 -border cyellow vcredit, by Speedmaster

gui, add, text, xp yp+80  w0 h0 border,

gui, font, cC78358
gui, font, s12 bold, Helvetica
gui, add, text, x800 y500 w100 csilver -border vscore, Score: %score%

gui, font, cred
gui, font, s8 bold italic underline, Helvetica
gui, add, button,  w150 h30 x10 y20 ghard_shuffle  , HARD SHUFFLE
gui, add, button,  wp hp xp yp+35  gsmart_shuffle , SMART SHUFFLE
gui, add, button,  wp hp xp yp+35  greplay , REPLAY SAME BOARD
gui, add, button,  wp hp xp yp+35  greload , RELOAD
gui, add, button,  wp hp xp yp+35  gundo , UNDO



stones=
(
000000000000
000111111000
000122221000
000123321000
000123321000
000122221000
000111111000
000000000000
)

grid1=
(
1
)

grid2=
(
100000000001
111000000111
110000000011
000000000000
000000000000
110000000011
111000000111
100000000001
)

grid3=
(
100001
100001
100001
100001
100001
100001
)

grid4=
(
1001
1001
1001
1001
)

grid5=
(
11
11
)

grid6=
(
1
)

grid7=
(
01
)

board1:=[]

hidecell("2_1_2")
hidecell("2_2_2")
hidecell("2_1_3")

hidecell("2_1_7")
hidecell("2_2_7")
hidecell("2_1_6")

hidecell("2_11_2")
hidecell("2_12_2")
hidecell("2_12_3")

hidecell("2_11_7")
hidecell("2_12_7")
hidecell("2_12_6")

agloaddatamap("grid1")
agloaddatamap("grid2")
agloaddatamap("grid3")
agloaddatamap("grid4")
agloaddatamap("grid5")
agloaddatamap("grid6")
agloaddatamap("grid7")


agloaddatamap("stones")  ; make a datastones:={} object

; automatically disbale stones making them unselectable with help of datastones{} object

for i, j in datastones
  {
   co:=a_index
    for k, l in j 
     {
      row:=a_index

      if l>0     ;select grid 2
        {
        stonetodisable:= "2_" . co . "_" . row
        disablecell(stonetodisable)
        }

      if l>1     ;select grid 3
        {
        d_co:=co-3    ;calculate delta ajustement of position
        d_row:=row-1  ;calculate delta ajustement of position
        stonetodisable:= "3_" . d_co . "_" . d_row 
        disablecell(stonetodisable)   ;disable cell
        }

      if l>2     ;select grid 4
        {
        d_co:=co-4
        d_row:=row-2
        stonetodisable:= "4_" . d_co . "_" . d_row
        disablecell(stonetodisable)
        }

      if l=3     ;select grid 5
        {
        d_co:=co-5
        d_row:=row-3
        stonetodisable:= "5_" . d_co . "_" . d_row
        disablecell(stonetodisable)
        }
     }
  }

gui, +resize
gui, -dpiscale
gui, color, black
gui,show, x10 y10, AHK Mahjong Solitaire v1.8
Gui, Show, autosize
return

reload:
reload
return

~f2::
sfx:=!sfx   ;toggle sound effect
return




hard_shuffle:

score:=0
updatescore()

if (sfx)
soundplay, .\sounds\tick.mp3

ShuffleArray(tiles)

ShuffleArray(ByRef arr)
{
    elems:=[]
    loop, % arr.Length() 
    {
	 Random, rnd, 1, % arr.MaxIndex()
	 elems[A_Index] := arr.RemoveAt(rnd)
    }
    arr:=elems
}

gridshow(1)
gridshow(2)
gridshow(3)
gridshow(4)
gridshow(5)
gridshow(6)
gridshow(7)


hidecell("2_1_2")
hidecell("2_2_2")
hidecell("2_1_3")

hidecell("2_1_7")
hidecell("2_2_7")
hidecell("2_1_6")

hidecell("2_11_2")
hidecell("2_12_2")
hidecell("2_12_3")

hidecell("2_11_7")
hidecell("2_12_7")
hidecell("2_12_6")


for i, j in datastones
  {
   co:=a_index
    for k, l in j 
     {
      row:=a_index

      if l>0     ;select grid 2
        {
        stonetodisable:= "2_" . co . "_" . row
        disablecell(stonetodisable)
        }

      if l>1     ;select grid 3
        {
        d_co:=co-3    ;calculate delta ajustement of position
        d_row:=row-1  ;calculate delta ajustement of position
        stonetodisable:= "3_" . d_co . "_" . d_row 
        disablecell(stonetodisable)   ;disable cell
        }

      if l>2     ;select grid 4
        {
        d_co:=co-4
        d_row:=row-2
        stonetodisable:= "4_" . d_co . "_" . d_row
        disablecell(stonetodisable)
        }

      if l=3     ;select grid 5
        {
        d_co:=co-5
        d_row:=row-3
        stonetodisable:= "5_" . d_co . "_" . d_row
        disablecell(stonetodisable)
        }


     }
  }

tilevalue:=0
loadboard(1)
loadboard(2)
loadboard(3)
loadboard(4)
loadboard(5)
loadboard(6)
loadboard(7)

loadboard(gridnumber="1")
{
global

Row:=0 Col:=0

loop, % MaxRows_Grid%gridnumber% {

     Row:= ROw+1

     loop, % MaxCols_Grid%gridnumber% {
           Col:= Col+1
               celltoload=%GridNumber%_%Col%_%Row%

               if celltoload != 2_1_2
               if celltoload != 2_2_2
               if celltoload != 2_1_3
               if celltoload != 2_1_7
               if celltoload != 2_2_7
               if celltoload != 2_1_6

               if celltoload != 2_11_2
               if celltoload != 2_12_2
               if celltoload != 2_12_3
               if celltoload != 2_11_7
               if celltoload != 2_12_7
               if celltoload != 2_12_6
               {

                tilevalue:=tilevalue+1
                read:=tiles[tilevalue]
                ObjRawSet(board1, celltoload, [read, 0, 0])  ;create 2d object board1:={ "value1" : ["value1","value2"] , "value2" : ["value1","value2"] ... }
                m=%a_scriptdir%\tiles\%read%.png
                drawpic(celltoload, m )
               }

     }

      Col:=0

  }
}


history:=[]

initialiseboard(datagrid1, 1)
initialiseboard(datagrid2, 2)
initialiseboard(datagrid3, 3)
initialiseboard(datagrid4, 4)
initialiseboard(datagrid5, 5)
initialiseboard(datagrid6, 6)
initialiseboard(datagrid7, 7)

;manually set open stones (playable stone) with help of data grids

initialiseboard(data, grnumb)
{
global

for i, j in data
  {
   co:=a_index
    for k, l in j 
     {
      row:=a_index
      if l=1
        cellb:= grnumb . "_" . co . "_" . row
        board1[cellb][2]:=1
     }
  }


for i, j in datastones
  {
   co:=a_index
    for k, l in j 
     {
      row:=a_index

      if l>0     ;select grid 2
        {
        stonetodisable:= "2_" . co . "_" . row
        board1[stonetodisable].3:=1
        }

      if l>1     ;select grid 3
        {
        d_co:=co-3    ;calculate delta ajustement of position
        d_row:=row-1  ;calculate delta ajustement of position
        stonetodisable:= "3_" . d_co . "_" . d_row 
        board1[stonetodisable].3:=1
        }

      if l>2     ;select grid 4
        {
        d_co:=co-4
        d_row:=row-2
        stonetodisable:= "4_" . d_co . "_" . d_row
        board1[stonetodisable].3:=1
        }

      if l=3     ;select grid 5
        {
        d_co:=co-5
        d_row:=row-3
        stonetodisable:= "5_" . d_co . "_" . d_row
        board1[stonetodisable].3:=1
        }

     }
  }


}

VoardB:=ObjFullyClone(board1)

if !(restore)
savedboard:=ObjFullyClone(board1)

ObjFullyClone(obj)
{
	nobj := obj.Clone()
	for k,v in nobj
		if IsObject(v)
			nobj[k] := A_ThisFunc.(v)
	return nobj
}

return

smart_shuffle:
gosub, hard_shuffle

if (sfx)
soundplay, .\sounds\tick.mp3

solution:=
pop1=
pop2=
enableunder1=
enableunder2=
pop1right=
pop2right=
pop1left=
pop2left=
tiletodraw=
stone_setB:=


gridshow(1)
gridshow(2)
gridshow(3)
gridshow(4)
gridshow(5)
gridshow(6)
gridshow(7)


hidecell("2_1_2")
hidecell("2_2_2")
hidecell("2_1_3")

hidecell("2_1_7")
hidecell("2_2_7")
hidecell("2_1_6")

hidecell("2_11_2")
hidecell("2_12_2")
hidecell("2_12_3")

hidecell("2_11_7")
hidecell("2_12_7")
hidecell("2_12_6")

stone_setB:=ObjFullyClone(stone_set)


loop, 72  ;  72 pairs (144 pieces)
{
ShuffleArray(stone_setB)
FreePos:=[]

for key, val in VoardB
{
if VoardB[key].2           ;stone is open
if VoardB[key].3=0         ; stone is not disabled (= is visible)
freepos.push(key)
}

ShuffleArray(freepos)
ShuffleArray(freepos)
pop1:=freepos.pop()
pop2:=freepos.pop()

   if % (agmove(pop1, "ez") = 3)
    {
     ;// enable the stone that is under the selected stone 
     enableunder1:=agmove(pop1 ,"z", -1)
     enableunder1:=agmove(enableunder1 ,"xy", 3)
     VoardB[enableunder1].3:=0
    } 


   if % (agmove(pop2, "ez") = 3)
    {
     enableunder2:=agmove(pop2 ,"z", -1)
     enableunder2:=agmove(enableunder2 ,"xy", 3)
     VoardB[enableunder2].3:=0
    }

   if % (agmove(pop1, "ez") = 4)
    {

     enableunder1:=agmove(pop1 ,"z", -1)
     enableunder1:=agmove(enableunder1 ,"xy", 1)
     VoardB[enableunder1].3:=0
    }


   if % (agmove(pop2, "ez") = 4)
    {
     enableunder2:=agmove(pop2 ,"z", -1)
     enableunder2:=agmove(enableunder2 ,"xy", 1)
     VoardB[enableunder2].3:=0
    }


   if % (agmove(pop1, "ez") = 5)
    {
     enableunder1:=agmove(pop1 ,"z", -1)
     enableunder1:=agmove(enableunder1 ,"xy", 1)
     VoardB[enableunder1].3:=0
    }


   if % (agmove(pop2, "ez") = 5)
    {
     enableunder2:=agmove(pop2 ,"z", -1)
     enableunder2:=agmove(enableunder2 ,"xy", 1)
     VoardB[enableunder2].3:=0
    }

  if (pop1="6_1_1" || pop2="6_1_1")
   {
     VoardB["5_1_1"].3:=0
     VoardB["5_1_2"].3:=0
     VoardB["5_2_1"].3:=0
     VoardB["5_2_2"].3:=0
   }

; // open adjacent stone

  pop1right:=agmove(pop1, "x", 1)
  pop1left:=agmove(pop1, "x", -1)

  pop2right:=agmove(pop2, "x", 1)
  pop2left:=agmove(pop2, "x", -1)

  VoardB[pop1right].2:=1
  VoardB[pop1left].2:=1

  VoardB[pop2right].2:=1
  VoardB[pop2left].2:=1



  if (pop1="1_1_1" || pop2="1_1_1")
   {
     VoardB["2_1_4"].2:=1
     VoardB["2_1_5"].2:=1
   }

  if (pop1="7_1_1" || pop2="7_1_1")
   {
     VoardB["2_12_4"].2:=1
     VoardB["2_12_5"].2:=1
   }

for key, val in VoardB
if key= % pop1 
{
VoardB.delete(pop1)
VoardB.delete(pop2)
}



for key, val in board1
if key= % pop1
{
out:=stone_setB.pop()
  if out !=
    {
     board1[pop1].1:=out
     board1[pop2].1:=out

ttd1:=out
ttd2:=out
    }

tiletodraw=%a_scriptdir%\tiles\%out%.png

drawpic(pop1, tiletodraw )
drawpic(pop2, tiletodraw )

}

solution:=solution . a_tab . pop1 . ", " . a_tab . ttd1 . ", " . a_tab . pop2 . ", " . a_tab . ttd2 . ", " 

} ; end of loop 72 pairs

;restore four seasons
for i, j in board1
 for k, l in j
  if (l="sea01")
  {
    board1[i].1:="sea02"
    tiletodraw=%a_scriptdir%\tiles\sea02.png
    drawpic(i, tiletodraw )
    break 2
  }
 
for i, j in board1
 for k, l in j
  if (l="sea01")
  {
     board1[i].1:="sea03"
    tiletodraw=%a_scriptdir%\tiles\sea03.png
     drawpic(i, tiletodraw )
     break 2
  } 
  
for i, j in board1
 for k, l in j
  if (l="sea01")
  {
    board1[i].1:="sea04"
    tiletodraw=%a_scriptdir%\tiles\sea04.png
    drawpic(i, tiletodraw )
    break 2
  } 
  
  ;restore four flowers
for i, j in board1
 for k, l in j
  if (l="flow01")
  {
    board1[i].1:="flow02"
    tiletodraw=%a_scriptdir%\tiles\flow02.png
    drawpic(i, tiletodraw )
    break 2
  }
 
for i, j in board1
 for k, l in j
  if (l="flow01")
  {
     board1[i].1:="flow03"
     tiletodraw=%a_scriptdir%\tiles\flow03.png
     drawpic(i, tiletodraw )
     break 2
  } 
  
for i, j in board1
 for k, l in j
  if (l="flow01")
  {
    board1[i].1:="flow04"
    tiletodraw=%a_scriptdir%\tiles\flow04.png
    drawpic(i, tiletodraw )
    break 2
  } 

savedboard:=ObjFullyClone(board1)


return

replay:
restore:=1
gosub, hard_shuffle

for i, j in savedboard
 for k, l in j
  if !(l=1)
  if !(l=0)
  {
    tiletodraw=%a_scriptdir%\tiles\%l%.png
    drawpic(i, tiletodraw)
  }
  
board1:=ObjFullyClone(savedboard)

restore:=0
return


undo:
his:=""
for k, v in history
his .= v . ","
;;msgbox, % his
;msgbox, %  history.removeat(1)

loop, 2
{
ts:=history.pop()
if (ts)
{
   if (a_index=2)
   score--
   updatescore()

showcell(ts)
enablecell(ts)

if % (agmove(ts, "ez") = 3)
    {
     disableunder:=agmove(ts ,"z", -1)
     disableunder:=agmove(disableunder ,"xy", 3)
     disablecell(disableunder)
    } 

   if % (agmove(ts, "ez") = 4)
    {
     disableunder:=agmove(ts ,"z", -1)
     disableunder:=agmove(disableunder ,"xy", 1)
     disablecell(disableunder)
    }

   if % (agmove(ts, "ez") = 5)
    {
     disableunder:=agmove(ts ,"z", -1)
     disableunder:=agmove(disableunder ,"xy", 1)
     disablecell(disableunder)
    }

   if % (agmove(ts, "ez") = 6)
    {
     disablecell("5_1_1")
     disablecell("5_2_1")
     disablecell("5_1_2")
     disablecell("5_2_2")
    }
}

}


return

clickcell:

if (debug)
msgbox, % a_guicontrol



if isopen()
{
  if select1=
    {
     select1:=board1[a_guicontrol].1
     select1pos:=a_guicontrol

     tiletodraw=%a_scriptdir%\tiles\%select1%.png
     drawpic("8_1_1",tiletodraw)
     if (sfx)
     soundplay, .\sounds\tick.mp3
    }
  else
    {
       if select2=
        {
         select2:=board1[a_guicontrol].1
         select2pos:=a_guicontrol

        tiletodraw=%a_scriptdir%\tiles\%select2%.png
        drawpic("8_2_1",tiletodraw)
     if (sfx)
     soundplay, .\sounds\tick.mp3
        }
    }
} ;end if isopen


if (select1="flow01" || select1="flow02" || select1="flow03" || select1="flow04")
if (select2="flow01" || select2="flow02" || select2="flow03" || select2="flow04")
select1:=select2

if (select1="sea01" || select1="sea02" || select1="sea03" || select1="sea04")
if (select2="sea01" || select2="sea02" || select2="sea03" || select2="sea04")
select1:=select2



if (select1=select2)
if (select1pos!=select2pos)
  {
   hidecell(select1pos)
   hidecell(select2pos)

   history.push(select1pos)
   history.push(select2pos)

   if (sfx) 
   soundplay, .\sounds\ok.mp3 
   
   score++
   updatescore()

   if (score=72)
   msgbox, You win !
            
   settimer, clearconsole, -1200, on

if % (agmove(select1pos, "ez") = 3)
    {
     enableunder1:=agmove(select1pos ,"z", -1)
     enableunder1:=agmove(enableunder1 ,"xy", 3)
     enablecell(enableunder1)
    } 

   if % (agmove(select2pos, "ez") = 3)
    {
     enableunder2:=agmove(select2pos ,"z", -1)
     enableunder2:=agmove(enableunder2 ,"xy", 3)
     enablecell(enableunder2)
    }

   if % (agmove(select1pos, "ez") = 4)
    {
     enableunder1:=agmove(select1pos ,"z", -1)
     enableunder1:=agmove(enableunder1 ,"xy", 1)
     enablecell(enableunder1)
    }

if % (agmove(select2pos, "ez") = 4)
    {
     enableunder2:=agmove(select2pos ,"z", -1)
     enableunder2:=agmove(enableunder2 ,"xy", 1)
     enablecell(enableunder2)
    }

   if % (agmove(select1pos, "ez") = 5)
    {
     enableunder1:=agmove(select1pos ,"z", -1)
     enableunder1:=agmove(enableunder1 ,"xy", 1)
     enablecell(enableunder1)
    }

   if % (agmove(select2pos, "ez") = 5)
    {
     enableunder2:=agmove(select2pos ,"z", -1)
     enableunder2:=agmove(enableunder2 ,"xy", 1)
     enablecell(enableunder2)
    }


  select1posright:=agmove(select1pos, "x", 1)
  select1posleft:=agmove(select1pos, "x", -1)

  select2posright:=agmove(select2pos, "x", 1)
  select2posleft:=agmove(select2pos, "x", -1)

  board1[select1posright].2:=1
  board1[select1posleft].2:=1

  board1[select2posright].2:=1
  board1[select2posleft].2:=1

  if (select1pos="6_1_1" || select2pos="6_1_1")
   {
    enablecell("5_1_1")
    enablecell("5_1_2")
    enablecell("5_2_1")
    enablecell("5_2_2")
   }

  if (select1pos="1_1_1" || select2pos="1_1_1")
   {
     board1["2_1_4"].2:=1
     board1["2_1_5"].2:=1
   }

  if (select1pos="7_1_1" || select2pos="7_1_1")
   {
     board1["2_12_4"].2:=1
     board1["2_12_5"].2:=1
   }

   select1:=
   select1pos:=
   select2:=
   select2pos:=
   select1posright:=
   select1posleft:=
   select2posright:=
   select2posleft:=

} ; end if select1=select2


if select1!=
if select2!=
if (select1!=select2)
  {
   select1:=
   select1pos:=
   select2:=
   select2pos:=
   select1posright:=
   select1posleft:=
   select2posright:=
   select2posleft:=
       drawpic("8_1_1",empty)
       drawpic("8_2_1",empty)
  }

if select1pos!=
if select2pos!=
if (select1pos=select2pos)
  {
        drawpic("8_1_1",empty)
        drawpic("8_2_1",empty)
   select1:=
   select1pos:=
   select2:=
   select2pos:=
   select1posright:=
   select1posleft:=
   select2posright:=
   select2posleft:=

  }

return


        clearconsole:
        drawpic("8_1_1",empty)
        drawpic("8_2_1",empty)
        return



isopen()
{
global
if board1[a_guicontrol].2
return true
}

isenabled()
{
global
if board1[a_guicontrol].3
return false
}


disablecell(cell)
{
global
guicontrol, disable, %cell%
guicontrol, hide, %cell%
guicontrol, show, %cell%
}


enablecell(cell)
{
global
guicontrol, enable, %cell%
guicontrol, hide, %cell%
guicontrol, show, %cell%
}

updatescore()
{
global score
guicontrol,, score, % "Score: " score
}


PutGridPicture(GridPosX="10",GridPosY=10, number_of_columns=3, number_of_raws=3, width_of_cell=100, height_of_cell=100, XCellSpacing=0, YCellSpacing=0, FilePath="" )
{
global

if gridnumber=
GridNumber:=0

GridNumber:=GridNumber+1
MaxCols_Grid%GridNumber%:=number_of_columns
MaxRows_Grid%GridNumber%:=number_of_raws

gui, add, text,  hidden w0 h0 x%GridPosX% y%GridPosY% section
Row:=0 Col:=0
  loop, %number_of_raws% {
     Row:= ROw+1
     loop, %number_of_columns% {
           Col:= Col+1
           if Col=1
              Gui, Add, Pic, section +BackgroundTrans w%width_of_cell% h%height_of_cell% xs y+%YCellSpacing% hidden0  v%GridNumber%_%Col%_%Row% gclickcell, %FilePath%
           else          
              Gui, Add, Pic,         +BackgroundTrans w%width_of_cell% h%height_of_cell% ys x+%XCellSpacing% hidden0  v%GridNumber%_%Col%_%Row% gclickcell, %FilePath%
     }
      Col:=0
  }
}

HideCell(cell_to_hide)
{
  guicontrol, hide1, %cell_to_hide%
}

showCell(cell_to_show)
{
  guicontrol, hide0, %cell_to_show%
}


AgLoadDataMap(InputGridMap:="Walls", colsep:="", cols:="maxcols_grid1", rows:="maxrows_grid1")
{
global
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

GridShow(gridnumber="1")
{
global
Row:=0 Col:=0
  loop, % MaxRows_Grid%gridnumber% {
     Row:= ROw+1

     loop, % MaxCols_Grid%gridnumber% {
           Col:= Col+1
              guicontrol, hide0, %GridNumber%_%Col%_%Row%
     }
      Col:=0
  }
}


DrawPic(cellname, object)
{
global
GuiControl, , %cellname%, %object%
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

GridHide(gridnumber="1")
{
global

Row:=0 Col:=0

  loop, % MaxRows_Grid%gridnumber% {
     Row:= ROw+1

     loop, % MaxCols_Grid%gridnumber% {
           Col:= Col+1
              guicontrol, hide1, %GridNumber%_%Col%_%Row%
     }
      Col:=0

  }
}


guiclose:
esc:: 
exitapp 
return



extract_tiles:

bam01:="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"
bam02:="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"
bam03:="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"
bam04:="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"
bam05:="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"
bam06:="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"
bam07:="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"
bam08:="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"
bam09:="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"
char01:="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"
char02:="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"
char03:="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"
char04:="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"
char05:="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"
char06:="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"
char07:="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"
char08:="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"
char09:="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"
cir01 :="iVBORw0KGgoAAAANSUhEUgAAADYAAABPCAMAAACXtsbmAAACc1BMVEW5k2O6kV69kl/Akl67kFzdzqbk2LHv58N2SBPt5Mbx58n17M3q4sXw6c7f2L/z7NXY0bnn38NbWlD8+e7k28H479Db1bv279TRy7Sdqo53jHK3s5/6892Xp4338+RyhW3i2r+1vaTt5sqwuaClspaLmn9oemH07tn59efTz7ihp5YyTCtDXT/VzbWrtZyRn4uHlX9Va0/n38V+jnNKYEVEWUI2UTQxSDF/k3tabVbu6dK6tqKaoZCNlYeEmoBqcmE/VkA+VDXv69ltgGL38NnNxrDDwK69wamprJyOnYGEmHlygmlvemlbdFI7UzssQSsmRCh8Gibi4tDUra+9vKq2uKm4ppa6e4GjUl2SQE5RaUj58dfHyrKrsKCfrpa2m5CVoYl9jXuFk3esYGxsgGlheGRRZk+CQkp9NEJuIi1+KCwmOybIwq3BhYmxhoKEi35+iHSmd3R4hnB6f21shWZif2JidF9Zc1pheldSa1RZZlNLZUSXNEItSSXnw8HbxbzIvKfFo6TKrKO0rpyOo4N+hHtea1pLZUyIND1EWDg3RzeLLjDt4NLo5cnZ38jgzcDdvbbBxq3UtanRoamwsqS8mJulrpa5jJGioYuKm4iUm4aOjX27c3eiZGepV2aXWmGUTV1RZVZUcE9VXU4/Zk1KW02PVEtBT0GVKDl2LDeKJTEvQiNyFRfRvbLBsJ7OlpnEjJnDeoukioOvb3x2eXGnam9yj26aZWxlalyXXlZiZVOkRVOFVlKYQlKJFyUhOxzk08WlmY6NhnWRd3GadmxRXkSKPj55IzZtNTRkJyVxGyJpFBf9+/fL0bOKYlmbSkJ2Pzu8DREzAAAACHRSTlMBFkydVlIXXiZBgLgAAAgeSURBVFjDxdZld9pQHAbw+QYkyJYCyZaFAMlWoMjwDh2ru8vq7u7t3Dt3d3d3d5ePtCSlQKA7Z9ubPW0v7T38znP539MDk2b9ZWbOmESFYl/n/Gnm0W76ZJpRauH832RhWOYJaDdlMs0WzhfExsaCIMgsgshIJJKlTCQ8OXPOaZMptgDkhIXLCi8Y7iL+LH/fLAHIAehwOMDElMdlMcaNszECMFROIU7QBPtAEcWYjLNxwoRC7FOCgTYW84NA17jjhaKoCEaBYBuDglU0HFvCWUjkzAmDXf7ncyARh3oMbwuWTTR8LiSUXovhhjN2Fye0C6RfGod/bXXnW15UOPtdV6DtQHXTU0kUD4BYjN0Vec/gzltN5wVRPA6bsbqYmxBROyGFW/dsOS+Q8ICJXhsjAIgvjJFSiRGKZSKOf5KiHJpNcAFyZhXJYuJa4vNKE1WqxERFvFQoYyDwMmfTI2o+0ISTBGTSlty9ztQh02Y6w/YuR240xKVGsnLPyI/dEDfAQv9xRMK4+L0dJktdVxIBo0lElc+cPmTEqULZgZNbrn5aBS6agMmk8Xnt50yYUgkTWJ2BRAhYW+HzetFoEXDgxKPzT4UCUSSTxcUn2r1dWgUyXKxRq8lidaYljVAo0yxYNABupbIAZDFm5Py4XF16sRLGTmWkqe6OOlWl51JV7RoNhjvNQwlyCRVmJGwGSeOdmj78kMlgytA55w4lpu5KLSG0xZnWU6Var6lkG3MP4QyKyXWkk/ihCxoC7stT5d1Vrc9rj3eq+pS6WjOBmzYmACB9fRCbiVtU5wxKxNRM6vU63d7E9es3qJwqVQoMG5PVmRWKdMM3gEsxdpssLm+DR9FhMvrsuLO00vnwoXu22+3uSknQw2kDwx4YVqdFy7lh9wYI4/UWwvHudHKFzqbqrj306tXt2+X5B7sxV9n9qrnK3o0JSEbVNpADiUMZFFe60aCovWKASZfr7pv8tsIPjY0NJzvX5HcjNiUJr7N242bLN1AuYzFx/PpMlPCYTd37MfvrG/feX63ft/pOUUN92/XXxhQU7TVblMbMJLmcdUhRzN5TGmUdgiqOdNW0lx8f+fxz946VK26NZDUdu/4YQ2w4brivTR/ks0cCxTlGU9B0G5rq7HKXn7yc9eXRmjWrc26MZF398vagwWXDUKMGr8kokbOYrKXdilZazWUK/ZnbJz4UnWg4XnCjtbVg07F7lz6VG3tdWrg/s6wiQ8lm4lzSsn/QWjdYg5C3P9zZubu1urBoy/vznW0vc+q/L+5NRoxYBqIdrdkmCh2JcO87DWy2JaG6/u4HDTk797Q++7ypKOtq0c2cFQX1q3wErlCk1irMG7OhIFsKClXe4jIPQnT0bzxyomjl6lvHs6pbC442PSvYt2JPQz7hS3aVrT+rOOPZzmYObxrsyUSQFPuRE5t2X7szsqW1/tLRwqY7a1bcvFR+EEFR9MxZxWPP9kX8ECZWXbDDFushbVKt89jz6tVtP7YUbMqi2NHVN4430mwdsvks/ti8HQhl/MQLBtiiR3WHyfZ7Fy83FD7Jqi4ouHXxyfGTzy5/yieoC00gzyY81mzfFmTzBFDeBZNSg+wqya3s7hx53njsWNHzJ4VNjZ1rqi9e/biqClZWqnS9CWfqsllsUfyZdGW/hey4i5GvirLq9x0ovHgx6/2jNTv2jHz53tKD7M8tPYfgF1JigRAm4UjdzTCSmQ7noqcPP2h8umPfzdaj1Z3lbStyihrz4Z7kw/oNmWX7rY5YkTCEgfz25hTY2gNXumzuAw0fd+54ubKgcPeOnStuNnSuMrr6Sdhu2VVpLYnlhzIekDjqUZp7lQq09uGbtksPclbmVF++d23lvvoHcQcRBDYSaT0Jg/ZsOZtxxRuak4j0tNOYNvXd6/KnzwqfXH6etan+59uWCgxZ10vUpCsclopYgM14gCOjTmG/MowOkffPrs9vO3mp6XPjxzf5qyoGlD09ysFMbJfbEx3BeGJ3sxFWF2OVSWnrTj08svb69fxVLbmODmxdD47BaaYSh1W/BAT4YjYDFaNWJWY1EnYYI/tJe6r+sF6PYckuxGVDEQ2cUOeJFkQynrwj41ypz7v8NHKqxocNGKoGfLAveUBbC5PLX+h29S1PXAJyRBGMJ3Q3G/DkDE0yakgaRAZRvY1wEfddOrRYnZxQaTUuiZVzRLIwFhUl4Q+9sCfqvacHLLpatP+QTYfoMHR4WFMH46QayxbIORTjhzHKlWxoNsPKFFPzAIxsXIcSBmOST61OUZSRajKbOiInrC2KVnSf+4q6C9fWaDSaFwak+MoLtaEKx6s8Vl22gFIUY10AbahCiWSRwzxqqlIqtEmInfSl6PfjWn2xeihviQCUUwpgsWUMoyMRSDu8V7x9tjItjuNah63Pk2GuyGbeXCKZXzEwVnh4g3f5crXXoqbW4RpFNlVFKYZBYjajh+J3EkF2Sakz1d2XalPlbV8iCKBIRqNgQIlAsITKAoqA3PEm6iuSBSD9wY4LMuEGEDC2TtQWUMEwKFgWyZiAbMWhkXyMMDKMSWgT7ApSCgXaaCUKZ/4+Vlfo8eiuiLZgGasrED8SsdiyYAcbAP6I6EAiCIJkwugAA5l9JsyT/X9CMioQs/KZiPliYYw0wBZRO1To/UDoDSEVZhHGMJFS39K4AOMLQxI9FulYqF+YH39oFWBrFwcydzxr/Y9jO2vXjm+rgmzWkdl/nFlB9jf5X2z6v7EZ0/+JTZo85V/YP7mpk2g37W/VlEl/6xg1+Rf+H4hQujoV+AAAAABJRU5ErkJggg=="
cir02 :="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"
cir03 :="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"
cir04 :="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"
cir05 :="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"
cir06 :="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"
cir07 :="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"
cir08 :="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"
cir09 :="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"
dra01 :="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"
dra02 :="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"
dra03 :="iVBORw0KGgoAAAANSUhEUgAAADYAAABPCAMAAACXtsbmAAACXlBMVEW5k2O6kmG8kV7dzqa+kl6+k17k2LHCk13v58N2SBP06s3p4MTt5Mby6cv27c/w5sn38dzz7NEUDw/z7djk28Hd1r349Obi2r8lIikTFxjY0bnt5swZGBf379P69N+HhoceHCHx6c7l48zm3cF8en63s5/b07nUzrYKEAz6+O3f17xvc3UZEBn38Nf8+e7v6tjs588RDAzx6tLOzMLHwbB4d3toaWu0sJxONEr79uLW1MrQy7R8enUtLDQQDxTDtq6Bf4JMSlI8NEE2NDsxOTQoHiUOFw21saonJTAoFh8KCQbLxLFTUlhSUFMzMDYgDx3u69SPkJGXlpBValRAPUMvJSscIyYGEgbS0MbEv7CXhpKBf314c3VobHJhbG9vdG1lY2VZWFdEM0tBJ0U5PD8lLiIYFyHbx7nTy7R2eXVwbW9ZX2JaWGFWOldVY1A7MTYeJhrq5dXIvLDGua+9rq+5pauzoqmbm5iOjIp1VHdtT3NrZ3JXR1tJZlBIVU1EQUlIL0c0KzQlJiAQIhfd0MKhjJthYmFTVEspGS7f1cWvraaon6SYkJmhnph+YH6BkHt4bHttZHp4hXZqYW9vbmdrgGZPPFNDSVBDREIyHzU6KDIrKyri3s/a1sqpqKWipZqUgY2kYGxdYmtkSmtnfGCfTV9KXVCTNUOCJjw5ITw1RTn8+/bn5s6klafapKaboZGQnomMl4Koi4J3Y3NUP2dab1t+NzglMzZ8GSXDn5yKd4pveH+odX86TkMvNCloHiheFhZ7dI2IanBlcGOBQkvv7uu9kpuuqpfZi5VtLTTjto5EAAAACXRSTlMBF01SoVgXll6HpH9kAAAHlUlEQVRYw8XX918SYRzA8XbJMeSAuIuzO+MyEirJICshdmiAYYwSTTC0HKVNLU1TS02zLCs123vvvff4r3oejg29XtUvfYRDhffr+4DecUzI+MtmTJsAAmx5/rrloHX569adBdv8fHAN3cDfnwV3gE0+aPnyfOgmTwyxr7dvz0/TwtTmz58N3SToMm7fXjjzD1uWmRFxGTNnZgoWx8dnEggE8Mq0AJSZuYAvibiMTEE2G0EQdlw8GCcSKxYHyWAcZBIkUqKM0QQGi2cxjcTzqOSmMnHOrFA5oUTgIsoViUQ5ublikFAoRXgpjI1INy9ZH2lJQqvDrRBzuNzkaeLVu0m5XF6uonW0TkfTtEqloukWHdjoSJ1OR7ZUPpCkstwlFzo8mKazU2PFMMxMYZjVatUYHBjMimmMQWrrnDTTtg9Z62try+UuAqdQqic0TufHcEprrNCBRTjwrXOykhgbEe8Ytla0m8ZHyIDaF6ir7Qg6NBpjYWFlbYBs0Bscra7fsD1YpamG0DhJspl00hqqBq/xyEtLwQ8d1iJL/RZi65wF6ZhZ/VwRoIddDvtoUO0rrKur9dF6l96oL1c1Wi5tUcBpLHbqtPogVa53KJSjXVoCa2x0GIMOsxbVEpTc5akoUGy9k7TIbMC2H8FM8lbaoCiWoagSZSJCWzzo72m9ia5Nz9wy9YC9U0mM9vb6C2Hl5ZUnegKNRVpLoFTfBxmLI01gbDhNVq/q6Cw25Z85s21RuG3bDpWNKbzttKEI3TcnLXPjzgGXufjWGQE/WhYfGdhPWI6fawszJJXJNpCGkuJbc/jZcfuYcNcWwnvt8BbI+KlsxxGzrH7IWgRZ/A4GWIn31rGbJSHGS1gkjy3csYcyOQ/rQyw6isuw7qOHTxUxTJjCmvx6u+o0+jaeceEi0RGylryJM9NSmVqDy/crAIuiECsgNugxeQHDkEQmXrm3SY3hG/Yr2u/wwyjGjFRPAb42mS0G01bura6jcHmVoj0vPC2OOXD/foZJ0zAsypiDTojthtNwdYhx2MIYywyxy03qKOMgQnGuEOEAJt5dQG3QRJk4kYkhs1K0QXsNMHbO6u3bV2+SskKMuGTA4UuSPI0fWmRTg99PG5XX1nBZyKZvbz5dfPOSx+WId59CR+psZHiaNJ5xeIARFNk8ghVfW8MH7OKNixdv/BRxOaKBUyhed94/JkvHpCv3UFpbq1FRvDXErl6/9+PG+81ZHNHBKqVsRG0oAoyVZtrjPot6rxv3rl2TBae9eHb9xTMki3Po4H60++SrjTXKp5AJk9mevu7mV27CG5724tmNF89yuIAVoE0Pdm+BDP5bpDw3yqs+5tbCRXLZYJGb7l3/8IgfYt5rQxsVyit52TwkldXI1A2YohgsMsTu3bsaZtruWnqsRHlSAqbFFjmbYZdrTM4yV1/xU8B4B758eH/j/ZdDAo7osAGvbykd7gOMw2NLU5hHrbfJx5SQsXgvHz168/IA+IseKGvE5B3tqpvoyTzAkCS288l4BUbRG9HPgHGzBJmZ4JLFYgNmHTZ7KjaiYFoSY0FWXdFHvd6IXgEMOBCfywLsQqPnmLl7A7gDPjdpAuMwzAzYSQFkMBYITDMwDL8yBwwTp5lGYa9vopURxgIOTnN4WilmGoeN5CZP21JdUWMdOq2NMObAxc4p20idqNYMnbYcl/DSsLauzw2qOrfsOGRwFsNmlRVoeyt1j82yo3ngLUaUwgjTeXDA8x4VRGYx7EKBlqh0thVZjuYlTctimLf+mBv1HhfEKQ4y60IVIQtcMpTI0jHxrjaFhfzoVsgAYwiMh8wqq8LHS51VRWkY3Inb8Or+u42ALc7m8dhMCCKcV1YlG78/0FZieZjEZi9g9n0wrVMhk4tFsyLNm7d59WEDilZWVIWZOMqWhdjAKYvpHDlWIntb2r8qrn7aLWvyXRoDTJLKRHermuS6FvAO0W3SB2w2u91u8w832Gz6TkLWSzovw2npmPFdq2O01U3hWgLFKaPLZTB2UgoCVaJU+aiNNhMP8sBzzU1mJtMxrJrUBTCKQsfLdbSq3OfHiHG8q0f+SfNcfjo9O2gyDVNezDVIkoX2QnWHBvNoSJIsVZNyfUENYNj9tMxoGjK8c9iaW5qd5LkGaw2Oe3zN51Y1n6v3lCieq05j5+H5oyiJlQWrW+lCH13f4Qoae5wquraSbGmwNYxcIuWP62rJToblJLFXQUJh7uoyU4QSRYlG8ELaG+wYQeCEJthhbx/tenc/dRoLeYzhqEImQ0MplUpUq6XM8JtieFpEEF1d9/NSGUu4vr+/f3Dw/ODgYCmopYX0+XyFoBOgnt5Ab++SvORFwoNHJkjAtEiwKNo22JmzZ5efWSRBUhgTnwXLBqcz2aF4Egm4wLKzJfAzhjCZhXcwJl44djRo2EnTsrhhk6hiBBqo4tnsBazwYyMk8uiEpDBxjMHTyUjxD5cKI4lzw4ly5kVZHiIWpQ1+dBHlgI8vs+bBNsMyogzeH2tetM0rVsCbFeASK8Yyvs9NaenS6AZ+RcuIsb/pf7HJ/8amTf4nNmHipH9h/+SmTIBu6l+q6ZMm/IObMmniL/jKvnkOWAWzAAAAAElFTkSuQmCC"
flow01 :="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"
flow02 :="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"
flow03 :="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"
flow04 :="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"
sea01 :="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"
sea02 :="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"
sea03 :="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"
sea04 :="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"
wind01 :="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"
wind02 :="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"
wind03 :="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"
wind04 :="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"
bla :="iVBORw0KGgoAAAANSUhEUgAAADYAAABPCAMAAACXtsbmAAAAw1BMVEW5k2O6kV69kl++kl6+k17w6cLZxZu4jVnk2LHCk112SBPv5cjs48Xt48br4sXx58np4cX8+e3e177x6crX0bi0rprTzbb49OXn3sPX0rvz7dWRiHLa1L1FNSHk3MHh2sDc1byakXz07M7f2MD69ufx6dLc1sDUzriVi3Xc1LrQyrRJOyf479C/taT48NhIOSTKw7LGv66xqpbAt6aWjnnNxbXCu6meloLp5MxgQR2rn4aMgWumjWh+dmNvYk2TckeEaUU3yqjDAAAACnRSTlMBFk6hWFJRSReWLGg69gAAAg9JREFUWMPl1n9zmjAYwHG0a9ehVQYZA0kTlA5ERwEBde1+vf9XtSeKCdesHT639Z99LweR43OcMXoa5pldXhsQsAIqs7JqmjLLsm2VHU5ZVZZNWWyLpqgquFZU2cMP4a4GB/a+b3cz9lW4oXDmx5e663Q/2yc/T86cfeo207o/tRh50aMpejswzPHk2PjQjWr0pKnFo6V5dIY5eZbt2/v3GjNfYsfgLFm8U8yyLFASt0ms8qJ4Ltn4HLbEMP6qLEKySLGb3sxiKDZm0RzzNE4xzLNpjWOBZKMzWLxUbKJSRkfAOI7BVsYwm2IYC2mAYMglgc1VK9YTCRbvEMyzfbUk096M0aTGsNAPMMyOFXN6M9hctcbGsud+zL2I7jAMNheCwZJgGKdkh2J+gGDMpootejOP07liPdEUPgAcswmGsTDBME5cDLOJW6MYCRTTERgdAfP912QUy5aSOf+acfpkK/8ZQQ7rfrs/92acJhgmdgmKkQDHME8LSfe9aX8ONNSylCQBipH/gy30xdeZA/0V5vRmJHEVsyzLs0QTkXXMY5wzxjgMuy1NXXf1KFkosmG0haKUQKlPIFe2arbfJfNVCXS6ZeW28xVM4QAV5fyLZOaH37bZdCcb0cM3UJLdivIcxnoNY53n4gjX4NUtTGQ5KMkQ4dkljl1foZgxGGIYyl0Ywr05U70bGgh3MRz8Ak369A3i0K7tAAAAAElFTkSuQmCC"

okData=
(
 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
)

tickData=
(
 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
)


FileCreateDir, tiles

tileset=bla,Bam01,Bam02,Bam03,Bam04,Bam05,Bam06,Bam07,Bam08,Bam09,char01,char02,char03,char04,char05,char06,char07,char08,char09,cir01,cir02,cir03,cir04,cir05,cir06,cir07,cir08,cir09,dra01,dra02,dra03,flow01,flow02,flow03,flow04,sea01,sea02,sea03,sea04,wind01,wind02,wind03,wind04

loop, parse, tileset, "`,"
{
 if !fileexist(a_scriptdir . "\tiles\" . a_loopfield . ".png")
 extract_tile(%a_loopfield%,a_scriptdir . "\tiles\" . a_loopfield . ".png")
}

FileCreateDir, sounds

sounds=ok,tick

loop, parse, sounds, "`,"
{
 if !fileexist(a_scriptdir . "\sounds\" . a_loopfield . ".mp3")
 extract_tile(%a_loopfield%Data, a_loopfield . ".mp3")
}

filemove, *.mp3, sounds\*.*


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
