/*
 Context-sensitive Documentation: http://ahkscript.org/docs/commands/_If.htm

	This entire script just loads scripts that are specific to certain apps.
	
	Example there is already one for notepad.  Everything in the script file will only work
	if " notepad " is the active window

*/
 
 ;If Notepad is the active window then the following 
 #If WinActive("ahk_class Notepad")
		#include %A_ScriptDir%\Scripts\AppSpecific\notepad.ahk
 #If ; turns off context sensitivity





