
span(html, tag="span", nl=0) ; if id is 1, class is the id.
{
	for k, v in strSplit(html, "`n", "`r") ; turn each line into a div
		if (v!="")
			o.="<" tag ">" v "</" tag ">" ((nl=1) ? "`n" : "")
	return o
}


addRow(HTML, class="", target="main")
{
	html:=trim(html, "`r`n")
	element:=wb.document.createElement("div")
	newLine:=wb.document.createTextNode("`r`n")
	if (class!="")
		element.setAttribute("class", class)
	element.innerHTML:=HTML ; "`n"
	wb.document.getElementById(target).appendChild(element)
	wb.document.getElementById(target).appendChild(newLine)
	element.scrollIntoView(1)
	
	makeClicky(HTML, element,, "cpname", "cename", "ciname")
	
	; msgBox % element.innerHTML "`n--------`n" element.outerhtml "`n--------`n" html
	
	return trim(HTML, "`r`n")
	; return element.outerhtml
}

makeClicky(content, main="", ID="", stuff*)
{
	if (main="")
		main:=wb.document
	for t, tt in stuff
	for k, v in grep(content, "im)=['""](" tt ")")
	{
		v:=trim(v)
		if (id="")
			element:=main.getElementsByClassName(v)[k-1]
		else
			element:=main.getElementById(ID).getElementsByClassName(v)[k-1]
		element.OnClick:=func("showItemInfo").bind(trim(element.innertext), v) ; give them all an onclick property
	}
}

showItemInfo(name, itype="")
{
	global reactionsArr1, reactionsArr2, reactionsArr3, isFight, FLHWND
	static pname, clickCount:=0, death:=0
	
	bbbbb:=wb
	if (winActive("ahk_id " FLHWND))
		bbbbb:=flwb
		
	; msgBox % name
	ttt:=bbbbb.document.getElementById("infoBox").style.visibility

	name:=trim(regExReplace(name, "\(\d*?\)"), "`r`n `t")
	if (name="[X]" || (ttt="visible" && name=pname))
	{
		bbbbb.document.getElementById("infoBox").style.visibility:="hidden"
		return
	}
	
	if (itype!="cpname")
		bbbbb.document.getElementById("infoBox").style.visibility:="visible"
		
	ttt:=(items[name].type=1) ? "Weapon" 
	: (items[name].type=2) ? "Armor"
	: (items[name].type=3) ? "Food"
	: (items[name].type=4) ? "Animal"
	: "Misc"

	if (itype="cpname")
	{
		clickCount+=1
		list:=(clickCount<=7) ? (reactionsArr1, ccc="cblue")
		: (clickCount<=20) ? (reactionsArr2, ccc="corange")
		: (reactionsArr3, ccc="cred")
		ttt:=choose(list*)
		; ttt:="I will destroy myself!"
		if (death=1)
		{
			player.level-=rand(1,3)
			player.level:=clamp(player.level, 0)
			player.exp:=0
			player.deaths+=1
			addRow("I will now destroy myself because of you.", "cred")
			while (player.hp>0)
			{
				player.hp-=rand(player.hpm.1//10, player.hpm.1//5)
				addRow(choose("ow", "OW!") " " f(player.hp "/" player.hpm.1 " HP",, "cphp"), "cred")
				sleep, 300
			}
				
			addRow("Because of you, I have been reduced to level " f(player.level,,"clevel"), "cred")
			SB_SetText("Level: " player.level " (" round(player.exp/player.expm*100, 1) "%)", 2)
			SB_SetText("HP: " player.hp "/" player.hpm.1, 3)
		}
		else
			addRow(f(ttt,, ccc))
		death:=inStr(ttt, "I will destroy myself!") ? 1 : 0
	}
	if (itype="ciname")
	{
		bbbbb.document.getElementById("rt").innerHTML:=f("Item info","B", "cyellow")
		bbbbb.document.getElementById("r1").innerHTML:=f("Name: " name)
		bbbbb.document.getElementById("r2").innerHTML:=f("Type: " ttt)
		bbbbb.document.getElementById("r3").innerHTML:=f("Damage: " items[name].stat[1])
		bbbbb.document.getElementById("r4").innerHTML:=f("Armor: " items[name].stat[2])
		bbbbb.document.getElementById("r5").innerHTML:=f("Food: " items[name].stat[3])
		bbbbb.document.getElementById("r6").innerHTML:=f("Quantity: " player.inv[name].qty)
	}
	else if (itype="cename" && name=enemy.name)
	{
		bbbbb.document.getElementById("rt").innerHTML:=f("Current enemy","B", "cyellow")
		bbbbb.document.getElementById("r1").innerHTML:=f("Name: " enemy.name)
		bbbbb.document.getElementById("r2").innerHTML:=f("Level: " enemy.level)
		bbbbb.document.getElementById("r3").innerHTML:=f("Damage: " enemy.dmg+enemy.w[2])
		bbbbb.document.getElementById("r4").innerHTML:=f("Life: " enemy.hp "/" enemy.hpm)
		bbbbb.document.getElementById("r5").innerHTML:=f("Weapon: " f(enemy.w[1],, "ciname"))
		bbbbb.document.getElementById("r6").innerHTML:=f("Armor: " f(enemy.a[1],, "ciname"))
		
		ttt:=bbbbb.document.getElementById("r5").getElementsByClassName("ciname")[0]
		ttt.OnClick:=func("showItemInfo").bind(trim(ttt.innertext), "ciname")
		ttt:=bbbbb.document.getElementById("r6").getElementsByClassName("ciname")[0]
		ttt.OnClick:=func("showItemInfo").bind(trim(ttt.innertext), "ciname")
	}
	else if (itype="cename")
	{
		ttt:=buildEnemy(name, player.level)
		bbbbb.document.getElementById("rt").innerHTML:=f("Enemy info","B", "cyellow")
		bbbbb.document.getElementById("r1").innerHTML:=f("Name: " ttt.name)
		bbbbb.document.getElementById("r2").innerHTML:=f("Level: " player.level)
		bbbbb.document.getElementById("r3").innerHTML:=f("Damage: " ttt.dmg//2 "-" ttt.dmg*3)
		bbbbb.document.getElementById("r4").innerHTML:=f("Life: " ttt.hp "/" ttt.hpm)
		bbbbb.document.getElementById("r5").innerHTML:="&nbsp;"
		bbbbb.document.getElementById("r6").innerHTML:="&nbsp;"
	}

	pname:=name
	; toolTip hi "%name%" %type%
}

versionInfo: ; congrats, you found the misleading name section
	reactionsArr1:=["Nice to see you too."
	, "Teehee, that tickles."
	, "I love you too."
	, "The feel of your warm cursor on my bits is quite relaxing."
	, "Do it again! Do it again!"
	, "Beep boop"]
	reactionsArr2:=["Okay, this is getting a little bit much."
	, "You can stop any time now."
	, "Please stop, I'm tired."
	, "You gotta be quicker than that."
	, "No more please."
	, "That was quite rude."
	, "That's enough."]
	reactionsArr3:=["Ow!"
	, "That hurt!"
	, "That was quite rude."
	, "That's ENOUGH!"
	, "If you don't stop, I will destroy myself!"
	, "Why are you not listening? STOP, please!"]
return

ASCIIBar(Current, Max=100, Length=20) ;, Unlock = 0)
{
	; Made by Bugz000 with assistance from tidbit, Chalamius and Bigvent
	; modified by tidbit (Tue May 28, 2013)
	Empty:="-"
	Full:="o"
	Percent:=(Current/Max)*100
	; if (unlock = 0)
	; 	length:=length > 97 ? 97 : length < 4 ? 4 : length
	percent:=(percent>100) ? 100 : (percent<0) ? 0 : percent
	Loop % round(((percent/100)*length), 0)
		Progress.=Full
	progress:=f(progress,"b;","cgreen")
	loop % Length-round(((percent/100)*length), 0)
		Progress.=Empty
	; progress:=f(progress,,"red")
	return "[" progress "]" f(round(percent) "%",,"cred") 
}

drawCombat(pArr, eArr, turn=2, end="") ; player/enemy arrays
{
	playerText:= ""
	. ((eArr.hp<=0) ? "Winner " : "") . ((turn=0) ? "--> " : "")
	. f(pArr.name,,"cpname") "   Lv." pArr.level
	. "`n" ASCIIBar((pArr.hp/pArr.hpm.1)*100)
	. "`n" floor(pArr.hp) "/" floor(pArr.hpm.1)
	
	enemyText:=""
	. "" format("{:t}", trim(substr(eArr.w.1,1,3) substr(eArr.a.1,1,3))) " "
	. f(eArr.name,,"cename") "   Lv." eArr.level 
	; . " (" eArr.w.1 ", " eArr.a.1 ")"
	. ((turn=1) ? " <--" : "") . ((pArr.hp<=0) ? "Winner" : "")
	. "`n" ASCIIBar((eArr.hp/eArr.hpm)*100)
	. "`n" floor(eArr.hp) "/" floor(eArr.hpm)
	
	loop, parse, enemyText, `n, `r
		ttt.="<div>" A_LoopField "</div>`n"
	enemyText:=ttt

	ttt:=""
	loop, parse, playerText, `n, `r
		ttt.="<div>" A_LoopField "</div>`n"
	playerText:=ttt
	
	; ttt:=addrow(enemyText, "left", "combat") "`n" addrow(playerText, "right", "combat") "`n" addrow(end,, "combat")
	ttt:="<div class='left'>" enemyText "</div>"
	. "`n<div class='right'>" playerText "</div>`n<div id='combatend'>" end "</div>"
	
	ooo:=wb.document.getElementById("combat").innerhtml:=ttt


	makeClicky(ttt,wb.document, "combat", "cename", "ciname")
	return ttt
}

; name:    html formatting function.
; version: 1 (Sunday, July 10, 2016)
; created: Sunday, July 10, 2016
; info:
;     existing shortcuts are: b, i, u, c#, bg#
; example: "I " f("HATE","c#ff0000 b") " veggies!"
;     result: I HATE veggies ... where HATE is red and bold
f(text, formatting="", hClass="", type="span")
{
	if (formatting!="")
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
	}
	fo:=(trim(fo, "; `t")="") ? "" : " style='" fo "'"
	if (hClass="")
		return "<" type " " fo ">" text "</" type ">"
	
	return "<" type " class='" hClass "'" fo ">" text "</" type ">"
}