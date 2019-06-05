/*
Name: 
Version 1.0 (Wednesday, August 10, 2016)
Created: Tuesday, June 21, 2016
Author: tidbit
Credit: 
	AfterLemon - Helping with item list stats 
	Coco       - JSON.ahk - https://autohotkey.com/boards/viewtopic.php?t=627
	GeekDude   - FixIE()
	
Hotkeys:
	esc --- Quit

Note: 
	A REGISTRY CHANGE IS NEEDED TO UPDATE YOUR OS's HTML RENDERING ENGINE.
	It will however be reset as soon as possible, usually less than a second.

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

; and so the messy code begins

; includes are at the bottom

prev:=FixIE()

_name_:="poek"
_version_:="1.0 (Wednesday, August 10, 2016)"
_author_:="tidbit"
_about_=

(join
`nName: %_name_%
`nVersion: %_version_%
`nAuthor: %_author_%
`nCredit:
`n    + AfterLemon
`n    + Coco
`n
`nHotkeys:
`n    space --- Advance the game by 1 move, even if paused
`n
`nAbout:
`nThe main point of this game is to let it run in the background, play completely
 randomly in the background, for you to check up on every once in a while to see how your person
 is doing. However, there is manual play (which currently has no easy way to turn on, other than Pause + spacebar)
)

; yes, globals, because why not. it's just file paths.
global saveDir:=A_ScriptDir ; also the load directory
global autoLoadFile:=saveDir "\" _name_ "-autoLoad.json"
global autoLoadFileL:=saveDir "\" _name_ "-autoLoad-Log.html"

; fileRead, ttt, %A_ScriptDir%\enemies.csv
; global enemies:=loadEnemies(ttt)
; fileRead, ttt, %A_ScriptDir%\items.csv
; global items:=loadItems(ttt)



msgBox, 48, INCOMPLETE, This game is not complete, may be prone to bugs and unrefined game values (such as exp`, and item stats). However, it works.


; variables
fightSpeed:=1200 ; time between fighting turns
gameSpeed:=1000  ; time between actions like walking and resting
autoPlay:=1   ; have the computer randomly play for you? Note: it's very random, not much AI involved
isPaused:=1   ; start out paused?
maxGear:=5    ; how many weapons can you equip? and armor. each get this qty
day:=1        ; how long have you been playing, in game days

; debug stuff
ucombat:=1 ; use combat
umove:=1   ; use moving
dbgLog:=""

; ------
; "globals are bad. blah blah blah". Deal with it. (~˘▾˘)~
; it's easier than passing (and returning) several extra parameters to 
; every function that needs them. They need to get used by other things, so why
; not just make them global.

; ARRAYS
global history:=50 ; how many rows to show at a time
global enemies ; the list/array of enemies  [see: poek.ahk]
global player  ; player array. [see: poek.ahk]
global items   ; the list/array of items. [see: poek.ahk]
global zones   ; the list/array of zones. [see: poek.ahk]

; MISC
global inEvent ; The name of the current event. Used for events that span 
	           ; multiple game passes. Set to "" to end the event
global canvasW ; display area width in characters
global canvasH ; display area height in characters

; FIGHTING
global eFight ; event triggered fight? 1 = fight, 0 = no fight
global enemy  ; if you're going to fight, who will it be?
; ------


; ------
; colors:
; cfBG:="#ff0000"   ; easier for testing
cBG:="#123331"
cText:="#ffffff"
cfBG:="#360E0E"   ; combat bg color, normal
cfDBG:="#000000"  ; combat bg color, you got defeated
chBG:="#175053"   ; healing combat bg color
cday:="#55D9FF"   ; new day message
clevel:="#FFB355" ; player/enemy levels
cphp:="#60E6F4"   ; player hp
cexp:="#9CED67"   ; exp numbers

cpname:="#FFB355" ; player name
cename:="#AD69EB" ; enemy name
czname:="#9CED67" ; area/zone name
ciname:="#6AEAC0" ; item name

; bg color of these areas
cfarm:="#4B381F"
cforest:="#005500"

; colors...
cred:="#FF5555"
corange:="#FFB355"
cyellow:="#FAE25A"
cgreen:="#9CED67"
cblue:="#60E6F4"
cpurple:="#AD69EB"

; misc
crow1:="#586876"
crow2:="#47545F"
crow1h:="#336699"
crow2h:="#336699"
cmisc1:="#44505B"
cmisc2:="#14283D"
cmisc3:="#14283D"
; ------

; DO NOT TOUCH
canvasW:=90 
canvasH:=20
chanceOfEvent:=3
turn:=0 ; 0=you, 1=enemy
distWalked:=0 ; used for zones
dirToMove:="North"
inEvent:=""
eFight:=""
zone:="" ; default zone
zsize:=0
isFight:=0
global dispLog:=[]

; file menu
menu, fmenu, add, Load, menuH
menu, fmenu, add, Save AutoLoad, menuH
menu, fmenu, add, Save As, menuH
menu, fmenu, add, Export log, menuH
menu, fmenu, add,
menu, fmenu, add, Quit, menuH

; menu bar
menu, guibar, add, File, :fmenu


menu, guibar, add, Pause, menuH
; menu, guibar, add, Pause, menuH
menu, guibar, add, 
menu, guibar, add, Full Log, menuH
menu, guibar, add, 
menu, guibar, add, About/Help, menuH
gui, menu, guiBar


menu, invMenu1, add, Equip as weapon, equipItems
menu, invMenu1, add, Equip as armor, equipItems
menu, invMenu1, add, Eat, equipItems
menu, invMenu2, add, Unequip, equipItems

gui, add, StatusBar
SB_SetParts(canvasW, canvasW*1.5, canvasW*1.3)
SB_SetText("Day: 9999", 1)
SB_SetText("Level: 999 (100%)", 2)
SB_SetText("HP: 1000/1000", 3)
SB_SetText("Zone: AAA BBBBBB (South)", 4)


prev:=FixIE()

ttt:=canvasW*7
gui, fullLog: +owner1 -alwaysOnTop ; +toolWindow
gui, fullLog: font,, consolas
gui, fullLog: add, edit, xm ym w%ttt% r30 hidden disabled hwndFLHWND vfullLogEdit
gui, fullLog: add, activex, xp yp wp hp vflwb, shell.explorer

gui, font, s10
gui, margin, 0, 0
gui, +hwndMYHWND
tabList:="Fight|Item|Escape|Other"

gui, font,, consolas
gui, add, edit, xm ym w350 r%canvasH% readonly disabled hidden vdispDummy,
gui, add, activex, xp yp wp hp hwndLogInfo vwb, shell.explorer

FixIE(prev)

gui, font, 
gui, font, s12

ttt:=canvasW*5
gui, add, listbox, xm w75 r8 0x100 altsubmit vlb glbox, % strReplace(tabList, "|", "||",, 1)
gui, add, button, x+m yp w%ttt% hp -theme disabled vtbtn
; gui, add, Progress, x+m yp w%ttt% hp backgroundred cred vtbtn

gui, add, listview, xp+3 yp+3 w244 r3 section disabled List -hscroll vlvF gfight, Fight

gui, font, s8
gui, add, listview, xs ys w244 r3 list vlvI gglvI, Item|Type
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

tabs:=[["lvF"],["lvI"],["text1"],["otherInfo"]]

gosub, load
gosub, invUpdate
gosub, lbox
gosub, versionInfo
	
gui, +resize
gosub, guiSize

; this used to be the standard resolution of a monitor :D
gui, show, w640 h480, %_name_% (%_version_%) by %_author_%

if (isPaused=0)
	setTimer, game, %gameSpeed%
else
	menu, guiBar, rename, Pause, Play
return


Esc::
	critical
	exitapp
return



guiSize:
	guiControlGet, pos, pos, wb
	guiControl, move, wb, % "w" A_GuiWidth-posx-6 " h" A_GuiHeight//2-6
	guiControlGet, pos, pos, wb
	
	guiControl, move, lb, % "y" posy+posh+6 " h" A_GuiHeight-(posy+posh+6)-6-20
	guiControlGet, pos, pos, lb
	
	guiControl, movedraw, tbtn, % "y" posy " w" A_GuiWidth-posx-posw-6 " h" posh
	guiControlGet, pos, pos, tbtn
	
	guiControl, movedraw, lvF, % "y" posy+3 " w" posw-3-3 " h" posh-3-3
	guiControl, movedraw, lvI, % "y" posy+3 " w" posw-3-3 " h" posh-3-3
	guiControl, movedraw, text1, % "y" posy+3 " w" posw-3-3 " h" posh-3-3
	guiControl, movedraw, otherInfo, % "y" posy+3 " w" posw-3-3 " h" posh-3-3
return


GuiContextMenu:
glvI:
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


guiEscape:
guiClose:
YouReallyShouldntQuitPlayingIfYOuValueYourLife:
	mmm:=""
	loop, % rand(1, 5)
	{
		ttt:=0
		mmm.=" really"
		mmm:=trim(mmm) ; message
		iii:=randKey(items) ; item
		iii2:=prefix(iii) ; an item
		goodbye:=[iii2 " will haunt you"
		, iii2 " will stalk you"
		, iii2 " will lick you furiously"
		, "a stampede of " iii "'s will chase you down"
		, rand(2, 27) " " iii "'s will corner you in a dark alley"
		, iii " will no longer love you."
		, iii " " iii " " iii " " iii " " iii " " iii " " iii " " iii " " iii
		, iii2 " will attack when you're not looking"
		, iii2 " might eat you"]
		aaa:=choose(goodbye*) ; action
		msgBox, 67, %A_Index% - Quit?, Are you %mmm% sure you want to quit? Any unsaved changes will be lost!`n`nIf you do`, %aaa%
		ifMsgBox, yes
			ttt:=1
		else
			break
	}
	if (ttt=1)
		exitapp
return


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ---------------------------------- LOADING ----------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
load:
	fileRead, ttt, %A_ScriptDir%\res\enemies.csv
	global enemies:=loadEnemies(ttt)
	fileRead, ttt, %A_ScriptDir%\res\items.csv
	global items:=loadItems(ttt)
	fileRead, ttt, %A_ScriptDir%\res\zones.json
	global zones:=json.load(ttt)

	; clipboard:=st_printArr(items)
	
	; manual load:
	fileDelete, %A_ScriptDir%\tmp\session-tmp.html
	if (mload=1)
	{
		fileSelectFile, toLoad,,, Load a %_name_% file, *.json
		if (errorLevel=1)
			return
		splitPath, toLoad,, lfd, lfe, lfn
		; msgBox % lfd "\" lfn "-Log.html" "`n" toload
		fileRead, toLoad, % lfd "\" lfn ".json" ; start settings
		fileRead, slog, % lfd "\" lfn "-Log.html" ; start log
		fileAppend, %slog%, %A_ScriptDir%\tmp\session-tmp.html ; add old stuff in file session
		; msgBox %slog%
	}
	else if (FileExist(autoLoadFile)) ; auto load
	{
		fileRead, toLoad, %autoLoadFile%
	}
	
	; base stats. [base, per-level]
	; make this global because a bunch of functions might use it for the event system
	global player:=json.load(toLoad)
	; msgBox % st_printArr(player)
	
	; player doesn't exist/blank name
	if (trim(player.name, "`r`n `t")="")
	{
		inputBox, uname, Choose a name, Choose your name.`nTry and keep it short`, but there's no limit.,, 300, 180
			if (errorLevel=1 || trim(uname)="")
			{
				msgBox, cannot start a game without a name. Exiting.`nRe-run to try again.
				exitapp
			}
		global player:={"name": uname
		, "Level":1
		, "exp":0, "expm":1000
		, "hp":80, "hpm":[100, 9]
		, "Deaths":0
		, "Fights":0
		, "Skills":{"Flick":[6,3]
		          , "Lick":[5,2]
		          , "Kick":[8,5]
		          , "Heal":[10,4]
		          , "Punch":[10,5]}
		, "Gear":{"W":[], "A":[]}
		, "Inv":{}
		, "Settings": {"day":1, "zone":zone, "dtm":dirToMove, "steps":steps, "inEvent":inEvent}}
		
		; expAdd(10000) ; start out at level 10
		player.hpm.1+=player.hpm.2*(player.level-1)
		loop, 5 ; random starting gear
			invAdd()
		; for k, v in player.inv
		; 	player.inv[k].qty:=1
		; fileAppend, % json.dump(player), %autoLoadFile%
	}
	; loop, 80 ; random starting gear
	; 	invAdd()
	; gosub, invUpdate
	
	steps:=player.settings.steps
	zone:=player.settings.zone
	day:=player.settings.day
	dirToMove:=player.settings.dtm
	inEvent:=player.settings.inEvent
	pday:=floor(day)
	
	gui, listview, lvF
	for k in player.skills
		LV_Add("", k)
	; msgBox % st_printArr(player)
		
	ttt:=""
	; pool of usable items for AP mode
	epool:=[] ; equip/eat pool
	upool:=[] ; unequip pool

	; msgBox % mload "::" FileExist(lfd "\" lfn "-Log.html")
	if (mload=1 && FileExist(lfd "\" lfn "-Log.html")) ; manual load
		sText:=trim(slog, "`r`n `t")
	else if (FileExist(autoLoadFileL)) ; autoload
		fileRead, sText, %autoLoadFileL%
	else ; default
		sText=
		(ltrim
		<pre>.------------------------------.
		|          <span class="cpname">POEK</span> v1.0           |
		|         <span class="crow1">random thing</span>         |
		|──────────────────────────────|
		|          by <span class="cpname">tidbit</span>           |
		'------------------------------'</pre>`n
		)

	loop, parse, sText, `n, `r ; add the last entries to the log
	{
		if (dispLog.length()>=history)
			dispLog.removeAt(1)
		dispLog.push(A_LoopField)
	}
	save(4)
	sText:=st_glue(dispLog,, "`n")
	ttt:="0x" substr(cBG, 2)
	ttt:=format("#{1:06X}", (ttt & 0xBABABA) >> 1) ; make the color darker

	html=
	(ltrim
	<!DOCTYPE html>
	<html id="thtml" lang="en" xmlns="http://www.w3.org/1999/xhtml">
	<head>
	    <meta charset="utf-8" />
		<meta name="generator" content="EverEdit" />
		<meta name="author"	content="" />
		<meta name="keywords" content="" />
		<meta name="description" content=""	/>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge"> 
		<title>%_name_% %_version_% by %_author_%</title>
		<style>
			html, body {margin: 0 1em`; padding: 0`;
			color: %cText%`; background-color: %cBG%`;
			font-family: consolas`; font-size: 10pt`; cursor: default`;}
			
			div, p {margin: 0`;}
			span {margin: 0`;}
			
			#infoBox {position: fixed`; right: 0`; top: 0`;
			padding: 3px`; background-color: %cmisc1%`; border-left: 5px solid %cyellow%`;
			visibility: hidden`;}
			
			#infoBox .crow1, #infoBox .crow2 {padding: 0px 3px 0px 0px`;}
			
			#infoBoxX {float: right`; text-align: right}
			
			#combatdummy {position: fixed`; left: 0`; right: 0`; top: 0`; bottom: 0`; background-color: %ttt%`;}
			#combat {position: fixed`; left: 10`%`; right: 10`%`; top: 25`%`; bottom: 25`%`; padding: 0 1em`;
			background-color: %cBG%`;}
			#combatend {position: absolute`; bottom: 0`;}

			
			#hideScroll {overflow: hidden`;}
			
			.left {text-align: left}
			.right {text-align: right}
			.center {text-align: center}
			.pre {white-space: pre`; margin: 0`; line-height: 1em`;}

			.cfight {background-color: %cfBG%}
			.cfight2 {background-color: %cfDBG%}
			.cheal {background-color: %chBG%}
			.clevel {color: %clevel%}
			.cday {color: %clevel%}
			.cexp {color: %cexp%}
			.cphp {color: %cphp%}
			
			.crow1 {background-color: %crow1%`; width: 100`%`; white-space: nowrap`;}
			.crow2 {background-color: %crow2%`; width: 100`%`; white-space: nowrap`;}
			.crow1:hover {background-color: %crow1h%}
			.crow2:hover {background-color: %crow2h%}

			.cfarm {background-color: %cfarm%}
			.cforest {background-color: %cforest%}
			
			.cpname {color: %cpname%`; font-weight: bold`;}
			.cename {color: %cename%`; font-weight: bold`;}
			.ciname {color: %ciname%`; font-weight: bold`;}
			.czname {color: %czname%`; font-weight: bold`;}

			.cename:hover, .ciname:hover {text-decoration: underline`; cursor: help`;}
			
			.cred {color: %cred%}
			.corange {color: %corange%}
			.cyellow {color: %cyellow%}
			.cgreen {color: %cgreen%}
			.cblue {color: %cblue%}
			
		</style>
	</head>
	<body id="hideScroll">


	<div id="combatdummy">
	<div id="combat"></div>
	</div>

	<div id="main">
	%sText%
	</div>
	<div id="infoBox">
	<span id="rt">Title</span><span id="infoBoxX">[X]</span>
	<div id="r1" class="crow1"></div>
	<div id="r2" class="crow2"></div>
	<div id="r3" class="crow1"></div>
	<div id="r4" class="crow2"></div>
	<div id="r5" class="crow1"></div>
	<div id="r6" class="crow2"></div>
	</div>
	</body>
	</html>
	)
	global flwb
	flwb.navigate("about:blank")
	flwb.Document.write(html)
	flwb.Document.body.removeAttribute("id")
	global wb
	wb.navigate("about:blank")
	wb.Document.write(html)
	wb.document.getElementById("combatdummy").style.visibility:="hidden"
	wb.document.getElementById("infoBox").style.visibility:="hidden"
	wb.document.getElementById("infoBoxX").onclick:=func("showItemInfo").bind("[X]", "0")
	ttt:=wb.document.body.innerHTML
	clipboard:=wb.document.getElementById("thtml").outerHTML
	
	; makeClicky(ttt,,, "cpname", "cename", "ciname")
	
	wb.document.getElementById("thtml").scrollIntoView(0)

	mload:=0

	setSB("Day: " floor(day)
	, "Level: " player.level " (" round(player.exp/player.expm*100, 1) "%)"
	, "HP: " player.hp "/" player.hpm.1
	, "Zone: " zone " (" dirToMove ")")
return



; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ---------------------------------- MENU BAR ----------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
menuH:
	ttt:=A_ThisMenuItem
	if (ttt="Quit")
		gosub, YouReallyShouldntQuitPlayingIfYOuValueYourLife
		
	if (ttt="Load")
	{
		mload:=1 ; manually load
		gosub, load
	}
	
	if (ttt="About/help")
	{
		msgbox, 64, About %_name_%, %_about_%
	}
	
	if (ttt="Save autoLoad")
		save(1)
	if (ttt="Save As")
		save(2)
	if (ttt="Export log")
		save(3)
	
	if (ttt="Play" || ttt="Pause")
	{
		isPaused:=!isPaused
		if (isPaused=0)
		{
			if (isFight=0)
				setTimer, game, %gameSpeed%
			menu, guiBar, rename, Play, Pause
		}
		else
		{
			setTimer, game, off
			menu, guiBar, rename, Pause, Play
		}
	}
	if (ttt="Full Log")
	{
		ttt:=wb.document.getElementById("thtml").outerHTML
		ttt:=strReplace(ttt, " id=""hideScroll""") ; it's easier to remove it this way
		flwb.document.getElementById("thtml").innerHTML:=ttt
		gui, fullLog: show,, %_name_% - Full Log
	}
return


lbox:
	gui, submit, nohide
	if (lb=1) ; fight
		gui, listview, lvF
	if (lb=2) ; inventory
		gui, listview, lvI
	if (lb=3) ; escape
	{
		if (isFight=1)
		{
			echance:=about((LD=1) ? 15 : (LD=2) ? 12 : (LD>=3) ? 10 
				: (LD>=4) ? 8 : (LD>=5) ? 5
				: (LD=-1) ? 19 : (LD=-2) ? 22 : (LD<=-3) ? 27 
				: (LD<=-4) ? 40 : (LD<=-5) ? 80 
				: 17
				, 3)
			if (rand()<=echance)
			{
				isFight:=0
				wb.document.getElementById("combatdummy").style.visibility:="hidden"
				addRow("You Escaped the " f(enemy.name,, "cename"), "cfight2")
				if (isPaused=0)
					setTimer, game, %gameSpeed%
			}
			else
			{
				turn:=1
				addRow("	" f(enemy.name,,"cename") f( " has too good of a grip on you!",,"corange"), "cfight2 pre")
				drawCombat(player, enemy, turn, f(enemy.name,,"cename") f( " has too good of a grip on you!",,"corange"))
				sleep, %fightSpeed%
				gosub, fight
			}
		}
	}
	if (lb=4) ; other info
	{
		dmg:=0
		for k, v in player.gear.w
			dmg+=player.inv[v].stat[1]
		dmg+=floor(about(player.skills[randkey(player.skills), 1], 20, 1))
		
		otherInfo:=""
		. "--- Stats --- (click again to update)"
		. "`nName: " player.name
		. "`nLevel: " player.Level
		. "`nExp: " player.exp "/" player.expm " (" round(player.expc/player.expm*100, 2) "`%)"
		. "`nHealth (HP): " player.hp "/" player.hpm.1 " (" round(player.hp/player.hpm.1*100) "`%)"
		. "`nDamage: Something like " dmg//2 "-" dmg+(dmg//2) " or more, or less"
		. "`n --- Location ---"
		. "`nDay: " day`
		. "`nLocation: " zone
		. "`nHeading: " dirToMove
		. "`n --- Misc ---"
		. "`nDeaths: " player.deaths
		. "`nFights: " player.fights " (Wins: " clamp(player.fights-player.deaths, 0) ")"
		. "`n --- Gear ---"
		. "`nWeapons:`n" rtrim(st_glue(player.gear.w, "    "), "`r`n `t")
		. "`nArmors:`n" rtrim(st_glue(player.gear.a, "    "), "`r`n `t")
		
		zzz:=dllCall("GetScrollPos", "ptr", OIHWND, "int", 1)
		guiControl,, otherInfo, %otherInfo%
		if (zzz>0 || zzz!="")
			loop, %zzz%
			 	SendMessage, 0x115, 1, 0,, ahk_id %OIHWND% 
	}
	
	tabCont(lb, tabs*)
return


invUpdate:
	gui, listview, lvI
	LV_Delete()
	LV_SetImageList(invIcons)
	for k, v in player.inv
		LV_Add("icon" v.type, k "(" v.qty ")", v.type)
	LV_ModifyCol(2, "sort")
	epool:=[] ; equip/eat pool
	upool:=[] ; unequip pool
	for k in player.inv
	{
		if (!(k~="^\.\w+\:") && player.inv[k].qty>0)
			epool.push(k)
		if (k~="^\.\w+\:" && player.inv[k].qty>0)
			upool.push(k)
	}
	tabCont(lb, tabs*)
	; for k in player.inv
	; 	if (k~="^\.\w+\:" && player.inv[k].qty>0)
	; 		upool.push(k)
return


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ---------------------------------- EQUIPMENT ---------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; 1::
; 2::
; 3::
	; APItem:=A_ThisHotkey
equipItems:
	; APItem 1 = equip
	; APItem 2 = unequip
	; APItem 3 = eat
	; APItem:=rand(3)
	
	nnn:="" ; name of the item to do stuff with
	if (upool.length()<=0 && APItem=2)
	{
		addRow("no items to unequip", "cred")
		return
	}
	if (epool.length()<=0 && (APItem=1 || APItem=3))
	{
		if (APItem=1)
			addRow("no items to equip", "cred")
		if (APItem=3)
			addRow("no items to eat", "cred")
		return
	}
	
	; ------ equip ------
	; ------ equip ------
	; ------ equip ------
	if (!(selItem~="^\.\w+\:") && (inStr(A_ThisMenuItem, "Equip as") || APItem=1))
	{
		if (inStr(A_ThisMenuItem, "weapon"))
			eType:=".w:"
		if (inStr(A_ThisMenuItem, "armor"))
			eType:=".a:"
		nnn:=selItem
		
		if (APItem=1)
			eType:=(rand(2)=1) ? ".w:" : ".a:"
			, nnn:=epool[rand(epool.length())]
		
		ttt:=ItemEquip(nnn, eType)
		if (ttt=1) ; success
		{
					
			mmm:=addRow("Equipped " f(nnn,,"ciname") " as: " ((instr(etype,"w")) ? "weapon" : "armor"))
			if (eType=".a:")
				player.hpm.1+=player.inv[nnn].stat.2
				,player.hp+=player.inv[nnn].stat.2
		}
		else
			mmm:=addRow(ttt, "cred")
			
		if (player.inv[nnn].qty<=0)
			remOne(epool, nnn)
			
		turn:=1 ; enemies turn
	}
	else if ((selItem~="^\.\w+\:" && A_ThisMenuItem="Unequip") || APItem=2)
	{ 
	; ------ unequip ------
	; ------ unequip ------
	; ------ unequip ------
		nnn:=selItem ; name with .blah:
		
		if (APItem=2)
			nnn:=upool[rand(upool.length())]
			, eType:=subStr(nnn, 2, 1)
			
		nnn2:=substr(nnn,4) ; name no .blah:
		
		ttt:=itemUnequip(nnn)
		if (ttt=1)
		{
			if (player.inv[nnn].qty<=0)
				remOne(upool, nnn)
			mmm:=addRow("Unequipped " f(nnn2,,"ciname") " from: " ((instr(etype,"w")) ? "weapon" : "armor"))
			if (eType=".a:")
				player.hpm.1-=player.inv[nnn2].stat.2
				, player.hp-=player.inv[nnn2].stat.2
		}
		else
			mmm:=addRow(ttt, "cred")
		turn:=1 ; enemies turn
	}
	else if (A_ThisMenuItem="Eat" || APItem=3)
	{ 
	; ------ eat ------
	; ------ eat ------
	; ------ eat ------
		nnn:=selItem
		eType:=""
		if (APItem=3)
			nnn:=epool[rand(epool.length())]
		ttt:=itemEat(nnn)
		if (ttt.1>=0)
		{
			hhh:=ttt.2 ; hp to add
			player.hp+=hhh
			player.hp:=clamp(player.hp,, player.hpm.1) ; don't go above max
			
			mmm:=addRow("" f("You",,"cpname") " ate " prefix(f(nnn,, "ciname")) " and " ((hhh<0) ? "lost " : "gained ") f(abs(hhh),,"cphp") " hp")
		}
		else if (ttt=-1)
			mmm:=addRow("" f("You",,"cpname") " are too full to eat")
		else
			mmm:=addRow(ttt, "cred")
			
		if (ttt.1=0)
			remOne(epool, nnn)
				
		turn:=1 ; enemies turn
	}
	setSB(,, "HP: " player.hp "/" player.hpm.1)
	gosub, invUpdate

	if (isFight=1)
	{
		drawCombat(player, enemy, turn, mmm) ; show the arrow pointing to the enemy
		addRow(mmm, "cfight pre")
		sleep, %gameSpeed%
		gosub, fight ; let the enemy attack
	}
	else
	{
		if (isPaused=0)
			setTimer, game, %gameSpeed%
	}
return


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; -------------------------------- MAIN STUFF ----------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------

#if (winActive("ahk_id" MYHWND))
\::
	clipboard:=wb.document.getElementById("thtml").outerHTML
	clipboard:=strReplace(clipboard, " id=""hideScroll""")
	; ; clipboard:=st_printArr(items)
	; msgBox % st_printArr(dispLog)
	soundBeep
return

space::
	if (isFight=1)
		goto, fight
game:
	critical
	eFight:="" ; event fight
	mode:=rand() ; 85% move, 15% combat
	if (day=1) ; if it's the very first run, don't let the first move be a fight
		mode:=1
		
	day+=round(rand(0.05, 0.1), 3)
	dayShort:=floor(day)
	mode:=(umove=1 && ucombat=0) ? 1 ; make it so you move
	: (umove=0 && ucombat=1) ? 100   ; make it so you fight
	: mode ; do nothing special
	

	guiControlGet, lvf, Enabled
	guiControlGet, lvI, Enabled
	if (lvf=1)
		guiControl, disable, lvf
	if (lvI=0)
		guiControl, enable, lvI

	wb.document.getElementById("combatdummy").style.visibility:="hidden"
	
	; ---------------------
	; ------ NEW DAY ------
	; ---------------------
	if (dayShort!=pday)
	{
		addRow("--- " f("Day " dayShort,,"cday") " ---")
		ttt:=rand(50,200)
		player.hp+=rand(30, 120)
		player.hp:=clamp(player.hp,, player.hpm.1)
		addRow("" f("You",,"cpname") " learn something new everyday, +" f(ttt,,"cexp") " exp")
		leveledUp:=expAdd(ttt)
		if (leveledUp=1)
			addRow("--- " f("You",,"cpname") " have leveled up to " f(player.level,,"clevel") "! ---")
		addRow("Level: " f(player.level,,"clevel") ", hp: " f(player.hp "/" player.hpm.1,,"cphp"))
	}
	pday:=dayShort ; prevous day

	; -------------------------
	; ------ ZONE CHANGE ------
	; -------------------------
	if (distWalked>zsize || zone="") 
	{
		distWalked:=0
		zone:=randKey(zones)
		while (zone=pzone)
		{
			zone:=randKey(zones)
			sleep, 50 ; don't abuse the cpu. 20/sec is fast enough
		}
		pzone:=zone ; previous zone
		zsize:=about(zones[zone].size, 15, 1)
		addRow("--- " f("You",,"cpname") " have entered " f(zone,, "czname")  " ---")
	}

	; ---------------------
	; ------ RESTING ------
	; ---------------------
	if (player.hp<=player.hpm.1//1.3)
	{
		heal:=rand(player.hpm.1//10, player.hpm.1//5)
		player.hp+=heal
		player.hp:=clamp(player.hp,, player.hpm.1)
		
		addRow("Healing for " f(heal,,"cgreen") ", " f(player.hp "/" player.hpm.1,,"cphp"), "cheal")
		setSB(,, "HP: " player.hp "/" player.hpm.1)
		return
	}

	; --------------------------------
	; ------ AUTOPLAY EQUIPMENT ------
	; --------------------------------
	; player.hp:=90
	APItem:=0
	if (autoPlay=1 && rand()<=23)
	{
		; toolTip, % st_printArr(upool) "`n----`n" st_printArr(epool)
		APMode:=rand() ; 50/35/15% chance to equip/unequip/eat
		APItem:=(APMode>0 && APMode<=50 && epool.length()>0)        ? 1 ; EQUIP
		: (APMode>50 && APMode<=85 && upool.length()>0)             ? 2 ; UNEQUIP
		: (APMode>85 && player.hp<player.hpm.1 && epool.length()>0) ? 3 ; EAT
		: 0			
		if (APItem!=0)
			gosub, equipItems
		; mode:=101 ; make it beyond the walk/fight limits to skip them, as this uses up a turn
	}
	; ------------------------------
	; ------ WALKING & EVENTS ------
	; ------------------------------
	; zone:="forest"
	; toolTip, %mode%<<<
	if (mode<=85 && umove=1)
	{
		eee:="" ; temp event output text
		eFight:=""
		eventChance:=rand()
		ttt:=zones[zone].events
		if (eventChance<=chanceOfEvent || inEvent!="")
		{
			if (eventName="")
				eventName:=ttt[rand(ttt.length())]
				
			if (eventName="hay")
				eee:=farmHay((rand(3)=1 && ucombat=1) ? 0 : 1) ; 33% chance to fight
			if (eventName="poo")
				eee:=farmPoo((rand(3)=1 && ucombat=1) ? 0 : 1) ; 33% chance to fight
			if (eventName="house")
				eee:=abandonedHouse(rand(7, 12), zone)
			if (eventName="climb")
				eee:=climb(rand(10,35))
				
			addRow(eee)
		}
		else
		{
			if (rand(4)=1 ||dirToMove="")
				dirToMove:=move(rand())
			distWalked+=1
			addRow("walking " dirToMove)
		}
	}

	; ----------------------
	; ------ FIGHTING ------
	; ----------------------
	if ((mode>85 && mode<=100 && ucombat=1 && inEvent="") || eFight!="")
	{
		isFight:=1
		turn:=0
		player.fights+=1
		guiControl, disable, lvf
		guiControl, disable, lvI
		setTimer, game, off
		
		
		; eFight:="Businessman"
		if (eFight="" || eFight=-1) ; event fight is auto or non-existent
		{
			eName:=zones[zone].enemies[rand(zones[zone].enemies.length())]
			enemy:=buildEnemy(eName, clamp(about(player.level, 5),1))
		}
		
		; just like how players can enter a fight damaged, so can enemies.
		if (rand(10)=1)
			enemy.hp:=About(enemy.hp, 15, 1)
			
		
		addRow(f("fight! ",,"cred") f("Lv." enemy.level,,"clevel") " " f(enemy.name,,"cename"), "cfight")

		
		sleep, 2000
		; sleep, % fightSpeed*2
		drawCombat(player, enemy, turn)
		wb.document.getElementById("combatdummy").style.visibility:="visible"
		
		; msgBox, % st_printArr(enemy) "`n---`n" st_printArr(player)
		
		guiControl, enable, lvf
		guiControl, enable, lvI
		
		if (autoPlay=1)
			setTimer, fight, -%fightSpeed%
		; distWalked+=1
	}
	gosub, invUpdate
	setSB("Day: " floor(day)
	, "Level: " player.level " (" round(player.exp/player.expm*100, 1) "%)"
	, "HP: " player.hp "/" player.hpm.1
	, "Zone: " zone " (" dirToMove ")")
return


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ----------------------------------- FIGHT ------------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
fight:
	gui, submit, noHide
	gui, listview, lvF
	if (isFight=1)
	{
		; 10% chance someone will get a critical of 1.3-2.5x damage
		; 10% chance that you'll do weakened damage, You just barely hit
		crit:=(rand(10)=1) ? rand(1.3, 2.5) : (rand(10)=1) ? rand(0.2, 0.5) : 1
		combatMsg:=""
		ttt:=0 ; used for healing detection. creative name, eh? "ttt" is "temp"
		; -----------------------
		; ------ YOUR TURN ------
		; -----------------------
		if (turn=0)
		{
			selSkill:=0 ; selected fight skill
			selSkill:=LV_GetNext(selSkill)
			selSkill:=(selSkill!=0) ? selSkill : 1
			LV_GetText(pSkill, selSkill)
			
			if (autoPlay=1)
			{
				pSkill:=randKey(player.skills)
				while (pSkill="heal" && player.hp>=player.hpm.1)
					pSkill:=randKey(player.skills)
			}

			if (pSkill="heal")
			{
				dmg:=about(player.skills[pSkill,1])
				player.hp+=dmg
				player.hp:=clamp(player.hp,, player.hpm.1)
				ttt:=1
				combatMsg:="" f("You",,"cpname") " heal for " f(dmg,"b", "cphp") " hp"
			}
			else
			{
				dmg:=about(player.skills[pSkill,1], 20, 1)
				for k, v in player.gear.w
					dmg+=player.inv[v].stat.1
					
				dmg:=floor(dmg*crit) ; can't get perfect hits always...
				enemy.hp-=dmg
				combatMsg:=(crit>1) ? f("Critical! ","b i", "cred")
				         : (crit<1) ? f("Weak hit. ","i","cgreen") : ""
				         
				combatMsg.=f(player.name,,"cpname") " did " 
				. f(dmg,,"cred") " " f(pSkill,,"corange")" damage to " 
				. f(enemy.name,,"cename")
			}
		}
		
		; ------------------------
		; ------ ENEMY TURN ------
		; ------------------------
		if (turn=1)
		{
			if (enemy.hp<enemy.hpm && rand()<=17)
			{
				dmg:=rand(3+enemy.level, 15+enemy.level)
				enemy.hp+=dmg
				enemy.hp:=clamp(enemy.hp,, enemy.hpm)
				ttt:=1
				combatMsg:=f(enemy.name,,"cename") " heals for " f(dmg,"b", "cphp") " hp"
			}
			else
			{
				dmg:=about(enemy.dmg, 20, 1)+enemy.w.2
				dmg:=floor(dmg*crit)
				player.hp-=dmg
				combatMsg.=(crit>1) ? f("Critical! ","b i", "cred")
				         : (crit<1) ? f("Weak hit. ","i","cgreen") : ""
				combatMsg.=f(enemy.name,,"cename") " did " f(dmg,,"cred") " damage to " f(player.name,,"cpname")
			}
		}
		addRow("	" combatMsg, ((ttt=1) ? "cheal" : "cfight") " pre")
		
		; both are still alive
		if (player.hp>0 && enemy.hp>0)
		{
			turn:=!turn
			; while (isPaused=1)
			; 	sleep, 214 ; because why not
			if ((turn=1 || autoPlay=1) && isPaused=0)
				setTimer, fight, -%fightSpeed%
		}

		; someone died
		if (player.hp<=0 || enemy.hp<=0)
		{
			; sleep, 2000
			setTimer, fight, off
			isFight:=0
			phperc:=ceil(player.hp/player.hpm.1*100)
			ehperc:=ceil(enemy.hp/enemy.hpm*100)
			
			drawCombat(player, enemy, turn, combatMsg)
			sleep, % fightSpeed*3
			; wb.document.getElementById("main").innerhtml:=backup ; we love you still
			
			wb.document.getElementById("combatdummy").style.visibility:="hidden"
			wb.document.getElementById("main").scrollIntoView(0)

			if (player.hp<=0) ; you died
			{
				player.deaths+=1
				ttt:=(enemy.w.1="") ? "." : " with " prefix(f(enemy.w.1,,"ciname"))
				addRow(f(enemy.name,,"cename") " defeated you" ttt 
				. " (" f(phperc "%",, "cpname") "/" f(ehperc "%",, "cename") ")", "cfight2")
				addRow("" f("You",,"cpname") " crawl into " prefix(f(getItem().1,,"ciname")) " while you heal", "cfight") 
				sleep, %gameSpeed%
			}
			if (enemy.hp<=0) ; you won
			{
				; defeat message
				ttt:=player.gear.w[rand(player.gear.w.length())]
				ttt:=(ttt!="") ? " with " prefix(f(ttt,, "ciname")) : ""
				addRow("" f("You",,"cpname") " defeated " prefix(f(enemy.name,,"cename")) ttt  
				. " ("  f(phperc "%",, "cpname") "/" f(ehperc "%",, "cename") ")", "cfight")
				
				; 50% chance we will take the enemies gear, if they have any
				if (rand(2)=1)
				{
					ttt:=[]
					if (enemy.a.1!="")
						ttt.push("a")
					if (enemy.w.1!="")
						ttt.push("w")
					ttt:=ttt[rand(ttt.length())]
					; msgBox % enemy[ttt].1
					if (ttt!="")
						ttt:=invAdd(enemy[ttt].1)
						, addRow("" f("You",,"cpname") " took " prefix(f(ttt.1 "(" ttt.2 ")",,"ciname"))
						. " from " f(enemy.name,,"cename"), "cfight")
				}

				; exp stuff
				LD:=enemy.level-player.level ; Level difference
				; your level + 0 ~= 180 exp
				; your level + 1 ~= 212 exp
				; your level + 2 ~= 320 exp
				; etc...
				expToAdd:=about((LD=1) ? 212 : (LD=2) ? 320 : (LD>=3) ? 380 
				: (LD>=4) ? 440 : (LD>=5) ? 512
				: (LD=-1) ? 160 : (LD=-2) ? 130 : (LD<=-3) ? 100 
				: (LD<=-4) ? 75 : (LD<=-5) ? 50 
				: 180
				, 30, 1)
				leveledUp:=expAdd(exptoAdd)
				addRow("" f("You",,"cpname") " earned " f(expToAdd,, "cexp") " experience!", "cfight")
				if (leveledUp=1)
					addRow("--- " f("You",,"cpname") " leveled up to " f(player.level,, "clevel") "! ---")
				gosub, invUpdate
				
				setSB("Day: " floor(day)
				, "Level: " player.level " (" round(player.exp/player.expm*100, 1) "%)"
				, "HP: " player.hp "/" player.hpm.1
				, "Zone: " zone " (" dirToMove ")")
				; sleep, %gameSpeed%
			}
			if (isPaused=0)
				setTimer, game, %gameSpeed%
			return
		}
		drawCombat(player, enemy, turn, combatMsg)
		sleep, %fightSpeed%
	}

	setSB("Day: " floor(day)
	, "Level: " player.level " (" round(player.exp/player.expm*100, 1) "%)"
	, "HP: " player.hp "/" player.hpm.1
	, "Zone: " zone " (" dirToMove ")")
return
#if


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; --------------------------------- FUNCTIONS ----------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------

; prefix(word) ; create a proper a/an <word>, basic system
; {
; 	return ((word~="i)^[aeiou]") ?  "an" : "a") " " word
; }

prefix(word) ; create a proper a/an <word>, basic system
{
	m1:=((regExMatch(word, ">(.*)<", m)=0)) ? word : m1
	return ((m1~="i)^[aeiou]") ?  "an" : "a") " " word
}

setSB(fields*)
{
	for k,v in fields
		SB_SetText(fields[k], k)
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

randKey(Arr)
{
	for k in Arr
		max:=A_Index
	ttt:=rand(max)
	for k in Arr
		if (A_Index=ttt)
			return k
}

remOne(arr, thing)
{
	for k, v in arr
		if (v=thing)
		{
			arr.removeAt(k)
			return k
		}
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

expAdd(exptoAdd)
{
	leveledUp:=0
	player.exp+=exptoAdd
	while (player.exp>player.expm)
	{
		player.exp-=player.expm
		player.level+=1
		player.hpm.1+=player.hpm.2
		player.hp+=player.hpm.2
		leveledUp:=1
		for k, v in player.Skills
			player.Skills[k,1]+=floor(player.Skills[k,2])
	}
	return leveledUp
}

buildEnemy(enemy=-1, lvl=1)
{
	if (enemy=-1)
	{
		for k in enemies
			max:=A_Index
		random, enemy, 1, %max%
		for k in enemies
			if (A_Index=enemy)
			{
				enemy:=k
				break
			}
	}
	adef:=0, aname:=""
	watk:=0, wname:=""
	
	if (rand()<=75)
		weapon:=getItem(-1, 1, 1)
		, watk:=weapon[2].stat[1]*rand(1,3) ; Simulate having 1, 2 or 3 of the same items
		, wname:=weapon.1
	if (rand()<=80)
		armor:=getItem(-1, 1, 3)
		, adef:=armor[2].stat[2]*rand(1,3)
		, aname:=armor[1]
		
	jjj:={"name":enemy
	, "level":lvl
	, "hp":enemies[enemy,"hp",1]+(enemies[enemy,"hp",2]*lvl)+adef
	, "hpm":enemies[enemy,"hp",1]+(enemies[enemy,"hp",2]*lvl)+adef
	, "dmg":enemies[enemy,"dmg",1]+(enemies[enemy,"dmg",2]*lvl)
	, "w":[wname, watk]
	, "a":[aname, adef]}
	return jjj
}

; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ------------------------------- MISC FUNCTIONS -------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------

grep(haystack, needle)
{
	array:=[]
	while (pos:=RegExMatch(haystack, needle, match, ((pos>=1) ? pos : 1)+StrLen(match)))
		array[A_Index]:=match1
	Return array
}


FixIE(Version=0, ExeName="")
{
	static Key := "Software\Microsoft\Internet Explorer"
	. "\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION"
	, Versions := {7:7000, 8:8888, 9:9999, 10:10001, 11:11001}
	
	if Versions.HasKey(Version)
		Version := Versions[Version]
	
	if !ExeName
	{
		if A_IsCompiled
			ExeName := A_ScriptName
		else
			SplitPath, A_AhkPath, ExeName
	}
	
	RegRead, PreviousValue, HKCU, %Key%, %ExeName%

	; RegRead, zzz, HKCU, %Key%, %ExeName%
	; msgbox, 222 %zzz%
	
	if (Version = "")
		RegDelete, HKCU, %Key%, %ExeName%
	else
		RegWrite, REG_DWORD, HKCU, %Key%, %ExeName%, %Version%
	return PreviousValue
}



; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; --------------------------------- INCLUDES -----------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; game elements
#include %A_ScriptDir%\func\events.ahk

; functions
#include %A_ScriptDir%\func\html.ahk
#include %A_ScriptDir%\func\json.ahk
#include %A_ScriptDir%\func\mathy.ahk
#include %A_ScriptDir%\func\saveLoad.ahk
#include %A_ScriptDir%\func\inventory.ahk
#include %A_ScriptDir%\func\stringStuff.ahk
