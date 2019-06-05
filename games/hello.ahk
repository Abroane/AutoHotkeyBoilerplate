; =================================================================================================================================
; Name:           AHK HELLO 
; Description:    A VINTAGE MICROSOFT BASIC GAME
; Topic:          https://autohotkey.com/boards/viewtopic.php?f=6&t=56717   
; Sript version:  1.0
; AHK Version:    1.1.24.03 (A32/U32/U64)
; Tested on:      Win 7 (x64)
; Author::        Game created by David Ahl adapted for AHK by SpeedMaster

; How to play:    The classic book BASIC Computer Games, published by Creative Computing 1978, inspired a generation of programmers.
;                 This is a sample of one of a great number of conversational programs. In a sense, it is like a CAI program 
;                 except that its responses are just good fun. Whenever a computer is exhibited at a convention or conference 
;                 with people that have not used a computer before, the conversational programs seem to get the first activity.
;
;                 In this particular program, the computer dispenses advice on various problems such as sex, health, money or job.
;
; ==================================================================================================================================


Hello_bas=
(
2 PRINT TAB(33);"HELLO"
4 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
6 PRINT: PRINT: PRINT
10 PRINT "HELLO.  MY NAME IS CREATIVE COMPUTER."
20 PRINT: PRINT: INPUT "WHAT'S YOUR NAME?";N$: PRINT
30 PRINT "HI THERE, ";N$;", ARE YOU ENJOYING YOURSELF HERE?";
40 INPUT B$: PRINT
50 IF B$="YES" THEN 70
55 IF B$="NO" THEN 80
60 PRINT N$;", I DON'T UNDERSTAND YOUR ANSWER OF '";B$;"'."
65 PRINT "PLEASE ANSWER 'YES' OR 'NO'.  DO YOU LIKE IT HERE?";: GOTO 40
70 PRINT "I'M GLAD TO HEAR THAT, ";N$;".": PRINT
75 GOTO 100
80 PRINT "OH, I'M SORRY TO HEAR THAT, ";N$;". MAYBE WE CAN"
85 PRINT "BRIGHTEN UP YOUR VISIT A BIT."
100 PRINT
105 PRINT "SAY, ";N$;", I CAN SOLVE ALL KINDS OF PROBLEMS EXCEPT"
110 PRINT "THOSE DEALING WITH GREECE.  WHAT KIND OF PROBLEMS DO"
120 PRINT "YOU HAVE (ANSWER SEX, HEALTH, MONEY, OR JOB)?";
125 INPUT C$
126 PRINT
130 IF C$="SEX" THEN 200
132 IF C$="HEALTH" THEN 180
134 IF C$="MONEY" THEN 160
136 IF C$="JOB" THEN 145
138 PRINT "OH, ";N$;", YOUR ANSWER OF '";C$;"' IS GREEK TO ME."
140 GOTO 250
145 PRINT "I CAN SYMPATHIZE WITH YOU ";N$;".  I HAVE TO WORK"
148 PRINT "VERY LONG HOURS FOR NO PAY -- AND SOME OF MY BOSSES"
150 PRINT "REALLY BEAT ON MY KEYBOARD.  MY ADVICE TO YOU, ";N$;","
153 PRINT "IS TO OPEN A RETAIL COMPUTER STORE.  IT'S GREAT FUN."
155 GOTO 250
160 PRINT "SORRY, ";N$;", I'M BROKE TOO.  WHY DON'T YOU SELL"
162 PRINT "ENCYCLOPEADIAS OR MARRY SOMEONE RICH OR STOP EATING"
164 PRINT "SO YOU WON'T NEED SO MUCH MONEY? "
170 GOTO 250
180 PRINT "MY ADVICE TO YOU ";N$;" IS:"
185 PRINT "     1.  TAKE TWO ASPRIN"
188 PRINT "     2.  DRINK PLENTY OF FLUIDS (ORANGE JUICE, NOT BEER!)"
190 PRINT "     3.  GO TO BED (ALONE)"
195 GOTO 250
200 INPUT "IS YOUR PROBLEM TOO MUCH OR TOO LITTLE?";D$: PRINT
210 IF D$="TOO MUCH" THEN 220
212 IF D$="TOO LITTLE" THEN 230
215 PRINT "DON'T GET ALL SHOOK, ";N$;", JUST ANSWER THE QUESTION"
217 INPUT "WITH 'TOO MUCH' OR 'TOO LITTLE'.  WHICH IS IT?";D$:GOTO 210
220 PRINT "YOU CALL THAT A PROBLEM?!!  I SHOULD HAVE SUCH PROBLEMS!"
225 PRINT "IF IT BOTHERS YOU, ";N$;", TAKE A COLD SHOWER."
228 GOTO 250
230 PRINT "WHY ARE YOU HERE, ";N$;"?  YOU SHOULD BE"
235 PRINT "IN TOKYO OR NEW YORK OR AMSTERDAM OR SOMEPLACE WITH SOME"
240 PRINT "REAL ACTION."
250 PRINT
255 PRINT "ANY MORE PROBLEMS YOU WANT SOLVED, ";N$;"?"
260 INPUT E$: PRINT
270 IF E$="YES" THEN 280
273 IF E$="NO" THEN 300
275 PRINT "JUST A SIMPLE 'YES' OR 'NO' PLEASE, ";N$;"."
277 GOTO 255
280 PRINT "WHAT KIND (SEX, MONEY, HEALTH, JOB)?";
282 GOTO 125
300 PRINT
302 PRINT "THAT WILL BE $5.00 FOR THE ADVICE, ";N$;"."
305 PRINT "PLEASE LEAVE THE MONEY ON THE TERMINAL."
307 FOR I=1 TO 2000: NEXT I
310 PRINT: PRINT: PRINT
315 PRINT "DID YOU LEAVE THE MONEY?";
320 INPUT G$: PRINT
325 IF G$="YES" THEN 350
330 IF G$="NO" THEN 370
335 PRINT "YOUR ANSWER OF '";G$;"' CONFUSES ME, ";N$;"."
340 PRINT "PLEASE RESPOND WITH 'YES' OR 'NO'.": GOTO 315
350 PRINT "HEY, ";N$;"??? YOU LEFT NO MONEY AT ALL!"
355 PRINT "YOU ARE CHEATING ME OUT OF MY HARD-EARNED LIVING."
360 PRINT:PRINT "WHAT A RIP OFF, ";N$;"!!!":PRINT
365 GOTO 385
370 PRINT "THAT'S HONEST, ";N$;", BUT HOW DO YOU EXPECT"
375 PRINT "ME TO GO ON WITH MY PSYCHOLOGY STUDIES IF MY PATIENTS"
380 PRINT "DON'T PAY THEIR BILLS?"
385 PRINT:PRINT "TAKE A WALK, ";N$;".":PRINT:PRINT:GOTO 999
390 PRINT "NICE MEETING YOU, ";N$;", HAVE A NICE DAY."
400 REM
999 END

)

gui, color, black
gui, +resize
gui, font, csilver s14, courier new
gui, add, text, x50 y10 w700 h810 -border backgroundtrans vmytext, 
gui, add, text, xp yp wp hp -border backgroundtrans vlayer1, 
gui, add, edit, w100 h0 y+10  vmyedit gedit,


Hello_bas:=regexreplace(Hello_bas, "60 PRINT N", "60 PRINT ""N")
Hello_bas:=regexreplace(Hello_bas, "N\$", "N$""")


text:={}

loop, parse, hello_bas, `n
{
;num:=strsplit(a_loopfield, a_space,,2) ; ahk 1.28
;text[num.1]:=num.2                     ; ahk 1.28
regexmatch(a_loopfield, "^\d+", num)   
regexmatch(a_loopfield, " .*", tail)   
text[num]:=trim(tail)
}

gui, show, w800 h900

k:=0
currentLine:=0

play:
loop, 80 {

	++k

	if (text[k]) && (instr(text[k], "PRINT")) {
		console:=text[k]
		gosub, draw
	}

	if (text[k]) && (instr(text[k], "INPUT")) && !(instr(text[k], "PRINT")){
		console:=text[k]
		gosub, draw
	}

	if (text[k]) && (instr(text[k], "GOTO")) {
		regexmatch(text[k],"\d+", go)
			if (go=210) {
				go:=200 
			}
			k:=go
	}

	if (text[k]) && (regexmatch(text[k], "^IF")) {
		var1:=% substr(text[k],4,2)
		regexmatch(text[k], """.*""", var2)
		var2:=regexreplace(var2, """", "")

		if  (%var1%=var2) {
			regexmatch(text[k],"\d+", k)
			--k
		}

	}

	if (text[k]) && (instr(text[k], "INPUT")) {
		regexmatch(text[k], ".\$", match)
		break
	}

    if (k=307)
       sleep, 2000

}

return


edit:
GuiControlGet, MyEdit,, myedit
txtout:=sliceword(print,"") "`n`n" MyEdit
drawtext("layer1", StrTail(37,Format("{:U}",txtout)), "lime") 
return

~enter::
(k>390) ? (k:=389)
if !(help)
gui, submit, nohide
else {
	help:="", hlp:="HELP"
--k	

gosub, play
}

if (myedit="reload") {
reload
return
}

if (myedit="exit") {
exitapp
return
}

if (myedit="help") || (myedit="about")  {
drawtext("mytext", "`n`nAbout:`n======`n`nHELLO is a game created by David Ahl (1978)`nadapted for AHK by SpeedMaster`n`nThe computer dispenses advice on various problems `nsuch as sex, health, money or job.`n`nCONSOLE COMMANDS: `n=================`n`nHELP  : display this help `nRELOAD: replay the game `nEXIT  : exit the game`n`n`nPRESS ENTER TO RESUME")
guicontrol, focus, myedit
guicontrol,,myedit,
disablecell("myedit")
help:=1
return
}


%match%:=myedit
if !(N$)
  return
if !(myedit) && (hlp) { 
	print .= "`n`n>> " . hlp "`n" 
	hlp:=""
}
else
	print .= "`n`n>> " . myedit "`n" 
guicontrol,,mytext, %  StrTail(35,Format("{:U}",print))
guicontrol, focus, myedit
guicontrol,,myedit,
gosub, play
return

draw:
disablecell("myedit")
print .= "`n"
out:=StrTail(35,console)
regexmatch(out, """.*""", out)
out:=regexreplace(out,"N\$", N$)
out:=regexreplace(out,"B\$", B$)
out:=regexreplace(out,"C\$", C$)
out:=regexreplace(out,"G\$", G$)
out:=regexreplace(out, "PRINT |INPUT |""|;", "")
out:=regexreplace(out,"\n\n", "\n")

if (k=2)  {
print := "==========================================`n            *** " out " ***"
}

if (k=4)  {
print .= out "`n==========================================`n"
guicontrol,,mytext, % StrTail(35,Format("{:U}", print )) 	
}

if (k>4)
for l, m in % strsplit(out) {
print .= m
print:=regexreplace(print, "\n\n\n", "`n`n")
guicontrol,,mytext, % StrTail(35,Format("{:U}",print))
sleep, 50
}
enablecell("myedit")
guicontrol, focus, myedit
return


StrTail(k,str) {
      Return RegExReplace(str,".*(?=(\n[^\n]*){" k "}$)")
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

drawtext(varname, texttodraw:="", color:="")
{
 global
guicontrol,, %varname%, %texttodraw%
if (color)
ColorText(varname, color)
}

ColorText(cell_to_paint, color:="red")
{
 GuiControl, +c%color%  , %cell_to_paint%
 GuiControl, MoveDraw, % cell_to_paint
}

disablecell(cell) {
 global
 guicontrol, disable, %cell%
 GuiControl, MoveDraw, % cell
}

enablecell(cell) {
 global
 guicontrol, enable, %cell%
 GuiControl, MoveDraw, % cell
}

guiclose:
esc::exitapp
return