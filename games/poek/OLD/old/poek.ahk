/*
Name: 
Version 1.0 (Wednesday, July 13, 2016)
Created: Tuesday, June 21, 2016
Author: tidbit
Credit: 
	AfterLemon - Helping with item list stats 

Hotkeys:
	esc --- Quit

Description:
	A completely random game with turn-based combat, 1000+ items to discover and
	many enemy types. Explore fields to the city, remote villages and even space!
	Climb trees in the forest and dig through hay in a farm. 
	Fight crazy enemies	such as a Goat herder wearing a Leotard and attacking 
	you with and army of Hippos. Or a Mop wearing a Skillet and attacking you
	with a Crepe.
*/

; Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
setControlDelay, -1
setBatchLines, -1
#SingleInstance, force
_name_:="poek"
_version_:="1.0"
_author_:="tidbit"

global canvasW:=70 ; display area width in characters
global canvasH:=7  ; display area height in characters
fightSpeed:=1200   ; time between fighting turns
gameSpeed:=1000    ; time between actions like walking and resting
autoPlay:=1   ; have the computer randomly play for you? Note: it's very random, not much AI involved
isPaused:=0   ; start out paused?
maxGear:=5    ; how many weapons can you equip? and armor. each get this qty
day:=1        ; how long have you been playing, in game days


; misc colors:
; fBG:="#ff0000" ; easier for testing
fBG:="#360E0E" ; combat bg color
hBG:="#175053" ; healing combat bg color

; DO NOT TOUCH
chanceOfEvent:=3
turn:=0 ; 0=you, 1=enemy
log:="" ; event log
distWalked:=0 ; used for zones
dirToMove:="North"
isInTree:=""
inEvent:=""
zone:="" ; default zone
isFight:=0
SBM_GETPOS:=0xE1
SBM_SETPOS:=0xE0

; debug stuff
ucombat:=1 ; use combat
umove:=1   ; use moving
dbgLog:=""

; base stats. [base, per-level]
; make this global because a bunch of functions might use it for the event system
global player:={"name":"tidbit"
, "Level":1
, "expc":0, "expm":1000
, "hp":80, "hpm":[100, 20]
, "Deaths":0
, "Fights":0
, "Skills":{"Flick":6
          , "Lick":5
          , "Kick":8
          , "Heal":10
          , "Punch":10}
, "Gear":{"W":[], "A":[]}
, "Inv":{}}
player.hpm.1+=player.hpm.2*(player.level-1)


zones:={"Farm":{"size":15
,    "enemies":["Cow","Farmer","Old farmer","Bat","Cat","Pig"]
,    "events":["poo","hay"]}
, "Forest":{"size":10
,    "enemies":["Spider","Snake","Mushroom","Witch","Wolf","Bear"]
,    "events":["climb"]}
, "Mountain":{"size":20
,    "enemies":["Billy goat","Mountain goat","Markhor","Wild goat","Alpine goat","Goat herder"]
,    "events":[]}
, "Plains":{"size":20
,    "enemies":["Prairie dog","Snake","Tall grass","Coyote","Bunny","Cuttle fish"]
,    "events":[]}
, "Plateau":{"size":15
,    "enemies":["Lion","Antelope","Zebra","Elephant","Rhino","Poacher","Tourists"]
,    "events":[]}
, "Jungle":{"size":25
,    "enemies":["Hippo","Tiger","Panther","Pointy vines","Natives","Insect","Spider","Snake"]
,    "events":[]}
, "Space":{"size":40
,    "enemies":["Alien","Green alien","Gray alien","Big Brother","Comet","Nothing"]
,    "events":[]}
, "City":{"size":15
,    "enemies":["Hipster","Muffin","Cat","Gangsta","Creeper","Businessman "]
,    "events":["House"]}
, "Village":{"size":8
,    "enemies":["Old man","Old woman","Annoyed teen","Dog","Cat","Fish"]
,    "events":[]}
, "Abandoned house":{"size":5
,    "enemies":["Toaster","Chair","Wood plank","Mirror","Bucket","Mop"]
,    "events":[]}}


; enemies
fileRead, ttt, %A_ScriptDir%\enemies.csv
global enemies:=loadEnemies(ttt)

; items
; fileRead, ttt, %A_ScriptDir%\items ORIGINAL.csv
fileRead, ttt, %A_ScriptDir%\items2.csv
global items:=loadItems(ttt)
loop, 5 ; random starting gear
	addToInv(player, items)

ttt:=""
; msgBox % st_printArr(items)
; global items:={"Knife":{"stat":[8,3,-35], "qty":1} ; stat: [dmg, hp, heal]
; , "Apple":{"stat":[2,2,12], "qty":2}
; , "Manhole":{"stat":[5,26,-10], "qty":1}}
; msgBox % st_printArr(items)

enemy:=buildEnemy(enemies, -1, 3)


ccc:=0
br:="`n<br/>`n"

html=
(
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
	<title>New Document</title>
	<meta name="generator" content="EverEdit" />
	<meta name="author"	content="" />
	<meta name="keywords" content="" />
	<meta name="description" content=""	/>
	<style>
		html, body {margin: 0 1em`; padding: 0`; color: #ffffff`; background-color: #123331`;
		font-family: consolas`; font-size: 10pt`;}
		
		div, p {white-space: pre`; margin: 0`; }
		span {margin: 0`;}
		#centerScroll {overflow: hidden`; text-align: center`;}
		; #main {text-align: center}

		.left {text-align: left}
		.right {text-align: right}
		.center {text-align: center}
		
		; .row1, .row2 {margin-left: 10`%`; width: 80`%`;}
		.row1 {background-color: #8B0000}
		.row2 {background-color: #556B2F}
		.row1:hover, .row2:hover {background-color: #336699}

		.farm {background-color: #4B381F}
		.forest {background-color: #005500}
		
		.pname {color: #FFB355`; font-weight: bold`;}
		.ename {color: #AD69EB`; font-weight: bold`;}
		.aname {color: #9CED67`; font-weight: bold`;}
		.item {color: #6AEAC0`; font-weight: bold`;}

		.red {color: #FF5555}
		.yellow {color: #FFB355}
		.green {color: #9CED67}
		.blue {color: #60E6F4}
		
	</style>
</head>
<body id="centerScroll">
	<div id="main"></div>
</body>
</html>
)





log=
(
╔══════════════════════════════╗
║          <span class="pname">POEK</span> v1.0           ║
║         <span class="row1">random thing</span>         ║
╟──────────────────────────────╢
║          by tidbit           ║
╚══════════════════════════════╝`n
)
fightTrans=
(
╔══════════════════════════════════════╗
║......................................║
║.................Ready................║
║................FIGHT!................║
║......................................║
╚══════════════════════════════════════╝
)


; msgBox, % st_printArr(buildEnemy(enemies, -1, 5))
; exitapp

menu, guibar, add, Pause, menuH
; menu, guibar, add, Pause, menuH
menu, guibar, add, 
menu, guibar, add, Full Log, menuH
menu, guibar, add, 
menu, guibar, add, About/Help, menuH
gui, menu, guiBar

menu, invMenu1, add, Equip as weapon, ImenuH
menu, invMenu1, add, Equip as armor, ImenuH
menu, invMenu1, add, Eat, ImenuH
menu, invMenu2, add, Unequip, ImenuH

gui, add, StatusBar
SB_SetParts(canvasW, canvasW*1.5, canvasW*1.3)
SB_SetText("Day: 9999", 1)
SB_SetText("Level: 999 (100%)", 2)
SB_SetText("HP: 1000/1000", 3)
SB_SetText("Zone: AAA BBBBBB (South)", 4)

gui, fullLog: +owner1 -alwaysOnTop ; +toolWindow
gui, fullLog: font,, consolas
gui, fullLog: add, edit, xm ym w400 r22 hidden disabled hwndFLHWND vfullLogEdit
gui, fullLog: add, activex, xp yp wp hp vflwb, shell.explorer
global flwb
flwb.navigate("about:blank")
flwb.Document.write(html)
flwb.Document.body.removeAttribute("id", "centerScroll")
htmlUpdate(f(log),,flwb)

gui, font, s10
gui, margin, 0, 0
gui, +hwndMYHWND
tabList:="Fight|Item|Escape|Other"

gui, font,, consolas
gui, add, edit, xm ym w350 r%canvasH% readonly disabled hidden vdispDummy,
gui, add, activex, xp yp wp hp hwndLogInfo vwb, shell.explorer
global wb
wb.navigate("about:blank")
wb.Document.write(html)
htmlUpdate(f(log))


gui, font, 
gui, font, s12

gui, add, listbox, xm w75 r8 altsubmit vlb gswitch, % strReplace(tabList, "|", "||",, 1)
ttt:=canvasW*5
gui, add, button, x+m yp w%ttt% hp -theme disabled vtbtn

gui, add, listview, xp+3 yp+3 w244 r3 section disabled List -hscroll vlvF gfight, Fight
for k in player.skills
	lv_add("", k)

gui, font, s8
gui, add, listview, xs ys w244 r3 iconSmall vlvI gitem, Item|Type
invIcons:=IL_Create(4)
IL_Add(invIcons, "shell32.dll", 105) ; weapon
IL_Add(invIcons, "shell32.dll", 206) ; armor
IL_Add(invIcons, "shell32.dll",  42) ; food
IL_Add(invIcons, "shell32.dll", 131) ; animal
IL_Add(invIcons, "shell32.dll", 260) ; misc
	
gui, font, s12
gui, add, text, xs ys cBlue vtext1, Try and escape the battle.

gui, font, s8
gui, add, edit, xs ys w244 r3 readonly hwndOIHWND votherInfo
gui, font, s12

gui, tab

guiControlGet, pos, pos, tbtn
guiControl, move, lvF, % "x" posx+3 " w" posw-3-3 " h" posh-3-3
guiControl, move, lvI, % "x" posx+3 " w" posw-3-3 " h" posh-3-3
guiControl, move, wb, % " w" posw+posx
guiControl, move, otherInfo, % "x" posx+3 " w" posw-3-3 " h" posh-3-3

tabs:=[["lvF"],["lvI"],["text1"],["otherInfo"]]

gosub, loadInv
gosub, switch
gui, show, autosize, %_name_% (%_version_%) by %_author_%
; gosub, game

if (isPaused=0)
	setTimer, game, %gameSpeed%
else
	menu, guiBar, rename, Pause, Play
	
return

guiEscape:
guiClose:
	exitapp
return


Esc::
	critical
	exitapp
return


j::
	; clipboard:=dbglog
	; msgbox2(dbgLog)
	clipboard:=dbgLog
	; clipboard:=htmlUpdate(log)
	soundBeep
	; msgBox % st_printArr(player)
	; msgBox % st_printArr(enemy)
return


loadInv:
	gui, listview, lvI
	LV_Delete()
	LV_SetImageList(invIcons)
	for k in player.inv
		lv_add("icon" player.inv[k].type, k "(" player.inv[k].qty ")", player.inv[k].type)
	LV_ModifyCol(1, "Hdr")
	LV_ModifyCol(2, "Sort")
	; msgBox % st_printArr(player.inv)
return


menuH:
	if ((A_ThisMenuItem="Play" || A_ThisMenuItem="Pause"))
	{
		isPaused:=!isPaused
		if (isPaused=1)
		{
			menu, guiBar, rename, Pause, Play
			if (isFight=1)
				setTimer, fight, off
			else
				setTimer, game, off
		}
		else
		{
			menu, guiBar, rename, Play, Pause
			if (isFight=1)
				setTimer, fight, %fightSpeed%
			else
				setTimer, game, %gameSpeed%
		}
	}
	if (A_ThisMenuItem="Full Log")
	{
		gui, fullLog: default
		; guiControl,, fullLogEdit, %log%
		htmlUpdate(f(log),,flwb, 0)
	 	; SendMessage, 0x115, 7, 0,, ahk_id %FLHWND% 
	 	winGetPos, xx, yy, ww,, ahk_id %MYHWND%
	 	xx+=ww//2
	 	yy+=100
		gui, fullLog: show, x%xx% y%yy%, %_name_% - full Log
	}
return


switch: ; switch tabs using a listbox. I really hate this method.
	critical
	gui, submit, noHide
	gui, default
	tabCont(lb, tabs*)
	
	dbglog.="listbox: " lb "`n"
	if (lb=3 && isFight=1) ; 3=escape
	{
		if (rand(2)=1 && cToEsc=1) ;chance to escape = 1 and 50/50 chance
		{
			isFight:=0
			log.="< Escaped the " enemy.name "`n"
			dbglog.="escaped`n"
			htmlUpdate(f(log))

			enemy:={}
			if (isPaused=0)
				settimer, game, %gameSpeed%
		}
		else
		{
			cToEsc:=0
			dbglog.="couldn't escape`n"
			htmlUpdate(f("Couldn't escape.`n`nThe " enemy.name " has too good of a grip on you to escape!`n`n`n"))

			sleep, 2000
			drawCombat(player, enemy, turn) 
		}
	}
	if (lb=4)
	{
		; guiControl, -redraw, %otherInfo%
		dmg:=about(10, 50, 1)
		for k, v in player.gear.w
			dmg+=player.inv[v].stat[1]
		otherInfo:=""
		. "--- Stats --- (click again to update)"
		. "`nName: " player.name
		. "`nLevel: " player.Level
		. "`nExp: " player.expc "/" player.expm " (" round(player.expc/player.expm*100, 2) "`%)"
		. "`nHealth (HP): " player.hp "/" player.hpm.1 " (" round(player.hp/player.hpm.1*100) "`%)"
		. "`nDamage: Something like " dmg//3 "-" dmg+(dmg//3) " or more, or less"
		. "`n --- Location ---"
		. "`nDay: " day`
		. "`nLocation: " zone
		. "`nHeading: " dirToMove
		. "`nIn a tree? " ((isInTree!="") ? "Yes" : "No")
		. "`n --- Misc ---"
		. "`nDeaths: " player.deaths
		. "`nFights: " player.fights
		. "`n --- Gear ---"
		. "`nWeapons:`n" rtrim(st_glue(player.gear.w), "`r`n `t")
		. "`nArmors:`n" rtrim(st_glue(player.gear.a), "`r`n `t")
		
		zzz:=dllCall("GetScrollPos", "ptr", OIHWND, "int", 1)
		guiControl,, otherInfo, %otherInfo%
		if (zzz>0 || zzz!="")
			loop, %zzz%
			 	SendMessage, 0x115, 1, 0,, ahk_id %OIHWND% 
		; guiControl, +redraw, %otherInfo%
	}
return

#if (winActive("ahk_id" MYHWND))
	\::toolTip, % st_printArr(enemy) "`n-----`n" st_printArr(player)
	p::
	game:
		; gui, submit, noHide
		gui, default
		mode:=rand() ; 85% move, 15% combat
		lll:=""
		ttt:=""
		randE:=1 ; random enemy
		player.hp:=round(player.hp)
		
		mode2:=0
		mode2:=(umove=1 && ucombat=0) ? 1 
		     : (umove=0 && ucombat=1) ? 2 : 0
		if (mode<=85 && umove=1)
			mode2:=1 ; move
		else if (mode<=100 && ucombat=1)
			mode2:=2 ; combat
		if (mode2=0)
			return

		guiControlGet, lvf, Enabled
		guiControlGet, lvI, Enabled
		if (lvf=1)
			guiControl, disable, lvf
		if (lvI=0)
			guiControl, enable, lvI
		
		; it's a new day!
		day+=rand(0.05, 0.1)
		if (floor(day)!=floor(pday))
		{
			log.="--- " f( "Day " floor(day),,"yellow") " ---`n"
			ttt:=about(100, 20, 1)
			log.="--- You learn something new everyday. +" f(ttt,,"green") " exp ---`n"
			leveledUp:=addExp(player, ttt)
			if (leveledUp=1)
				log.="--- You're now level " f(player.level,, "green") "! ---`n"
			player.hp+=rand(player.hpm.1//5, player.hpm.1//2)
			player.hp:=clamp(player.hp, 1, player.hpm.1)
			log.="* Lv. " f(player.level,,"green") ", Hp " f(player.hp "/" player.hpm.1,,"blue")  " *`n"

			dbglog.="day:" day ", Lv. " player.level ", Hp " f(player.hp "/" player.hpm.1,,"blue")  "`n"
		}
		pday:=day

		resting:=0
		if (player.hp/player.hpm.1<=0.7)
			resting:=1
			
		if (resting=1)
		{
			player.hp+=rand(player.hpm.1//5, player.hpm.1//3)
			player.hp:=clamp(player.hp, -(player.hpm.1), player.hpm.1)
				
			log.="> Resting " f(player.hp "/" player.hpm.1,,"blue") "`n"
			dbglog.="resting: " f(player.hp "/" player.hpm.1,,"blue") "`n"
			htmlUpdate(f(log))

			
			if (player.hp=player.hpm.1)
				resting=0
			return
		}
		
		if (distWalked>zsize || zone="") 
		{
			distWalked:=0
			while (zone=pzone)
				zone:=randKey(zones)
			; zone:="City"
			pzone:=zone ; previous zone
			zsize:=about(zones[zone].size, 25, 1) ; zone size +/- 25%
			log.="--- You have entered " f(zone,,"aname") " ---`n"
			dbglog.="zone: " zone "`n"
		}

		
		; equip gear if autoPlay mode is on
		if (autoPlay=1 && rand()<=30 && inEvent="")
		{
			ttt:=0 ; yes I reuse this a lot
			pool:=[]
			iState:=0 ; was item successfully un/equipped?
			pgw:=player.gear.w.length()
			pga:=player.gear.a.length()
			for k, v in player.inv ; if there is an item in the inv
				if (v.qty>0)
					pool.push(k)
			if (pool.length()>0) ; && (pgw<maxGear || pga<maxGear))
			{
				aPType:=(pga=maxGear) ? "w" 
				: (pgw=maxGear) ? "a"
				: (rand(1,2)=1) ? "w" : "a"
				
				aPItem:=pool[rand(pool.length())] ; autoplay item
				aPMode:=rand() ; equip, unequip or eat
				if (aPItem~="^\.\w+\:") ; if it's already equipped, strip info
					aPType:=subStr(aPItem, 2, 1)
					, aPItem:=subStr(aPItem, 4)
					, ttt:=1
				dbglog.="AG " aPType ", " aPItem ", " ttt ", " aPMode "`n"
				dbglog.="-- AG-W " iState " " player.gear.w.length() "/" maxGear ", AG-A " player.gear.a.length() "/" maxGear "`n"
				; toolTip, % aPItem "::" aPType "::" aPMode "::" ttt "`n--`n" st_printArr(pool)
				if (aPMode<=80) ; un/equip
				{
					if (ttt=1 && rand()<50) ; make unequipping less frequent
						lll.=unequipItem(player, aPItem, aPType)
						, dbgLog.="Unequip --- " lll
						, iState:=1
					else if (ttt=0 && (pgw<maxGear || pga<maxGear))
						lll.=equipItem(player, aPItem, aPType)
					    , dbgLog.="equip --- " lll
						, iState:=1
				    dbgLog.="un/e --- " lll
				}
				else if (player.hp<player.hpm.1) ; eat if hp is low
				{
					; if an equipped item was chosen, remove before eatting
					if (ttt=1)
						lll.=unequipItem(player, aPItem, aPType)
					lll.=eat(player, aPItem)
					dbgLog.="eat --- " lll
				}
				dbglog.="--- AG-W " iState " " player.gear.w.length() "/" maxGear ", AG-A " player.gear.a.length() "/" maxGear "`n"
				if ((iState=1 && aPMode<=80) || player.hp<player.hpm.1)
				{
					log.=lll

					htmlUpdate(f(log))
					gosub, loadInv
					return
				}
			}
		}
		; msgBox % inEvent "::" mode2
		if (mode2=1 || inEvent!="") ; walk and other non-enemy actions
		{
			dbglog.="walk and other non-enemy actions `n"
			isFight:=0
			eventChance:=rand()
			ttt:=zones[zone].events
			; msgBox % inEvent "/" curEvent "/" eventChance
			
			; event log symbols are prefixed with a :
			; if ((eventChance<=5 || inEvent!="")) 
			if ((eventChance<=chanceOfEvent || inEvent!="")) 
			{
				curEvent:=ttt[rand(ttt.maxindex())]
				
				dbglog.="E: " inEvent "/" curEvent " --> " zone
				; forest events
				if (zone="forest")
				{
					if (curEvent="climb" || inEvent="climb") ; tree climb
					{
						isInTree:=1
						ttt:=climb()
						inEvent:=isInTree:=ttt.1
						log.=":^ " ttt.2 "`n"
						dbglog.="-- " ttt.2 "`n"
					}
				}

				if (zone="City" || zone="Abandoned house")
				{
					; zName:=""
					if (curEvent="House" || inEvent="House")
					{
						isInHouse:=1
						pzone:=zone
						zName:="Abandoned house"
						zone:="Abandoned house"
						if (inEvent="")
							hsize:=rand(zones[zName].size, zones[zName].size+6)
						ttt:=abandonedHouse(hsize, player, items)
						if (ttt.3!="")
							gosub, loadInv
						inEvent:=isInHouse:=ttt.1
						if (inEvent="")
							zone:=pzone
						log.=":^" ttt.2 "`n"
						dbglog.="-- " ttt.2 "`n"
					}
				}
				
				if (zone="farm")
				{
					if (curEvent="poo" || inEvent="poo"
					|| curEvent="hay" || inEvent="hay")
					{
						cToEsc:=0
						selEnemy:=""
						if (rand()<=60) ; chance to find item, otherwise combat
						{
							ttt:=farmEvent1(player, items, 1, curEvent)
							gosub, loadInv
						}
						else
							ttt:=farmEvent1(player, enemies, 2, curEvent)
							, randE:=0 ; don't choose random enemy
							, selEnemy:=ttt.3 ; use this enemy
							, mode2:=2 ; fight
						
						log.=":" ((curEvent="poo") ? "@" : "#") ttt.2 "`n"
						dbglog.="-- " ttt.2 "`n"
						htmlUpdate(f(log))

						; sleep, 1000
						inEvent:=ttt.1
						
						if (selEnemy="")
							return
					}
				}
			}
			if (inEvent="")
			{
				distWalked+=1
				; guiControl, disable, lvf
				; guiControl, enable, lvI
				if (changeDir=1 || changeDir="")
					dirToMove:=move(rand())
				changeDir:=rand(4) ; 25% chance to choose a new direction
				log.="> Walking " dirToMove "`n"
				dbglog.="Walking " dirToMove "`n"
			}

			htmlUpdate(f(log))
		}
		if (mode2=2 && ucombat=1) ; fight
		{
			isFight:=1
			player.fights+=1
			cToEsc:=1 ; give the player a chance to escape
			dbglog.="fight`n"
			setTimer, game, off
			guiControl, disable, lvf
			guiControl, disable, lvI
			
			enemy:=buildEnemy(enemies
			, (randE=0) ? selEnemy 
			: zones[zone, "enemies", rand(zones[zone].enemies.maxindex())]
			, about(player.level, 3))
			dbglog.="-- " enemy.level " " enemy.name "`n"
			; enemy:=buildEnemy(enemies, -1, 1)
			log.=f("! Fight: " f(player.name,, "pname") " vs " f("L." enemy.level " " enemy.name,,"ename"), "bg" fBG) "`n"

			htmlUpdate(f(log))
			; soundPlay, *48
			turn:=rand(0,1)
			; turn:=0
			
			sleep, 1200
			drawCombat(player, enemy, turn) 
			
			guiControl, enable, lvf
			guiControl, enable, lvI
			
			if (autoPlay=1)
				setTimer, fight, -%fightSpeed%
		}
	return


	~enter::
	~space::
		if (turn=1)
			return
	fight:
		critical
		gui, default
		if (A_GuiEvent="doubleclick" && turn=1)
			return
		if (isPaused=1)
			return
			
		gui, listview, lvF
		gui, submit, noHide
		if (isFight=1)
		{
			if (player.hp>=1 && enemy.hp>=1)
			{
				; 10% for someone to crit, player OR enemy
				crit:=(rand()<=10) ? rand(1.5, 3) : 1
				; player
				if (turn=0)
				{
					selSkill:=0 ; selected fight skill
					selSkill:=LV_GetNext(selSkill)
					selSkill:=(selSkill!=0) ? selSkill : 1
					LV_GetText(pSkill, selSkill)

					if (autoPlay=1)
					{
						pskill:=randKey(player.Skills)
						while (pSkill="heal" && player.hp>=player.hpm.1)
							pskill:=randKey(player.Skills)
					}
					if (trim(pSkill)="")
						msgBox % pskill "`n---`n" st_printArr(player.Skills)
					if (pSkill="heal")
					{
						dmg:=floor(about(player.skills[pSkill], 10, 1))
						player.hp:=clamp(player.hp+dmg,, player.hpm.1)
						combatMsg:=f(f(player.name,,"pname") " healed for " f(dmg,,"blue") " HP","bg" hBG)
					}
					else
					{
						dmg:=about(player.skills[pSkill], 10, 1)
						for k, v in player.gear.w
							dmg+=player.inv[v].stat[1]
						dmg:=floor(dmg*crit)
						enemy.hp-=dmg
						
						combatMsg:=((crit>1) ? f("Critical! ","b;i;") : "")
						. f(player.name,,"pname") " " f(pskill "'d","b;") 
						. " " f(enemy.name,,"ename") " for " f(dmg,,"blue") " HP" 
						
					}
					log.=f("`t! " combatMsg "`n", "bg" fBG,, "span")
				}
				else if (turn=1) ; enemy
				{
					; too lazy to give the enemy an inventory system
					; so I'll simulate it with a small random number
					if (enemy.hp<enemy.hpm && rand()<=22)
					{
						dmg:=(rand()<=20) ? rand(-5, 0) : rand(0,10)
						enemy.hp:=clamp(enemy.hp+dmg,, enemy.hpm)
						combatMsg:=f(f(enemy.name,,"ename") " healed for " f(dmg,,"blue") " HP","bg" hBG)
						log.=f("`t! " combatMsg "`n", "bg" fBG)
					}
					else
					{
						dmg:=about(enemy.dmg, 20, 1)+enemy.w[2]
						dmg:=floor(dmg*crit)
						; msgBox % f(dmg,,"blue") "::" st_printArr(enemy)
						player.hp-=dmg
						combatMsg:=((crit>1) ? f("Critical! ","b;i;") : "" ) f(enemy.name,,"ename") " hurt " f(player.name,,"pname") " for " f(dmg,,"blue") " HP" 
						log.=f("`t! " combatMsg "`n", "bg" fBG)
					}
				}
			}
			
			if (player.hp>=1 && enemy.hp>=1) ; if they are STILL both alive
			{
				turn:=!turn
				if (turn=1 || autoPlay=1)
					setTimer, fight, -%fightSpeed%
			}
			else ; if someone is dead
			{
				if (player.hp>0) ; if player is alive
				{
					ttt:="You " pSkill "'d "
					. prefix(f(enemy.name,, "ename"))
					. " to death"
					. ((player.gear.w.length()>0) 
					? " with " prefix(f(player.gear.w[rand(player.gear.w.length())],,"item")) "!" 
					: "!")
					log.=f(ttt "`n", "bg" fBG)

					if (rand()<=50) ; 50% chance an enemy will drop part of their gear
					{
						ccc:=addToInv(player, items, (rand(1,2)=1) ? enemy.w.1 : enemy.a.1)
						log.=f("$ You took " f(enemy.name,,"ename") "'s " f(ccc.1 " (" ccc.2 ")",,"item"), "bg" fBG) "`n"
						gosub, loadInv
					}

					LD:=enemy.level-player.level ; Level difference
					; your level + 0 ~= 256 exp
					; your level + 1 ~= 320 exp
					; your level + 2 ~= 480 exp
					; etc...
					expToAdd:=about((LD=1) ? 212 : (LD=2) ? 320 : (LD>=3) ? 380 
					: (LD>=4) ? 440 : (LD>=5) ? 512
					: (LD=-1) ? 160 : (LD=-2) ? 130 : (LD<=-3) ? 100 
					: (LD<=-4) ? 75 : (LD<=-5) ? 50 
					: 180
					, 30, 1)
					log.=f("You earned " expToAdd " exp" , "bg" fBG) "`n"
					leveledUp:=addExp(player, expToAdd)

					; toolTip, % st_printArr(player)
					if (leveledUp=1)
					{
						log.="--- You have leveled up to " f(player.level,,"green") "! ---`n"

						htmlUpdate(f("`n`n" ttt "`n`nYou have leveled up to " f(player.level,,"green") "!`n`n`n"))
						sleep, 1800
					}
				}
				else ; if enemy is alive
				{
					player.deaths+=1
					ttt:=f(enemy.name,,"ename") " defeated you" 
					. ((enemy.w.1!="") ? " with " prefix(f(enemy.w.1,,"item")) : "")
					
					log.=f("x " ttt, "bg" fBG) "`n"
					; htmlUpdate(f(log))
					htmlUpdate(f("`n`n"
					. ttt
					. "`n`nYour HP: " f(floor(player.hp) "/" floor(player.hpm.1),,"blue") "`n"
					. "`nYou hide in " prefix(f(getItem(items)[1],,"item")) "`nwhile you heal"))

					; . ttt
					; . "`n`nYour HP: " floor(player.hp) "/" floor(player.hpm.1) "`n"
					; . "`nYou hide in a <random object>`nwhile you heal")
					sleep, 3500
				}

				; log.=ttt "`n"
				isFight:=0  ; fighting is over
				enemy:={} ; clear the enemy array for, just because
				settimer, game, %gameSpeed% ; resume the game
				return ; end the fighting stuff
			}
			drawCombat(player, enemy, turn,, combatMsg)
		}
	return


	GuiContextMenu:
	item:
		gui, default
		if (A_GuiControl!="lvI")
			return
		gui, listview, lvI
		LV_GetText(selItem, A_EventInfo)
		selItem:=regExReplace(selItem, "\(.*?\)")
		
		if (A_EventInfo=0 || player.inv[selItem].qty<=0)
			return
			
		if (!(selItem~="\.\w+\:"))
			menu, invMenu1, show
		else
			menu, invMenu2, show
	return

		
	ImenuH:
		gui, default
		gui, listview, lvI
		eType:="" ; equipment type, weapon or armor
		lll:=""
		; equip			
		if (!regExMatch(selItem, "^\.\w+\:") && inStr(A_ThisMenuItem, "Equip as"))
		{
			if (inStr(A_ThisMenuItem, "weapon"))
				eType:="W"
			if (inStr(A_ThisMenuItem, "armor"))
				eType:="A"
			toAdd:=selItem
			lll:=equipItem(player, toAdd, eType)
			turn:=1 ; enemies turn
		}
		else if (selItem~="^\.\w+\:" && A_ThisMenuItem="Unequip")
		{ ; unequip
			eType:=subStr(selItem, 2, 1)
			toRemove:=subStr(selItem, 4)
			lll:=unequipItem(player, toRemove, eType)
			turn:=1 ; enemies turn
		}
		else if (A_ThisMenuItem="Eat")
		{
			lll:=eat(player, selItem)
			turn:=1 ; enemies turn
		}
		
		log.=((isFight=1) ? "`t" : "") lll
		; toolTip % st_printArr(player)
		gosub, loadInv
		if (isFight=1)
		{
			drawCombat(player, enemy, turn,, "" combatMsg) ; show the arrow pointing to the enemy
			sleep, 1300
			gosub, fight ; let the enemy attack
		}
		else
		{

			htmlUpdate(f(log))
			if (isPaused=0)
				setTimer, game, %gameSpeed%
		}
	return
	
#if


about(in, num=5, perc=0) ; number give or take Num, optionally a percent
{
	ttt:=round(in*(num/100))
	if (perc=0)
		random, anum, % in-num, % in+num
	else
		random, anum, % in-ttt, % in+ttt
	return clamp(anum, 0)
}

prefix(word) ; create a proper a/an <word>, basic system
{
	return ((word~="i)^[aeiou]") ?  "an" : "a") " " word
}

clamp(num, min="", max="")
{
	return ((num<min && min!="") ? min : (num>max && max!="") ? max : num)
}

rand(max=100, min=1)
{
	if (min>max)
		t:=max, max:=min, min:=t
	random, r, %min%, %max%
	return r
}

setSB(fields*)
{
	for k,v in fields
		SB_SetText(fields[k], k)
	; SB_SetText("Day: 9999", 1)
	; SB_SetText("Level: 999 (100.0%)", 2)
	; SB_SetText("HP: 1000/1000", 3)
	; SB_SetText("Zone: AAA BBBBBB (South)", 4)
}

; name: tabCont
; version: 1.0 (Monday, July 11, 2016)
; created: Monday, July 11, 2016
; info: Simulate a tab control by hiding/showing groups of controls
;
; tab    = the group number you want to show, all others are hidden
; cList* = A 2D array of the controls. [[group1-1, group1-2], [group2-1, group2-2], [...]]
tabCont(tab, cList*)
{
	for curList, v in cList
		for k2, v2 in v
			guicontrol, % (curList=tab) ? "show" : "hide", % trim(v2)
}

move(dir)
{
	if (dir<=35)
		return "North"
	else if (dir<=60)
		return "East" 
	else if (dir<=85)
		return "West"
	else if (dir<=100)
		return "South"
}

randKey(Arr)
{
	for k in Arr
		max:=A_Index
	ttt:=rand(max)
	for k in Arr
		if (A_Index=ttt)
			return k
}


addToInv(byref pArr, iList, item=-1)
{
	iii:=getItem(iList, item)
	if (!(pArr.inv.hasKey(iii.1)))
		pArr.inv[iii.1]:=iii.2
		, pArr.inv[iii.1].qty:=rand(iii.2.qty)
	else
		pArr.inv[iii.1].qty+=rand(iii.2.qty)
	return [iii.1, iii.2.qty]
}

getItem(iList, name=-1, qty1=1, qty2=3)
{
	arr:={}
	if (name=-1)
		name:=randKey(iList)
	for k, v in iList[name]
		arr[k]:=v
	arr.qty:=rand(qty1, qty2)*iList[name].qty
	return [name, arr]
}

drawCombat(pArr, eArr, turn=2, pre="", end="") ; player/enemy arrays
{
	playerText:= ""
	. ((eArr.hp<=0) ? "Winner " : "") . ((turn=0) ? "--> " : "")
	. f(pArr.name,,"pname") "   Lv." pArr.level
	. "`n" ASCIIBar((pArr.hp/pArr.hpm.1)*100)
	. "`n" floor(pArr.hp) "/" floor(pArr.hpm.1)
	
	enemyText:=""
	. "" format("{:t}", trim(substr(eArr.w.1,1,3) substr(eArr.a.1,1,3))) " "
	. f(eArr.name,,"ename") "   Lv." eArr.level 
	; . " (" eArr.w.1 ", " eArr.a.1 ")"
	. ((turn=1) ? " <--" : "") . ((pArr.hp<=0) ? "Winner" : "")
	. "`n" ASCIIBar((eArr.hp/eArr.hpm)*100)
	. "`n" floor(eArr.hp) "/" floor(eArr.hpm)
	
	enemyText:="<div class='left'>" div(enemyText) "</div>"
	playerText:="<div class='right'>" div(playerText) "</div>"
	
	return htmlUpdate(pre enemyText "" playerText "" end,,,0)
}

addExp(byref pArr, exp=1)
{
	pArr.expc+=exp
	lup:=0 ; leveled up
	while (pArr.expc>pArr.expm) ; a rolling EXP system
	{
		lup:=1
		pArr.expc-=pArr.expm
		; pArr.expm*=1.2
		pArr.level+=1
		pArr.hpm.1+=pArr.hpm.2
		pArr.hp+=pArr.hpm.2
		for k, v in pArr.Skills ; add 15% more damage to each skill
			pArr.Skills[k]+=v*0.15
			
		; msgbox, % pArr.level "`n" pArr.expc "/" pArr.expm "`n---`n" st_printArr(pArr)
	}
	return lup
}


buildEnemy(arr, enemy=-1, lvl=1)
{
	if (enemy=-1)
	{
		for k in arr
			max:=A_Index
		random, enemy, 1, %max%
		for k in arr
			if (A_Index=enemy)
			{
				enemy:=k
				break
			}
	}
	adef:=0, aname:="defense"
	watk:=0, wname:="attack"
	if (rand()<=100)
		weapon:=getItem(items, -1, 1, 1)
		, watk:=weapon[2].stat[1]*rand(1,3)
		, wname:=weapon.1
	if (rand()<=100)
		armor:=getItem(items, -1, 1, 3)
		, adef:=armor[2].stat[2]*rand(1,3)
		, aname:=armor[1]
	jjj:={"name":enemy
	, "level":lvl
	, "hp":arr[enemy,"hp",1]+(arr[enemy,"hp",2]*lvl)+adef
	, "hpm":arr[enemy,"hp",1]+(arr[enemy,"hp",2]*lvl)+adef
	, "dmg":arr[enemy,"dmg",1]+(arr[enemy,"dmg",2]*lvl)
	, "w":[wname, watk]
	, "a":[aname, adef]}
	return jjj
}


ASCIIBar(Current, Max=100, Length=20, Unlock = 0)
{
	; Made by Bugz000 with assistance from tidbit, Chalamius and Bigvent
	; modified by tidbit (Tue May 28, 2013)
	Empty:="-"
	Full:="o"
	Percent:=(Current/Max)*100
	if (unlock = 0)
		length:=length > 97 ? 97 : length < 4 ? 4 : length
	percent:=(percent>100) ? 100 : (percent<0) ? 0 : percent
	Loop % round(((percent/100)*length), 0)
		Progress.=Full
	progress:=f(progress,"b;", "green")
	loop % Length-round(((percent/100)*length), 0)
		Progress.=Empty
	; progress:=f(progress,,"red")
	return "[" progress "]" f(round(percent)"%",,"red") 
}


loadItems(csv)
{
	arr:={}
	loop, parse, csv, `n, `r
	{
		if (A_LoopField="" || subStr(trim(A_LoopField), 1, 1)=";")
			continue
		loop, parse, A_LoopField, CSV
		{
			lf:=A_LoopField
			if (A_Index=1)
				name:=trim(lf)
			else if (A_Index=2 || A_Index=3 || A_Index=4)
				arr[name, "stat", A_Index-1]:=trim(lf)
			else if (A_Index=5)
				arr[name, "qty"]:=trim(lf)
			else if (A_Index=6)
				arr[name, "type"]:=(lf="!") ? 1 ; weapons
				: (lf="@") ? 2 ; armors
				: (lf="#") ? 3 ; foods
				: (lf="%") ? 4 ; animals
				: 5 ; $ misc
		}
	}
	return arr
}

loadEnemies(csv)
{
	arr:={}
	loop, parse, csv, `n, `r
	{
		if (A_LoopField="" || subStr(trim(A_LoopField), 1, 1)=";")
			continue
		loop, parse, A_LoopField, CSV
		{
			lf:=trim(A_LoopField)
			if (A_Index=1)
				name:=lf
			else if (A_Index=2)
				arr[name, "level"]:=lf
			else if (A_Index=3)
				arr[name, "hp"]:=strSplit(lf, "|")
			else if (A_Index=4)
				arr[name, "dmg"]:=strSplit(lf, "|")
			else if (A_Index=5)
				arr[name, "w"]:=["",0]
			else if (A_Index=6)
				arr[name, "a"]:=["",0]
		}
	}
	return arr
}

eat(pArr, selitem)
{
	toHP:=player.inv[selItem].stat[3]
	lll:=""
	if (pArr.hp>=pArr.hpm.1) ; && toHP>1)
		lll.=") Your tummy is too full to eat " prefix(f(selItem,, "item")) "`n"
	else
	{
		pArr.hp+=toHP
		pArr.hp:=clamp(pArr.hp,, pArr.hpm.1)
		pArr.inv[selItem].qty-=1
		
		if (pArr.hp<=0)
			lll.=") You ate " prefix(f(selItem,, "item")) " and died." "`n"
			, pArr.deaths+=1
		else
			, lll.=") You ate " prefix(f(selItem,, "item"))
			. " and " ((toHP>=0) ? "gained" : "lost")
			. " " abs(toHP) " HP" "`n"

		if (pArr.inv[selItem].qty<=0)
			pArr.inv.delete(selItem)
	}
	return lll
}

unequipItem(pArr, toRemove, eType)
{
	; toolTip % toRemove "`n---`n" st_printArr(pArr.inv[toRemove]), 200,0
	for k, v in pArr.gear[eType]
		if (v=toRemove)
		{
			pArr.inv[toRemove].qty+=1
			pArr.inv["." eType ":" toRemove].qty-=1
			pArr.gear[eType].removeAt(k)
			break
		}
	if (eType="A")
		pArr.hpm.1-=pArr.inv[toRemove].stat[2]
		, pArr.hp-=pArr.inv[toRemove].stat[2]
	; if there's 0 left, remove the equipped item from the list
	if (pArr.inv["." eType ":" toRemove].qty<=0)
		pArr.inv.delete("." eType ":" toRemove)
		
	return "- Unequip " f(toRemove,, "item")  " from: " ((eType="W") ? "weapon" : "armor") "`n"
}

equipItem(pArr, toAdd, eType)
{
	global maxGear
	if (pArr.inv[toAdd].qty>=1 && pArr.gear[eType].length()<maxGear)
	{
		; remove from base inventory item
		pArr.gear[etype].push(toAdd)
		pArr.inv[toAdd].qty-=1

		; clone the attributes to the new "equipped" item
		for k, v in pArr.inv[toAdd]
			pArr.inv["." etype ":" toAdd, k]:=v
			, pArr.inv["." etype ":" toAdd].qty:=0

		; loop through and find how many are equipped
		for k, v in pArr.gear[etype]
			pArr.inv["." etype ":" toAdd].qty+=(v=toAdd) ? 1 : 0
		if (eType="A")
			pArr.hpm.1+=pArr.inv[toAdd].stat[2]
			, pArr.hp+=pArr.inv[toAdd].stat[2]
		lll:="+ Equipped " f(toAdd,, "item") " as: " ((eType="W") ? "weapon" : "armor") "`n"

		turn:=1 ; enemies turn
	}
	else 
		lll:="ERROR1"
	return lll
}



div(html, class="", id=0) ; if id is 1, class is the id.
{
	for k, v in strSplit(html, "`n", "`r") ; turn each line into a div
		if (v!="")
			o.="<span>" v "</span>" "`n"
	return o
	; return (class="" && id=0) ? "<div>" o "</div>" 
	; : (id=0) ? "<div class='" class "'>" o "</div>"
	; : "<div id='" id "'>" o "</div>"
}


htmlUpdate(html, ID="main", browser="", trim1=1)
{
	global logInfo, day, zone, dirToMove
	if (browser="")
		browser:=wb

	; msgBox % "111`n`n" html
	if (trim1=1)
		html:=strReplace(html, "`t!", "!")
		; html:=regExReplace(html, "m`n)^[ \t]+")
	
	html:=div(html)
	; msgBox % "222`n`n" html
	; for k, v in strSplit(html, "`n", "`r") ; turn each line into a div
	; 	if (v!="")
	; 		html.=div(v) ; "`n"
			
	browser.document.getElementByID(ID).InnerHtml:=html
	browser.document.body.scrollIntoView({block: "end", behavior: "instant"})

	setSB("Day: " floor(day)
	, "Level: " player.level " (" round(player.expc/player.expm*100, 1) "%)"
	, "HP: " player.hp "/" player.hpm.1
	, "Zone: " zone " (" dirToMove ")")
	return html
}
; st_
; name:    html formatting function.
; version: 1 (Sunday, July 10, 2016)
; created: Sunday, July 10, 2016
; info:
;     existing shortcuts are: b, i, u, c#, bg#
; example: "I " f("HATE","c#ff0000 b") " veggies!"
;     result: I HATE veggies ... where HATE is red and bold
f(text, formatting="", hClass="", type="span")
{
	formats:=strSplit(formatting, [" ", ";", "`t", ","])
	for k, v in formats
	{
		if (v="")
			continue
		v:=trim(v)
		fo.=(inStr(v, "c#")) ? strReplace(v, "c#", "color: #") ; formatting output
		: (inStr(v, "bg#")) ? strReplace(v, "bg#", "background-color: #")
		: (v="b") ? "font-weight: bold"
		: (v="i") ? "font-style: italic"
		: (v="u") ? "text-decoration: underline"
		: v
		fo.=";"
	}
	fo:=(trim(fo, "; `t")="") ? "" : " style='" fo "'"
	if (hClass="")
		return "<" type " " fo ">" text "</" type ">"
	return "<" type " class='" hClass "'" fo ">" text "</" type ">"
}






#include, %A_ScriptDir%\stringStuff.ahk
#include, %A_ScriptDir%\events.ahk