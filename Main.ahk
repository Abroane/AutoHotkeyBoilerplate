#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
#Persistent
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;-------------------------------------------------------------------------------
;;;; Loads base/necessary scripts ;;;
;-------------------------------------------------------------------------------

	;For adding functions (see Auto Hot Key help file for explination)
	#Include *i %A_ScriptDir%\Scripts\Functions.ahk

	;Unknown essentially empty file
	#Include %A_ScriptDir%\Util\Init.ahk

	;script for how AHK is to read the settings.ini file
	#Include %A_ScriptDir%\Util\ParseSettings.ahk

	;For altering and editing the tray menu see (In the Auto Hot Key help file under "Graphical User Interface" then "menu")
	#Include %A_ScriptDir%\Util\TrayMenu.ahk

;-------------------------------------------------------------------------------
;;;; Settings.ini controlled options ;;;
;-------------------------------------------------------------------------------

	;shows a small popup saying the script has started if set to 1 in settings.ini
	If (Settings.StartupNotification)
		Notify(Settings.ScriptName " Started",,-3,"Style=StandardGray")

	;Will load autocorrect script if set to 1 in settings.ini
	If (Settings.UseAutoCorrect)
		Run, %A_ScriptDir%\Util\AutoCorrect.ahk
	Else
	{
		DetectHiddenWindows, On 
		WinClose, %A_ScriptDir%\Util\AutoCorrect.ahk ahk_class AutoHotkey
	}

;-------------------------------------------------------------------------------
;;;; Starts User Scripts ;;;
;-------------------------------------------------------------------------------

	;Launches the hotkeys script for launching or running things by keypress
	#Include *i %A_ScriptDir%\Scripts\Hotkeys.ahk
	
	;This loads scripts that contain application specific scipting
	#Include *i %A_ScriptDir%\Scripts\AppSpecific.ahk
	
	;Script changes certain things that have been typed in for something else example (btw being swapped for "by the way")
	#Include *i %A_ScriptDir%\Scripts\HotStrings.ahk

;-------------------------------------------------------------------------------
;;;; Launches other tools ;;;
;-------------------------------------------------------------------------------

	;Launches Pederson GUI
	#include %A_ScriptDir%\Util\Pederson\Host.ahk 
