/*
Name: poek
Version 1.3 (Friday, November 4, 2016)
Created: Tuesday, June 21, 2016
Author: tidbit
Credit: 
	AfterLemon - Helping with item list stats 
	Coco - JSON.ahk - https://autohotkey.com/boards/viewtopic.php?t=627
	GeekDude   - FixIE()
	
Hotkeys:
	Spacebar --- step the game forward one move (handy for manual playing while paused)

Note: !! A REGISTRY CHANGE IS NEEDED TO UPDATE YOUR OS's HTML RENDERING ENGINE !!
	It will however be reset back when you exit the game.

Description:
	A completely random game with turn-based combat, 1000+ items to discover and
	many enemy types. Explore fields to the city, remote villages and even space!
	Climb trees in the forest and dig through hay in a farm. 
	Fight crazy enemies	such as a Goat herder wearing a Leotard and attacking 
	you with and army of Hippos. Or a Mop wearing a Skillet and attacking you
	with a Crepe.

KNOWN ISSUES (mostly with autoplay mode):
	- Sometimes an item will try to equip itself when there is none left
	- Sometimes an item will try to equip into a type that has no slots
	- Most item values are completely weird. I got bored after ~400 (had some help)
	- Various other things I cannot remember over the months of frustration.



; new:
- enemies have a 50% chance of starting out 0-20% injured.
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

; variables
fightSpeed:=2000 ; time between fighting turns
gameSpeed:=4000  ; time between actions like walking and resting
autoPlay:=1      ; have the computer randomly play for you? Note: it's very random, not much AI involved
isPaused:=1      ; start out paused?
maxGear:=5       ; how many weapons can you equip? and armor. each get this qty
day:=1           ; how long have you been playing, in game days


prev:=FixIE() ; THIS MAKES A REGISTRY CHANGE

_name_:="poek"
_version_:="1.3 (Friday, November 4, 2016)"
_author_:="tidbit"
_about_=
(join
`nName: %_name_%
`nVersion: %_version_%
`nAuthor: %_author_%
`nCredit:
`n    + AfterLemon
`n    + Coco
`n    + GeekDude
`n
`nHotkeys:
`n    space --- Advance the game by 1 move, even if paused
`n
`nAbout:
`nThe main point of this game is to let it run in the background, play completely
 randomly in the background, for you to check up on every once in a while to see how your person
 is doing. However, there is manual play (which currently has no easy way to turn on, other than Pause + spacebar)
)

saveDir:=A_ScriptDir ; also the load directory
autoLoadFile:=saveDir "\" _name_ "-autoLoad.json"
autoLoadFileL:=saveDir "\" _name_ "-autoLoad-Log.html"

fileRead, ttt, %A_ScriptDir%\res\enemies.csv
global enemies:=loadEnemies(ttt)
fileRead, ttt, %A_ScriptDir%\res\items.csv
global items:=loadItems(ttt)
fileRead, ttt, %A_ScriptDir%\res\zones.json
global zones:=json.load(ttt)


msgBox, 48, INCOMPLETE, This game is not complete, may be prone to bugs and unrefined game values (such as exp`, and item stats). However, it works.



; debug stuff
ucombat:=1 ; use combat
umove:=1   ; use moving
startLevel:=0 ; 0 means 1 :P
startItems:=5




; ------
; "globals are bad. blah blah blah". Deal with it. (~˘▾˘)~
; it's easier than passing (and returning) several extra parameters to 
; every function that needs them. They need to get used by other things, so why
; not just make them global.

; ARRAYS
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

; file menu
; manual save/load is broken. too lazy/don't care to fix.
; menu, fmenu, add, Load, menuH
menu, fmenu, add, Save AutoLoad, menuH
; menu, fmenu, add, Save As, menuH
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


menu, tray, add, Show, menuH
menu, tray, default, Show

menu, invMenu1, add, Equip as weapon, equipItems
menu, invMenu1, add, Equip as armor, equipItems
menu, invMenu1, add, Eat, equipItems
menu, invMenu1, add, Drop, equipItems
menu, invMenu2, add, Unequip, equipItems

gui, add, StatusBar
SB_SetParts(canvasW, canvasW*1.5, canvasW*1.3)
SB_SetText("Day: 9999", 1)
SB_SetText("Level: 999 (100%)", 2)
SB_SetText("HP: 1000/1000", 3)
SB_SetText("Zone: AAA BBBBBB (South)", 4)

ttt:=canvasW*7
gui, fullLog: +owner1 -alwaysOnTop +hwndFLHWND ; +toolWindow
; gui, fullLog: add, edit, xm ym w%ttt% r30 hidden disabled vfullLogEdit
gui, fullLog: add, activex, xm ym w%ttt% r30 vflwb, shell.explorer

gui, font, s10
gui, margin, 0, 0
gui, +hwndMYHWND +owner
tabList:="Fight|Item|Escape|Other"

gui, font,, consolas
gui, add, edit, xm ym w350 r%canvasH% readonly disabled hidden vdispDummy,
gui, add, activex, xp yp wp hp hwndLogInfo vwb, shell.explorer



gui, font, 
gui, font, s12

ttt:=canvasW*5
gui, add, listbox, xm w75 r8 altsubmit vlb glbox, % strReplace(tabList, "|", "||",, 1)
gui, add, button, x+m yp w%ttt% hp -theme disabled vtbtn

gui, add, listview, xp+3 yp+3 w244 r3 section -multi disabled List -hscroll vlvF gfight, Fight

gui, font, s8
gui, add, listview, xs ys w244 r3 list -multi vlvI gglvI, Item|Type
invIcons:=IL_Create(4)
IL_Add(invIcons, a_scriptdir "\res\" "weapon.ico", 1) ; weapon
IL_Add(invIcons, a_scriptdir "\res\" "armor.ico", 1) ; armor
IL_Add(invIcons, a_scriptdir "\res\" "food.ico",  1) ; food
IL_Add(invIcons, a_scriptdir "\res\" "animal.ico", 1) ; animal
IL_Add(invIcons, a_scriptdir "\res\" "misc.ico", 1) ; misc
	
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


gosub, load
gosub, invUpdate
gosub, lbox
gosub, versionInfo

gui, +resize
gosub, guiSize

gui, show, w640 h480, %_name_% (%_version_%) by %_author_%

Process, Exist
PID:=errorLevel
CleanMemory(PID)

if (isPaused=0)
	setTimer, game, %gameSpeed%
else
	menu, guiBar, rename, Pause, Play
return


; Esc::
; 	critical
; 	exitapp
; return



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


load:
	; manual load:
	if (mload=1)
	{
		fileSelectFile, toLoad,,, Load a %_name_% file, *.json
		if (errorLevel=1)
			return
		splitPath, toLoad,, lfd, lfe, lfn
		; msgBox % lfd "\" lfn "-Log.html" "`n" toload
		
		fileRead, toLoad, % lfd "\" lfn ".json" ; start settings
		fileRead, slog, % lfd "\" lfn "-Log.html" ; start log
		toLoadLog:=lfd "\" lfn "-Log.html"
		
		; msgBox % lfd "\" lfn "-Log.html" "`n`n" lfd "\" lfn ".json"
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
		, "hp":100, "hpm":[100, 15]
		, "Deaths":0
		, "Fights":0
		, "Skills":{"Flick":[6,3]
		          , "Lick":[5,3]
		          , "Kick":[8,5]
		          , "Heal":[10,4]
		          , "Punch":[10,4]}
		, "Gear":{"W":[], "A":[]}
		, "Inv":{}
		, "Settings": {"day":1, "zone":zone, "dtm":dirToMove, "steps":steps, "inEvent":inEvent}}

		
		expAdd(startLevel*1000) ; start out at level 10
		player.hpm.1+=player.hpm.2*(player.level-1)
		loop, %startItems% ; random starting gear
			invAdd()
		player.skills
		; invAdd("lava", 2)
		; for k, v in player.inv
		; 	player.inv[k].qty:=1
		; fileAppend, % json.dump(player), %autoLoadFile%
	}

	steps:=player.settings.steps
	zone:=player.settings.zone
	day:=player.settings.day
	dirToMove:=player.settings.dtm
	inEvent:=player.settings.inEvent
	; dayShort:=floor(day)
	; pday:=dayShort
	
	gui, listview, lvF
	for k in player.skills
		LV_Add("", k)
	; msgBox % st_printArr(player)
		
	ttt:=""
	; pool of usable items for AP mode
	epool:=[] ; equip/eat pool
	upool:=[] ; unequip pool
	ttt:=subStr(_version_, 1, 3)

	if (mload=1 && FileExist(toLoadLog)) ; manual load
		sText:=slog
		, wb.document.body.innerHTML:=""
	else if (FileExist(autoLoadFileL)) ; autoload
		fileRead, sText, %autoLoadFileL%
	else ; default
		sText=
		(ltrim
		<pre>.------------------------------.
		|          <span class="cpname">poek</span> v%ttt%           |
		|         <span class="crow1">random thing</span>         |
		|──────────────────────────────|
		|          by <span class="cpname">tidbit</span>           |
		'------------------------------'</pre>`n
		)

	ttt:="0x" substr(cBG, 2)
	ttt:=format("#{1:06X}", (ttt & 0xBABABA) >> 1) ; make the color darker
	html:=""
	html=
	(ltrim
	<!DOCTYPE html>
	<html id="thtml" lang="en" xmlns="http://www.w3.org/1999/xhtml">
	<head>
	    <meta charset="utf-8" />
		<meta name="generator" />
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
			#combat {position: fixed`; left: 10`%`; right: 10`%`; top: 0`; bottom: 0`; padding: 0 1em`;
			background-color: %cBG%`;}

			
			
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
	; flwb.document.getElementById("infoBoxX").onclick:=func("showItemInfo").bind("[X]", "0")
	global wb
	wb.navigate("about:blank")
	wb.Document.write(html)
	wb.document.getElementById("combatdummy").style.visibility:="hidden"
	wb.document.getElementById("infoBoxX").onclick:=func("showItemInfo").bind("[X]", "0")
	ttt:=wb.document.getElementById("hideScroll").innerHTML

	makeClicky(ttt, wb.document,, "cpname", "cename", "ciname")
	
	wb.document.getElementById("thtml").scrollIntoView(0)

	mload:=0
	
	setSB("Day: " floor(day)
	, "Level: " player.level " (" round(player.exp/player.expm*100, 1) "%)"
	, "HP: " player.hp "/" player.hpm.1
	, "Zone: " zone " (" dirToMove ")")
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
	{
		FixIE(prev)
		exitapp
	}
return

; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ---------------------------------- MENU BAR ----------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
menuH:
	critical
	ttt:=A_ThisMenuItem
	if (ttt="Show")
		gui, show
		
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

	if (inStr(ttt, "Save"))
	{
		if (isFight)
		{
			; msgBox, 16, You have tried the forbidden, You are not allowed to save while fighting, bad things happen.
			msgBox, 16, % " ", You cannot save while enemies are nearby.
			return
		}
		; wb.document.getElementById("main").removeAttribute("id")
		wb.document.getElementById("infoBox").style.visibility:="hidden"
		wb.document.getElementById("combatdummy").style.visibility:="hidden"
		player.settings.steps:=steps
		player.settings.zone:=zone
		player.settings.day:=day
		player.settings.dtm:=dirToMove
		player.settings.inEvent:=inEvent
	}
	
	if (ttt="Save autoLoad")
	{
		if (FileExist(autoLoadFile))
		{
			msgBox, 52, Overwrite?, % "Overwrite the exisiting AutoLoad files with this session?"
			. "`nPlayer: " player.name "`nLevel: " player.level "`nDay: " day
			ifMsgBox, no
				return
		}
		; ttt:=regexreplace(wb.document.getElementById("main").innerHTML, "<div id=""infoBox"".*?>.*<\/div>")
		fileDelete, %autoLoadFile%
		fileDelete, %autoLoadFileL%
		fileAppend, % json.dump(player), %autoLoadFile%
		fileAppend, % wb.document.getElementById("main").innerHTML, %autoLoadFileL%
		
		; msgBox, 64, Save Complete, Save complete`n`n%autoLoadFile%`n%autoLoadFileL%
	}
	
	; if (ttt="Save As")
	; {
	; 	fileSelectFile, toSave, s16,, Save your current %_name_% settion as what?, *.json
	; 		if (errorLevel=1)
	; 			return
	; 	splitPath, toSave,, ofd, ofe, ofn
	; 		if (trim(ofn)="")
	; 			return
	; 	if (ofe!="json")
	; 		toSave:=ofd "\" ofn ".json"
	; 		, toSaveL:=ofd "\" ofn "-Log.html"
	; 	if (FileExist(toSave))
	; 		fileDelete, %toSave%
	; 	if (FileExist(toSaveL))
	; 		fileDelete, %toSaveL%
	; 	fileAppend, % json.dump(player), %toSave%
	; 	fileAppend, % wb.document.getElementById("hideScroll").innerHTML, %toSaveL%
		
	; 	; msgBox, 64, Save Complete, Save complete`n`n%toSave%`n%toSaveL%
	; }
	if (ttt="Export log")
	{
		fileSelectFile, toSave, s16,, Save your current %_name_% settion as what?, *.html
			if (errorLevel=1)
				return
		splitPath, toSave,, ofd, ofe, ofn
		if (ofe!="json")
			toSave:=ofd "\" ofn ".html"
		if (FileExist(toSave))
			fileDelete, %toSave%
		ttt:=wb.document.getElementById("thtml").outerhtml
		ttt:=strReplace(ttt, " id=""hideScroll""") ; it's easier to remove it this way
		fileAppend, %ttt%, %toSave%
	}
	
	if (ttt="Play" || ttt="Pause")
	{
		isPaused:=!isPaused
		if (isPaused=0)
		{
			if (isFight=0)
				setTimer, game, %gameSpeed%
			else,
				gosub, fight
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
		ttt:=wb.document.getElementById("thtml").outerhtml
		ttt:=strReplace(ttt, " id=""hideScroll""") ; it's easier to remove it this way
		flwb.document.getElementById("thtml").innerHTML:=ttt
		makeClicky(ttt, flwb.document, main, "cpname", "cename", "ciname")
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
		. "`nExp: " player.exp "/" player.expm " (" round(player.exp/player.expm*100, 1) "`%)"
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
		. "`nWeapons:`n" rtrim(st_glue(player.gear.w, "    "), "`r`n")
		. "`nArmors:`n" rtrim(st_glue(player.gear.a, "    "), "`r`n")
		
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
	atmi:=A_ThisMenuItem
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

	; if something is severely lowering our life, remove stuff!
	if (player.hpm.1<1 && upool.length()>0)
		APItem:=2

	
	; msgBox % selItem " && " atmi " || " APItem
	
	; ------ drop ------
	; ------ drop ------
	; ------ drop ------
	if (atmi="drop")
	{
		if (player.inv.HasKey(selItem))
		{
			player.inv.delete(selItem)
			ttt:=choose("A sad " f(selItem,,"ciname") " watches " f("You",,"cpname") " slowly walking away from " choose("him","her") "."
			, f("You",,"cpname") " drop " prefix(f(selItem,,"ciname")) "."
			, f("You",,"cpname") " kick " prefix(f(selItem,,"ciname")) " to the side of the road."
			, prefix(f(selItem,,"ciname")) " escapes your captivity!"
			, f("You",,"cpname") " vaporize " prefix(f(selItem,,"ciname")) "!"
			, f(selItem,,"ciname") " doesn't need " f("You",,"cpname") " either!")
			addRow(ttt)
		}
	}
	; ------ equip ------
	; ------ equip ------
	; ------ equip ------
	if ((!(selItem~="^\.\w+\:") && inStr(atmi, "Equip as")) || APItem=1)
	{
		if (inStr(atmi, "weapon"))
			eType:=".w:"
		if (inStr(atmi, "armor"))
			eType:=".a:"
		nnn:=selItem
		if (APItem=1)
		{
			eType:=(rand(2)=1) ? ".w:" : ".a:"
			nnn:=epool[rand(epool.length())]
		}
		
		ttt:=ItemEquip(nnn, eType)
		if (ttt=1) ; success
		{
			mmm:=addRow("Equipped " f(nnn,,"ciname") " as: " ((instr(etype,"w")) ? "weapon" : "armor"))
			if (eType=".a:")
			{
				player.hpm.1+=player.inv[nnn].stat.2
				player.hp+=player.inv[nnn].stat.2
				superHeal:=0
				if (player.hp<=0)
				{
					msg:="Ow "
					loop, % rand(3, 5)
						msg.=Choose(" ow", " owow", "wowow")
					addRow(f(msg "!",, "cred"), "cfight2")
					player.deaths+=1
					itemUnequip(".a:" nnn)
					player.hpm.1+=abs(player.inv[nnn].stat.2)
					player.exp-=rand(20,140)
					player.exp:=clamp(player.exp, 0)
					addRow("Unequipped " f(nnn,,"ciname") " from: armor")
					superHeal:=1
					; player.hp+=abs(player.inv[nnn].stat.2)
				}
			}
		}
		else
			mmm:=addRow(ttt, "cred")
			
		if (player.inv[nnn].qty<=0)
			remOne(epool, nnn)
			
		turn:=1 ; enemies turn
	}
	else if ((selItem~="^\.\w+\:" && atmi="Unequip") || APItem=2)
	{ 
	; ------ unequip ------
	; ------ unequip ------
	; ------ unequip ------
		nnn:=selItem ; name with .blah:
		
		if (APItem=2)
		{
			nnn:=upool[rand(upool.length())]
			eType:=subStr(nnn, 2, 1)
		}
			
		nnn2:=substr(nnn,4) ; name with no .blah:

			
		ttt:=itemUnequip(nnn)
		if (ttt=1)
		{
			if (player.inv[nnn].qty<=0)
				remOne(upool, nnn)
			mmm:=addRow("Unequipped " f(nnn2,,"ciname") " from: " ((instr(etype,"w")) ? "weapon" : "armor"))
			if (instr(etype, "a"))
			{
				val:=player.inv[nnn2].stat.2
				player.hpm.1-=val
				player.hp-=val
			}
		}
		else
			mmm:=addRow(ttt, "cred")
		turn:=1 ; enemies turn
	}
	else if (atmi="Eat" || APItem=3)
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
	selItem:=atmi:=""
	gosub, invUpdate
	
	; toolTip, % player.hp "/" player.hpm.1 "`n------`n" st_printArr(player), 500
	; toolTip % nnn "/" eType "/" APItem "`n---`n" st_printArr(epool) "`n-----`n" st_printArr(upool), 500
	; toolTip % epool.length() "," upool.length() "," , 600,,2
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
; \::
; 	clipboard:=wb.document.getElementById("thtml").outerhtml
; 	clipboard:=strReplace(clipboard, " id=""hideScroll""")
; 	; clipboard:=st_printArr(items)
; 	soundBeep
; return

; a little cheat to set your level, handy after an update to keep your progress but update to the new stats
!\::
	inputBox, ulvl, set your level, set your level. WHOLE NUMBERS ONLY.,,,,,,,, % player.level
	if ulvl is not integer
		return
	IF (errorLevel=1 || ulvl<0)
		return
		
	player:={"name": player.name
		, "Level":1, "exp": player.exp, "expm":1000, "hp":100, "hpm":[100, 15]
		, "Deaths": player.deaths, "Fights": player.fights
		, "Skills":{"Flick":[6,3], "Lick":[5,3], "Kick":[8,5], "Heal":[10,4], "Punch":[10,4]}
		, "Gear": player.gear, "Inv": player.inv, "Settings": player.settings}
		
	expAdd((ulvl-1)*1000) ; start out at level 10

	setSB("Day: " floor(day)
	, "Level: " player.level " (" round(player.exp/player.expm*100, 1) "%)"
	, "HP: " player.hp "/" player.hpm.1
	, "Zone: " zone " (" dirToMove ")")
	soundBeep, 1200, 160
	soundBeep, 1400, 120
	soundBeep, 2000, 80
return

space::
	if (isFight=1)
		goto, fight
game:
	critical
	eFight:="" ; event fight
	mode:=rand() ; 85% move, 15% combat
	
	if (day<=1.2) ; the very first vew steps are just walking. don't get attecked instantly
		mode:=1
	

	; day+=round(rand(1.5, 4.5)/100, 5)
	; day+=round(rand(0.020, 0.035), 5)
	; dayShort:=floor(day)
		
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

		; pre-equip some stuff.
		if (pdayF=1)
		{
			APItem:=1
			addRow("Your journey begins here. Equipping some starting gear before starting.", "cyellow")
			loop, % rand(5, 3)
				gosub, equipItems
		}
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
			zone:=randKey(zones)
		pzone:=zone ; previous zone
		zsize:=about(zones[zone].size, 15, 1)
		addRow("--- " f("You",,"cpname") " have entered " f(zone,, "czname")  " ---")
		CleanMemory(PID)
	}
	
	; ---------------------
	; ------ RESTING ------
	; ---------------------
	isResting:=0
	if (player.hp<=player.hpm.1//1.3)
	{
		heal:=abs(rand(player.hpm.1//10, player.hpm.1//5))
		player.hp+=heal
		player.hp:=clamp(player.hp,, player.hpm.1)
		
		addRow("Healing for " f(heal,,"cgreen") ", " f(player.hp "/" player.hpm.1,,"cphp"), "cheal")
		setSB(,, "HP: " player.hp "/" player.hpm.1)
		isResting:=1
	}
	else
		superHeal:=0 ; used when you have taken severe damage from putting something on, like armor
	
	; --------------------------------
	; ------ AUTOPLAY EQUIPMENT ------
	; --------------------------------
	; player.hp:=90
	APItem:=0
	if (autoPlay=1 && rand()<=23 && superHeal=0)
	{
		APMode:=rand() ; 50/35/15% chance to equip/unequip/eat
		APItem:=((APMode>0 && APMode<=50) && epool.length()>0)        ? 1 ; EQUIP
		: ((APMode>50 && APMode<=85) && upool.length()>0)             ? 2 ; UNEQUIP
		: ((APMode>85 && player.hp<player.hpm.1) && epool.length()>0) ? 3 ; EAT
		: 0	

		if (APItem!=0)
			gosub, equipItems
		; mode:=101 ; make it beyond the walk/fight limits to skip them, as this uses up a turn
	}
	; toolTip, % APItem "`n---`n" APMode "`n---`n " upool.length() ". "  st_printArr(upool) "`n----`n" epool.length() ". " st_printArr(epool)
	; msgBox % st_printArr(player)

	if (isResting=1)
		return
		
	; ------------------------------
	; ------ WALKING & EVENTS ------
	; ------------------------------
	; zone:="City"
	if (mode<=89 && umove=1 && pdayF>1)
	{
		eee:="" ; temp event output text
		eFight:=""
		eventChance:=rand()
		ttt:=zones[zone].events
		; toolTip % zone "/" eventName "`n---`n" st_printArr(ttt) "`n--------`n" inEvent "/" zones[zone].events.length() "<<<"
		if (eventChance<=chanceOfEvent && inEvent="")
			inEvent:=eventName:=ttt[rand(ttt.length(), 1)]
		; if ((eventChance<=80 || inEvent!="") && zones[zone].events.length()>0)
		; toolTip % zone "/" pzone
		if (inEvent!="") ; && (zone=pzone && zones[pzone].events.length()>0))
		{
			eventName:=inEvent ; probably not needed. meh
			if (eventName="hay")
				eee:=farmHay((rand(3)=1 && ucombat=1) ? 0 : 1) ; 33% chance to fight
			if (eventName="poo")
				eee:=farmPoo((rand(3)=1 && ucombat=1) ? 0 : 1) ; 33% chance to fight
			if (eventName="house")
				eee:=abandonedHouse(rand(7, 12), zone)
			if (eventName="climb")
				eee:=climb(rand(10,35))
			addRow(eee)
			gosub, invUpdate
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
	if ((mode>90 && mode<=100 && ucombat=1 && inEvent="") || eFight!="")
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
			enemy:=buildEnemy(eName, clamp(about(player.level, 6),1))
		}
		
		; just like how players can enter a fight damaged, so can enemies.
		if (rand(10)=1)
			enemy.hp:=About(enemy.hp, 15, 1)
			
		
		addRow(f("fight! ",,"cred") f("Lv." enemy.level,,"clevel") " " f(enemy.name,,"cename"), "cfight")

		
		sleep, 1250
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
	
	pdayF:=day ; the full previous day
	day+=round(rand(1.2, 3.5)/100, 5)
	; day+=round(rand(0.020, 0.035), 5)
	dayShort:=floor(day)
	
	; gosub, invUpdate
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
				dmg:=rand(enemy.hpm//15, enemy.hpm//8)
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
				addRow("" f("You",,"cpname") " crawl into " prefix(f(getItem(-1).1,,"ciname")) " while you heal", "cfight") 
				superHeal:=1
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
				expToAdd:=about((LD=1) ? 212 : (LD=2) ? 320 : (LD=3) ? 380 
				: (LD=4) ? 440 : (LD>=5) ? 512
				: (LD=-1) ? 160 : (LD=-2) ? 130 : (LD=-3) ? 100 
				: (LD=-4) ? 75 : (LD<=-5) ? 50 
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
	, "dmg":floor(enemies[enemy,"dmg",1]+(enemies[enemy,"dmg",2]*lvl))
	, "w":[wname, watk]
	, "a":[aname, adef]}

	if (rand(2)=1) ; just like how the player can enter a battle injured, so can an enemy.
		jjj.hp-=floor(rand(jjj.hp*0.20)) 
		
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

; thanks strictlyfocused02 and Temp01! http://www.autohotkey.com/board/topic/49436-memory-cleanup-a-simple-gui-for-the-emptyworkingset-api/
CleanMemory(PID)  ;Written with help from "Temp01" on the AHK IRC chat (thank you again, temp01!!!)
{
	Process, Exist
	h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel)
	DllCall("Advapi32.dll\OpenProcessToken", "UInt", h, "UInt", 32, "UIntP", t)
	VarSetCapacity(ti, 16, 0)
	NumPut(1, ti, 0)
	DllCall("Advapi32.dll\LookupPrivilegeValueA", "UInt", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
	NumPut(luid, ti, 4, "int64")
	NumPut(2, ti, 12)
	DllCall("Advapi32.dll\AdjustTokenPrivileges", "UInt", t, "Int", false, "UInt", &ti, "UInt", 0, "UInt", 0, "UInt", 0)
	DllCall("CloseHandle", "UInt", h)
	hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")
	h := DllCall("OpenProcess", "UInt", 0x400|0x100, "Int", false, "UInt", PID)
	e := DllCall("psapi.dll\EmptyWorkingSet", "UInt", h)
	DllCall("CloseHandle", "UInt", h)
	DllCall("FreeLibrary", "UInt", hModule)
	Return e
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



/*
Thursday, November 3, 2016
poek rewrite idea:

@@@ = currently how the game has it implemented


Base:
    * 100% computer controlled, even the player. It's an idle-rpg type game, but more depth
@@@ * game runs at a slow tick rate, about 2000 while fighting, 4000 for everything else
@@@ * unlimited inventory and stack size, but limited equiped items (5 of each)
@@@ * any item can be used in any way, whether it's a good or bad thing to do
@@@ * pokemon-esque display style (it's an effective layout)
@@@ * multiple zone types (biomes)
      - maybe have them transition a certain way? you can only get to X or Y when in Z zone
@@@ * rare chance of events
      - this needs to be rewritten, I think. some of them are buggy. There could also be a boss event for each zone
@@@ * flat exp curve, I really like this style
@@@   - 0-1000 exp at all levels. exp gained is based on level difference. max exp gain of 550-ish
@@@ * days only progress while NOT fighting
@@@   days last around 15-20 game ticks.
@@@   you get exp at the start of a new day
      - maybe a bigger bonus if you don't get defeated that day?
@@@   - you heal a decent amount on a new day
      - autosave every day if the player has created a save file?
@@@ * level restrictions? NO!
      - however, maybe a system that affects the items (accuracy, damage, etc) based on its level and your level
      - if an item is level 1, you're level 80, you should be a master of it. if it's 80 and you're 1, it'll be weak.
    * what should the main display be:
      - formatted HTML? 
      - ascii (my original version)? 
      - figure out some generated terrain system (voronoi?) and display it?
      
/-----


strengths/weaknesses:
    resists:
    * resists are a % reduction or multiplier of ele damage recienved
    * would there be caps?
    * water > fire > lightning > water (more or less. or alternative creative ones)
    
    physical:
    * defense is a % reduction of damage recieved
    * perhaps multiplier too? something makes you weaker, such as equipping needles as armor. you get hit, the stab you.
/-----


attacks:
    * each persons could have its own timer/thread based on its attack speed, it's not turn based
      - because of this, the next move needs to be determined at the end of the action to set the timer accordingly, probably
@@@ * every hit always hits, although it can be a weak hit instead of a miss
      
    physical:
    * attack speed is that of the slowest weapon equipped
@@@ * all damage is combined from all weapons
    * apply the phys reduction/multiplier of the enemy gear
    * add up all the ele damages of each type, deal each damage type separately so appropriate strengths/weaknesses can be applied
@@@ * the final blow chooses a random item for the defeat message

    magic:
    * cast speed is based on the skill
    * each item has various elemental properties too
    * add up all the ele damages of each type
    * since this is magic, it should have a boost too, based on the skill type used
      - say you do a lightning spell, have it multiply lightning damage by 200% on the gear, then toss in the spells damage. 
    * deal each damage type separately so appropriate strengths/weaknesses can be applied
/-----


player "ai":
    * when attacking an enemy, choose randomly. if a hit is effective, favor that skill more but keep it randomized.
      - say, you have 3 skills, you got a 33/33/33 chance. one non-crit does good, you now have a 60/20/20 chance. 
        if yet another skill does good, that'd be 40/40/20. etc.
@@@ * how should criticals work? just a flat rate chance?
@@@ * x% chance to heal when lower than y% of life

    gear equip:
    * only equip items if there's a slot available. @ this is mildly implemented but it's broken somehow.
      - if not, don't do anything. wait until it decides to unequip
@@@ * random equip? analyze for the best available stuff?
    
    gear unequip:
@@@ * random unequip? analyze for the worst equipped stuff?
@@@ * if something damages you when equipping and brings you below 1 hp, unequip immediately
/-----


enemy "ai":
    * pretty much the same as "player ai" except with these differences:
    
    gear:
@@@ * enemies are specialists, they have random 0-3 of ONE type of weapon, and 0-3 of ONE type of armor
      - as in, if "knife" if chosen as a weapon, it'll get: [] or [knife] or [knife, knife] or [knife, knife, knife]
      - ... same for armor.
      (this could be changed. I was just lazy)
/-----


other:
    * enemy is defeated:
@@@ - x% chance to take either all their armor OR all their weapons, if they have any
@@@ - get the difference in your levels, apply appropriate exp

    * player is defeated:
@@@ - no exp gain
@@@ - longer wait time (thus "overkill" as a penalty) for you to heal
@@@ - no chance of an item
    - chance of losing an equiped item
/-----
*/







