/*
Name: poek events
Version 1.0 (Wednesday, July 20, 2016)
Created: Friday, July 01, 2016
Author: tidbit
Credit: 

*/

; ------
; list of variables to interact with the main game:
; OBJECT LISTS
global enemies ; the list/array of enemies  [see: poek.ahk]
global player  ; player array. [see: poek.ahk]
global items   ; the list/array of items. [see: poek.ahk]
global zones   ; the list/array of zones. [see: poek.ahk]

; MISC
global inEvent ; The name of the current event. Used for events that span 
	           ; multiple game passes. Set to "" to end the event

; FIGHTING
global eFight  ; event triggered fight? 1 = fight, 0 = no fight
global enemy   ; if you're going to fight, who will it be?
; ------


; ------
; small list of helpful functions:
/*
out:=invAdd() ... adds a random item to the players inventory,. out.1 = name, out.2 = quantity
buildEnemy(randKey(enemies)) ... get a random enemy, not zone-restricted
randKey(object) ... most commonly ised with "items" or "enemies"
prefix(word) ... gives a word "a" or "an". "a banana", "an enemy"
f(stuff, html, class) ... formats stuff with html formatting
*/
; ------

farmPoo(mode=1)
{
	if (mode=1)
		out:=invAdd()
		, eFight:=""
		, enemy:=""
		, eLog:=f("You",,"cpname") "  fell in " f("poo","c#A58445") " and " prefix(f(out.1 "(" out.2 ")" ,, "ciname")) " popped out!"
	else
		eFight:=1
		, enemy:=buildEnemy(randKey(enemies), clamp(about(player.level, 10),1))
		, eLog:=f("You",,"cpname") "  stepped in " f("poo","c#A58445") "  and " prefix(f(enemy.name,,"cename")) " jumped out!"

	inEvent:="" ; quick event. just a random item or combat
	return eLog
}
farmHay(mode=1)
{
	if (mode=1)
		out:=invAdd()
		, eFight:=""
		, enemy:=""
		, eLog:=f("You",,"cpname") "  see the twinkle of " prefix(f(out.1 "(" out.2 ")" ,, "ciname")) " in a " f("hay bale","c#D0C16F") "!"
	else
		eFight:=1
		, enemy:=buildEnemy(randKey(enemies), clamp(about(player.level, 10),1))
		, eLog:=f("You",,"cpname") "  stepped on " prefix(f(enemy.name,,"cename")) " sleeping in a " f("hay pile","c#D0C16F") "!"

	inEvent:="" ; quick event. just a random item or combat
	return eLog
}



abandonedHouse(size, byref mainZone)
{
	static steps, hsize, pzone, isInHouse:=0, name:="Old House"
	; msgBox % "bbbbb" mainZone
	if (isInHouse=0)
		eLog:=f(f("You",,"cpname") " ",,"cpname") " have " f("entered ",, "cblue") prefix(f(name,,"czname"))
		, inEvent:="House"
		, pzone:=mainZone ; save the zone name for restoring
		, mainZone:=name  ; new name
		, isInHouse:=1
		, steps:=0
		, hsize:=size ; house size
	else if (isInHouse=1)
	{
		steps+=1
		mainZone:=name ; gotta keep forcing the name until we leave
		
		if (steps>=hsize)
		{
			; msgbox, % steps "/" hsize "/" mainZone "/" pzone
			eLog:=f("You",,"cpname") "  have " f("exited ",, "cred") prefix(f(name,,"czname"))
			, inEvent:=""
			, mainZone:=pzone ; restore the main zone
			, pzone:=""
			, isInHouse:=0
			, steps:=0
		}
		else
		{
			if (rand(1,22)=1) ; 22% chance to find something
				out:=invAdd()
				, eLog:=f("You",,"cpname") "  see " prefix(f(out.1 "(" out.2 ")",,"ciname")) " and take it!"
			else
				eLog:=f("You",,"cpname") "  are looking around the house"
		}
	}
	; tooltip % "inev: " inEvent "::inh " isInHouse "::steps " steps "::pzone " pzone
	return eLog
}


climb(size)
{
	static isInTree:=0, treeH
	if (isInTree=0) 
	{
		isInTree:=1
		inEvent:="climb"
		treeH:=size ; tree height
		eLog:=f("You",,"cpname") "  climb a tree that is " f(treeH,,"cred") " units tall"
	}
	else if (isInTree=1)
	{
		eventChance:=rand() ; 25/15/60%
		if (eventChance<=25) ; fall
			eLog:=f("You",,"cpname") "  fell from the top hurting yourself for " f(treeH,,"cred") " HP"
			, player.hp-=treeH
			, isInTree:=0, inEvent:=""
		else if (eventChance<=40) ; climb
			eLog:=f("You",,"cpname") "  climb down after looking around a bit"
			, isInTree:=0, inEvent:=""
		else if (eventChance<=100) ; sit
		{
			if (player.hp<player.hpm.1)
				player.hp+=rand(player.hpm.1//4, player.hpm.1//8)
				, player.hp:=clamp(player.hp, -(player.hpm.1), player.hpm.1)
				, eLog:=f("You",,"cpname") "  sit at the top to relax " f(player.hp "/" player.hpm.1,, "cblue") ""
			else
				eLog:=f("You",,"cpname") "  sit at the top to relax"
		}
	}
	return eLog
}