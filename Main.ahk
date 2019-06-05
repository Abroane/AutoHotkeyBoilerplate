#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
#Persistent
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;-------------------------------------------------------------------------------
;;; System Scripts ;;;
;-------------------------------------------------------------------------------

#Include %A_ScriptDir%\Util\Functions.ahk		
#Include %A_ScriptDir%\Util\subroutines.ahk
#Include %A_ScriptDir%\Util\Init.ahk
#Include %A_ScriptDir%\Util\ParseSettings.ahk
#Include %A_ScriptDir%\Util\TrayMenu.ahk

;-------------------------------------------------------------------------------
;;; Setting.ini controlled scripts ;;;
;-------------------------------------------------------------------------------

If (Settings.StartupNotification)
	Notify(Settings.ScriptName " Started",,-3,"Style=StandardGray")

If (Settings.UseAutoCorrect)
	Run, %A_ScriptDir%\programs\AutoCorrect.ahk
Else
{
	DetectHiddenWindows, On 
	WinClose, %A_ScriptDir%\programs\AutoCorrect.ahk ahk_class AutoHotkey
}

;-------------------------------------------------------------------------------
;;; Command Scripts ;;;
;-------------------------------------------------------------------------------

#Include *i %A_ScriptDir%\Scripts\Hotkeys.ahk
#Include *i %A_ScriptDir%\Scripts\AppSpecific.ahk
#Include *i %A_ScriptDir%\Scripts\HotStrings.ahk


;-------------------------------------------------------------------------------
;;; Script Programs ;;;
;-------------------------------------------------------------------------------

; Launch PedersonGUI.ahk
Gosub, gui_autoexecute
#Include %A_ScriptDir%\programs\PedersonGUI.ahk
; End Launch PedersonGUI.ahk

;-------------------------------------------------------------------------------
;;; Compiled Scripts ;;;
;-------------------------------------------------------------------------------