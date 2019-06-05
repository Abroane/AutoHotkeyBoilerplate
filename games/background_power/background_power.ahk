; =================================================================================================================================
; Name:           Background Power
; Description:    
; Topic:          https://www.autohotkey.com/boards/viewtopic.php?f=6&t=56483 
; Sript version:  1.3
; AHK Version:    unknown
; Tested on:      
; Author::        Mipha

; How to play:   
;
; ==================================================================================================================================

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir% ; Ensures a consistent starting directory.
savename := A_workingdir . "\backgroundpowersave.ini"
DetectHiddenWindows, on 
#singleinstance force
#MaxHotkeysPerInterval 500
OnExit("savegame_onclick")
;Version. I change this value with new versions. Some features on savefiles of older versions may not be compatible so I try to make something that fixes that
Currentversion := 134
if(!FileExist(savename)){
	;if there is no savefile. One will be made and filled with some values as to not freak out the check below that checks if values got corrupted (just in case)
	FileAppend,[values]`n[treasures]`n[garden]`n[options], %savename%
	iniwrite, 0, %savename%, values, power
	iniwrite, 0, %savename%, values, treasurekeys
	iniwrite, 0, %savename%, values, treasurechests
	iniwrite, 0, %savename%, values, treasureradarbought
	iniwrite, 0, %savename%, values, gardentiles
	iniwrite, 0, %savename%, values, freezertiles
	iniwrite, 0, %savename%, garden, almanacunlocked
	iniwrite, currentversion, %savename%, values, version
}
;read all the values from the savefile
IniRead, Power, %savename%, Values, Power
IniRead, upgrades, %savename%, Upgrades, upgrades
IniRead, gardentiles, %savename%, Values, gardentiles
IniRead, freezertiles, %savename%, Values, freezertiles
iniread, stats, %savename%, values, stats
IniRead, treasurekeys, %savename%, Values, treasurekeys
IniRead, treasurechests, %savename%, Values, treasurechests
iniread, version, %savename%, Values, version
IniRead, treasures, %savename%, Treasures, treasures
IniRead, treasureradarbought, %savename%, Values, treasureradarbought
IniRead, plantknowledge, %savename%, garden, plantknowledge
IniRead, almanacunlocked, %savename%, garden, almanacunlocked
iniread, optionchecks, %savename%, options, optionchecks
if(VersionCompare("1.1.30.00", A_ahkversion) == 1 && currentversion <> version){
	msgbox % "Your autohotkey version is outdated. This may end up causing problems."
}
;just to be sure I added a couple failsaves in case something goes wrong with the values
checkvalues := ["power", "treasurekeys", "treasurechests", "treasureradarbought", "gardentiles", "freezertiles"]
loop, % checkvalues.MaxIndex(){
	somevalue := checkvalues[A_index]
	if %somevalue% is not number
	{
		msgbox % "something went wrong. " . checkvalues[A_index] . " is not a number. The value contained the following: " . arraytostring(%somevalue%) . "`nif there's nothing here that means the values are empty. Sadly this means " . checkvalues[A_index] . " has been reset to 0. Please report this problem to the game maker. found on reddit by the name /u/pimhazeveld"
		%somevalue% := 0
	}
}
;these V are all the upgrades available in the shop. They have an abillity, description, cost, and increase in price.
;clickpower, movepower and treasurepower should sound obvious. Ones with 'percent' after them boost the power gain by a procentual amount instead.
;price is the base price of the upgrade, priceincrease increases the price by a set amount after every purchase and priceincreasepercent increases the price by a set % after every upgrade, formula should be price := price + (priceincrease * purchased) * ((priceincreasepercent / 100)^purchased) + 1
;repeated means the amount of times the upgrade can be purchased
clickingpower := {clickpower: 1, descr: "You can only gain power by clicking once every 2 seconds", name: "Clicking power", price: 5, priceincrease: 4, priceincreasepercent: 10, repeated: 100}
clickingpower2 := {clickpower: 2, clickpowerpercent: 1, descr: "A more powerful way to click. Also gives a procentual buff", name: "Clicking power 2", price: 250, priceincrease: 30, priceincreasepercent: 15, repeated: 100, unlockcondition:[{name:"clickingpower", array:"purchased", amount:15, requirement:">="}]}
mouseengine := {movepower: 4, movespeed: 1, descr: "Every 10 seconds you gain power based on how much the mouse was moved.", name: "Mouse engine", price: 20, priceincrease: 20, priceincreasepercent: 8, repeated: 100, unlockcondition:[{name:"clickingpower", array:"purchased", amount:3, requirement:">="}]}
keyboardmotor := {keyboardkeypower:1, descr:"Every second, gain power when pressing a letter on the keyboard", name:"Keyboard motor", price:50, priceincrease:25, priceincreasepercent:10, repeated: 100, unlockcondition:[{name:"mouseengine", array:"purchased", amount:5, requirement:">="}, {name:"clickingpower", array:"purchased", amount:5, requirement:">="}]}
keyboardmotor2 := {keyboardkeypower:3, keyboardkeypowerpercent:1, descr:"Everything needs a second level nowadays.", name:"Keyboard motor 2", price:500, priceincrease:100, priceincreasepercent:12, repeated: 100, unlockcondition:[{name:"keyboardmotor", array:"purchased", amount:15, requirement:">="}]}
gamersfuel := {descr:"Doubles keyboard power gain when pressing one of the WASD keys", name:"Gamers fuel", repeated:1, price:7500, unlockcondition:[{name:"keyboardmotor", array:"purchased", amount:10, requirement:">="}]}
mouseengine2 := {movepower: 8, movespeed: 1, movepowerpercent: 1, descr: "A more powerful mouse engine. Also gives a procentual buff.", name: "Mouse engine 2", price: 600, priceincrease: 200, priceincreasepercent: 15, repeated: 100, unlockcondition:[{name:"mouseengine", array:"purchased", amount:15, requirement:">="}]}
mousemastery := {descr:"Moving the mouse now also grants power for clicking", name:"Mouse mastery", price:35000, repeated:1, unlockcondition:[{name:"clickingpower2", array:"purchased", amount:5, requirement:">="}, {name:"mouseengine2", array:"purchased", amount:5, requirement:">="}]}
mouseengine3 := {descr: "Grants a lot of extra power for mouse movements based on how much the mouse was moved", name: "Mouse engine 3", price: 1000000000, unlockcondition:[{name:"mouseengine2", array:"purchased", amount:50, requirement:">="}]}
;this one ^ is neat but slightly too powerful so it isn't included in all upgrades right now. However if you want to add it to the game. All you have to do is add its name (mouseengine3) to the allupgrades array below
knowledgepower := {movepowerpercent: 5, clickpowerpercent: 5, keyboardkeypowerpercent: 5, harvestpowerpercent:5, descr: "This knowledge is getting to your head. Great!", name: "Knowledge is power", price: 500000, repeated:10, priceincreasepercent:95, unlockcondition:[{name:"plantknowledge", array:"knowledge", amount:100, requirement:">="}]}
knowledgepower2 := {descr:"Making power with your mind", name:"Knowledge is power too", knowledgepower:0.02, price:1234567, repeated:1, unlockcondition:[{name:"plantknowledge", array:"knowledge", amount:500, requirement:">="}, {name:"knowledgepower", array:"purchased", amount:1}]}
garden := {plantchance: 1, descr: "The first level of this upgrade also unlocks the garden in the options menu.`n", name: "Garden", price: 1000, repeated: 100, priceincreasepercent: 10, unlockcondition:[{name:"clickingpower", array:"purchased", amount:12, requirement:">="}]}
garden2 := {harvestpowerpercent:1, descr: "Spices up your garden by increasing power gained", name: "Garden 2", price:3000, repeated: 100, priceincrease:100, priceincreasepercent:12, unlockcondition:[{name:"power", amount:10000, requirement:">="}, {name:"garden", array:"purchased", requirement:">=", amount:15}]}
hiddentreasure := {descr: "Occasionally assigns a random point on the screen as a treasure point.`n Mouse over them to gain 25 times the power of a normal mouse movement and sometimes a chest", name: "Hidden treasures", repeated: 1, price: 6250, unlockcondition:[{name:"mouseengine", array:"purchased", amount:15, requirement:">="}, {name:"keyboardmotor", array:"purchased", amount:10, requirement:">="}]}
goldenkeys := {descr: "Occasionally turns a random keyboard letter key into an golden key.`nPressing it gives 25 times the power of a normal keyboard key and sometimes a treasure key.", name: "Golden keys", repeated:1, price: 6250, unlockcondition:[{name:"keyboardmotor", array:"purchased", amount:15, requirement:">="}, {name:"mouseengine", array:"purchased", amount:10, requirement:">="}]}

allupgrades := ["clickingpower", "mouseengine", "keyboardmotor", "garden", "clickingpower2", "mouseengine2", "keyboardmotor2", "garden2", "mousemastery", "gamersfuel", "hiddentreasure", "goldenkeys", "knowledgepower", "knowledgepower2"]

;all plants available in the game are listed here except one which is created by "evolution"
dusttree := {rarity: 100, knowledge: 4, descr: "Contains power. Mostly dust but some power", name:"dust tree", symbol:"Dt", background:"#888888", textcolor:"#000000", harvest:{harvestpower:90}, global:{clickpower:2}}
barkwood := {rarity: 100, knowledge: 15, descr: "A small but dense tree. Its bark makes for a great power source but sadly this plant has barely any of it", name:"barkwood", symbol:"Bw", background:"#55AA88", textcolor:"#000000", harvest:{harvestpower:200}, passive:{harvestpowerpercent:400}, global:{harvestpowerpercent:1}}
titantree := {rarity: 100, knowledge: 30, descr:"A tall tree with tons of bark. Its almost impossible to harvest most of the possible power from it but its influence stands tall", name:"titantree", symbol:"TT", background:"#55AA88", textcolor:"#555555", harvest:{harvestpower:1900}, global:{harvestpowerpercent:10}}
tickflower := {rarity: 100, knowledge: 5, descr: "A relatively normal flower. It smells like progress", name:"tick flower", symbol:"Tf", background:"#AADD88", textcolor:"#DD4444", global:{clickpowerpercent:2}}
pumpkin := {rarity:100, knowledge: 50, descr:"Spooky", name:"pumpkin", symbol:"P", background:"#FF7700", textcolor:"#00AA00", harvest:{harvestpower:5000, chest:1}}
goldleaf := {rarity:100, knowledge: 50, descr:"A plant known for its great wealth and secrets.", name:"gold leaf", symbol:"Gl", background:"#55AA88", textcolor:"#FFCC55", harvest:{harvestpower:7777, goldenkey:1, knowledge:1}}
lockbloom := {rarity:100, knowledge:50, descr:"A neat plant that occasionally takes on the shape of the current golden key", name:"lockbloom", symbol:"Lb", background:"#DDDD00", harvest:{harvestpower:3000}}
yellowberry := {rarity: 100, knowledge: 7, descr: "Yellow berries don't do anything special but are great at creating new and exciting plants",name: "yellowberry", symbol:"Yb", background:"#55AA88", textcolor:"#FFFF00"}
bluestalk := {rarity: 100, knowledge: 15, descr: "An uncommon plant containing a high density of power", name:"blue stalk", symbol:"Bs", background:"#AA9900", textcolor:"#3333FF", harvest:{harvestpower:1200}, global:{clickpower:6}}
fruittree := {rarity: 100, knowledge: 8, descr: "Useful for when you're hungry. Or just want to fruit up your clicks.", name:"fruit tree", symbol:"Ft", background:"#55AA88", textcolor:"#FF4422", harvest:{harvestpower:270}, passive:{clickpower:2}, global:{clickpowerpercent:4}}
yellowbulb := {rarity: 100, knowledge: 8, descr: "A rather large bulb shrowded in green leaves, ready to explode with power.", name: "yellow bulb", symbol:"YB", background:"#55AA55", textcolor:"#FFFF00", harvest:{harvestpower:350}}
bluebulb := {rarity: 100, knowledge:24, descr: "This plant contains a dense pocket of power. Useful for sure", name: "blue bulb", symbol:"Bb", background:"#9999FF", textcolor:"#3333FF", harvest:{harvestpower:5000}}
crystalbulb := {rarity: 100, knowledge:24, descr: "A giant berry made of pure crystallized power.", name: "crystal bulb", symbol:"Cb", background:"#225522", textcolor:"#9999FF", harvest:{harvestpower:25000}}
partythyme :={rarity: 100, knowledge: 28, descr: "Happy birthda.... Wait what do you mean its not your birthday? Or is it?", name:"party thyme", symbol:"Pt", background:"#55AA88", textcolor:"#FF8888", harvest:{harvestpower:8000}, global:{clickpower:10, movepower:25, keyboardkeypower:15}}
yellowstalk := {rarity: 100, knowledge: 12, descr: "Does a bit of everything", name: "yellow stalk", symbol:"Ys", textcolor:"#FFFF00", background:"#55AA88", harvest:{harvestpower:800}, global:{clickpower:2, movepower:6, movespeed:1, movepowerpercent:1, clickpowerpercent:1}}
dimbloom := {rarity: 100, knowledge: 20, descr: "The mist seems to have disappeared leaving behind a purely black flower. Eldritch powers lie within. What happens if you continue breeding?", name:"dimbloom", symbol:"D", background:"#555555", textcolor:"#000000", harvest:{harvestpower:900}, global:{clickpowerpercent:7}}
greenstalk := fusearrays([{descr: "This outcome should not be a surprise", name:"green stalk", symbol:"Gs", background:"#55AA88", textcolor:"#00FF00"}, yellowstalk, bluestalk])
greenstalk["rarity"] := 100
weaversivy := {rarity:100, knowledge:35, descr:"A moderately toxic plant affecting the life around it.", name:"weavers ivy", symbol:"Wi", background:"#22AAAA", auras:{passive:{toxic:1}}}
;popoppy := {rarity:100, knowledge:17, descr:"Pop!", name:"Popoppy", symbol:"Pp", background:"#55AA88", textcolor:"#FF6666", harvest:{harvestseeds:1}}
;agrose := {rarity: 100, knowledge:40, descr: "Violent red flower that blasts rather harmless seeds that are mostly helpful.", name:"agrose", symbol:"Ar", background:"#FF6666", harvest:{harvestseeds:6}}
;these two are currently unused due to them possibly causing bugs because they delay the harvest animation meaning you could move or inspect them during the harvest which screws stuff up.
sapleaf := {rarity: 100, knowledge:35, descr: "A rich energetic sap oozes from this plant to the neighboring tiles", name:"sapleaf", symbol:"Sl", background:"#DD8844", textcolor:"#111111", auras:{global:{clickpower:1}, passive:{harvestpower:3, harvestpowerpercent:5, movepowerpercent:1}}, tileauras:{passive:{harvestpowerpercent:5}}}
shockweaver := {rarity: 100, knowledge:35, descr: "An plant with electric current running through it. It ""helps"" perform better mouse movement", name:"shockweaver", symbol:"Sw", background:"#DD9900", textcolor:"#7766FF", global:{movespeed:2, movepower:5}, auras:{passive:{movepowerpercent:5}}, tileauras:{global:{movepower:3}, passive:{movepowerpercent:5}}}
rootwraith := {rarity: 100, knowledge:40, descr: "This tree looks rather hollow and cursed. But a good kind of cursed", name:"rootwraith", symbol:"Rw", background:"#997700", textcolor:"#880088", harvest:{harvestpower:1900}, passive:{harvestpowerpercent:50}, auras:{passive:{harvestpower:15, harvestpowerpercent:7}}, tileauras:{passive:{harvestpower:10}, global:{harvestpowerpercent:1}}}
knowleaf := {rarity: 100, knowledge:6, descr: "A plant that knows a lot about plants", name:"knowleaf", symbol:"kl", background:"#55AA88", textcolor:"#FFAAFF", harvest:{harvestpower:2, knowledge:2}}
knowleafier := {rarity:100, knowledge:16, descr:"Now we're talking knowledge", name:"knowleafier", symbol:"Kl", background:"#55AA88", textcolor:"#FF55AA", harvest:{harvestpower:5, knowledge:5}}
knowleafiest := {rarity:100, knowledge:36, descr:"Its bursting with knowledge. You're probably not gonna fit anything else in it", name:"knowleafiest", symbol:"KL", background:"#55AA88", textcolor:"#FF0000", harvest:{harvestpower:10, knowledge:10}}
smartstalk := {rarity:100, knowledge:66, descr:"Luckily knowleaf plants arent the only ones capable of storing knowledge", name:"smartstalk", symbol:"Ss", background:"#55AA88", textcolor:"#5555FF", harvest:{knowledge:25}}
brainmoss := {rarity:100, knowledge:166, descr:"The ultimate solution to your lack of knowledge (not a personal insult). You should probably stop here before your plants gain sentience", name:"brainmoss", symbol:"Bm", background:"#FFAAFF", textcolor:"#AA00AA", harvest:{knowledge:40}, auras:{passive:{knowledgepercent:100}}, tileauras:{global:{knowledgepercent:4}}}
grimpetal := {rarity: 100, knowledge:16, descr: "A dark mist shrouds this flower making it kinda hard to see", name:"grimpetal", symbol:"Gp", background:"#000000", textcolor:"#FFFFFF", global:{clickpower:10}, auras:{passive:{clickpowerpercent:10}}}
gripvine := {rarity: 100, knowledge:24, descr: "A vine that gets a good grip on things", name: "gripvine", symbol:"Gv", background:"#665500", textcolor:"#22FF44", global:{movepower:25, movespeed:1}}
clickvine := {rarity: 100, knowledge:40, descr: "A very potent vine infused with clicking power", name:"clickvine", symbol:"Cv", background:"#665500", textcolor:"#22FF44", harvest:{harvestpower:800}, auras:{passive:{clickpowerpercent:5}}, tileauras:{passive:{clickpowerpercent:5}}}
evolution := {rarity: 100, knowledge:100, descr: "A weird plant composed of a combination of darkness, potency and combination.", name: "evolution", symbol:"Ev", background:"#000000", textcolor:"#AA00AA", harvest:{harvestpower:6666}, fusion:{strength:1, amount:2, result:{rarity:100, knowledge:1, descr:"Turns out fusing plants doesn't combine the appeal of them.", name:"amalgam plant", symbol:"X"}}}
;The plants value contains an array of all plants that can appear naturally in the garden

plants := [dusttree, tickflower]

allplants := {dusttree:dusttree, barkwood:barkwood, titantree:titantree, tickflower:tickflower, pumpkin:pumpkin, goldleaf:goldleaf, lockbloom:lockbloom, yellowberry:yellowberry, bluestalk:bluestalk, bluebulb:bluebulb, crystalbulb:crystalbulb, fruittree:fruittree, yellowbulb:yellowbulb, partythyme:partythyme, yellowstalk:yellowstalk, dimbloom:dimbloom, greenstalk:greenstalk
, weaversivy:weaversivy, sapleaf:sapleaf, shockweaver:shockweaver, rootwraith:rootwraith, knowleaf:knowleaf, knowleafier:knowleafier, knowleafiest:knowleafiest, smartstalk:smartstalk, brainmoss:brainmoss, grimpetal:grimpetal, gripvine:gripvine, clickvine:clickvine, evolution:evolution}

plantcombos := [{pardners:["dusttree", "tickflower"], result:"fruittree", rarity:25}, {pardners:["tickflower"], result:"yellowberry", rarity:80}, {pardners:["yellowbulb", "grimpetal"], result:"yellowstalk", rarity:25}
	, {pardners:["dusttree", "yellowberry"], result:"yellowbulb", rarity:45}, {pardners:["yellowstalk", "bluestalk"], result:"greenstalk", rarity:35}, {pardners:["greenstalk", "dimbloom"], result:"gripvine", rarity:40}
	, {pardners:["fruittree", "gripvine", "grimpetal"], result:"clickvine", rarity:35}, {pardners:["tickflower", "tickflower", "yellowberry"], result:"grimpetal", rarity:50}, {pardners:["grimpetal", "tickflower", "tickflower"], result:"dimbloom", rarity:35}
	, {pardners:["yellowbulb", "dimbloom"], result:"bluestalk", rarity:50}, {pardners:["greenstalk", "dimbloom", "clickvine"], result:"evolution", rarity:15}, {pardners:["dusttree", "yellowberry"], result:"knowleaf", rarity:100}
	, {pardners:["dusttree", "fruittree"], result:"barkwood", rarity:40}, {pardners:["dusttree", "dusttree", "dusttree", "dusttree", "dusttree", "dusttree", "dusttree"], result:"titantree", rarity:4}, {pardners:["barkwood", "barkwood", "dusttree"], result:"titantree", rarity:30}
	, {pardners:["tickflower", "yellowbulb", "dimbloom", "fruittree"], result:"sapleaf", rarity:45}, {pardners:["knowleaf", "dimbloom", "yellowbulb", "bluestalk"], result:"shockweaver", rarity:35}
	, {pardners:["dusttree", "dusttree", "barkwood", "fruittree", "titantree", "titantree"], result:"rootwraith", rarity:75}, {pardners:["fruittree", "fruittree", "yellowbulb", "rootwraith", "evolution"], result:"pumpkin", rarity:25}
	, {pardners:["knowleaf", "dimbloom", "rootwraith", "sapleaf", "evolution"], result:"goldleaf", rarity:25}, {pardners:["knowleaf", "evolution", "fruittree", "yellowbulb"], result:"partythyme", rarity:75}
	, {pardners:["knowleaf", "knowleaf", "knowleaf"], result:"knowleafier", rarity:25}, {pardners:["knowleaf", "yellowbulb", "tickflower"], result:"knowleafier", rarity:50}, {pardners:["knowleafier"], result:"knowleaf", rarity:25}]
;here are all the combos in the game. When the listed plants are next to an empty tile. The plant in the result object can appear there.
;The statement ended up being too long so I had to end it and step over to pushing additional entries individually
plantcombos.push({pardners:["titantree", "yellowbulb", "bluestalk"], result:"bluebulb", rarity:30})
plantcombos.push({pardners:["bluebulb", "shockweaver", "evolution"], result:"crystalbulb", rarity:10})
plantcombos.push({pardners:["yellowberry", "tickflower"], result:"knowleaf", rarity:100})
plantcombos.push({pardners:["knowleafier", "knowleafier", "knowleafier"], result:"knowleafiest", rarity:25})
plantcombos.push({pardners:["knowleafier", "dimbloom", "grimpetal", "tickflower"], result:"knowleafiest", rarity:100})
plantcombos.push({pardners:["knowleafiest"], result:"knowleafier", rarity:25})
plantcombos.push({pardners:["knowleaf", "knowleafier", "knowleafiest", "evolution"], result:"smartstalk", rarity:100})
plantcombos.push({pardners:["evolution", "knowleafiest", "smartstalk", "shockweaver"], result:"brainmoss", rarity:16})
plantcombos.push({pardners:["shockweaver", "yellowberry", "tickflower"], result:"weaversivy", rarity:50})
plantcombos.push({pardners:["goldleaf", "dimbloom"], result:"lockbloom", rarity:100})

;garden height and size are listed here (different sizes could occur in the future)
gardenmaxX := 10
gardenmaxY := 10

upgrades := stringtoarray(upgrades)
if (!IsObject(upgrades) || upgrades.Count() == 0 ||upgrades.Count() == ""){
	upgrades := {}
}
for a, b in allupgrades
{
	if(!isnum(upgrades[b]["purchased"])){
		upgrades[b] := {purchased:0, unlocked:"locked"}
		if(b == "clickingpower"){
			upgrades[b]["purchased"] := 1
		}
		fusearrays([%b%, upgrades[b]])
	}
	for c, d in upgrades[b]{
		%b%[c] := d
	}
}

plantknowledge := stringtoarray(plantknowledge)
if (!IsObject(plantknowledge) || plantknowledge.Count() == 0 ||plantknowledge.Count() == ""){
	plantknowledge := {}
}
if(!plantknowledge["knowledge"]){
	plantknowledge["knowledge"] := 0
}
for a, b in allplants{
	if(!plantknowledge[a]){
		plantknowledge[a] := {}
	}
	if(!plantknowledge[a]["current"]){
		plantknowledge[a]["current"] := 0
	}
	if(!plantknowledge[a]["cap"]){
		plantknowledge[a]["cap"] := b["Knowledge"]
	}
	if(!plantknowledge[a]["seen"]){
		plantknowledge[a]["seen"] := 0
	}
}
;here are all the treasures in the game. Their rarity and their name.
treasurestats := {amulets:{rarity:100, name:"amulet"}, rings:{rarity:100, name:"ring"}, grails:{rarity:100, name:"grail"}, goldbars:{rarity:100, name:"gold bar"}, goldcoins:{rarity:100, name: "gold coin"}, pearls:{rarity:100, name:"pearl"}, emeralds:{rarity:100, name:"emerald"}}
treasures := stringtoarray(treasures)
if (!IsObject(treasures) || treasures.Count() == 0 ||treasures.Count() == ""){
	treasures := {}
}
for a, b in treasurestats
{
	if(!treasures[a]){
		treasures[a] := 0
	}
}

stats := stringtoarray(stats)
if (!IsObject(stats) || stats.Count() == 0 ||stats.Count() == ""){
	stats := {}
}
;these are all the buttons in the options menu. Optionchecks stores whether they are selected or not.
alloptions := {disablemenusnapping:"Disable putting the main menu to another location when it is moved off screen. (does not work on the top of the screen)"
	, autoclickprevention:"Prevent clicking rewards gained when clicking really fast (in case autoclickers are used and you dont want them to affect the game)"}
optionchecks := stringtoarray(optionchecks)
if (!IsObject(optionchecks) || optionchecks.Count() == 0 ||optionchecks.Count() == ""){
	optionchecks := {}
}
optioncheckvalue := {}
for a, b in alloptions
{
	if(optionchecks[a] == 1){
		optioncheckvalue[a] := 1
	}
	else{
		optioncheckvalue[a] := 0
	}
}
optionchecks := optioncheckvalue

;assign all garden tiles with their values
loop, % gardenMaxX * gardenMaxY{
	CX := mod(A_index, gardenMaxX)
	CY := ceil(A_index / gardenMaxY)
	if(CX == 0){
		CX := gardenMaxX
	}
	;check if the buttons contain plants and if you have enough garden tiles to make them visible. Tiles you dont have are invisible. Tiles you dont have but with a plant are disabled.
	nextto := [ CX - 1 . "A" . CY - 1, CX . "A" . CY - 1, CX + 1 . "A" . CY - 1, CX - 1 . "A" . CY, CX + 1 . "A" . CY, CX - 1 . "A" . CY + 1, CX . "A" . CY + 1, CX + 1 . "A" . CY + 1]
	;this part reads the savedata for the garden and imports and plants in their correct locations.
	freezertile%CX%A%CY% := {nextto:nextto, temp:{}, permanent:{}, location:[CX, CY, "freezer", A_index]}
	iniread, savedtile, %savename%, garden, freezertile%CX%A%CY%
	if(savedtile <> "ERROR"){
		gardenvalue := objfullyclone(stringtoarray(savedtile))
		freezertile%CX%A%CY%["plant"] := gardenvalue["plant"]
	}
	tile%CX%A%CY% := {nextto:nextto, temp:{}, permanent:{}, location:[CX, CY, "garden", A_index]}
	iniread, savedtile, %savename%, garden, tile%CX%A%CY%
	if(savedtile <> "ERROR"){
		gardenvalue := objfullyclone(stringtoarray(savedtile))
		tile%CX%A%CY%["permanent"] := gardenvalue["permanent"]
		tile%CX%A%CY%["plant"] := gardenvalue["plant"]
	}
	;this is an average tile string looks like remove the ; symbol from all text below this to see what happens and get some info out of it. (I hope)
	;tile4A5 := {plant: ;if there's a plant here V. This object contains its stats
	;{rarity: 100, descr: "An ordinary tree", name: "tree", harvest:{harvestpower:25}, global:{clickpower:1}}
	;, nextto: ;here V are all the tiles that the current tile is next to. Does not go below 1 but can go above the current amount of tiles in case new ones get added
	;[3A4, 4A4, 5A4, 3A5, 5A5, 3A6, 4A6, 5A6]
	;, location: ; This contains the location of the tile itself
	;[4, 5, garden, 54]
	;, temp: ;here V come temporary effects from plants that buff nearby tiles
	;{passive:{clickpowerpercent: 10}}
	;, permanent: ;here V come the permanent buffs to a tile which are slowly affected by certain other plants
	;{passive:{movepowerpercent: 20, clickpowerpercent: 10}}}
	;msgbox % arraytostring(tile4A5["nextto"]) ;returns the tiles the current tile is next to
	;msgbox % tile4A5["nextto"][1] ;returns the first tile that the current tile is next to. Tiles that do not exist like tiles below 0 should be ignored.
	;msgbox % arraytostring(tile4A5) returns everything from garden tile 3-2
}

clickwaitvalue := 2000
autoclickwaitvalue := 125
movewaitvalue := 10000
timercheckvalue := 100
treasurewaitvalue := 60000
keyboardkeywaitvalue := 1000
goldenkeywaitvalue := 60000
autosavewaitvalue := 300000
clickwait := A_tickcount + clickwaitvalue
autoclickwait := A_tickcount + autoclickwaitvalue
movewait := A_tickcount + movewaitvalue
timercheck := A_tickcount + timercheckvalue
treasurewait := A_tickcount + treasurewaitvalue
keyboardkeywait := A_tickcount + keyboardkeywaitvalue
goldenkeywait := A_tickcount + goldenkeywaitvalue
autosavewait := A_tickcount + autosavewaitvalue
logs := {}
tooltips := []

starttime := A_tickcount
coordmode, mouse, screen
coordmode, tooltip, screen

;dev functions
instantmouseclicks := "false" ;disables the waiting time before claiming power by clicking
instantmousemovement := "false" ;disables the waiting time before claiming power by moving the mouse. Even when not moving at all
silentmovementlogs := "100" ;removes the "moving the mouse gave (AMOUNT) power" logs. Set this to a number to reduce the amount of logs put in (250 sets it to 1/4th of the original rate)
maxgardenplantchance := "false" ;grants a 100% chance of a plant appearing on a tile when moving the mouse
maxgardenpermbuffs := "false" ;Makes garden plants with permanent effects apply their max possible effect immediately
silentplants := "false" ;same deal as silent movement logs but for when a garden plant appears in the garden instead. Some special plants still bypass this
ignoreplantrarity := "false" ;plant rarity no longer makes it appear less
noplants := "false" ;moving the mouse doesn't cause plants to appear anymore
limitlessfusions := "false" ;causes plants with the fusion abillity to ignore plant weakness allowing them to fuse as many already fused plants together as you want.
devbuttonenabled := "false" ;enables the dev button which has varying effects based on what I want to test right now
F11reset := "false" ;reloads the game when pressing F11

loop, 26{
	;binds all letter keys to a hotkey
	Hotkey, % "~" . Chr(A_index+96) . " up", keyboardletters
}

guiwidth := A_screenwidth / 1.5
guiheight := A_screenheight / 1.5
gui Backgroundpower:default
gui, add, edit, h0 w0
gui, font, s10
gui +Border -Caption +lastfound
gui, color, EBAE02
WinSet, TransColor, EBAE02
winsettitle, Background Power
selectedfeature := "nothing"
updatemain()
updategardeneffects()
if(version <> "ERROR" && 130 > version){
	;in v 1.30, hidden keys have been renamed to golden keys so this part turns all the hidden keys levels into golden key levels. Furthermore the power gained from hidden treasures has been changed to 25x the power of moving the mouse with 1 max level
	almanacunlocked := 0
	if(upgrades["hiddenkeys"]["purchased"] >= 1){
		if(!upgrades["goldenkeys"]){
			upgrades["goldenkeys"] := {}
		}
		upgrades["goldenkeys"]["purchased"] := 1
		upgrades.delete("hiddenkeys")
	}
	if(hiddentreasure["purchased"] > 1){
		hiddentreasure["purchased"] := 1
	}
	IniRead, plantcomboknowledge, %savename%, garden, plantcomboknowledge
	;the plant combo part system has been overhauled and turned into the almanac rendering the old system useless. Anyone gets 2 free knowledge points per unlocked recipe. They still need to unlock the almanac though
	plantcomboknowledge := stringtoarray(plantcomboknowledge)
	loop, % plantcomboknowledge.maxIndex(){
		if(plantcomboknowledge[A_index] == 1){
			plantknowledge["knowledge"] += 2
		}
	}
	IniDelete, %savename%, garden, plantcomboknowledge
}

if(version <> "ERROR" && 134 > version){
	loop, % gardenMaxX * gardenMaxY{
		CX := mod(A_index, gardenMaxX)
		CY := ceil(A_index / gardenMaxY)
		if(CX == 0){
			CX := gardenMaxX
		}
		if(tile%CX%A%CY%["plant"]["fusion"]){
			tile%CX%A%CY%["plant"]["fusion"] := {strength:1, amount:2, result:{rarity:100, knowledge:1, descr:"Turns out fusing plants doesn't combine the appeal of them.", name:"amalgam plant", symbol:"X"}}
		}
	}
}
;not sure what this V part does but it makes moving the gui with the mouse possible so it stays
OnMessage(0x0201, "WM_LBUTTONDOWN")
WM_LBUTTONDOWN()
{
	If (A_Gui){
		PostMessage, 0xA1, 2
	}
}
timervalue := 25
SetTimer, globaltimer, %timervalue%
gui, show, autosize
return

~LButton::
;this triggers whenever the left mouse button is clicked.
removetooltip("shopdescription")
removetooltip("gardendescription")
if(A_tickcount > clickwait && !(autoclickwait > A_tickcount && optionchecks["autoclickprevention"] == 1) || instantmouseclicks == "true"){
	;autoclickprevention is an option that you can turn on (default off) which prevents power gain from clicking too fast
	;in case people really want to play the game but also really feel like autoclickers are cheating
	clickwait := A_tickcount + clickwaitvalue
	somemousevalue := calculateclickvalue()
	changepower(somemousevalue)
	if(!stats["clicks"]){
		stats["clicks"] := 0
	}
	stats["clicks"] += 1
}
autoclickwait := A_tickcount + autoclickwaitvalue
return

keyboardletters:
;when a keyboard key is released. This part triggers.
;I made it trigger on release instead of pressing because you could trigger this multiple times by holding.
if(A_tickcount > keyboardkeywait && keyboardmotor["purchased"] >= 1){
	somekeyboardvalue := calculatekeyboardkeyvalue(A_thishotkey)
	keyboardkeywait := A_tickcount + keyboardkeywaitvalue
	changepower(somekeyboardvalue)
	if(!stats["keyboardletterspressed"]){
		stats["keyboardletterspressed"] := 0
	}
	stats["keyboardletterspressed"] += 1
	;pressing keys can sometimes create hidden treasures and rarely spawns a golden key
	random, keyboardrngesus, 1, 100
	if(keyboardrngesus > 95 && hiddentreasure["purchased"] >= 1){
		treasureavailable := randompointonscreen()
	}
	random, keyboardrngesus, 1, 100
	if(keyboardrngesus > 98 && goldenkeys["purchased"] >= 1){
		keyavailable := randomletter()
	}
}
if(A_thishotkey == "~" . keyavailable . " up"){
	;if the hidden key is pressed. Do this
	somekeyboardvalue := calculatekeyboardkeyvalue(A_thishotkey) * 25
	goldenkeywait := A_tickcount + goldenkeywaitvalue
	addlog("collecting the golden key (" . keyavailable . ") gave " . somekeyboardvalue . " power", "power")
	addlog("collecting the golden key (" . keyavailable . ") gave " . somekeyboardvalue . " power", "treasure")
	keyavailable := ""
	changepower(somekeyboardvalue)
	somekeyboardvalue := getkeys()
	if(!stats["goldenkeyspressed"]){
		stats["goldenkeyspressed"] := 0
	}
	stats["goldenkeyspressed"] += 1
	if(somekeyboardvalue >= 1){
		;when a treasure key is obtained. Do this
		treasurekeys += somekeyboardvalue
		chesttext := "collecting a golden key gave " . somekeyboardvalue . " treasure Key"
		if(somekeyboardvalue >= 2){
			chesttext .= "s"
		}
		addlog(chesttext, "treasure")
		if(!stats["goldenkeysfound"]){
			stats["goldenkeysfound"] := 0
		}
		stats["goldenkeysfound"] += somekeyboardvalue
	}
	updatemain()
}
return

globaltimer:
if(A_tickcount > timercheck){
	;update the power on the menu
	timercheck := A_tickcount + timercheckvalue
	power := round(power)
	shownpower := % toscientific(power, 3)
	mainshowpower.InnerHtml := "Power: " . shownpower
	;fixwindowpos moves the window if its offscreen
	if(optionchecks["disablemenusnapping"] == 0){
		fixwindowpos("Background Power")
	}
}
if(A_tickcount > autosavewait){
	;save the game
	savegame_onclick()
}
;get where the mouse is currently at on screen
Coordmode, Mouse, Screen
MouseGetPos, MouseX, MouseY

;this part handles moving the mouse dot in the radar on the hidden treasure gui
if(selectedfeature == "treasure" && treasureradarbought == 1){
	treasureradardot.style.left := (MouseX / (A_screenwidth / 100)) . "%"
	treasureradardot.style.top := (MouseY / (A_screenheight / 100)) . "%"
	if(treasureavailable && 100 >= abs(treasureavailable[1] - MouseX) && 100 >= abs(treasureavailable[2] - MouseY)){
		treasureradardot.innerhtml := "O"
	}
	else if(treasureavailable && 200 >= abs(treasureavailable[1] - MouseX) && 200 >= abs(treasureavailable[2] - MouseY)){
		treasureradardot.innerhtml := "0"
	}
	else if(treasureavailable && 400 >= abs(treasureavailable[1] - MouseX) && 400 >= abs(treasureavailable[2] - MouseY)){
		treasureradardot.innerhtml := "o"
	}
	else{
		treasureradardot.innerhtml := "."
	}
}
if(treasureavailable && 30 >= abs(treasureavailable[1] - MouseX) && 30 >= abs(treasureavailable[2] - MouseY)){
	;check if the mouse is near a hidden treasure and if so. Collect it
	treasurewait := A_tickcount + treasurewaitvalue
	somevalue := calculatemovevalue() * 25
	changepower(somevalue)
	addlog("collecting a hidden treasure gave " . somevalue . " power", "power")
	addlog("collecting a hidden treasure gave " . somevalue . " power", "treasure")
	if(!stats["hiddentreasuresfound"]){
		stats["hiddentreasuresfound"] := 0
	}
	somevalue := getchests()
	treasurechests += somevalue
	stats["hiddentreasuresfound"] += 1
	if(somevalue >= 1){
		;check if a treasure chest has been obtained
		if(!stats["treasurechestsfound"]){
			stats["treasurechestsfound"] := 0
		}
		stats["treasurechestsfound"] += somevalue
		chesttext := "collecting a hidden treasure gave " . somevalue . " chest"
		if(somevalue >= 2){
			chesttext .= "s"
		}
		addlog(chesttext, "treasure")
	}
	treasureavailable := ""
	updatemain()
}
moveX := (MouseX - MouseStartX)
moveY := (MouseY - MouseStartY)
;subract the place where the mouse was last with where the mouse is now.
MouseStartX := MouseX
MouseStartY := MouseY
;the current place is stored for the next time.
;moving the mouse increases this V value. When it reaches a certain treshhold and after enough time passes. Power is gained for moving the mouse.
movetrack += round((abs(moveX) + abs(moveY)) * calculatemovespeed())
if((movetrack >= 15000 && A_tickcount >= movewait) || instantmousemovement == "true"){
	;movement is more effective the more the mouse was moved
	min("IF YOU'RE reading this as an error message. That means your autohotkey version is outdated. Please update it to play the game.")
	moveeffectiveness := min(1 + (movetrack / 300000), 2)
	somevalue := floor(calculatemovevalue() * moveeffectiveness)
	if(mouseengine3["purchased"] >= 1){
		somevalue += movetrack
	}
	movetrack = 0
	changepower(somevalue)
	random, globalrngesus, 1, 1000
	if(silentmovementlogs == "false" || silentmovementlogs >= globalrngesus){
		addlog("moving the mouse gave " . somevalue . " power", "power")
	}
	if(globalrngesus > 900){
		keyavailable := randomletter()
	}
	random, globalrngesus, 1, 1000
	if(globalrngesus > 975 && hiddentreasure["purchased"] >= 1){
		treasureavailable := randompointonscreen()
	}
	if(!stats["mousemoves"]){
		stats["mousemoves"] := 0
	}
	stats["mousemoves"] += 1
	movewait := A_tickcount + movewaitvalue
	;calculate the chance of garden plants appearing. Its 3% by default + up to 3 from upgrades + up to 3 if the mouse was moved a lot.
	plantchance := 3
	gardenplantchance := 0
	for globalentry, globalcontent in upgrades{
		if(%globalentry%["plantchance"]){
			gardenplantchance += %globalentry%["plantchance"] * globalcontent["purchased"]
		}
	}
	plantchance += (gardenplantchance * plantchance / 100) + ((moveeffectiveness - 1) * plantchance)
	if(noplants == "false"){
		creategardenplant(plantchance)
	}
	;gardentick handles permanent effects for now. I plan on eventually adding a plant growth feature that uses this
	gardentick()
}
;this part here handles the tooltips added by addtooltip() and puts them below eachother and next to your mouse on every call.
totaltooltips := ""
loop, % tooltips.MaxIndex(){
	if(0 >= tooltips[A_index]["timer"]){
		tooltips.remove(A_index)
	}
	totaltooltips .= tooltips[A_index]["content"] . "`n"
	tooltips[A_index]["timer"] -= timervalue / 100
}
;This function makes tooltips smoother and prevents flickering
ToolTipFM(totaltooltips, 5)
return

updatemain(){
	global
	critical, on
	gui, backgroundpower:default
	guicontrolget, mainguiexist, hwnd, maindoc
	if(!mainguiexist){
		;create the main menu used for displaying all features
		mainmenuhighW := guiwidth * 0.1
		mainmenuhighH := guiheight
		Gui, Add, ActiveX, x0 y0 w%mainmenuhighW% h%mainmenuhighH% vmaindoc, HtmlFile
		guicontrolget, maindoc, pos
		mainmenuhighX := maindocW
		Gui, Add, ActiveX, x%mainmenuhighX% y0 w%mainmenuhighW% h%mainmenuhighH% vmaindoc2, HtmlFile
		mainhtmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; width:100%; height: 100%; font-family: 'Verdana'; font-size:" . guiwidth / 100 . "px;} body {background:#666666; width:100%; height: 100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
		mainhtmlpart1 .= "button{font-size:" . guiwidth / 100 . "px;}"
		mainhtmlpart1 .= ".power{width:100%; height: 30px; color: #000000;}"
		mainhtmlpart1 .= ".shop{width:100%; height: 30px; background: #AAAAAA; color: #000000;}"
		mainhtmlpart1 .= ".garden{width:100%; height: 30px; background: #AAAAAA; color: #000000;}"
		mainhtmlpart1 .= ".hiddentreasure{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
		mainhtmlpart1 .= ".logs{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
		mainhtmlpart1 .= ".stats{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
		mainhtmlpart1 .= ".options{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
		mainhtmlpart1 .= ".help{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
		mainhtmlpart1 .= ".devbutton{width:100%; height: 30px; left:0px; background: #000000; color: #DDDDDD;}"
		mainhtmlpart1 .= ".save{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
		mainhtmlpart1 .= ".exit{width:100%; height: 30px; left:0px; background: #222222; color: #FFFFFF;}"
		mainhtmlpart2 := "</style></head><body><table id='mainmenutable'>"
		mainhtmlpart2 .= "<tr><td><p class='power' id='showpower'>Power: " . power . "</button></td></tr>"
		mainhtmlpart2 .= "<tr><td><button class='shop' id='shop' mode='shop'>Shop</button></td></tr>"
		mainhtmlpart2 .= "<tr id='gardentable' style=""display:none;""><td><button class='garden' id='garden' mode='garden' style=""display:none;"">Garden</button></td></tr>"
		mainhtmlpart2 .= "<tr id='treasuretable' style=""display:none;""><td><button class='hiddentreasure' id='treasure' mode='treasure' style=""display:none;"">Hidden treasures</button></td></tr>"
		mainhtmlpart2 .= "<tr><td><button class='logs' id='logs' mode='logs'>Logs</button></td></tr>"
		mainhtmlpart2 .= "<tr><td><button class='stats' id='stats' mode='stats'>Stats</button></td></tr>"
		mainhtmlpart2 .= "<tr><td><button class='options' id='options' mode='options'>Options</button></td></tr>"
		mainhtmlpart2 .= "<tr><td><button class='help' id='help' mode='help'>Help</button></td></tr>"
		mainhtmlpart2 .= "<tr><td><button class='save' id='save'>Save</button></td></tr>"
		mainhtmlpart2 .= "<tr id='devtable' style=""display:none;""><td><button class='devbutton' id='devbutton' style=""display:none;"">Devbutton</button></td></tr>"
		mainhtmlpart2 .= "<tr><td><button class='exit' id='exit'>Exit</button></td></tr>"
		mainhtmlpart2 .= "</table></body></html>"
		mainhtml := mainhtmlpart1 . mainhtmlpart2
		maindoc.open()
		maindoc.write(mainhtml)
		maindoc.close()
		
		mainshowpower := maindoc.getElementById("showpower")
		mainshopbutton := maindoc.getElementById("shop")
		maingardenbutton := maindoc.getElementById("garden")
		maingardentable := maindoc.getElementById("gardentable")
		maintreasurebutton := maindoc.getElementById("treasure")
		maintreasuretable := maindoc.getElementById("treasuretable")
		mainlogsbutton := maindoc.getElementById("logs")
		mainstatsbutton := maindoc.getElementById("stats")
		mainoptionsbutton := maindoc.getElementById("options")
		mainhelpbutton := maindoc.getElementById("help")
		mainsavebutton := maindoc.getElementById("save")
		maindevbutton := maindoc.getElementById("devbutton")
		maindevtable := maindoc.getElementById("devtable")
		mainexitbutton := maindoc.getElementById("exit")
		ComObjConnect(mainshopbutton, "selectfeature_")
		ComObjConnect(maingardenbutton, "selectfeature_")
		ComObjConnect(maintreasurebutton, "selectfeature_")
		ComObjConnect(mainlogsbutton, "selectfeature_")
		ComObjConnect(mainstatsbutton, "selectfeature_")
		ComObjConnect(mainoptionsbutton, "selectfeature_")
		ComObjConnect(mainhelpbutton, "selectfeature_")
		ComObjConnect(mainsavebutton, "savegame_")
		ComObjConnect(maindevbutton, "devbutton_")
		ComObjConnect(mainexitbutton, "exit_")
	}
	if(devbuttonenabled == "true"){
		maindevbutton.style.display := "block"
		maindevtable.style.display := "block"
	}
	if(maintreasurebutton.style.display == "none" && hiddentreasure["purchased"] >= 1){
		maintreasurebutton.style.display := "block"
		maintreasuretable.style.display := "block"
	}
	else if(0 >= hiddentreasure["purchased"]){
		maintreasurebutton.style.display := "none"
		maintreasuretable.style.display := "none"
	}
	if(maingardenbutton.style.display == "none" && garden["purchased"] >= 1){
		maingardenbutton.style.display := "block"
		maingardentable.style.display := "block"
	}
	else if(0 >= garden["purchased"]){
		maingardenbutton.style.display := "none"
		maingardentable.style.display := "none"
	}
	if(selectedfeature){
		mainbuttoncheck := maindoc.getElementById(selectedfeature)
		mainbuttoncheck.disable := "disabled"
		mainbuttoncheck.value := mainbuttoncheck.value
	}
	guicontrolget, mainguiexist, hwnd, featuredoc
	if(!mainguiexist){
		guicontrolget, maindoc, pos
		guicontrolget, maindoc2, pos
		mainmenuhighW := guiwidth - maindocW - maindoc2W
		mainmenuhighH := guiheight
		mainmenuhighX := maindocW + maindoc2W
		Gui, Add, ActiveX, w%mainmenuhighW% h%mainmenuhighH% x%mainmenuhighX% y0 vfeaturedoc, HTMLFile
	}
	;pressing a button on the sidebar changes the selectedfeature value. The displayed info changes depending on the currently pressed button
	if(selectedfeature == "nothing"){
		if(!storedselectedfeature <> selectedfeature){
			storedselectedfeature := selectedfeature
			htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; border-style: none; height: 100%;} body {background:#888888; height: 100%;}"
			htmlpart2 := "</style></head><body><table>"
			htmlpart2 .= "</table></body></html>"
			html := htmlpart1 . htmlpart2
			
			html2 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; width:100%; height: 100%;} body {background:#777777; width:100%; height: 100%;}</style></head></html>"
		}
		featuredoc.open()
		featuredoc.write(html)
		featuredoc.close()
		maindoc2.open()
		maindoc2.write(html2)
		maindoc2.close()
	}
	if(selectedfeature == "shop"){
		if(storedselectedfeature <> selectedfeature){
			storedselectedfeature := selectedfeature
			htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:auto; height: 100%;} body {background:#888888; height: 100%; font-family:verdana; font-size:" . guiwidth / 100 . "px;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
			htmlpart1 .= "button{font-size:" . guiwidth / 100 . "px;}"
			htmlpart1 .= ".scrollable {overflow-y: auto;}"
			htmlpart2 := "</style></head><body><table class='scrollable'>"
			loop, % allupgrades.MaxIndex(){
				shopentry := allupgrades[A_index]
				htmlpart1 .= "." . shopentry . "{width: 100%; height: 30px; background: #AAAAAA; color: #000000;}"
				htmlpart2 .= "<tr id='" . shopentry . "table'><td style=""width:10%;""><button class='" . shopentry . "' id='" . shopentry . "' disable=''> " . %shopentry%["name"] . "</button></td><td><p id='" . shopentry . "price'>Price: " . round(calculateshopprice(%shopentry%)) . "</p></td></tr>"
			}
			htmlpart2 .= "</table></div></body></html>"
			html := htmlpart1 . htmlpart2
			
			html2part1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; height: 100%;} body {background:#777777; height: 100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
			html2part1 .= "button{font-size:" . guiwidth / 100 . "px;}"
			html2part1 .= ".inspect{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".purchase{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part2 := "</style></head><body><table style='float:left;'>"
			html2part2 .= "<tr><td><button class='inspect' id='inspect' mode='inspect'>Inspect mode</button></td></tr>"
			html2part2 .= "<tr><td><button class='purchase' id='purchase' mode='purchase'>Purchase Mode</button></td></tr>"
			html2part2 .= "</table></div></body></html>"
			html2 := html2part1 . html2part2
			featuredoc.open()
			featuredoc.write(html)
			featuredoc.close()
			
			maindoc2.open()
			maindoc2.write(html2)
			maindoc2.close()
			shoppurchasebutton := maindoc2.getElementById("purchase")
			shopinspectbutton := maindoc2.getElementById("inspect")
			ComObjConnect(shoppurchasebutton, "shopmode_")
			ComObjConnect(shopinspectbutton, "shopmode_")
			for, mainentry, maincontent in allupgrades{
				if(%maincontent%){
					shopupgrade%maincontent%button := featuredoc.getElementById(maincontent)
					ComObjConnect(shopupgrade%maincontent%button, "shoppurchase_")
				}
			}
		}
		for shopentry, shopcontent in allupgrades{
			;example of an upgrade with an unlock requirement: clickingpower2 := {unlockcondition:[{name:"clickingpower", array:"purchased", amount:10, requirement:">="}, {name:"power", amount:5000, requirement:">="}]}
			;this part hides any upgrade that does not have their unlock requirement met and permanently shows them if they are met.
			unlockcheck := "unlocked"
			if(%shopcontent%["unlocked"] <> "unlocked"){
				;this part checks for buttons with an unlock requirement and checks if that requirement has been met.
				loop % %shopcontent%["unlockcondition"].Count(){
					unlockcondition := %shopcontent%["unlockcondition"]
					shopvalue := unlockcondition[A_index]["name"]
					if(unlockcondition[A_index]["array"]){
						shopvalue := %shopvalue%[unlockcondition[A_index]["array"]]
					}
					else{
						shopvalue := %shopvalue%
					}
					if(unlockcondition[A_index]["requirement"] == "<"){
						if(shopvalue >= unlockcondition[A_index]["amount"]){
							unlockcheck := "locked"
						}
					}
					if(unlockcondition[A_index]["requirement"] == "<="){
						if(shopvalue > unlockcondition[A_index]["amount"]){
							unlockcheck := "locked"
						}
					}
					if(unlockcondition[A_index]["requirement"] == "=="){
						if(shopvalue <> unlockcondition[A_index]["amount"]){
							unlockcheck := "locked"
						}
					}
					if(unlockcondition[A_index]["requirement"] == ">="){
						if(unlockcondition[A_index]["amount"] > shopvalue){
							unlockcheck := "locked"
						}
					}
					if(unlockcondition[A_index]["requirement"] == ">"){
						if(unlockcondition[A_index]["amount"] >= shopvalue){
							unlockcheck := "locked"
						}
					}
				}
				if(unlockcheck == "unlocked"){
					%shopcontent%["unlocked"] := "unlocked"
				}
			}
			shopupgradetable := featuredoc.getElementById(shopcontent . "table")
			shopupgradebutton := featuredoc.getElementById(shopcontent)
			shopupgradeprice := featuredoc.getElementById(shopcontent . "price")
			;disable does not mean the button is disabled. disabled with an d at the end means that its disabled. Disable is something I added myself which only changes the button color.
			if(shopupgradebutton.disable <> "disabled" && (%shopcontent%["repeated"] && %shopcontent%["purchased"] >= %shopcontent%["repeated"]) || !%shopcontent%["repeated"] && %shopcontent%["purchased"] > 0){
				shopupgradebutton.disable := "disabled"
			}
			else if(shopupgradebutton.disable == "disabled" && %shopcontent%["repeated"] > %shopcontent%["purchased"]){
				shopupgradebutton.disable := ""
			}
			if(%shopcontent%["unlocked"] <> "unlocked"){
				shopupgradetable.style.display := "none"
			}
			else{
				shopupgradetable.style.display := "block"
			}
			;change the button value to itself to update the visibillity/color etc
			shopupgradebutton.value := %shopcontent%["name"]
			if(shopupgradebutton.disable <> "disabled"){
				shopupgradeprice.innerhtml := "Price: " . round(calculateshopprice(%shopcontent%))
			}
			else{
				shopupgradeprice.innerhtml := "Max level"
			}
		}
		if(shopmode){
			mainbuttoncheck := maindoc2.getElementById(shopmode)
			mainbuttoncheck.disable := "disabled"
			mainbuttoncheck.value := mainbuttoncheck.value
		}
	}
	if(selectedfeature == "garden"  || selectedfeature == "freezer"){
		if(storedselectedfeature <> selectedfeature || storedgardentiles <> gardentiles || storedfreezertiles <> freezertiles){
			storedselectedfeature := selectedfeature
			storedgardentiles := gardentiles
			storedfreezertiles := freezertiles
			htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow: hidden; height:100%; width:100%;} body {background:#888888; height:100%; width:100%;} [disable=disabled]{background: #666666 !important;}"
			htmlpart1 .= "button{font-size:" . guiwidth / 100 . "px;}"
			htmlpart1 .= ".gardentable {width:100%; height:100%; left:0px; top:0px; border-style:none; position:absolute;}"
			htmlpart2 := "</style></head><body><table class='gardentable'>"
			guicontrolget, featuredoc, pos
			loop, % gardenmaxX * gardenmaxY{
				;this loop creates the buttons for every garden and freezer tile
				CX := mod(A_index, gardenmaxX)
				CY := ceil(A_index / gardenmaxY)
				if(CX == 1){
					htmlpart2 .= "<tr>"
				}
				if(CX == 0){
					CX := gardenmaxX
				}
				;IMPORTANT buttons here are set at a specific pixel length instead of % length. For some reason pressing any button with % width shrinks it before it turns normal again (only the first one is unaffected)
				;to see this for yourself. Replace the following
				;width: " . round(featuredocW / 100 * 9, 1) . "px; >>>> width: " . round((100 / gardenmaxX) * 0.9) . "px;
				;height: " . round(featuredocH / 100 * 9, 1) . "px; >>>> height: " . round((100 / gardenmaxY) * 0.9) . "px;
				if(selectedfeature == "garden"){
					htmlpart1 .= ".Tile" . CX . "A" . CY . " {left:" . round((CX - 0.95) * (100 / gardenmaxX), 1) . "%; width: " . round(featuredocW / 100 * 9, 1) . "px; top:" . round((CY - 0.95) * (100 / gardenmaxY), 1) . "%; height: " . round(featuredocH / 100 * 9, 1) . "px; font-size:" . guiwidth / 40 . "px; background: #55DD88; color: #000000; position: absolute;}"
					htmlpart2 .= "<td><button class='Tile" . CX . "A" . CY . "' id='tile" . CX . "A" . CY . "'></button></td>"
				}
				else if(selectedfeature == "freezer"){
					htmlpart1 .= ".Freezertile" . CX . "A" . CY . " {left:" . round((CX - 0.95) * (100 / gardenmaxX), 1) . "%; width: " . round(featuredocW / 100 * 9, 1) . "px; top:" . round((CY - 0.95) * (100 / gardenmaxY), 1) . "%; height: " . round(featuredocH / 100 * 9, 1) . "px; font-size:" . guiwidth / 40 . "px; background: #AADDDD; color: #000000; position: absolute;}"
					htmlpart2 .= "<td><button class='Freezertile" . CX . "A" . CY . "' id='freezertile" . CX . "A" . CY . "' style=''></button></td>"
				}
				if(CX == gardenmaxX){
					htmlpart2 .= "</tr>"
				}
			}
			htmlpart2 .= "</table>"
			html := htmlpart1 . htmlpart2
			
			html2part1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; border-style:none; border-color:#FFFFFF; height: 100%; width: 100%;} body {background:#777777; height: 100%; width: 100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
			html2part1 .= "button{word-break: break-word; font-size:" . guiwidth / 100 . "px;}"
			html2part1 .= ".inspect{width:100%; left:0px; height: 30px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".harvest{width:100%; left:0px; height: 30px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".protect{width:100%; left:0px; height: 30px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".swap{width:100%; left:0px; height: 30px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".swapgarden{width:100%; left:0px; height: 30px; color: #000000;}"
			html2part1 .= ".almanac{width:100%; left:0px; height: 30px;, background: #55DD88; color: #000000;}"
			html2part1 .= ".purchasetile{width:100%; left:0px; height: 64px; background: #AAAAAA; color: #000000;}"
			html2part2 := "</style></head><body><table style='float:left;'>"
			html2part2 .= "<tr><td><button class='inspect' id='inspect' mode='inspect'>Inspect mode</button></td></tr>"
			html2part2 .= "<tr><td><button class='harvest' id='harvest' mode='harvest'>Harvest mode</button></td></tr>"
			html2part2 .= "<tr><td><button class='swap' id='swap' mode='swap'>Swap mode</button></td></tr>"
			html2part2 .= "<tr><td><button class='protect' id='protect' mode='protect'>Protect mode</button></td></tr>"
			if(selectedfeature == "garden"){
				html2part2 .= "<tr><td><button class='swapgarden' id='swapgarden' mode='freezer' style=""background: #AADDDD;"">Freezer</button></td></tr>"
				html2part2 .= "<tr id='almanactable' style=""display:none;""><td><button class='almanac' id='almanac' mode='almanac'>Almanac</button></td></tr>"
				html2part2 .= "<tr><td><button class='purchasetile' id='purchasetile' topurchase='gardentile'>Purchase garden tile</br>costs " . tileprice("garden") . "</button></td></tr>"
			}
			if(selectedfeature == "freezer"){
				html2part2 .= "<tr><td><button class='swapgarden' id='swapgarden' mode='garden' style=""background: #55DD88;"">Garden</button></td></tr>"
				html2part2 .= "<tr id='almanactable' style=""display:none;""><td><button class='almanac' id='almanac' mode='almanac'>Almanac</button></td></tr>"
				html2part2 .= "<tr><td><button class='purchasetile' id='purchasetile' topurchase='freezertile'>Purchase freezer tile</br>costs " . tileprice("freezer") . "</button></td></tr>"
			}
			html2part2 .= "</table></body></html>"
			html2 := html2part1 . html2part2
			featuredoc.open()
			featuredoc.write(html)
			featuredoc.close()
			
			maindoc2.open()
			maindoc2.write(html2)
			maindoc2.close()
			if(gardenmode){
				mainbuttoncheck := maindoc2.getElementById(gardenmode)
				mainbuttoncheck.disable := "disabled"
				mainbuttoncheck.value := mainbuttoncheck.value
			}
			gardeninspectbutton := maindoc2.getElementById("inspect")
			gardenharvestbutton := maindoc2.getElementById("harvest")
			gardenprotectbutton := maindoc2.getElementById("protect")
			gardenswapbutton := maindoc2.getElementById("swap")
			gardenswapgardenbutton := maindoc2.getElementById("swapgarden")
			gardenalmanacbutton := maindoc2.getElementById("almanac")
			gardenalmanactable := maindoc2.getElementById("almanactable")
			gardenpurchasetilebutton := maindoc2.getElementById("purchasetile")
			ComObjConnect(gardeninspectbutton, "gardenmode_")
			ComObjConnect(gardenharvestbutton, "gardenmode_")
			ComObjConnect(gardenswapbutton, "gardenmode_")
			ComObjConnect(gardenprotectbutton, "gardenmode_")
			ComObjConnect(gardenswapgardenbutton, "selectfeature_")
			ComObjConnect(gardenpurchasetilebutton, "purchasetile_")
			ComObjConnect(gardenalmanacbutton, "selectfeature_")
			ComObjConnect(gardenswapgardenbutton, "selectfeature_")
			
			loop, % gardenmaxX * gardenmaxY{
				CX := mod(A_index, gardenMaxX)
				CY := ceil(A_index / gardenMaxY)
				if(CX == 0){
					CX := gardenMaxX
				}
				if(selectedfeature == "garden"){
					gardentile%CX%A%CY%button := featuredoc.getElementById("tile" . CX . "A" . CY)
					ComObjConnect(gardentile%CX%A%CY%button, "garden_")
				}
				else if(selectedfeature == "freezer"){
					freezertile%CX%A%CY%button := featuredoc.getElementById("freezertile" . CX . "A" . CY)
					ComObjConnect(freezertile%CX%A%CY%button, "garden_")
				}
			}
			if(selectedfeature == "garden" && gardentiles >= GardenmaxX * GardenmaxY){
				gardenpurchasetilebutton.disable := "disabled"
				gardenpurchasetilebutton.value := gardentiles . " Tiles!"
			}
			else if(selectedfeature == "garden"){
				gardenpurchasetilebutton.disable := ""
				gardenpurchasetilebutton.value := "Purchase garden tile</br>costs " . tileprice("garden")
			}
			else if(selectedfeature == "freezer" && freezertiles >= GardenmaxX * GardenmaxY){
				gardenpurchasetilebutton.disable := "disabled"
				gardenpurchasetilebutton.value := freezertiles . " Tiles!"
			}
			else if(selectedfeature == "garden"){
				gardenpurchasetilebutton.disable := ""
				gardenpurchasetilebutton.value := "Purchase freezer tile</br>costs " . tileprice("freezer")
			}
			loop, % gardenMaxX * gardenMaxY{
				CX := mod(A_index, gardenMaxX)
				CY := ceil(A_index / gardenMaxY)
				if(CX == 0){
					CX := gardenMaxX
				}
				if(selectedfeature == "garden"){
					gardenbuttoncheck := featuredoc.getElementById("tile" . CX . "A" . CY)
					;this part hides garden tiles that you havent unlocked yet or if there's somehow a plant on it. It disables them instead
					if(tile%CX%A%CY%["plant"]["name"] && A_index > gardentiles){
						gardenbuttoncheck.disable := "disabled"
					}
					else if(A_index > gardentiles){
						gardenbuttoncheck.style.display := "none"
					}
					else{
						gardenbuttoncheck.style.display := "block"
						gardenbuttoncheck.disable := ""
					}
				}
				if(selectedfeature == "freezer"){
					gardenbuttoncheck := featuredoc.getElementById("freezertile" . CX . "A" . CY)
					if(freezertile%CX%A%CY%["plant"]["name"] && A_index > freezertiles){
						gardenbuttoncheck.disable := "disabled"
						gardenbuttoncheck.style.display := "block"
					}
					else if(A_index > freezertiles){
						gardenbuttoncheck.style.display := "none"
					}
					else{
						gardenbuttoncheck.style.display := "block"
						gardenbuttoncheck.disable := ""
					}
				}
			}
		}
		if(gardenalmanactable.style.display == "none" && almanacunlocked){
			gardenalmanactable.style.display := "block"
		}
		loop, % gardenmaxX * GardenmaxY{
			CX := mod(A_index, 10)
			CY := ceil(A_index / 10)
			if(CX == 0){
				CX = 10
			}
			;update any garden tiles that don't have their current name as the same one displayed on the button
			if(selectedfeature == "garden"){
				storedplantname := tile%CX%A%CY%["plant"]["name"]
				if(storedplantname == "lockbloom" && !keyavailable){
					tile%CX%A%CY%["plant"]["symbol"] := "Lb"
				}
				storedplantsymbol := tile%CX%A%CY%["plant"]["symbol"]
				storedplantbackgroundcolor := tile%CX%A%CY%["plant"]["background"]
				storedplanttextcolor := tile%CX%A%CY%["plant"]["textcolor"]
				gardendocedit := featuredoc.getelementbyid("tile" . CX . "A" . CY)
				if(CX == plantselect["location"][1] && CY == plantselect["location"][2] && plantselect["location"][3] == "garden"){
					gardendocedit.style.background := "#FF6666"
				}
				else if(tile%CX%A%CY%["plant"]["protected"] == 1){
					gardendocedit.style.background := "#557744"
				}
				else{
					gardendocedit.style.background := "#55DD88"
				}
			}
			if(selectedfeature == "freezer"){
				storedplantname := freezertile%CX%A%CY%["plant"]["name"]
				storedplantsymbol := freezertile%CX%A%CY%["plant"]["symbol"]
				storedplantbackgroundcolor := freezertile%CX%A%CY%["plant"]["background"]
				storedplanttextcolor := freezertile%CX%A%CY%["plant"]["textcolor"]
				gardendocedit := featuredoc.getelementbyid("freezertile" . CX . "A" . CY)
				if(CX == plantselect["location"][1] && CY == plantselect["location"][2] && plantselect["location"][3] == "freezer"){
					gardendocedit.style.background := "#FF6666"
				}
				else if(freezertile%CX%A%CY%["plant"]["protected"] == 1){
					gardendocedit.style.background := "#AAAADD"
				}
				else{
					gardendocedit.style.background := "#AADDDD"
				}
			}
			;update garden tile names if they have been changed.
			if((storedplantname <> gardendocedit.value && storedplantsymbol <> gardendocedit.value)){
				if(storedplantbackgroundcolor){
					if(storedplantsymbol){
						gardendocedit.value := "<table style=""background:" . storedplantbackgroundcolor . "; width:60%; height:60%;""><td>" . storedplantsymbol . "</td></table>"
					}
					else{
						gardendocedit.value := "<table style=""background:" . storedplantbackgroundcolor . "; width:60%; height:60%;""><td>" . storedplantname . "</td></table>"
					}
				}
				else{
					if(storedplantsymbol){
						gardendocedit.value := storedplantsymbol
					}
					else{
						gardendocedit.value := storedplantname
					}
				}
				if(storedplanttextcolor){
					gardendocedit.style.color := storedplanttextcolor
				}
				else{
					gardendocedit.style.color := "#000000"
				}
			}
		}
		if(gardenmode){
			mainbuttoncheck := maindoc2.getElementById(gardenmode)
			mainbuttoncheck.disable := "disabled"
			mainbuttoncheck.value := mainbuttoncheck.value
		}
	}
	if(selectedfeature == "almanac"){
		if(storedselectedfeature <> selectedfeature || storedalmanacplant <> selectedalmanacplant || plantknowledge["knowledge"] <> storedknowledge){
			storedalmanacplant := selectedalmanacplant
			storedknowledge := plantknowledge["knowledge"]
			;the almanac is rather complex. Most of the code is either displaying the html or comparing knowledge points invested in the selected plant to see which recipes to display.
			htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow: hidden; height:100%; width:100%; font-family: 'Verdana'; font-size:" . guiwidth / 75 . "px;} body {background:#888888; height:100%; width:100%;} table {top:0px; border-style: none;} [disable=disabled]{background: #666666 !important;}"
			htmlpart1 .= "button{font-size:" . guiwidth / 100 . "px;}"
			htmlpart1 .= ".know{background: #55DD88; color: #000000; width:100%;}"
			htmlpart1 .= ".maindiv{position:absolute; left:0px; top:0px; width:100%;}"
			htmlpart2 := "</style></head><body>"
			if(selectedalmanacplant){
				mainvalue := %selectedalmanacplant%
				htmlpart2 .= "<div class='maindiv' style=""overflow-y:scroll; overflow-X:hidden; height:66%;""><table>"
				htmlpart2 .= "<tr><td><button style=""width: " . round(featuredocW / 100 * 9, 1) . "px; height: " . round(featuredocH / 100 * 9, 1) . "px; font-size:" . guiwidth / 40 . "px; background: #55DD88; "
				if(mainvalue["textcolor"]){
					htmlpart2 .= "color: " . mainvalue["textcolor"] . "; "
				}
				else{
					htmlpart2 .= "color: #000000; "
				}
				htmlpart2 .= """>"
				if(mainvalue["background"]){
					if(mainvalue["symbol"]){
						htmlpart2 .= "<table style=""background:" . mainvalue["background"] . "; width:60%; height:60%;""><td>" . mainvalue["symbol"] . "</td></table>"
					}
					else{
						htmlpart2 .= "<table style=""background:" .  mainvalue["background"] . "; width:60%; height:60%;""><td>" . mainvalue["name"] . "</td></table>"
					}
				}
				else if(mainvalue["symbol"]){
					htmlpart2 .= mainvalue["symbol"]
				}
				else{
					htmlpart2 .= mainvalue["name"]
				}
				htmlpart2 .= "</button></td></tr></table><table>"
				htmlpart2 .= "<tr><td colspan='2'><p>" . getplantdescription(mainvalue, "</br>") . "</p></td></tr></table><table>"
				mainvalue := plantknowledge[selectedalmanacplant]
				if(mainvalue["current"] > 0){
					createdby := 0
					cancreate := 0
					loop, % plantcombos.maxIndex(){
						mainindex := A_index
						for mainentry, maincontent in plantcombos[mainindex]{
							if(mainentry == "result" && maincontent == selectedalmanacplant){
								createdby += 1
							}
						}
						for mainentry, maincontent in plantcombos[mainindex]["pardners"]{
							if(maincontent == selectedalmanacplant){
								cancreate += 1
								break
							}
						}
					}
					writtendescriptions := 0
					loop, % plants.MaxIndex(){
						if(plants[A_index]["name"] == selectedalmanacplant){
							createdby += 1
						}
					}
					if((mainvalue["current"] / mainvalue["cap"] * 100) >= ((100 / createdby) - (50 / createdby)) / 2 && createdby > 0){
						htmlpart2 .= "<tr><td><p></br>This plant can be created the following way"
						if((mainvalue["current"] / mainvalue["cap"] * 100) >= (((100 / createdby) * 2) - (50 / createdby)) / 2 && createdby > 1){
							htmlpart2 .= "s"
						}
						htmlpart2 .= ":</p></td></tr>"
					}
					loop, % plants.MaxIndex(){
						if(plants[A_index]["name"] == selectedalmanacplant){
							if((mainvalue["current"] / mainvalue["cap"] * 100) >= (100 / createdby) / 2){
								htmlpart2 .= "<tr><td><p>By randomly appearing in the garden</p></td></tr>"
								writtendescriptions += 1
							}
							else if((mainvalue["current"] / mainvalue["cap"] * 100) >= ((100 / createdby) - (50 / createdby)) / 2){
								htmlpart2 .= "<tr><td><p>????????????????????</p></td></tr>"
								writtendescriptions += 1
							}
						}
					}
					loop, % plantcombos.maxIndex(){
						mainindex := A_index
						for mainentry, maincontent in plantcombos[mainindex]{
							if(mainentry == "result" && maincontent == selectedalmanacplant){
								writtendescriptions += 1
								if((mainvalue["current"] / mainvalue["cap"] * 100) >= (100 / createdby) * writtendescriptions / 2){
									htmlpart2 .= "<tr><td><p>breeding using a "
									for mainentry2, maincontent2 in plantcombos[mainindex]["pardners"]{
										plantname := %maincontent2%["name"]
										if(plantknowledge[maincontent2]["current"] / plantknowledge[maincontent2]["cap"] >= 0.25){
											htmlpart2 .= plantname . " and a "
										}
										else{
											htmlpart2 .= "????? and a "
										}
									}
									stringtrimright, htmlpart2, htmlpart2, 7
									htmlpart2 .= "</p></td></tr>"
								}
								else if((mainvalue["current"] / mainvalue["cap"] * 100) >= (((100 / createdby) * writtendescriptions) - (50 / createdby)) / 2){
									htmlpart2 .= "<tr><td><p>????????????????????</p></td></tr>"
								}
							}
						}
					}
					writtendescriptions := 0
					if((mainvalue["current"] / mainvalue["cap"] * 100) >= 50 + (((100 / cancreate) - (50 / cancreate)) / 2) && cancreate > 0){
						htmlpart2 .= "<tr><td><p></br>This plant can be used in creating the following plant"
						if((mainvalue["current"] / mainvalue["cap"] * 100) >= 50 + ((((100 / cancreate) * 2) - (50 / cancreate)) / 2) && cancreate > 1){
							htmlpart2 .= "s"
						}
						htmlpart2 .= ":</p></td></tr>"
					}
					loop, % plantcombos.maxIndex(){
						mainindex := A_index
						for mainentry, maincontent in plantcombos[mainindex]["pardners"]{
							if(maincontent == selectedalmanacplant){
								writtendescriptions += 1
								if((mainvalue["current"] / mainvalue["cap"] * 100) >= 50 + ((100 / cancreate) * writtendescriptions / 2)){
									htmlpart2 .= "<tr><td><p>breeding using a "
									for mainentry2, maincontent2 in plantcombos[mainindex]["pardners"]{
										plantname := %maincontent2%["name"]
										if(plantknowledge[maincontent2]["current"] / plantknowledge[maincontent2]["cap"] >= 0.5 || maincontent2 == selectedalmanacplant){
											htmlpart2 .= plantname . " and a "
										}
										else{
											htmlpart2 .= "????? and a "
										}
									}
									stringtrimright, htmlpart2, htmlpart2, 7
									htmlpart2 .= " may result in a "
									plantname := plantcombos[mainindex]["result"]
									plantname := %plantname%["name"]
									if(plantknowledge[plantcombos[mainindex]["result"]]["current"] / plantknowledge[plantcombos[mainindex]["result"]]["cap"] >= 0.1){
										htmlpart2 .= plantname
									}
									else{
										htmlpart2 .= "?????"
									}
									mhtlpart2 .= "</p></td></tr>"
								}
								else if((mainvalue["current"] / mainvalue["cap"] * 100) >= 50 + (((100 / cancreate * writtendescriptions) - (50 / cancreate)) / 2)){
									htmlpart2 .= "<tr><td><p>????????????????????</p></td></tr>"
								}
								break
							}
						}
					}
				}
				htmlpart2 .= "</table></div><div style=""bottom:0px; position:absolute;""><table><tr><td></br></br><p>knowledge: " . plantknowledge["knowledge"] . "</p></td></tr>"
				htmlpart2 .= "<tr><td><button class='know' id='addknowledge1' mode='1' percent='false'>add 1 knowledge</button></td>"
				htmlpart2 .= "<td><button class='know' id='addknowledge2' mode='10' percent='true'>add 10% of your knowledge</button></td></tr>"
				htmlpart2 .= "<tr><td><button class='know' id='addknowledge3' mode='10' percent='false'>add 10 knowledge</button></td>"
				htmlpart2 .= "<td><button class='know' id='addknowledge4' mode='25' percent='true'>add 25% of your knowledge</button></td></tr>"
				htmlpart2 .= "<tr><td><button class='know' id='addknowledge5' mode='100' percent='false'>add 100 knowledge</button></td>"
				htmlpart2 .= "<td><button class='know' id='addknowledge6' mode='50' percent='true'>add 50% of your knowledge</button></td></tr>"
				htmlpart2 .= "<tr><td><button class='know' id='addknowledge7' mode='1000' percent='false'>add 1000 knowledge</button></td>"
				htmlpart2 .= "<td><button class='know' id='addknowledge8' mode='100' percent='true'>add 100% of your knowledge</button></td></tr>"
				htmlpart2 .= "<tr><td><p>knowledge: " . mainvalue["current"] . "/" . mainvalue["cap"] . "</p></td></tr></table></div>"
			}
			htmlpart2 .= "</body></html>"
			html := htmlpart1 . htmlpart2
			
			html2part1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow-x:hidden; height:100%; width:100%; font-family: 'Verdana'; font-size:" . guiwidth / 100 . "px;} body {background:#777777; height:100%; width:100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
			html2part1 .= "button{font-size:" . guiwidth / 100 . "px;}"
			html2part1 .= "button{width:100%; left:0px; height: 30px; background: #AAAAAA; color: #000000;}"
			html2part2 := "</style></head><body><table>"
			html2part2 .= "<tr><td><p>seen plants</p></td></tr>"
			
			for mainentry, maincontent in plantknowledge{
				if(maincontent["seen"] > 0){
					html2part2 .= "<tr><td><button id='" . mainentry . "' mode='" . mainentry . "'>" . %mainentry%["name"] . "</td></tr>"
				}
			}
			html2part2 .= "</table></body></html>"
			html2 := html2part1 . html2part2
			
			featuredoc.open()
			featuredoc.write(html)
			featuredoc.close()
			
			if(storedselectedfeature <> selectedfeature){
				maindoc2.open()
				maindoc2.write(html2)
				maindoc2.close()
			}
			storedselectedfeature := selectedfeature
			if(selectedalmanacplant){
				addknowledgebutton1 := featuredoc.getElementById("addknowledge1")
				addknowledgebutton2 := featuredoc.getElementById("addknowledge2")
				addknowledgebutton3 := featuredoc.getElementById("addknowledge3")
				addknowledgebutton4 := featuredoc.getElementById("addknowledge4")
				addknowledgebutton5 := featuredoc.getElementById("addknowledge5")
				addknowledgebutton6 := featuredoc.getElementById("addknowledge6")
				addknowledgebutton7 := featuredoc.getElementById("addknowledge7")
				addknowledgebutton8 := featuredoc.getElementById("addknowledge8")
				comObjConnect(addknowledgebutton1, "addknowledge_")
				comObjConnect(addknowledgebutton2, "addknowledge_")
				comObjConnect(addknowledgebutton3, "addknowledge_")
				comObjConnect(addknowledgebutton4, "addknowledge_")
				comObjConnect(addknowledgebutton5, "addknowledge_")
				comObjConnect(addknowledgebutton6, "addknowledge_")
				comObjConnect(addknowledgebutton7, "addknowledge_")
				comObjConnect(addknowledgebutton8, "addknowledge_")
			}
			for mainentry, maincontent in plantknowledge{
				if(maincontent["seen"] > 0){
					almanac%mainentry%button := maindoc2.getElementById(mainentry)
					comObjConnect(almanac%mainentry%button, "almanacmode_")
				}
			}
		}
		if(selectedalmanacplant){
			mainbuttoncheck := maindoc2.getElementById(selectedalmanacplant)
			mainbuttoncheck.disable := "disabled"
			mainbuttoncheck.value := mainbuttoncheck.value
		}
	}
	if(selectedfeature == "treasure"){
		if(storedselectedfeature <> selectedfeature){
			storedselectedfeature := selectedfeature
			htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow: hidden; height:100%; width:100%;} body {background:#888888; height:100%; width:100%;} table {left:0px; top:0px; width:20%; border-style: none; position:absolute;} [disable=disabled]{background: #888888 !important;}"
			htmlpart1 .= "button{font-size:" . guiwidth / 100 . "px;}"
			htmlpart1 .= ".radarbutton{width: 100%; height: 64px; left:0px; background: #AAAAAA; color: #000000;}"
			htmlpart1 .= ".radardot{position:absolute; color: #000000; font-size:" . guiwidth / 50 . "px;}"
			htmlpart2 := "</style></head><body><table align='left'>"
			htmlpart2 .= "<tr><td><button class='radarbutton' id='radarbutton'>Purchase radar</br>costs 50000 power</button></td></tr>"
			htmlpart2 .= "</table><p class='radardot' id='radardot'></p>"
			htmlpart2 .= "</body></html>"
			html := htmlpart1 . htmlpart2
			
			html2part1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; height: 100%; width: 100%; font-family: 'Verdana'; font-size:" . guiwidth / 100 . "px;} body {background:#777777; height: 100%; width: 100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
			html2part1 .= "p{height:0%;}"
			html2part1 .= ".openchest{width:100%; height: 64px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".openallchests{width: 100%; height: 96px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".treasureinfo{word-wrap:break-word;}"
			html2part2 := "</style></head><body><table>"
			html2part2 .= "<tr><td><button class='openchest' id='openchest' mode='1' style=""font-size:" . guiwidth / 120 . "px;"">Open A treasure chest</br>using 1 key</button></td></tr>"
			html2part2 .= "<tr><td><button class='openallchests' id='openallchests' mode='all' style=""font-size:" . guiwidth / 120 . "px;""></button></td></tr>"
			html2part2 .= "<tr><td><p id='chests'><p></td></tr>"
			html2part2 .= "<tr><td><p id='keys'><p></td></tr>"
			for mainentry, maincontent in treasures{
				html2part2 .= "<tr><td><p id='" . mainentry . "'><p></td></tr>"
			}
			html2part2 .= "<tr><td><p id='treasureinfo' style='height:100%;'><p></td></tr>"
			html2part2 .= "</table></body></html>"
			html2 := html2part1 . html2part2
			featuredoc.open()
			featuredoc.write(html)
			featuredoc.close()
			
			maindoc2.open()
			maindoc2.write(html2)
			maindoc2.close()
			treasureopenchestbutton := maindoc2.getElementById("openchest")
			treasureopenallchestsbutton := maindoc2.getElementById("openallchests")
			treasureradarbutton := featuredoc.getElementById("radarbutton")
			treasureradardot := featuredoc.getElementById("radardot")
			treasureinfotable := maindoc2.getElementById("treasureinfotable")
			treasureinfo := maindoc2.getElementById("treasureinfo")
			treasurecheststext := maindoc2.getElementById("chests")
			treasurekeystext := maindoc2.getElementById("keys")
			for mainentry, maincontent in treasures{
				treasure%mainentry%text := maindoc2.getElementById(mainentry)
			}
			ComObjConnect(treasureopenchestbutton, "treasureopen_")
			ComObjConnect(treasureopenallchestsbutton, "treasureopen_")
			ComObjConnect(treasureradarbutton, "purchaseradar_")
		}
		if(treasureradarbought <> 1){
			treasureradardot.style.display := "none"
			treasureradarbutton.style.display := "block"
		}
		else{
			treasureradardot.style.display := "block"
			treasureradarbutton.style.display := "none"
		}
		treasurecheststext.Innerhtml := "chests: " . treasurechests
		treasurekeystext.Innerhtml := "golden keys: " . treasurekeys
		mainvalue := Min(treasurechests, treasurekeys)
		if(mainvalue == 1){
			treasureopenallchestsbutton.Innerhtml := "Open 1 chest</br>usng 1 Key"
		}
		else{
			treasureopenallchestsbutton.Innerhtml := "Open " . mainvalue . " chests</br>using " . mainvalue . " Keys"
		}
		for mainentry, maincontent in treasures{
			treasure%mainentry%text.InnerHtml := mainentry . ": " . maincontent
		}
		treasureinfo.InnerHtml := treasureinfotext
	}
	if(selectedfeature == "logs"){
		if(storedselectedfeature <> selectedfeature){
			storedselectedfeature := selectedfeature
			htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:shown; border-style:none; height: 100%; font-family: 'Verdana'; font-size:" . guiwidth / 100 . "px;} body {background:#888888; height: 100%;}"
			htmlpart1 .= ".logstext{width:100%; height:30px; left:0px; color: #000000;}"
			htmlpart2 := "</style></head><body><table width='100%'>"
			htmlpart2 .= "<tr><td><p class='logstext' id='logstext' style='height:100%; width:100%;'></p></td></tr>"
			htmlpart2 .= "</table></body></html>"
			html := htmlpart1 . htmlpart2

			html2part1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; border-style:none; height: 100%;} body {background:#777777; height: 100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
			html2part1 .= "button{font-size:" . guiwidth / 100 . "px;}"
			html2part1 .= ".general{width:100%; height:30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".power{width:100%; height:30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".garden{width:100%; height:30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".treasure{width:100%; height:30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".shop{width:100%; height:30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part2 := "</style></head><body><table width='100%' id='logstable'>"
			html2part2 .= "<tr><td><button class='general' id='general' mode='general'>General logs</button></td></tr>"
			html2part2 .= "<tr><td><button class='shop' id='shop' mode='shop'>Shop logs</button></td></tr>"
			html2part2 .= "<tr><td><button class='power' id='power' mode='power'>Power logs</button></td></tr>"
			html2part2 .= "<tr><td id='gardentable'><button class='garden' id='garden' mode='garden'>Garden Logs</button></td></tr>"
			html2part2 .= "<tr><td id='treasuretable'><button class='treasure' id='treasure' mode='treasure'>Treasure Logs</button></td></tr>"
			html2part2 .= "</table></body></html>"
			html2 := html2part1 . html2part2

			featuredoc.open()
			featuredoc.write(html)
			featuredoc.close()

			maindoc2.open()
			maindoc2.write(html2)
			maindoc2.close()

			logstext := featuredoc.getElementById("logstext")
			logsgeneralbutton := maindoc2.getElementById("general")
			logsshopbutton := maindoc2.getElementById("shop")
			logspowerbutton := maindoc2.getElementById("power")
			logsgardenbutton := maindoc2.getElementById("garden")
			logsgardentable := maindoc2.getElementById("gardentable")
			logstreasurebutton := maindoc2.getElementById("treasure")
			logstreasuretable := maindoc2.getElementById("treasuretable")
			ComObjConnect(logsgeneralbutton, "logsmode_")
			ComObjConnect(logsshopbutton, "logsmode_")
			ComObjConnect(logspowerbutton, "logsmode_")
			ComObjConnect(logsgardenbutton, "logsmode_")
			ComObjConnect(logstreasurebutton, "logsmode_")
		}
		if(logsmode){
			mainbuttoncheck := maindoc2.getElementById(logsmode)
			mainbuttoncheck.disable := "disabled"
			mainbuttoncheck.value := mainbuttoncheck.value
		}
		totallogs := ""
		for logsentry, logscontent in logs{
			while(logscontent.MaxIndex() > 50){
				logs[logsentry].remove(1) ;logscontent
			}
			loop, % logs[logsentry].MaxIndex(){
				if(logsentry == logsmode || logsmode == "all"){
					totallogs .= logs[logsentry][A_index] . "</br>"
				}
				if(totallogs.MaxIndex() > 50){
					totallogs.Remove(1)
				}
			}
		}
		logstext.innerhtml := totallogs
	}
	if(selectedfeature == "stats"){
		storedselectedfeature := selectedfeature
		htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow: hidden; height:100%; width:100%; font-family: 'Verdana'; font-size:" . guiwidth / 100 . "px;} body {background:#888888; height:100%; width:100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
		htmlpart2 := "</style></head><body><table>"
		if(stats["clicks"] >= 0){
			htmlpart2 .= "<tr><td>times power gained by clicking: " . stats["clicks"] . "</td></tr>"
		}
		if(stats["powergained"] >= 0){
			htmlpart2 .= "<tr><td>total power gained: " . stats["powergained"] . "</td></tr>"
		}
		if(stats["powerspent"] >= 0){
			htmlpart2 .= "<tr><td>total power spent: " . stats["powerspent"] . "</td></tr>"
		}
		if(stats["upgradespurchased"] >= 0){
			htmlpart2 .= "<tr><td>Upgrades purchased: " . stats["upgradespurchased"] . "</td></tr>"
		}
		if(stats["mousemoves"] >= 0){
			htmlpart2 .= "<tr><td>times power gained by moving the mouse: " . stats["mousemoves"] . "</td></tr>"
		}
		if(stats["keyboardletterspressed"] >= 0){
			htmlpart2 .= "<tr><td>times power gained by using the keyboard: " . stats["keyboardletterspressed"] . "</td></tr>"
		}
		if(stats["hiddentreasuresfound"] >= 0){
			htmlpart2 .= "<tr><td>hidden treasures found: " . stats["hiddentreasuresfound"] . "</td></tr>"
		}
		if(stats["goldenkeyspressed"] >= 0){
			htmlpart2 .= "<tr><td>golden keyboard keys pressed: " . stats["goldenkeyspressed"] . "</td></tr>"
		}
		if(stats["treasurechestsfound"] >= 0){
			htmlpart2 .= "<tr><td>treasure chests found: " . stats["treasurechestsfound"] . "</td></tr>"
		}
		if(stats["goldenkeysfound"] >= 0){
			htmlpart2 .= "<tr><td>golden keys found: " . stats["goldenkeysfound"] . "</td></tr>"
		}
		if(stats["chestsopened"] >= 0){
			htmlpart2 .= "<tr><td>Chests opened: " . stats["chestsopened"] . "</td></tr>"
		}
		if(stats["gardenplantscreated"] >= 0){
			htmlpart2 .= "<tr><td>garden plants created: " . stats["gardenplantscreated"] . "</td></tr>"
		}
		if(stats["powerharvested"] >= 0){
			htmlpart2 .= "<tr><td>Total power harvested from plants: " . stats["powerharvested"] . "</td></tr>"
		}
		if(stats["plantsharvested"] >= 0){
			htmlpart2 .= "<tr><td>Total plants harvested: " . stats["plantsharvested"] . "</td></tr>"
		}
		htmlpart2 .= "</table></body></html>"
		html := htmlpart1 . htmlpart2
		
		html2part1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; height:100%; width:100%; font-family: 'Verdana'; font-size:" . guiwidth / 100 . "px;} body {background:#777777; height:100%; width:100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
		html2part2 := "</style></head><body><table>"
		html2part2 := "<tr><td></td></tr>"
		html2part2 .= "</table></body></html>"
		html2 := html2part1 . html2part2
		featuredoc.open()
		featuredoc.write(html)
		featuredoc.close()
		maindoc2.open()
		maindoc2.write(html2)
		maindoc2.close()
	}
	if(selectedfeature == "options"){
		if(storedselectedfeature <> selectedfeature){
			storedselectedfeature := selectedfeature
			;these handle the option checkboxes. I'm not entirely sure what other options should be added though there should probably eventually be one to set autosave timer or notation.
			htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {border-style:none; overflow:shown; width:100%; height: 100%; font-family:verdana; font-size:" . guiwidth / 100 . "px;} body {background:#888888; width:100%; height: 100%;} table {left:0px; top:0px; border-style: none; position:absolute;} input[type='checkbox'] {width:20px; height:15px;}"
			htmlpart2 := "</style></head><body><table width='100%'>"
			for mainentry, maincontent in alloptions{
				htmlpart1 .= "." . mainentry . "{height: 30px; left:0px; color: #000000;}"
				htmlpart2 .= "<tr><td><input type='checkbox' class='" . mainentry . "' id='" . mainentry . "'>" . maincontent . "</td></tr>"
			}
			htmlpart2 .= "</table></body></html>"
			html := htmlpart1 . htmlpart2
			
			html2 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; width:100%; height: 100%;} body {background:#777777; width:100%; height: 100%;}</style></head></html>"
			featuredoc.open()
			featuredoc.write(html)
			featuredoc.close()
			
			maindoc2.open()
			maindoc2.write(html2)
			maindoc2.close()
			for mainentry, maincontent in alloptions{
				options%mainentry%checkbox := featuredoc.getElementById(mainentry)
				if(optionchecks[mainentry] == 1){
					options%mainentry%checkbox.checked := "true"
					optionchecks[mainentry] := 1
				}
				ComObjConnect(options%mainentry%checkbox, "optionscheckbox_")
			}
		}
	}
	if(selectedfeature == "help"){
		if(storedselectedfeature <> selectedfeature){
			storedselectedfeature := selectedfeature
			htmlpart1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:shown; border-style: none; height: 100%; font-family: 'Verdana'; font-size:" . guiwidth / 75 . "px;} body {background:#888888; height: 100%;}"
			htmlpart1 .= ".helpinfo{width:100%; left:0px; color: #000000; word-wrap: break-word;}"
			htmlpart2 := "</style></head><body><table id='helpbuttonstable'>"
			htmlpart2 .= "<tr><td><p class='helpinfo 'id='helpinfo'></p></td></tr>"
			htmlpart2 .= "<table></body></html>"
			html := htmlpart1 . htmlpart2
			
			html2part1 := "<!DOCTYPE html><html><head><style type=text/css> html {overflow:hidden; border-style: none; height: 100%;} body {background:#777777; height: 100%;} table {left:0px; top:0px; width:100%; border-style: none; position:absolute;} [disable=disabled]{background: #666666 !important;}"
			html2part1 .= "button{font-size:" . guiwidth / 100 . "px;}"
			html2part1 .= ".basics{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".powergeneration{width:100%; height: 60px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".saving{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".shop{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".logs{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".treasure{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".garden{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part1 .= ".almanac{width:100%; height: 30px; left:0px; background: #AAAAAA; color: #000000;}"
			html2part2 := "</style></head><body><table id='helpbuttonstable'>"
			html2part2 .= "<tr><td><button class='basics' id='basics' mode='basics'>The Basics</button></td></tr>"
			html2part2 .= "<tr><td><button class='powergeneration' id='powergeneration' mode='powergeneration'>Methods of</br>power generation</button></td></tr>"
			html2part2 .= "<tr><td><button class='saving' id='saving' mode='saving'>Saving the game</button></td></tr>"
			html2part2 .= "<tr><td><button class='shop' id='shop' mode='shop'>Shop</button></td></tr>"
			html2part2 .= "<tr><td><button class='logs' id='logs' mode='logs'>Logs</button></td></tr>"
			html2part2 .= "<tr id='treasuretable'><td><button class='treasure' id='treasure' mode='treasure'>Treasures</button></td></tr>"
			html2part2 .= "<tr id='gardentable'><td><button class='garden' id='garden' mode='garden'>Garden</button></td></tr>"
			html2part2 .= "<tr id='almanactable'><td><button class='almanac' id='almanac' mode='almanac'>Almanac</button></td></tr>"
			html2part2 .= "</table></body></html>"
			html2 := html2part1 . html2part2
			
			featuredoc.open()
			featuredoc.write(html)
			featuredoc.close()
			maindoc2.open()
			maindoc2.write(html2)
			maindoc2.close()
			
			helpbasicsbutton := maindoc2.getElementById("basics")
			helpsavingbutton := maindoc2.getElementById("saving")
			helplogsbutton := maindoc2.getElementById("logs")
			helpshopbutton := maindoc2.getElementById("shop")
			helpmousepowerbutton := maindoc2.getElementById("powergeneration")
			helpgardenbutton := maindoc2.getElementById("garden")
			helpgardentable := maindoc2.getElementById("gardentable")
			helpalmanacbutton := maindoc2.getElementById("almanac")
			helpalmanactable := maindoc2.getElementById("almanactable")
			helptreasurebutton := maindoc2.getElementById("treasure")
			helptreasuretable := maindoc2.getElementById("treasuretable")
			helpkeytable := maindoc2.getElementById("helpkeytable")
			
			if(0 >= garden["purchased"]){
				;hide these buttons if you haven't unlocked them yet.
				helpgardentable.style.display := "none"
			}
			else{
				helpgardentable.style.display := "block"
			}
			if(0 >= hiddentreasure["purchased"] && 0 >= goldenkeys["purchased"]){
				helptreasuretable.style.display := "none"
			}
			else{
				helptreasuretable.style.display := "block"
			}
			if(!plantknowledge["knowledge"]){
				helpalmanactable.style.display := "none"
			}
			else{
				helpalmanactable.style.display := "block"
			}
			ComObjConnect(helpbasicsbutton, "helpmode_")
			ComObjConnect(helpsavingbutton, "helpmode_")
			ComObjConnect(helpshopbutton, "helpmode_")
			ComObjConnect(helplogsbutton, "helpmode_")
			ComObjConnect(helpmousepowerbutton, "helpmode_")
			ComObjConnect(helpgardenbutton, "helpmode_")
			ComObjConnect(helpalmanacbutton, "helpmode_")
			ComObjConnect(helptreasurebutton, "helpmode_")
			helpinfotext := featuredoc.getElementById("helpinfo")
		}
		if(helpmode){
			mainbuttoncheck := maindoc2.getElementById(helpmode)
			mainbuttoncheck.disable := "disabled"
			mainbuttoncheck.value := mainbuttoncheck.value
		}
		helpvalue := ""
		if(helpmode == "basics"){
			helpvalue :=
			(
			"Welcome to Background power. Made by mipha (also known as /u/pimhazeveld) In this game you can earn power which is the game's main resource by clicking. Click anywhere you want, while having anything selected.
			It could be this screen, some page on the internet or even another game. This game will register the clicks and earn you power.</br>Clicking power gain is affected by various sources and new ways of earning power will quickly become available."
			)
		}
		if(helpmode == "saving"){
			helpvalue :=
			(
			"The game autosaves every 5 minutes and can be saved by manually pressing the save button. It saves by making a file near where the game is located and reads the savedata there.
			Saves can be backed up by copying them somewhere else and can be imported by replacing the current one. Make sure to quit the game before doing this, otherwise the game will overwrite parts of the save and possibly do some weird stuff.
			Futhermore the save should always be called 'backgroundpowersave.ini' otherwise it doesn't work."
			)
		}
		if(helpmode == "powergeneration"){
			if(calculateclickvalue() >= 1){
				helpvalue := calculateclickvalue() . " power is currently obtained every click.</br>"
				helpvalue .= clickpowerbonus . " from upgrades</br>"
				;check if some upgrades have been bought at least once
				if(garden["purchased"] >= 1){
					helpvalue .= "+" . round(farmclickpower) . " from garden plants</br>"
					helpvalue .= "*" . round((farmclickpowerpercent / 100) + 1, 3) . " from garden plants</br>"
				}
				helpvalue .= "*" . round(clickpowermult, 3) . " from upgrades</br>"
				if(hiddentreasure["purchased"] >= 1){
					helpvalue .= "*" . round(treasureclickpowermult, 3) . " from amulets</br>"
				}
				if(knowledgepower2["purchased"] >= 1){
					helpvalue .= "*" . round(knowledgeclickpowermult, 3) . " from knowledge points</br>"
				}
			}
			if(calculatemovevalue() >= 1){
				helpvalue .= "</br>" . calculatemovevalue() * 2 . " power is currently obtained at most when moving the mouse</br>"
				helpvalue .= movepowerbonus . " from upgrades</br>"
				if(garden["purchased"] >= 1){
					helpvalue .= "+" . round(farmmovepower) . " from garden plants</br>"
					helpvalue .= "*" . round((farmmovepowerpercent / 100) + 1, 3) . " from garden plants</br>"
				}
				if(hiddentreasure["purchased"] >= 1){
					helpvalue .= "*" . round(treasuremovepowermult, 3) . " from rings</br>"
				}
				helpvalue .= "*" . round(movepowermult, 3) . " from upgrades</br>"
				helpvalue .= "* up to 2 depending on how much the mouse was moved</br>"
				if(knowledgepower2["purchased"] >= 1){
					helpvalue .= "*" . round(knowledgemovepowermult, 3) . " from knowledge points</br>"
				}
				if(mousemastery["purchased"] >= 1){
					helpvalue .= "+" . calculateclickvalue() . " from clicking power added by mouse mastery</br>"
				}
			}
			if(calculatemovespeed() >= 1){
				helpvalue .= "</br>Mouse movement efficiency is " . calculatemovespeed() . "</br>"
				helpvalue .= movespeedbonus . " from upgrades</br>"
				if(garden["purchased"] >= 1){
					helpvalue .= "+" . round(farmmovespeed) . " from garden plants</br>"
					helpvalue .= "*" . round((farmmovespeedpercent / 100) + 1, 3) . " from garden plants</br>"
				}
				helpvalue .= "*" . round(movespeedmult, 3) . " from upgrades</br>"
				if(hiddentreasure["purchased"] >= 1){
					helpvalue .= "*" . round(treasuremovespeedmult, 3) . " from pearls</br>"
				}
				helpvalue .= "Mouse movement affects how quick power is built up when moving the mouse</br>"
			}
			if(calculatekeyboardkeyvalue() >= 1){
				helpvalue .= "</br>power gained from keyboard keys is " . calculatekeyboardkeyvalue() . "</br>"
				helpvalue .= keyboardkeypowerbonus . " from upgrades</br>"
				if(garden["purchased"] >= 1){
					helpvalue .= "+" . round(farmkeyboardkeypower) . " from garden plants</br>"
					helpvalue .= "*" . round((farmkeyboardkeypowerpercent / 100) + 1, 3) . " from garden plants</br>"
				}
				helpvalue .= "*" . round(keyboardkeypowermult, 3) . " from upgrades</br>"
				if(gamerfuel["purchased"] >= 1){
					helpvalue .= "*2 when pressing a WASD key</br>"
				}
				if(hiddentreasure["purchased"] >= 1){
					helpvalue .= "*" . round(treasurekeyboardkeymult, 3) . " from gold bars</br>"
				}
				if(knowledgepower2["purchased"] >= 1){
					helpvalue .= "*" . round(knowledgekeyboardkeymult, 3) . " from knowledge points</br>"
				}
			}
		}
		if(helpmode == "shop"){
			helpvalue :=
			(
			"In the shop you can spend power to gain upgrades. The shop has 2 modes, purchase and inspect. Inspect provides information about what the upgrade does and purchase mode does the same but will also attempt to buy the upgrades using power.
			Most upgrades in the shop are hidden until you meet the right requirement."
			)
		}
		if(helpmode == "logs"){
			helpvalue := "The logs show general info of what recently happened. Things like purchases, power gain from mouse moving"
			if(garden["purchased"] >= 1){
				helpvalue .= ", garden plants appearing"
			}
			if(hiddentreasure["purchased"] >= 1){
				helpvalue .= ", hidden treasures being found"
			}
			helpvalue .= ", the game being saved and many other things are all displayed there."
		}
		if(helpmode == "garden"){
			helpvalue :=
			(
			"In the garden. Plants appear over time when moving the mouse. Plants provide various buffs when left alone or harvested. Plants can occasionally create new plants next to them so keep your eyes open.</br>The garden has 4 modes to manage plants
			</br>Inspect mode, which displays information about the tile</br>Harvest mode which removes a plant and gives rewards based on the plant</br> Swap mode which swaps the contents of 2 tiles</br> and protect mode which prevents plants from
			accidentally being harvested.</br> Furthermore there's also a freezer which is an entirely different garden but plants wont grow there. Plants can be moved from the garden to the freezer"
			)
			calculateharvestvalue()
			helpvalue .= "</br></br>Power gained from harvesting a plant varies per plant. Here is an example when harvesting a plant that yields 50 power.</br>"
			helpvalue .= "It would yield 50 from the plant itself</br>"
			helpvalue .= "+" . harvestpowerbonus . " from upgrades</br>"
			helpvalue .= "+" . round(farmharvestpower) . " from garden plants</br>"
			helpvalue .= "*" . round((farmharvestpowerpercent / 100) + 1, 3) . " from garden plants</br>"
			helpvalue .= "*" . round(harvestpowermult, 3) . " from upgrades</br>"
			if(hiddentreasure["purchased"] >= 1){
				helpvalue .= "*" . round(treasureharvestmult, 3) . " from emeralds</br>"
			}
			if(knowledgepower2["purchased"] >= 1){
				helpvalue .= "*" . round(knowledgeharvestpowermult, 3) . " from knowledge points</br>"
			}
			helpvalue .= "For a total of " . calculateharvestvalue(50) . " power"
			plantchance := 3
			gardenplantchance := 0
			for globalentry, globalcontent in upgrades{
				if(%globalentry%["plantchance"]){
					gardenplantchance += %globalentry%["plantchance"] * globalcontent["purchased"]
				}
			}
			plantchance += (((gardenplantchance * plantchance / 100)))
			helpvalue .= "</br></br>Empty tiles have a " . round(plantchance, 3) . " - " . round(plantchance * 2, 3) . "% chance of spawning a plant when the mouse is moved depending on how much the mouse was moved."
			
		}
		if(helpmode == "almanac"){
			helpvalue :=
			(
			"The almanac is an extension to the garden. Here you can learn more about plants without many other plants affecting their stats so you can take a good look at them. Note however that rewards gained by harvesting are still affected by things
			like upgrades or global buffs.</br>Furthermore, here you can dump knowledge points
			in your discovered plants which are obtained by harvesting knowleaf plants. As more knowledge is dumped into plants, you'll discover how to create the plant and eventually start discovering how you can create other plants with it
			as well. Note that recipes often show question marks (?????). That means that either the plant does not have enough knowledge yet, or that it is trying to show a different plant that you do not have enough knowledge for yet.
			So dumping knowledge in every plant should be a priority if you want to know every plant there is to create.</br></br>"
			)
			if(10 <> calculateknowledge(10)){
				helpvalue .= "knowledge gained from a plant varies per plant. Here is an example when harvesting a plant that yields 10 knowledge.</br>"
				helpvalue .= "It would yield 10 from the plant itself</br>"
				helpvalue .= "+" . knowledgebonus . " from upgrades</br>"
				helpvalue .= "+" . round(farmknowledge) . " from garden plants</br>"
				helpvalue .= "*" . round((farmknowledgepercent / 100) + 1, 3) . " from garden plants</br>"
				helpvalue .= "*" . round(knowledgemult, 3) . " from upgrades</br>"
				helpvalue .= "For a total of " . calculateknowledge(10) . " knowledge"
			}
		}
		if(helpmode == "treasure"){
			if(hiddentreasure["purchased"] >= 1){
				helpvalue :=
				(
				"</br></br>Points on the screen can occasionally be assigned as hidden treasures when pressing keyboard keys. Mousing close to them digs them up and grants rewards. The process is entirely silent.
				You wont know whenever a treasure appears or when one is collected as to not bug the player with information while doing something else.</br></br>Furthermore treasure chests can occasionally be found and opened with a key to gain additional power and treasures."
				)
				if(0 >= hiddenkeys["purchased"]){
					helpvalue .= " How do you get a key you ask? Well you'll have to wait a little longer to find out.</br>"
				}
				helpvalue .= "power gained from hidden treasures is currently " . calculateclickvalue() * 25 . "</br>"
				helpvalue .=
				(
				"</br>Each treasure obtained from chests provides a 1% boost to a feature.</br>Amulets boost power gain from clicking.</br>Emeralds boost power gain from harvesting garden plants.</br>
				Gold bars boost power gain from opening treasure chests.</br>Grails boost power gain from finding keys.</br>Pearls boost mouse movement effeciency</br>Rings boost power gain from moving the mouse"
				)
				if(treasureradarbought == 1){
					helpvalue .=
					(
					"</br></br>The treasure radar is an useful feature that shows where treasures are currently located on the screen. Your mouse is displayed as a dot most of the time. When you are near a treasure.
					The mouse becomes an o, getting even closer makes it a 0 and finally an O until you move away or collect it."
					)
				}
			}
			if(goldenkeys["purchased"] >= 1){
				helpvalue .= 
				(
				"</br></br>Golden keys are a slightly different type of key where occasionally a random letter key on the keyboard becomes a secret golden key when the mouse has been moved.
				Pressing that letter gives way more power than a normal keyboard key and occasionally an usable key</br>"
				)
				if(0 >= hiddentreasure["purchased"]){
					helpvalue .= " Where do you use these keys? Well you'll have to wait a little longer to find out.</br>"
				}
				helpvalue .= "power gained from golden keys currently is " . calculatekeyboardkeyvalue() * 25 . "</br>"
			}
			if(hiddentreasure["purchased"] >= 1 && goldenkeys["purchased"] >= 1){
				helpvalue .= "</br>Hidden treasures and golden keys can appear when both moving the mouse or pressing keyboard keys but pressing keys is more effective for treasures to appear and moving the mouse is more effective for golden keys"
			}
		}
		helpinfotext.innerHTML := helpvalue
	}
	critical, off
}

selectfeature_onclick(selectfeaturedoc){
	global
	;change the selected feature and disable the pressed button
	if(selectedfeature){
		buttoncheck := maindoc.getElementById(selectedfeature)
		buttoncheck.disable := ""
		buttoncheck.value := buttoncheck.value
	}
	selectedfeature := selectfeaturedoc.mode
	if(selectedfeature == "freezer" && gardenmode == "harvest"){
		gardenmode := "inspect"
	}
	updatemain()
}

shopmode_onclick(shopmodedoc){
	global
	if(shopmode){
		buttoncheck := maindoc2.getElementById(shopmode)
		buttoncheck.disable := ""
		buttoncheck.value := buttoncheck.value
	}
	shopmode := shopmodedoc.mode
	updatemain()
}

gardenmode_onclick(gardenmodedoc){
	global
	gardenmodedoc := gardenmodedoc.mode
	if(gardenmode){
		gardenbuttoncheck := maindoc2.getElementById(gardenmode)
		gardenbuttoncheck.disable := ""
		gardenbuttoncheck.value := gardenbuttoncheck.value
	}
	;changes garden mode. Also handles changing from garden to freezer and vice versa.
	if(gardenmodedoc == "harvest" && selectedfeature == "freezer"){
		addtooltip("Harvest mode doesnt work in the freezer")
	}
	else{
		gardenmode := gardenmodedoc
		plantselect := ""
	}
	updatemain()
}

almanacmode_onclick(almanacdoc){
	global
	if(selectedalmanacplant){
		buttoncheck := maindoc2.getElementById(selectedalmanacplant)
		buttoncheck.disable := ""
		buttoncheck.value := buttoncheck.value
	}
	selectedalmanacplant := almanacdoc.mode
	updatemain()
}

addknowledge_onclick(addknowledgedoc){
	global
	;add knowledge points to a plant based on which button is pressed and the amount of knowledge you and the plant already have.
	almanacvalue := min(plantknowledge[selectedalmanacplant]["cap"] - plantknowledge[selectedalmanacplant]["current"])
	if(addknowledgedoc.percent == "true"){
		addknowledgevalue := round(min(almanacvalue, plantknowledge["knowledge"] / 100 * addknowledgedoc.mode))
		plantknowledge[selectedalmanacplant]["current"] := round(plantknowledge[selectedalmanacplant]["current"] + addknowledgevalue)
	}
	else{
		addknowledgevalue := round(min(almanacvalue, plantknowledge["knowledge"], addknowledgedoc.mode))
		plantknowledge[selectedalmanacplant]["current"] := round(plantknowledge[selectedalmanacplant]["current"] + addknowledgevalue)
	}
	plantknowledge["knowledge"] := round(plantknowledge["knowledge"] - addknowledgevalue)
	updatemain()
}

logsmode_onclick(logsmodedoc){
	global
	if(logsmode){
		buttoncheck := maindoc2.getElementById(logsmode)
		buttoncheck.disable := ""
		buttoncheck.value := buttoncheck.value
	}
	logsmode := logsmodedoc.mode
	updatemain()
}

helpmode_onclick(helpmodedoc){
	global
	if(helpmode){
		buttoncheck := maindoc2.getElementById(helpmode)
		buttoncheck.disable := ""
		buttoncheck.value := buttoncheck.value
	}
	helpmode := helpmodedoc.mode
	updatemain()
}

optionscheckbox_onclick(optionscheckboxdoc){
	global
	;for the checkboxes in the options
	gui, Options:default
	optionscheckboxvalue := optionscheckboxdoc.id
	if(optionscheckboxdoc.checked){
		optionchecks[optionscheckboxvalue] := 1
	}
	else{
		optionchecks[optionscheckboxvalue] := 0
	}
	updatemain()
}

purchaseradar_onclick(){
	global
	if(power > 50000 && treasureradarbought <> 1){
		changepower(50000, "subtract")
		treasureradarbought := 1
		addtooltip("radar bought. Look in the help tab about treasure power generation to learn more about it", 50)
		addlog("radar bought. Look in the help tab about treasure power generation to learn more about it", "treasure")
		updatemain()
	}
}

shoppurchase_onclick(shoppurchasedoc){
	global
	shoppurchasedoc := shoppurchasedoc.id
	shoppurchasedoc := % %shoppurchasedoc%
	;this gets the id of the button pressed which contains the name of an upgrad. The name of the upgrade then gets turned into its value because every upgrade contains an array of its stats and cost and such.
	;shopmode is set in shopmode_onclick()
	upgradeprice := calculateshopprice(shoppurchasedoc)
	upgradeprice := round(upgradeprice)
	totaldescription := ""
	if(shopmode == "purchase"){
		;if you can afford the upgrade and you haven't bought equal or more upgrades than the repeated tag or you haven't bought this and there is no repeated tag. Buy the upgrade
		if(power >= upgradeprice && ((shoppurchasedoc["repeated"] > shoppurchasedoc["purchased"]) || (shoppurchasedoc["purchased"] == 0 && !shoppurchasedoc["repeated"]))){
			addlog("bought " . shoppurchasedoc["name"] . " " . shoppurchasedoc["purchased"] . " > " . shoppurchasedoc["purchased"] + 1 . ". Power -" . upgradeprice, "shop")
			changepower(upgradeprice, "subtract")
			shoppurchasedoc["purchased"] += 1
			if(!stats["upgradespurchased"]){
				stats["upgradespurchased"] := 0
			}
			stats["upgradespurchased"] += 1
		}
		else if(shoppurchasedoc["purchased"] >= shoppurchasedoc["repeated"] || !shoppurchasedoc["repeated"]){
			totaldescription .= "No more levels of that upgrade available`n"
		}
		else if(upgradeprice > power){
			totaldescription .= "Not enough power (need " . round(upgradeprice - power) . " more)`n"
		}
	}
	;this creates the description of the upgrade based on what they boost and their associated description. Use tostring(name of upgrade) to see how the array and its description look.
	totaldescription .= shoppurchasedoc["name"] . "`n"
	if(shoppurchasedoc["repeated"] > hoppurchasedoc["purchased"]){
		totaldescription .= "Cost: " . upgradeprice . "`n"
	}
	if(shoppurchasedoc["repeated"]){
		totaldescription .= "Level: " . shoppurchasedoc["purchased"] . "/" . shoppurchasedoc["repeated"] . "`n"
	}
	else{
		totaldescription .= "Level: " . shoppurchasedoc["purchased"] . "`n"
	}
	for UpgradeDescrA, UpgradeDescrB in shoppurchasedoc{
		if(UpgradeDescrA == "clickpower"){
			totaldescription .= "+" . UpgradeDescrB . " power gained for every click. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "clickpowerpercent"){
			totaldescription .= "+" . UpgradeDescrB . "% power gained for every click (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "movepower"){
			totaldescription .= "+" . UpgradeDescrB . " power gained for moving the mouse. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "movepowerpercent"){
			totaldescription .= "+" . UpgradeDescrB . "% power gained for moving the mouse. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "movespeedtopower"){
			totaldescription .= "+" . UpgradeDescrB . " power gained every time the mouse moves. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "movespeed"){
			totaldescription .= "+" . UpgradeDescrB . " to mouse movement efficiency. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "harvestpower"){
			totaldescription .= "+" . UpgradeDescrB . " power gained from harvested plants. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "harvestpowerpercent"){
			totaldescription .= "+" . UpgradeDescrB . "% power gained from harvested plants. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "plantchance"){
			totaldescription .= "+" . UpgradeDescrB . "% plant appearance rate. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "treasurepower"){
			totaldescription .= "+" . UpgradeDescrB . " power gained from hidden treasures. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "keyboardkeypower"){
			totaldescription .= "+" . UpgradeDescrB . " power gained from keyboard keys. (" . UpgradeDescrB * shoppurchasedoc["purchased"] . ") total`n"
		}
		if(UpgradeDescrA == "knowledgepower"){
			totaldescription .= "each point of knowledge grants + " . UpgradeDescrB . "% power generation from all sources`n"
		}
	}
	totaldescription .= shoppurchasedoc["descr"]
	addtooltip(totaldescription, 150, "shopdescription")
	updatemain()
}

updategardeneffects(){
	global
	
	farmclickpower := 0
	farmclickpowerpercent := 0
	farmmovepower := 0
	farmmovepowerpercent := 0
	farmharvestpower := 0
	farmharvestpowerpercent := 0
	farmmovespeed := 0
	farmmovespeedpercent := 0
	farmmovespeedtopower := 0
	farmmovespeedtopowerpercent := 0
	farmtreasurepower := 0
	farmtreasurepowerpercent := 0
	farmkeyboardkeypower := 0
	farmkeyboardkeypowerpercent := 0
	farmknowledge := 0
	farmknowledgepercent := 0
	;all plant effects are here. They need to be set to 0 here otherwise things that use them return empty string instead of an actual number.
	
	loop, % gardentiles{
		GX := mod(A_index, 10)
		GY := ceil(A_index / 10)
		if(GX == 0){
			GX = 10
		}
		;remove the temporary effects on tiles. FIRST. Otherwise effects from plants to the top or left get wiped.
		tile%GX%A%GY%["temp"] := {}
	}
	loop, % gardentiles{
		GX := mod(A_index, 10)
		GY := ceil(A_index / 10)
		if(GX == 0){
			GX = 10
		}
		if(tile%GX%A%GY%["plant"]["auras"]){
			loop, % tile%GX%A%GY%["nextto"].MaxIndex(){
				nexttoentry := tile%GX%A%GY%["nextto"][A_index]
				tile%nexttoentry%["temp"] := fusearrays([tile%nexttoentry%["temp"], tile%GX%A%GY%["plant"]["auras"]])
				;the temp stat of a plant gets combined with the auras of all nearby plants
			}
		}
	}
	;This part was rather complicated so I put all plant effects here so I can easily take a look at them
	;tree := {harvest:{harvestpower:25}, global:{clickpower:1}}
	;barkwood := {harvest:{harvestpower:50}, passive:{harvestpowerpercent:400}}
	;titantree := {harvest:{harvestpower:300}, global:{harvestpowerpercent:10}}
	;flower := {global:{clickpowerpercent:1}}
	;yellowberry := {name: "Y berry"}
	;bluestalk := {harvest:{harvestpower:350}, global:{clickpower:3}}
	;appletree := {harvest:{harvestpower:170}, global:{clickpowerpercent:4}}
	;yellowbulb := {name: "Y bulb", harvest:{tpower:250}}
	;yellowstalk := {harvest:{harvestpower:100}, global:{clickpower:2, movepower: 1, clickpowerpercent:1}}
	;dimbloom := {harvest:{harvestpower:200}, global:{clickpowerpercent:9}}
	;greenstalk := {harvest:{harvestpower:450}, global:{clickpower:5, movepower:1, clickpowerpercent:1}}
	;sapleaf := {auras:{global:{clickpower:1}, harvest:{harvestpower:1, harvestpowerpercent:5}}, tileauras:{harvest:{harvestpowerpercent:5}}}
	;grimpetal := {global:{clickpower:1}, auras:{passive:{clickpowerpercent:5}}}
	;gripvine := {global:{movepower:5, movespeed:1}}
	;GX := 2
	;GY := 2
	;farmvalue := fusearrays([tile%GX%A%GY%["plant"], tile%GX%A%GY%["temp"]])
	;msgbox % arraytostring(farmvalue)
	loop, % gardentiles{
		GX := mod(A_index, 10)
		GY := ceil(A_index / 10)
		if(GX == 0){
			GX = 10
		}
		if(tile%GX%A%GY%["plant"]["name"]){
			;this part gathers all the stats of all plants and puts them into one appropriate value for each different stat for other features to use.
			farmvalue := fusearrays([tile%GX%A%GY%["plant"], tile%GX%A%GY%["permanent"], tile%GX%A%GY%["temp"]])
			;msgbox % arraytostring(farmvalue) ;shows the entire array of what the tile with its plant, temp and permanent effects look like
			for gardeneffectentry, gardeneffectcontent in farmvalue["global"]{
				;gardenglobalbonus contains the global bonus
				gardenglobalbonus := gardeneffectcontent
				Stringright, farmvalue3, gardeneffectentry, 7
				if(farmvalue3 <> "percent"){
					gardenpassivebonus := farmvalue["passive"][gardeneffectentry]
					;gardenpassive bonus contains an added passive bonus for the global bonus
				}
				gardenpassivepercentbonus := farmvalue["passive"][gardeneffectentry . "percent"]
				;gardenpassivepercent bonus contains an added passive % bonus for the global bonus
				if gardenpassivebonus is not number
				{
					gardenpassivebonus := 0
				}
				if gardenpassivepercentbonus is not number
				{
					gardenpassivepercentbonus := 0
				}
				if(!farmvalue[gardeneffectentry]){
					farmvalue[gardeneffectentry] := 0
				}
				farm%gardeneffectentry% += (gardenglobalbonus + gardenpassivebonus) * ((gardenpassivepercentbonus / 100) + 1)
			}
		}
	}
}

purchasetile_onclick(purchasedoc){
	global
	;handles purchasing garden/freezer tiles. Its very similar to buying upgrades. The price is 300 power for every garden tile + 8% for every garden tile. The price for freezer tiles is 400 per freezer tile + 8% per freezer tile
	purchasedoc := purchasedoc.topurchase
	if(purchasedoc == "gardentile"){
		if(power >= tileprice("garden") && 100 > gardentiles){
			changepower(tileprice("garden"), "subtract")
			addlog("bought garden tile " . gardentiles . ". Power -" . tileprice("garden"), "garden")
			gardentiles += 1
			updatemain()
		}
	}
	else if(purchasedoc == "freezertile"){
		if(power >= tileprice("freezer") && 100 > freezertiles){
			changepower(tileprice("freezer"), "subtract")
			addlog("bought freezer tile " . freezertiles . ". Power -" . tileprice("freezer"), "garden")
			freezertiles += 1
			updatemain()
		}
	}
}

garden_onclick(gardendoc){
	global
	updategardeneffects()
	contents := gardendoc.id
	contents := % %contents%
	loginfo := ""
	;when any tile on the garden/freezer is clicked. This activates. The biggest part here is assembling the description for the tiles based on what's on there at the moment
	farmvalue := fusearrays([contents["plant"], contents["permanent"], contents["temp"]])
	;when trying to harvest a plant. This part activates
	if (gardenmode == "harvest" && featuredoc.getElementById(gardendoc.id).getAttribute("disable") <> "disabled" && !contents["plant"]["protected"]){
		if(farmvalue["name"] == ""){
			;addtooltip("there is no plant here to harvest")
		}
		else{
			contents["plant"] := ""
			addlog("Harvested a " . farmvalue["name"], "garden")
			descr := "harvested " . farmvalue["name"]
			loginfo .= "harvested " . farmvalue["name"]
			gardentreasurelog := ""
			for farmentry, farmcontent in allplants{
				if(farmcontent["name"] == farmvalue["name"]){
					;show new harvested plants in the almanac
					plantknowledge[farmentry]["seen"] := 1
				}
			}
			farmvalue2 := {}
			farmvalue2["harvest"] := fusearrays([farmvalue["harvest"], farmvalue["passive"], farmvalue["global"]])
			for gardenentry, gardencontent in farmvalue2["harvest"]{
				if(gardenentry == "harvestpower"){
					gardenvalue := calculateharvestvalue(farmvalue2)
					;plant example
					;barkwood := {rarity: 25, descr: "A small but dense tree. Its bark makes for a great power source but sadly this plant has barely any of it", name:"barkwood", harvest:{power:5}, passive:{harvestpowerpercent:400}}
					descr .= "`ngained " . gardenvalue . " power"
					addlog("Harvested a " . farmvalue["name"] . ". Gained " . gardenvalue . " Power.", "power")
					changepower(gardenvalue)
					if(!stats["powerharvested"]){
						stats["powerharvested"] := 0
					}
					stats["powerharvested"] += gardenvalue
				}
				if(gardenentry == "chest"){
					gardentreasurelog .= "Harvested a " . farmvalue["name"] . ". Gained " . gardencontent . " chest"
					descr .= "`ngained " . gardencontent . " chest"
					if(gardenvalue <> 1){
						gardentreasurelog .= "s"
						descr .= "s"
					}
					gardentreasurelog .= "`n"
					treasurechests += gardencontent
					if(!stats["treasurechestsfound"]){
						stats["treasurechestsfound"] := 0
					}
					stats["treasurechestsfound"] += gardencontent
				}
				if(gardenentry == "key"){
					gardentreasurelog .= "Harvested a " . farmvalue["name"] . ". Gained " . gardencontent . " key"
					descr .= "`ngained " . gardencontent . " key"
					if(gardenvalue <> 1){
						gardentreasurelog .= "s"
						descr .= "s"
					}
					gardentreasurelog .= "`n"
					goldenkeys += gardencontent
					if(!stats["goldenkeysfound"]){
						stats["goldenkeysfound"] := 0
					}
					stats["goldenkeysfound"] += gardencontent
				}
				if(gardenentry == "knowledge"){
					gardenvalue := calculateknowledge(farmvalue2)
					if(!almanacunlocked){
						almanacunlocked := 1
						addtooltip("You could harness this knowledge into something useful. You unlocked the almanac", 100)
					}
					plantknowledge["knowledge"] += gardenvalue
					descr .= "`ngained " . gardenvalue . " knowledge"
				}
			}
			if(farmvalue["fusion"]){
				;this entire part handles plant fusion. Its rather complex
				fusiontargets := []
				loop, % contents["nextto"].Maxindex(){
					farmvalue2 := contents["nextto"][A_index]
					if (tile%farmvalue2%["plant"] && (!tile%farmvalue2%["plant"]["weakness"] || farmvalue["fusion"]["strength"] > tile%farmvalue2%["plant"]["weakness"] || limitlessfusions == "true") && (!tile%farmvalue2%["plant"]["fusion"])){
						fusiontargets.push(tile%farmvalue2%["plant"])
						;gather all plants around the harvested tile that have less weakness than the harvested plant has strength
					}
				}
				while(fusiontargets.MaxIndex() > farmvalue["fusion"]["amount"]){
					random, farmrngesus, 1, fusiontargets.MaxIndex()
					fusiontargets.remove(farmrngesus)
				}
				;then it removes random ones until it has equal or less than the max amount of plants it can fuse. The rest is handled in the createamalgamplant() function which combines the stats of the selected plants
				amalgamplant := createamalgamplant(fusiontargets, farmvalue["fusion"])
				if(amalgamplant){
					loginfo := "Harvesting the " . farmvalue["name"] . " made it target " . fusiontargets.Maxindex() . " plant"
					descr .= "`n fused " . fusiontargets.Maxindex() . " plant"
					if(fusiontargets.MaxIndex() <> 1){
						loginfo .= "s"
						descr .= "s"
					}
					descr .= " together into one plant"
					loginfo .= " and added their stats together forming an " . amalgamplant["name"] . " on tile " . contents["location"][1] . " - " . contents["location"][2]
					addlog(loginfo, "garden")
				}
			}
			if(amalgamplant){
				contents["plant"] := amalgamplant
				amalgamplant := ""
				if(!stats["gardenplantscreated"]){
					stats["gardenplantscreated"] := 0
				}
				stats["gardenplantscreated"] += 1
			}
			if(gardentreasurelog){
				addlog(gardentreasurelog)
			}
			if(!stats["plantsharvested"]){
				stats["plantsharvested"] := 0
			}
			stats["plantsharvested"] += 1
			addtooltip(descr, 100, "gardendescription")
			updategardeneffects()
		}
	}
	if(gardenmode == "swap"){
		if(!plantselect){
			plantselect := objfullyclone(contents)
			;I don't really understand how these clones work but it prevents changing arrays in weird ways. The normal clone() function is imperfect so objfullyclone() handles that
		}
		else if(plantselect == contents){
			plantselect := ""
		}
		else{
			;change the location of both selected plants.
			swapprepvalue2 := plantselect["location"][1]
			swapprepvalue3 := plantselect["location"][2]
			swapprepvalue4 := contents["location"][1]
			swapprepvalue5 := contents["location"][2]
			;plantselect == first clicked tile. contents == second clicked tile
			if(plantselect["location"][3] == "freezer"){
				freezertile%swapprepvalue2%A%swapprepvalue3%["plant"] := contents["plant"]
			}
			else{
				tile%swapprepvalue2%A%swapprepvalue3%["plant"] := contents["plant"]
			}
			if(contents["location"][3] == "freezer"){
				freezertile%swapprepvalue4%A%swapprepvalue5%["plant"] := plantselect["plant"]
			}
			else{
				tile%swapprepvalue4%A%swapprepvalue5%["plant"] := plantselect["plant"]
			}
			plantselect := ""
		}
		if(plantselect){
			addtooltip("selected " . plantselect["plant"]["name"] . " in the " . selectedfeature . " on tile " . plantselect["location"][1] . "-" . plantselect["location"][2], 150, "gardendescription")
		}
		updategardeneffects()
		updatemain()
	}
	if(gardenmode == "protect"){
		;protect is really simple. It just switches a value on the plant.
		if(!contents["plant"]["protected"]){
			contents["plant"]["protected"] := 1
		}
		else{
			contents["plant"]["protected"] := 0
		}
	}
	if(gardenmode == "inspect"){
		;re-assign farmvalue because the clicked plant may have been swapped or harvested
		farmvalue := fusearrays([contents["plant"], contents["permanent"], contents["temp"]])
		addtooltip(getplantdescription(farmvalue, "`n", contents, gardendoc), 150, "gardendescription")
	}
	updatemain()
}

getplantdescription(plant, break, tile:="", doc:=""){
	global
	;ahk tooltip's use `n to create a new line why html uses </br>
	descr := ""
	if(tile){
		descr .= tile["location"][3] . " tile " . tile["location"][1] . "-" . tile["location"][2]
	}
	if(plant["name"]){
		descr .= " (" . plant["name"] . ")"
		if(featuredoc.getElementById(doc.id).getAttribute("disable") && doc.disable == "disabled"){
			descr .= break . "The plant here is currently inactive because its garden tile disappeared." . break . "It can't be moved or harvested and has no effects."
		}
	}
	descr .= break
	farmvalue := fusearrays([tile["temp"], tile["permanent"]])
	for farmentry, farmcontent in farmvalue{
		if(farmentry == "global" && farmcontent["clickpower"]){
			descr .= "plants here gain +" . round(farmcontent["clickpower"]) . " power per click" . break
		}
		if(farmentry == "passive" && farmcontent["clickpowerpercent"]){
			descr .= "increases the click power by " . round(farmcontent["clickpowerpercent"], 3) . "% on plants here" . break
		}
		if(farmentry == "global" && farmcontent["movepower"]){
			descr .= "plants here gain +" . round(farmcontent["movepower"]) . " move power" . break
		}
		if(farmentry == "passive" && farmcontent["movepowerpercent"]){
			descr .= "increases the move power by " . round(farmcontent["movepowerpercent"], 3) . "% to plants here" . break
		}
		if(farmentry == "passive" && farmcontent["harvestpower"]){
			descr .= "plants here gain +" . round(farmcontent["harvestpower"]) . " power when harvested" . break
		}
		if(farmentry == "passive" && farmcontent["harvestpowerpercent"]){
			descr .= "increases resources harvested by " . round(farmcontent["harvestpowerpercent"], 3) . "% to plants here" . break
		}
		if(farmentry == "global" && farmcontent["harvestpowerpercent"]){
			descr .= "plants here grant +" . round(farmcontent["harvestpowerpercent"], 3) . "% resources harvested from all plants" . break
		}
		if(farmentry == "global" && farmcontent["treasurepower"]){
			descr .= "plants here gain +" . round(farmcontent["treasurepower"], 3) . " power when finding treasures" . break
		}
		if(farmentry == "passive" && farmcontent["treasurepowerpercent"]){
			descr .= "Increases the treasure power gained by " . round(farmcontent["treasurepowerpercent"], 3) . "% to plants here" . break
		}
		if(farmentry == "global" && farmcontent["keyboardkeypower"]){
			descr .= "plants here gain +" . round(farmcontent["keyboardkeypower"], 3) . " power when pressing keyboard keys" . break
		}
		if(farmentry == "passive" && farmcontent["keyboardkeypowerpercent"]){
			descr .= "Increases the keyboard key power gained by " . round(farmcontent["keyboardkeypowerpercent"], 3) . "% to plants here" . break
		}
		if(farmentry == "passive" && farmcontent["knowledge"]){
			descr .= "plants here grant +" . farmcontent["knowledge"] . " knowledge points when harvested" . break
		}
		if(farmentry == "passive" && farmcontent["knowledgepercent"]){
			descr .= "Increases knowledge points gained by " . round(farmcontent["knowledgepercent"], 3) . "% to plants here" . break
		}
		if(farmentry == "global" && farmcontent["knowledgepercent"]){
			descr .= "plants here grant +" . round(farmcontent["knowledgepercent"], 3) . "% knowledge points harvested to all plants" . break
		}
		if(farmentry == "passive" && farmcontent["toxic"]){
			descr .= "Something is preventing basic plants from spawning here" . break
		}
	}
	if(plant["rarity"]){
		descr .= break . "Plant rarity: " . plant["rarity"] . " (lower numbers mean a rarer plant)" . break
	}
	if((plant["global"] || plant["auras"] || plant["tileauras"]) && plant["name"]){
		descr .= break . "Passive bonusses:" . break
		if(gardenselection == "freezer"){
			descr .= "These do currently not apply because the plant is frozen" . break
		}
		;msgbox %  arraytostring(farmvalue["global"])
		for farmentry, farmcontent in plant["global"]{
			farmglobalbonus := farmcontent
			Stringright, farmvalue, farmentry, 7
			if(farmvalue <> "percent"){
				farmpassivebonus := plant["passive"][farmentry]
				;gardenpassive bonus contains an added passive bonus for the global bonus
			}
			farmpassivepercentbonus := plant["passive"][farmentry . "percent"]
			if farmpassivebonus is not number
			{
				farmpassivebonus := 0
			}
			if farmpassivepercentbonus is not number
			{
				farmpassivepercentbonus := 0
			}
			;msgbox % farmpassivepercentbonus . ", " . farmpassivebonus . ", " farmglobalbonus . ", " . round((farmglobalbonus + farmpassivebonus) * ((farmpassivepercentbonus / 100) + 1))
			if(farmentry == "clickpower"){
				descr .= "Increases power gain from clicking by " . round((farmglobalbonus + farmpassivebonus) * ((farmpassivepercentbonus / 100) + 1)) break
			}
			if(farmentry == "clickpowerpercent"){
				descr .= "Increases power gain from clicking by " . round(farmcontent, 3) . "%" . break
			}
			if(farmentry == "movepower"){
				descr .= "Increases power gain from moving the mouse by " . round((farmglobalbonus + farmpassivebonus) * ((farmpassivepercentbonus / 100) + 1)) break
			}
			if(farmentry == "movepowerpercent"){
				descr .= "Increases power gain from moving the mouse by " . round(farmcontent, 3) . "%" . break
			}
			if(farmentry == "movespeed"){
				descr .= "Increases mouse movement efficiency by " . round((farmglobalbonus + farmpassivebonus) * ((farmpassivepercentbonus / 100) + 1)) break
			}
			if(farmentry == "harvestpower"){
				descr .= "Increases power gain from all harvested plants by " . round((farmglobalbonus + farmpassivebonus) * ((farmpassivepercentbonus / 100) + 1)) break
			}
			if(farmentry == "harvestpowerpercent"){
				descr .= "Increases power gain from all harvested plants by " . round(farmcontent, 3) . "%" . break
			}
			if(farmentry == "treasurepower"){
				descr .= "Increases power gain from treasures by " . round((farmglobalbonus + farmpassivebonus) * ((farmpassivepercentbonus / 100) + 1)) break
			}
			if(farmentry == "treasurepowerpercent"){
				descr .= "Increases power gain from treasures by " . round(farmcontent, 3) . "%" . break
			}
			if(farmentry == "keyboardkeypower"){
				descr .= "Increases power gain from keyboard keys by " . round((farmglobalbonus + farmpassivebonus) * ((farmpassivepercentbonus / 100) + 1)) . "%" . break
			}
			if(farmentry == "keyboardkeypowerpercent"){
				descr .= "Increases power gain from keyboard keys by " . round(farmcontent, 3) . "%" . break
			}
		}
		;msgbox %  arraytostring(farmvalue["auras"])
		for farmentry, farmcontent in plant["auras"]{
			if(farmentry == "global" && farmcontent["clickpower"]){
				descr .= "boosts the power per click of plants around this by " . farmcontent["clickpower"] break
			}
			if(farmentry == "passive" && farmcontent["clickpowerpercent"]){
				descr .= "boosts the power per click % bonus of plants around this by " . farmcontent["clickpowerpercent"] . "%" . break
			}
			if(farmentry == "global" && farmcontent["movepower"]){
				descr .= "boosts the power gained from moving the mouse of plants around this by " . farmcontent["movepower"] break
			}
			if(farmentry == "passive" && farmcontent["movepowerpercent"]){
				descr .= "boosts the power % gained from moving the mouse of plants around this by " . farmcontent["movepowerpercent"] . "%" . break
			}
			if(farmentry == "passive" && farmcontent["harvestpower"]){
				descr .= "boosts the power gained from harvesting plants around this by " . farmcontent["harvestpower"] break
			}
			if(farmentry == "passive" && farmcontent["harvestpowerpercent"]){
				descr .= "boosts the power gained from harvesting plants around this by " . farmcontent["harvestpowerpercent"] . "%" . break
			}
			if(farmentry == "global" && farmcontent["treasurepower"]){
				descr .= "boosts the power gained from hidden treasures of plants around this by " . farmcontent["treasurepower"] break
			}
			if(farmentry == "passive" && farmcontent["treasurepowerpercent"]){
				descr .= "boosts the power gained from hidden treasures of plants around this by " . farmcontent["treasurepowerpercent"] . "%" . break
			}
			if(farmentry == "global" && farmcontent["keyboardkeypower"]){
				descr .= "boosts the power gained from keyboard keys of plants around this by " . farmcontent["keyboardkeypower"] . "%" . break
			}
			if(farmentry == "passive" && farmcontent["keyboardkeypowerpercent"]){
				descr .= "boosts the power gained from keyboard keys of plants around this by " . farmcontent["keyboardkeypowerpercent"] . "%" . break
			}
			if(farmentry == "passive" && farmcontent["knowledge"]){
				descr .= "boosts the knowledge gained from plants around this by " . farmcontent["knowledge"] break
			}
			if(farmentry == "passive" && farmcontent["knowledgepercent"]){
				descr .= "boosts the knowledge gained from plants around this by " . farmcontent["knowledgepercent"] . "%" . break
			}
			if(farmentry == "passive" && farmcontent["toxic"]){
				descr .= "prevents basic plants from appearing around this" . break
			}
		}
		;msgbox % arraytostring(farmvalue["tileauras"])
		for farmentry, farmcontent in plant["tileauras"]{
			;rootwraith := {auras:{passive:{harvestpower:15, harvestpowerpercent:7}}, tileauras:{passive:{harvestpower:10}, global:{harvestpowerpercent:1}}}
			if(farmentry == "global" && farmcontent["clickpower"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to click power. up to a max of " . farmcontent["clickpower"] break
			}
			if(farmentry == "passive" && farmcontent["clickpowerpercent"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to click power. up to a max of " . farmcontent["clickpowerpercent"] . "%" . break
			}
			if(farmentry == "global" && farmcontent["movepower"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to move power. up to a max of " . farmcontent["movepower"] break
			}
			if(farmentry == "passive" && farmcontent["movepowerpercent"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to move power. up to a max of " . farmcontent["movepowerpercent"] . "%" . break
			}
			if(farmentry == "passive" && farmcontent["harvestpower"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to harvest power. up to a max of " . farmcontent["harvestpower"] break
			}
			if(farmentry == "passive" && farmcontent["harvestpowerpercent"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to harvest power. up to a max of " . farmcontent["harvestpowerpercent"] . "%" . break
			}
			if(farmentry == "global" && farmcontent["harvestpowerpercent"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to harvest power to all plants. up to a max of " . farmcontent["harvestpowerpercent"] . "%" . break
			}
			if(farmentry == "global" && farmcontent["treasurepower"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to treasure power. up to a max of " . farmcontent["treasurepower"] break
			}
			if(farmentry == "passive" && farmcontent["treasurepowerpercent"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to treasure power. up to a max of " . farmcontent["treasurepowerpercent"] . "%" . break
			}
			if(farmentry == "global" && farmcontent["keyboardkeypower"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to keyboard key power. up to a max of " . farmcontent["keyboardkeypower"] break
			}
			if(farmentry == "passive" && farmcontent["keyboardkeypowerpercent"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to keyboard key power. up to a max of " . farmcontent["keyboardkeypowerpercent"] break
			}
			if(farmentry == "global" && farmcontent["knowledgepercent"]){
				descr .= "slowly affects nearby tiles with a permanent bonus to knowledge points gained from all plants up to a max of " . farmcontent["knowledgepercent"] . "%" . break
			}
		}
		if(plant["weakness"]){
			descr .= break . "Fusion weakness: " . plant["weakness"] . " (weakened plants can only be fused using plants with more strength than this has weakness)" . break
		}
	}
	plant2 := {}
	plant2["harvest"] := fusearrays([plant["harvest"], plant["passive"], plant["global"]])
	for farmentry, farmcontent in plant2["harvest"]{
		stringleft, farmvalue, farmentry, 7
		if(farmvalue == "harvest"){
			descr .= break . "Harvest rewards:" . break
			if(gardenselection == "freezer"){
				descr .= "move this plant to the garden to be able to harvest it" . break
			}
			break
		}
	}
	for farmentry, farmcontent in plant2["harvest"]{
		farmglobalbonus := farmcontent
		farmpassivepercentbonus := plant[farmentry . "percent"]
		if farmpassivepercentbonus is not number
		{
			farmpassivepercentbonus := 0
		}
		if(farmentry == "harvestpower"){
			descr .= "Power: " . calculateharvestvalue(plant2)
			if(plant["harvest"]["harvestpower"]){
				descr .= " (" . plant["harvest"]["harvestpower"] . ") default"
			}
			else{
				descr .= " (0) default"
			}
			descr .= break
		}
		if(farmentry == "harvestseeds"){
			descr .= "plants up" . floor(farmglobalbonus) . " plants around this."
		}
		if(farmentry == "chest"){
			descr .= farmglobalbonus . " chest"
			if(farmglobalbonus <> 1){
				descr .= "s"
			}
			descr .= break
		}
		if(farmentry == "key"){
			descr .= farmglobalbonus . " key"
			if(farmglobalbonus <> 1){
				descr .= "s"
			}
			descr .= break
		}
		if(farmentry == "knowledge"){
			descr .= "plant knowledge: " . calculateknowledge(plant2)
			if(plant["harvest"]["knowledge"]){
				descr .= " (" . plant["harvest"]["knowledge"] . ") default"
			}
			else{
				descr .= " (0) default"
			}
			descr .= break
		}
	}
	if(plant["fusion"]){
		descr .= break . "Fusion strength: " . plant["fusion"]["strength"] . " (Higher strength levels are required to fuse already fused plants together)" . break
		descr .= "This plant copies the stats of up to " . plant["fusion"]["amount"] . " nearby plants when harvested and forms it together." . break . "Creating a single plant with the stats of all selected plants combined." . break
	}
	if(plant["descr"]){
		descr .= break "Description: " . plant["descr"]
	}
	return descr
}

creategardenplant(fixedchance:=5, fixedposX:="", fixedposY:="", fixedplant:="", aggressive:=""){
	global
	;fixedchance. If this value is given, the chance of a plant appearing for tiles checked will be a percentage equal to the given value. Say putting it on 50 gives a 50% for putting a plant on every tile
	;fixedposX, if this value is given, plants  can only appear on the X location of the given value
	;fixedposY is pretty self explanatory now
	;aggressive, if this value is given. Plants will override other plants.
	;fixedplant should be filled with the array of a plant, examples are shown here below. This changes all plants changed to be this specific plant instead.
	if(s0 >= garden["purchased"]){
		;no plants when there is no garden
		return
	}
	loop, %gardentiles%{
		SX := mod(A_index, gardenmaxX)
		SY := ceil(A_index / gardenmaxY)
		if(SX == 0){
			SX = 10
		}
		if(fixedposX && SX <> fixedposX){
			continue
			;continue just ends the current loop and starts a new one
		}
		if(fixedposY && SY <> fixedposY){
			continue
		}
		if(tile%SX%A%SY%["plant"]["name"] == "" || aggressive){
			random, rngesus, 1, 100
			if(fixedchance >= rngesus || maxgardenplantchance == "true"){
				;plant combo example
				;plantcombos := [{pardners:["tree", "flower"], result:"appletree", rarity:100}]
				random, trycombo, 1, 2
				;if trycombo is 2 it tries to create a combo plant which checks nearby tiles to see if it can create something
				loop{
					result := ""
					if(trycombo == 2){
						plantcombototal := {}
						;first it loops through every available combo
						loop, % plantcombos.MaxIndex(){
							plantloop := A_index
							plantsneeded := {}
							;an array is created containing a number according to the plant needed.
							loop, % plantcombos[plantloop]["Pardners"].MaxIndex(){
								whatneeded := plantcombos[plantloop]["Pardners"][A_index]
								whatneeded := %whatneeded%["name"]
								if(!plantsneeded[whatneeded]){
									plantsneeded[whatneeded] := 0
								}
								plantsneeded[whatneeded] += 1
							}
							;it checks all the tiles next to the selected tile and if it finds a plant that the combo needs. It subtracts 1 from the array.
							for, creategardenplantentry, creategardenplantcontent in tile%SX%A%SY%["nextto"]{
								if(plantsneeded[tile%creategardenplantcontent%["plant"]["name"]] > 0){
									plantsneeded[tile%creategardenplantcontent%["plant"]["name"]] -= 1
								}
							}
							;so simple! it checks the entire array and gets the largest number. If its 0 then the combo is successful. Else it removes the combo from the current list and tries again.
							if(0 >= objectminmax(plantsneeded, "max")){
								random, rngesus3, 1, 1000
								if(plantcombos[plantloop]["rarity"] * 10 >= rngesus3 || ignoreplantrarity == "true"){
									plantcombototal.push(plantcombos[plantloop]["result"])
								}
							}
						}
						loop{
							;loop through all successful combos and choose one.
							if(plantcombototal.MaxIndex() > 0){
								random, rngesus3, 1, 1000
								random, whichcombo, 1, plantcombototal.MaxIndex()
								creategardenplantvalue := plantcombototal[whichcombo]
								;check the rarity. If the check fails. Remove this combo too and try the next one.
								if(%creategardenplantvalue%["rarity"] * 10 >= rngesus3 || ignoreplantrarity == "true"){
									;if it succeeds. Put the plant in result which will be added to the garden
									result := %creategardenplantvalue%
									break
								}
								else{
									plantcombototal.remove(whichcombo)
								}
							}
							else{
								break
							}
						}
						if(plantcombototal.MaxIndex() >= 1){
							break
						}
						else{
							;no combinations are possible. Create a normal non-combo plant instead
							trycombo = 1
						}
					}
					else{
						random, rngesus2, 1, plants.MaxIndex()
						random, rngesus3, 1, 1000
						selectedplant := plants[rngesus2]
						;take a random plant from the list, check its rarity and if the check succeeds.
						if((selectedplant["rarity"] * 10) >= rngesus3 || ignoreplantrarity == "true"){
							;if it succeeds. Put the plant in result which will be added to the garden
							if(!tile%SX%A%SY%["temp"]["passive"]["toxic"]){
								;non-combo plants can not be created next to a toxic plant. No more useless clearing of dust trees and tick flowers while searching for those rare plants
								result := selectedplant
							}
							break
						}
					}
				}
				random, gardentimerrngesus, 1, 1000
				if(fixedplant){
					result := fixedplant
				}
				if(result){
					if(result["name"] == "lockbloom" && keyavailable){
						result["symbol"] := keyavailable
					}
					tile%SX%A%SY%["plant"] := ObjFullyClone(result)
					if(silentplants == "false" || silentplants >= gardentimerrngesus){
					;silentplants is a dev function which causes plants to not fill the logs as much as they normally do. 
						addlog(result["name"] . " appeared on tile " . SX . " - " . SY, "garden")
					}
					;I had a lot of trouble with this until I figured out objfullyclone(). If I remove this function. Every plant will think its next to the same spaces
					gardendocedit := gardendoc.getelementbyid("tile" . SX . "A" . SY)
					storedplantname := tile%SX%A%SY%["plant"]["name"]
					if(!stats["gardenplantscreated"]){
						stats["gardenplantscreated"] := 0
					}
					stats["gardenplantscreated"] += 1
					updategardeneffects()
				}
				updatemain()
			}
		}
	}
}

gardentick(){
	global
	;plant example
	;clickvine := {tileauras:{passive:{percent:{clickpower:5}, direct:{clickpower:5}}}}
	;this function activates whenever mouse movement tries to spawn garden plants.
	;this part handles garden ticks which happen after moving the mouse. The activate effects like permanent tile buffing.
	loop, % gardentiles{
		GTX := mod(A_index, 10)
		GTY := ceil(A_index / 10)
		if(GTX == 0){
			GTX = 10
		}
		;rootwraith := {tileauras:{global:{harvestpower:10, harvestpowerpercent:1}}}
		gardentickvalue := fusearrays([tile%GTX%A%GTY%["plant"], tile%GTX%A%GTY%["passive"], tile%GTX%A%GTY%["permanent"]])
		for gardentickentry, gardentickcontent in gardentickvalue["tileauras"]{
			for gardentickentry2, gardentickcontent2 in gardentickvalue["tileauras"][gardentickentry]{
				for, gardentickentry3, gardentickcontent3 in tile%GTX%A%GTY%["nextto"]{
					;this part is painfully complex but kinda required to handle this correctly.
					if(!tile%gardentickcontent3%["permanent"]){
						tile%gardentickcontent3%["permanent"] := {}
					}
					if(!tile%gardentickcontent3%["permanent"][gardentickentry]){
						tile%gardentickcontent3%["permanent"][gardentickentry] := {}
					}
					if(!tile%gardentickcontent3%["permanent"][gardentickentry][gardentickentry2]){
						tile%gardentickcontent3%["permanent"][gardentickentry][gardentickentry2] := 0
					}
					tile%gardentickcontent3%["permanent"][gardentickentry][gardentickentry2] += calculateauraincrease(gardentickcontent2, tile%gardentickcontent3%["permanent"][gardentickentry][gardentickentry2])
				}
			}
		}
		if(gardentickvalue["name"] == "lockbloom" && keyavailable){
			;lockbloom's symbol can randomly change to that of the current hidden key
			random, gardentickrngesus, 1, 100
			if(gardentickrngesus >= 98){
				tile%GTX%A%GTY%["plant"]["symbol"] := keyavailable
			}
		}
	}
	updategardeneffects()
}

calculateauraincrease(plantmax, tilecurrent){
	global maxgardenpermbuffs
	;the rate at which permanent buffs grow is higher based on the value on the plant and slows down after the value on the tile is higher.
	;there is a mimimum growth so the value doesn't stay right under the maximum all the time but it stops increasing at all once it reaches the max.
	if tilecurrent is not number
	{
		tilecurrent := 0
	}
	a := (plantmax / 500) * (1 - min((tilecurrent + 1) / plantmax, 1)) + (plantmax / 1000)
	if(tilecurrent + a >= plantmax || maxgardenpermbuffs == "true"){
		a := max(plantmax - tilecurrent, 0)
	}
	return a
}

tileprice(value:=""){
	global gardentiles, freezertiles
	if(value == "garden"){
		return round((200 * gardentiles) * (1.08 ** gardentiles))
	}
	else if(value == "freezer"){
		return round((225 * freezertiles) * (1.08 ** freezertiles))
	}
}

treasureopen_onclick(treasureopendoc){
	global
	;activates when the open treasure button is clicked. 
	treasureopendoc := treasureopendoc.Mode
	treasuretoopen := treasureopendoc
	if (treasureopendoc == "all"){
		treasuretoopen := Min(treasurekeys, treasurechests)
	}
	treasuresopened := "false"
	;loop once for every treasure chest to open
	loop, % treasuretoopen{
		if(treasurekeys >= 1 && treasurechests >= 1){
			if(treasuresopened == "false"){
				treasuresinfo := []
				;true when at least one chest has been opened. It resets the description of what happened
				treasuresopened := "true"
			}
			treasurekeys -= 1
			treasurechests -= 1
			random, powergained, 5000, 10000
			random, treasureartifacts, 0, 4
			treasureresult := []
			loop{
				random, whichtreasure, 1, treasurestats.Count()
				for, treasureentry, treasurecontent in treasures{
					random, whichtreasurechance, 1, 100
					if(A_index == whichtreasure){
						if(treasurestats[treasureentry]["rarity"] >= whichtreasurechance){
							treasureresult.Push(treasureentry)
							treasureartifacts -= 1
						}
						if(0 >= treasureartifacts){
							break
						}
					}
				}
				if(0 >= treasureartifacts){
					break
				}
				
			}
			if(!treasuresinfo["power"]){
				treasuresinfo["power"] := [0, "power"]
			}
			treasuresinfo["power"][1] += powergained
			changepower(powergained)
			for each, treasureopencontent in treasureresult{
				treasures[treasureopencontent] += 1
				if(!treasuresinfo[treasureopencontent]){
					treasuresinfo[treasureopencontent] := [0, treasurestats[treasureopencontent]["name"]]
				}
				treasuresinfo[treasureopencontent][1] += 1
			}
		}
	}
	if(treasuresopened == "true"){
		;turns the treasuresinfo string into an actual readable description and changes the description to that text.
		if(!stats["chestsopened"]){
			stats["chestsopened"] := 0
		}
		stats["chestsopened"] += treasuretoopen
		treasureinfotext := "Last "
		if(treasuretoopen > 1){
			treasureinfotext .= treasuretoopen . " chests gave"
		}
		else{
			treasureinfotext .= "chest gave"
		}
		for treasureopenentry, treasureopencontent in treasuresinfo{
			treasureinfotext .= "</br>" . treasureopencontent[1] . " " . treasureopencontent[2]
			if(treasureopencontent[1] <> 1 && treasureopenentry <> "power"){
				treasureinfotext .= "s"
			}
		}
	}
	updatemain()
}

ObjFullyClone(obj){
	;no idea how this works but it solves my problems so.. Yay
	nobj := obj.Clone()
	for k,v in nobj
		if IsObject(v)
			nobj[k] := A_ThisFunc.(v)
	return nobj
}

addlog(log, ID:="Default"){
	global logs
	;this function adds an extra log to the pile...... Anyways. This stuff is handled in the updatelogs() function
	if(!logs[ID]){
		logs[ID] := []
	}
	logs[ID].push(log)
}

addtooltip(content:="nothingness", timer:=15, identifier:=""){
	global tooltips
	;timer goes down by 1 around 5 times every second
	loop{
		if(!tooltips[A_index]){
			tooltips[A_index] := {content:content, timer:timer, identifier:identifier}
			break
		}
	}
}

;I found this V function on the internet. Its a better way to put the tooltip next to the mouse which doesnt flicker.
ToolTipFM(Text="", WhichToolTip=16, xOffset=16, yOffset=16) { ; ToolTip which Follows the Mouse
	static LastText, hwnd, VirtualScreenWidth, VirtualScreenHeight ; http://www.autohotkey.com/forum/post-430240.html#430240
	
	if (VirtualScreenWidth = "" or VirtualScreenHeight = "")
	{
		SysGet, VirtualScreenWidth, 78
		SysGet, VirtualScreenHeight, 79
	}
	
	if (Text = "") ; destroy tooltip
	{
		ToolTip,,,, % WhichToolTip
		LastText := "", hwnd := ""
		return
	}
	else ; move or recreate tooltip
	{
		CoordMode, Mouse, Screen
		MouseGetPos, x,y
		x += xOffset, y += yOffset
		WinGetPos,,,w,h, ahk_id %hwnd%
		
		; if necessary, adjust Tooltip position
		if ((x+w) > VirtualScreenWidth)
			AdjustX := 1
		if ((y+h) > VirtualScreenHeight)
			AdjustY := 1
		
		if (AdjustX and AdjustY)
			x := x - xOffset*2 - w, y := y - yOffset*2 - h
		else if AdjustX
			x := VirtualScreenWidth - w
		else if AdjustY
			y := VirtualScreenHeight - h
		
		if (Text = LastText) ; move tooltip
			DllCall("MoveWindow", A_PtrSize ? "UPTR" : "UInt",hwnd,"Int",x,"Int",y,"Int",w,"Int",h,"Int",0)
		else ; recreate tooltip
		{
			; Perfect solution would be to update tooltip text (TTM_UPDATETIPTEXT), but must be compatible with all versions of AHK_L and AHK Basic.
			; My Ask For Help link: http://www.autohotkey.com/forum/post-421841.html#421841
			CoordMode, ToolTip, Screen
			ToolTip,,,, % WhichToolTip ; destroy old
			ToolTip, % Text, x, y, % WhichToolTip ; show new
			hwnd := WinExist("ahk_class tooltips_class32 ahk_pid " DllCall("GetCurrentProcessId")), LastText := Text
			%A_ThisFunc%(Text, WhichToolTip, xOffset, yOffset) ; move new
		}
		Winset, AlwaysOnTop, on, ahk_id %hwnd%
	}
}

removetooltip(identifier:="", all:="false"){
	;remove tooltips based on their identifier. Very versatile
	global tooltips
	loop{
		if(!tooltips[A_index]){
			break
		}
		else if(tooltips[A_index]["identifier"] == identifier || all <> "false"){
			tooltips[A_index] := ""
		}
	}
}

isnum(number){
	;if (thing) is number is stupid and works really bad with and/or statements so dumped into a function it is.
	if number is number
	{
		return 1
	}
	return 0
}

randompointonscreen(){
	;simple
	random, X, 0, A_screenwidth
	random, Y, 0, A_screenheight
	return, [X, Y]
}

randomletter(){
	;gets a random letter from the alphabet. Used for golden keys
	random, rngesus, 1, 26
	return % Chr(rngesus+96)
}

arraytostring(object){
	;turns arrays and objects into strings.
	;very rough example. I haven't tested many things on it like inputting incorrect arrays.
	firstrun := 1
	firstrun2 := 1
	result := object
	for entry, content in object{
		if(firstrun == 1){
			result := "{"
			firstrun == 0
		}
		result .= entry . ":" . arraytostring(content) . ", "
	}
	for entry, content in object{
		if(firstrun2 == 1){
			StringTrimright, result, result, 2
			result .= "}"
			firstrun2 := 0
		}
	}
	if result is not number
		if(firstrun2 == 1)
		{
			result := """" . result . """"
		}
	return result
}

stringToArray(String){
	;my experiment of turning strings into objects. Also very rough and will also break on array strings being sent instead of objects.
	stringleft, a, string, 1
	stringright, b, string, 1
	if(a == "{"){
		stringtrimleft, string, string, 1
	}
	if(b == "}"){
		stringtrimright, string, string, 1
		string .= ","
	}
	if(a <> "{" && b <> "}"){
		return string
	}
	result := []
	storedvalue := ""
	bracketcount := 0
	plaintext := "false"
	part := 1
	loop, parse, string
	{
		if(A_loopfield == """"){
			if(plaintext == "false"){
				plaintext := "true"
			}
			else{
				plaintext := "false"
			}
		}
		if(plaintext == "false" && bracketcount == 0){
			if(A_loopfield == " "){
				continue
			}
			if(A_loopfield == ":" && part == 1){
				part := 2
				storedpart := storedvalue
				storedvalue := ""
				continue
			}
			if(A_loopfield == "," && part == 2){
				part := 1
				result[storedpart] := stringtoarray(storedvalue)
				storedvalue := ""
				continue
			}
			if(A_loopfield == "{"){
				bracketcount += 1
				storedvalue := ""
			}
		}
		else if(plaintext == "false" && bracketcount > 0){
			if(A_loopfield == "{"){
				bracketcount += 1
			}
			if(A_loopfield == "}"){
				bracketcount -= 1
			}
		}
		if(A_loopfield <> """" || bracketcount > 0){
			dontstore := ""
			storedvalue .= A_loopfield
			if(A_loopfield == "e"){
			}
		}
	}
	if(!IsObject(result) || result.Count() == 0 || result.Count() == ""){
		return, storedvalue
	}
	return, result
}

fusearrays(object){
	result2 := {}
	;another very rought example similar to the arraytostring() and stringtoarray() but this one should work with any kind of array, object or string with no problems.
	;if one object has another object in place another one has an string or number. The object gets priority. Same with numbers over strings. If there's just strings. Only the one of the first plant gets used.
	for entry, content in object{
		if (IsObject(object[A_index]) || object[A_index].Count() > 0 || selected == "object"){
			selected := "object"
		}
		else if (isnum(object[A_index]) || selected == "number"){
			selected := "number"
		}
		else{
			selected := "text"
		}
	}
	for entry, content in object{
		storedvalue := A_index
		if (selected == "text"){
			if(!result){
				result := object[storedvalue]
			}
		}
		else if(selected == "number"){
			if result is not number
			{
				result := 0
			}
			result += object[storedvalue]
		}
		else if(selected == "object"){
			for entry2, content2 in object[storedvalue]{
				if(!result){
					result := {}
				}
				if(!result[entry2]){
					for entry3, content3 in object{
						result2.Push(object[entry3][entry2])
					}
					result[entry2] := fusearrays(result2)
					result2 := {}
				}
			}
		}
	}
	return result
}

createamalgamplant(object, fusiontype:=""){
	;the continuation of an already tricky piece of code. The purpose of this function is to fuse multiple plants objects together which thankfully is way easier with the combine arrays function
	result := []
	object2 := {}
	object2.push(fusiontype["result"])
	loop, % object.maxIndex(){
		object2.push(object[A_index])
	}
	result := fusearrays(object2)
	resultdescription := " The combined power of a "
	for entry, content in object{
		;the rarity of the resulting plant is the lowest of all combined plants
		morethanzeroplants := "true"
		resultdescription .= content["name"] . " and a "
		for, entry2, content2 in object[A_index]["fusion"]{
			;overwrite any fusion stats this plant has with the highest of a single plant. This is to prevent 2 fusion strength 1 plants to combine into one that has 2 strength which would result in potential infinite fusions
			if content2 is number
			{
				if(!result["fusion"][entry2]){
					result["fusion"][entry2] := 0
				}
				result["fusion"][entry2] := Max(result["fusion"][entry2], content2)
			}
			else if(!result["fusion"][entry2]){
				result["fusion"][entry2] := content2
			}
		}
	}
	;some extra values to add to the plant. Name, descr and weakness don't depend on the fused plants but on the plant used to fuse instead.
	;V create the plant and further build the description if the plant used to fuse targetted anything.
	stringtrimright, resultdescription, resultdescription, 7
	result["descr"] .= resultdescription
	result["weakness"] := fusionstats["strength"]
	if(fusiontype){
		result["rarity"] := fusiontype["rarity"]
	}
	else{
		result["rarity"] := min(object["rarity"])
	}
	result["protected"] := 0
	;if(fusionstats["background"]){
		;result["background"] := fusionstats["background"]
	;}
	;else{
		;result.delete("background")
	;}
	;if(fusionstats["textcolor"]){
		;result["textcolor"] := fusionstats["textcolor"]
	;}
	;else{
		;result.delete("textcolor")
	;}
	;if(fusionstats["symbol"]){
		;result["symbol"] := fusionstats["symbol"]
	;}
	;else{
		;result.delete("symbol")
	;}
	stringtrimright, resultdescription, resultdescription, 6
	if(!morethanzeroplants){
		;if no plant was used to fuse. Just return nothing.
		return
	}
	return result
}

HasVal(haystack, needle){
	;check if an array contains a specific word
	if !(IsObject(haystack)) || (haystack.Length() == 0){
		return 0
	}
	for index, value in haystack{
		if (value = needle){
			return index
		}
	}
	return 0
}

objectminmax(object, minmax){
	;get the highest or lowest number in an entire object (doesnt work on objects inside objects)
	switch := 1
	if (!IsObject(object) || object.Count() == 0 ||object.Count() == ""){
		return object
	}
	for, a, b in object{
		if(isnum(b)){
			if(switch){
				switch := ""
				result := b
			}
			if(minmax == "min"){
				result := min(result, b)
			}
			else if(minmax == "max"){
				result := max(result, b)
			}
		}
	}
	return result
}

VersionCompare(version1, version2){
	;I found and copy/pasted this from somewhere. Checks if your ahk version is higher or lower depending on the one that I made this game in.
	;I have had a couple people telling me that they got errors with lower versions meaning they likely didn't see the message I put up. So any help with that is appreciated
	StringSplit, verA, version1, .
	StringSplit, verB, version2, .
	Loop, % (verA0> verB0 ? verA0 : verB0)
	{
		if (verA0 < A_Index)
			verA%A_Index% := "0"
		if (verB0 < A_Index)
			verB%A_Index% := "0"
		if (verA%A_Index% > verB%A_Index%)
			return 1
		if (verB%A_Index% > verA%A_Index%)
			return 2
	}
	return 0
}

fixwindowpos(name){
	;name is case sensitive. Moves windows that are slightly or entirely offscreen. Can be disabled with an checkbox option
	GetKeyState, LButtonState, LButton, P
	if(LButtonState == "U"){
		wingetpos, X, Y, W, H, %name%
		if(X + W > A_screenwidth){
			WinMove,%name%,, A_screenwidth - W, Y
		}
		wingetpos, X, Y, W, H, %name%
		if(Y + H >= A_screenheight){
			WinMove,%name%,, X, A_screenheight - H
		}
		wingetpos, X, Y, W, H, %name%
		if(0 > X){
			WinMove,%name%,, 0, Y
		}
		wingetpos, X, Y, W, H, %name%
		if(0 > Y){
			WinMove,%name%,, X, 0
		}
	}
}

toscientific(input:=0, rounding:=1, donttouchnumberlength:=6){
	;rounding means the amount of numbers the result should have. For example an input of 1000000 and a rounding of 4 should result in 1.000E+6, a rounding of 5 becomes 1.0000E+6
	;I might add different roundings eventually if the demand is high.
	numbers := strlen(input)
	if(donttouchnumberlength >= numbers){
		return input
	}
	StringLeft, result, input, 1
	StringTrimLeft, result2, input, 1
	Stringleft, result2, result2, rounding - 1
	result .= "." . result2 . "E+" . numbers - 1
	return result
}

devbutton_onclick(){
	;this button does whatever I want it to do.
	global
	;addtooltip(plantchance)
	;addtooltip(seeddrops)
	;addtooltip(keyavailable)
	;treasurekeys += 1
	;treasurechests += 1
	;plantknowledge["knowledge"] += 10
	;addtooltip(plantknowledge["knowledge"])
	;power *= 1.5
	;tile2A2["plant"] := {rarity: 100, knowledge:6, descr: "This is a plant that knows a lot about plants. Who knows what info you can extract when you harvest this", name:"knowleaf", symbol:"kl", background:"#55AA88", textcolor:"#FFAAFF", harvest:{harvestpower:100, knowledge:100}}
	creategardenplant(100, 2, 2, lockbloom, "aggressive")
	if(!keyavailable){
		keyavailable := randomletter()
	}
	updatemain()
}

changepower(change:=0, subtract:="", changepercent:=100){
	global
	;the main reason this function exists is to track the stats when power is increased or decreased
	if(!stats["powergained"]){
		stats["powergained"] := 0
	}
	if(!stats["powerspent"]){
		stats["powerspent"] := 0
	}
	if(!subtract){
		stats["powergained"] += change
	}
	else{
		stats["powerspent"] += change
	}
	if(power * (changepercent / 100) > power){
		stats["powergained"] += ((power * (changepercent / 100)) - power)
	}
	if(power > power * (changepercent / 100)){
		stats["powerspent"] += ((power * (changepercent / 100)) + power)
	}
	if(!subtract){
		power += change
	}
	else{
		power -= change
	}
	power *= (changepercent / 100)
}

;These are all the functions that calculate power gain. Most are the same but some got tiny differences.
calculateclickvalue(){
	global
	;base
	clickpower := 0
	;from upgrades
	clickpowerbonus := 0
	;% increase from upgrades
	clickpowermult := 1
	;% increase from treasures
	treasureclickpowermult := 1 + (treasures["amulets"] / 100)
	;from knowledge points
	knowledgeclickpowermult := 1
	
	for a, b in upgrades{
		;loop through all upgrades
		clickpowerbonus += %a%["clickpower"] * %a%["purchased"]
		if(%a%["clickpowerpercent"] && %a%["purchased"]){
			clickpowermult *= (%a%["clickpowerpercent"] * %a%["purchased"] / 100) + 1
		}
		if(%a%["knowledgepower"] && %a%["purchased"]){
			knowledgeclickpowermult *= (%a%["knowledgepower"] * plantknowledge["knowledge"] * %a%["purchased"] / 100) + 1
		}
	}
	clickpower += clickpowerbonus
	clickpower += farmclickpower
	clickpower *= (farmclickpowerpercent / 100) + 1
	clickpower *= clickpowermult
	clickpower *= treasureclickpowermult
	clickpower *= knowledgeclickpowermult
	return round(clickpower)
}

calculateharvestvalue(plantharvest:=""){
	global
	;a plant array or number can be used here to affect power gain. Note that when a plant is input here. It should be combined with the temp and permanent stats to apply those in the harvest
	harvestpower := 0
	plantharvestpowermult := 0
	if plantharvest is number
	{
		harvestpower := plantharvest
	}
	for, a, b in plantharvest["harvest"]{
		if(a == "harvestpower"){
			harvestpower += b
		}
		if(a == "harvestpowerpercent"){
			plantharvestpowermult += b
		}
	}
	harvestpowerbonus := 0
	harvestpowermult := 1
	treasureharvestmult := 1 + (treasures["emeralds"] / 100)
	knowledgeharvestpowermult := 1
	for a, b in upgrades{
		harvestpowerbonus += %a%["harvestpower"] * %a%["purchased"]
		if(%a%["harvestpowerpercent"] && %a%["purchased"]){
			harvestpowermult *= (%a%["harvestpowerpercent"] * %a%["purchased"] / 100) + 1
		}
		if(%a%["knowledgepower"] && %a%["purchased"]){
			knowledgeharvestpowermult *= (%a%["knowledgepower"] * plantknowledge["knowledge"] * %a%["purchased"] / 100) + 1
		}
	}
	harvestpower += harvestpowerbonus
	harvestpower += farmharvestpower
	harvestpower *= (farmharvestpowerpercent / 100) + 1
	harvestpower *= (plantharvestpowermult / 100) + 1
	harvestpower *= harvestpowermult
	harvestpower *= treasureharvestmult
	harvestpower *= knowledgeharvestpowermult
	return round(harvestpower)
}

calculateknowledge(plantharvest:=""){
	global
	knowledge := 0
	plantharvestknowledgemult := 0
	if plantharvest is number
	{
		knowledge := plantharvest
	}
	for, a, b in plantharvest["harvest"]{
		if(a == "knowledge"){
			knowledge += b
		}
		if(a == "knowledgepercent"){
			plantharvestknowledgemult += b
		}
	}
	knowledgebonus := 0
	knowledgemult := 1
	treasureknowledgemult := 1
	for a, b in upgrades{
		knowledgebonus += %a%["knowledge"] * %a%["purchased"]
		if(%a%["knowledgepercent"] && %a%["purchased"]){
			knowledgemult *= (%a%["knowledgepercent"] * %a%["purchased"] / 100) + 1
		}
	}
	knowledge += knowledgebonus
	knowledge += farmknowledge
	knowledge *= (farmknowledgepercent / 100) + 1
	knowledge *= (plantharvestknowledgemult / 100) + 1
	knowledge *= knowledgemult
	knowledge *= treasureknowledgemult
	return round(knowledge)
}

calculatemovevalue(){
	global
	movepower := 0
	movepowerbonus := 0
	movepowermult := 1
	treasuremovepowermult := 1 + (treasures["rings"] / 100)
	knowledgemovepowermult := 1
	for a, b in upgrades{
		movepowerbonus += %a%["movepower"] * %a%["purchased"]
		if(%a%["movepowerpercent"] && %a%["purchased"]){
			movepowermult *= (%a%["movepowerpercent"] * %a%["purchased"] / 100) + 1
		}
		if(%a%["knowledgepower"] && %a%["purchased"]){
			knowledgemovepowermult *= (%a%["knowledgepower"] * plantknowledge["knowledge"] * %a%["purchased"] / 100) + 1
		}
	}
	movepower += movepowerbonus
	movepower += farmmovepower
	movepower *= (farmmovepowerpercent / 100) + 1
	movepower *= treasuremovepowermult
	movepower *= movepowermult
	movepower *= knowledgemovepowermult
	if(mousemastery["purchased"] >= 1){
		movepower += calculateclickvalue()
	}
	return round(movepower)
}

calculatemovespeed(){
	global
	movespeed := 0
	movespeedbonus := 0
	movespeedmult := 1
	treasuremovespeedmult := 1 + (treasures["pearls"] / 100)
	for a, b in upgrades{
		movespeedbonus += %a%["movespeed"] * %a%["purchased"]
		if(%a%["movespeedpercent"] && %a%["purchased"]){
			movespeedmult *= (%a%["movespeedpercent"] * %a%["purchased"] / 100) + 1
		}
	}
	movespeed += movespeedbonus
	movespeed += farmmovespeed
	movespeed *= (farmmovespeedpercent / 100) + 1
	movespeed *= treasuremovespeedmult
	movespeed *= movespeedmult
	return round(movespeed)
}

calculatemovespeedtopowervalue(movespeedtopower:=0){
	global
	;super OP and rightfully unused right now
	movespeedtopowerbonus := 0
	movespeedtopowermult := 1
	treasuremovespeedtopowermult := 1
	knowledgemovespeedtopowermult := 1
	for a, b in upgrades{
		movespeedtopowerbonus += %a%["movespeedtopower"] * %a%["purchased"]
		if(%a%["movespeedtopowerpercent"] && %a%["purchased"]){
			movespeedtopowermult *= (%a%["movespeedtopowerpercent"] * %a%["purchased"] / 100) + 1
		}
		if(%a%["knowledgepower"] && %a%["purchased"]){
			knowledgemovespeedtopowermult *= (%a%["knowledgepower"] * plantknowledge["knowledge"] * %a%["purchased"] / 100) + 1
		}
	}
	movespeedtopower += movespeedtopowerbonus
	movespeedtopower += farmmovespeedtopower
	movespeedtopower *= (farmmovespeedtopowerpercent / 100) + 1
	movespeedtopower *= treasuremovespeedtopowermult
	movespeedtopower *= movespeedtopowermult
	movespeedtopower *= knowledgemovespeedtopowermult
	return round(movespeedtopower)
}

calculatekeyboardkeyvalue(key:=""){
	global
	keyboardkeypower := 0
	keyboardkeypowerbonus := 0
	keyboardkeypowermult := 1
	treasurekeyboardkeymult := 1 + (treasures["grails"] / 100)
	knowledgekeyboardkeymult := 1
	for a, b in upgrades{
		keyboardkeypowerbonus += %a%["keyboardkeypower"] * %a%["purchased"]
		if(%a%["keyboardkeypowerpercent"] && %a%["purchased"]){
			keyboardkeypowermult *= (%a%["keyboardkeypowerpercent"] * %a%["purchased"] / 100) + 1
		}
		if(%a%["knowledgepower"] && %a%["purchased"]){
			knowledgekeyboardkeymult *= (%a%["knowledgepower"] * plantknowledge["knowledge"] * %a%["purchased"] / 100) + 1
		}
	}
	keyboardkeypower += keyboardkeypowerbonus
	keyboardkeypower += farmkeyboardkeypower
	if(gamersfuel["purchased"] >= 1){
		if(key = "~W up" || key = "~A up" || key = "~S up" || key = "~D up" ||){
			;turns out gaming is a good way to earn money (power) afterall
			keyboardkeypower *= 2
		}
	}
	keyboardkeypower *= (farmkeyboardkeypowerpercent / 100) + 1
	keyboardkeypower *= treasurekeyboardkeymult
	keyboardkeypower *= keyboardkeypowermult
	keyboardkeypower *= knowledgekeyboardkeymult
	return round(keyboardkeypower)
}

calculateshopprice(object){
	price := object["price"]
	if(object["priceincrease"]){
		price += (object["priceincrease"] * object["purchased"])
	}
	if(object["priceincreasepercent"]){
		price *= ((1 + (object["priceincreasepercent"] / 100)) ** object["purchased"])
	}
	return price
}

getchests(){
	chestchance := 30
	random, chestodds, 1, 100
	if(chestchance >= chestodds){
		return 1
	}
	else{
		return 0
	}
}

getkeys(){
	keychance := 30
	random, keyodds, 1, 100
	if(keychance >= keyodds){
		return 1
	}
	else{
		return 0
	}
}

savegame_onclick(){
	global
	critical, on
	if(lastsave){
		gui, backgroundpower:default
		gui, hide
	}
	autosavewait := A_tickcount + autosavewaitvalue
	iniwrite, % power, %savename%, values, power
	iniwrite, % gardentiles, %savename%, values, gardentiles
	iniwrite, % freezertiles, %savename%, values, freezertiles
	iniwrite, % treasurekeys, %savename%, values, treasurekeys
	iniwrite, % treasurechests, %savename%, values, treasurechests
	iniwrite, % treasureradarbought, %savename%, values, treasureradarbought
	iniwrite, % currentversion, %savename%, values, version
	iniwrite, % almanacunlocked, %savename%, garden, almanacunlocked
	iniwrite, % arraytostring(treasures), %savename%, treasures, treasures
	for savegameindex, savegamecontent in upgrades{
		for savegameindex2, savegamecontent2 in upgrades[savegameindex]{
			upgrades[savegameindex][savegameindex2] := %savegameindex%[savegameindex2]
		}
	}
	iniwrite, % arraytostring(upgrades), %savename%, upgrades, upgrades
	iniwrite, % arraytostring(plantknowledge), %savename%, garden, plantknowledge
	iniwrite, % arraytostring(optionchecks), %savename%, options, optionchecks
	iniwrite, % arraytostring(stats), %savename%, values, stats
	;saving garden tiles can get pretty long at times if there's many unlocked tiles
	loop, % gardentiles{
		SaveX := mod(A_index, 10)
		SaveY := ceil(A_index / 10)
		if(SaveX == 0){
			SaveX = 10
		}
		savevalue := {plant:tile%SaveX%A%SaveY%["plant"], permanent:tile%SaveX%A%SaveY%["permanent"]}
		savevalue := arraytostring(savevalue)
		IniWrite, % savevalue, %savename%, garden, tile%SaveX%A%SaveY%
	}
	loop, % freezertiles{
		SaveX := mod(A_index, 10)
		SaveY := ceil(A_index / 10)
		if(SaveX == 0){
			SaveX = 10
		}
		savevalue := {plant:freezertile%SaveX%A%SaveY%["plant"]}
		savevalue := arraytostring(savevalue)
		IniWrite, % savevalue, %savename%, garden, freezertile%SaveX%A%SaveY%
	}
	addlog("saved the game", "general")
	critical, off
}

exit_onclick(){
	global
	lastsave := 1
	exitapp
}

BackgroundpowerGuiClose:
lastsave := 1
exitapp
return

~F11::
if(F11reset == "true"){
	savegame_onclick()
	Reload
}
return

;here are all future ideas listed for the game that I hope to implement some day.

;Ascension system with a new resource: Mana. Mana is gained from varying sources like upgrades or garden plants. (garden plants need to be alive and not harvest to get their mana)
;Ascension destroys most things and ascends your character into a deity. Allowing you to spend your mana on a skill tree to buff further progression.
;Future playthrough players would be able to build a statue to your previous character as a deity for example which would yield various buffs

;Bloobs, Floobs are pets that you can breed and train (sorta). Bloobs have various benefits that can be utilized when they are equipped. 1 can be equipped by default but some ways unlock more slots.
;Bloobs can breed when put in a queen and king slot (they dont buff your stats in there). Over time they create new bloops with stats based on the current bloob with around an equal chance of increasing or decreasing the stats
;Bloobs have a stat cap which they will quickly reach. Once all stats are maxed, a bloob can be ascended and be reset back but their max stat caps will be increased

;I have started working on this feature V
;A dungeon crawler feature controlled by the arrow/wasd keys. A character moves through a dungeon based on your input and encounters treasures, blockades and enemies.
;The player enters stairs automatically upon entering and the stairs are always near a wall. Enemies trap you when walking on them and pressing a arroy/wasd key starts attacking it.
;I'm not sure if I want to introduce a health system or just want the character to be invurnerable with progress limited by time.
;Deeper floors give better rewards of course
;The character gets various buffs from other features, like bloobs or plants.
;The theme of the dungeon is reptiles. Almost every enemy is some sort of lizard or snake. This doesn't mean there wont be a wide variety of enemies.
;Locked doors which are enemies that have large amounts of health but are insta-killed when a golden key is collected during combat.
;hidden doors which are the same thing but finding a hidden treasure kills them instead

;Maybe a safe cracking minigame played with the number keys. Eventually pressing enough buttons will open the safe and grant rewards.

;Garden rework (again). I'm not entirely sure what I want the garden to be. But right now my mind goes something like this.
;Fully remove random plant spawns. Seeds for plants can be bought and mystery seeds can be planted to attempt breeding pairs.
;Special enchants on tile allow random plant spawns
;Plant managing. Plants that move other plants around or auto-harvest them (this does not break the no-idle rule as plants only appear/grow/move/harvest when the mouse moves)
;A growth system. Plants are less efficient when they are not fully grown and many powerful effects only work when the plant is grown 100% (note: making an amalgam plant combines the growth times for both plants so it may take long to grow at times)
;extra reasons to use the knowledge system. More knowledge can be invested in completed plants for increased 'mana' gain
;Rework the breeding system. Instead of requiring plants nearby. Plants require certain stats to be met. For example one plant could need the 8 plants around it to have a combined total of 10 clickpower before it grows there.