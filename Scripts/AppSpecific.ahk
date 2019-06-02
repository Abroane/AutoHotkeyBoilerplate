/*
 Context-sensitive Documentation: http://ahkscript.org/docs/commands/_If.htm
*/
 
 ;If Notepad is the active window then the following 
 #If WinActive("ahk_class Notepad")
		#include %A_ScriptDir%\Scripts\AppSpecific\notepad.ahk
 #If ; turns off context sensitivity





