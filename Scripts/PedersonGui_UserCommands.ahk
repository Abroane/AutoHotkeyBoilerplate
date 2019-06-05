; Created by Asger Juul Brunshøj
; Source: https://github.com/plul/Public-AutoHotKey-Scripts

; Note: Save with encoding UTF-8 with BOM if possible.
; I had issues with special characters like in ¯\_(ツ)_/¯ that wouldn't work otherwise.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; Write your own AHK commands in this file to be recognized by the GUI. Take inspiration from the samples provided here.

;-------------------------------------------------------------------------------
;;; tooltip ;;; (also wanted the start of the if loop not inside a include file)
;-------------------------------------------------------------------------------
if Pedersen = ? ; Tooltip with list of commands
{
    GuiControl,, Pedersen, ; Clear the input box
    Gosub, gui_commandlibrary
}

;-------------------------------------------------------------------------------
;;; Command files include statements ;;;
;-------------------------------------------------------------------------------

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\searchWeb.ahk
        ;includes any command to search the web (via google for example) or any specific website (ex. youtube)

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchWeb.ahk
        ;Includes any command that just goes to a website without interacting with the site

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchPrograms.ahk
        ;Includes any command that launches a program installed on the PC

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchFolder.ahk
        ;Includes any command that launches a specific folder on the pc, network mount, etc

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchFile.ahk
        ;Includes any command that launches a specific file (ex. host file)
    
    #include %A_ScriptDir%\scripts\PedersonGui_scripts\guiHotstrings.ahk
        ;This is for any hotstrings that i want included with the gui but don't wish to include in my normal hotstring file.

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\guiAHK.ahk
        ;This has any commands that interact directly with AHK (ex suspend or open the script file)

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\
        ;

;-------------------------------------------------------------------------------
;;; Misc commands that don't really belong anywhere ;;;
;-------------------------------------------------------------------------------
else if Pedersen = ping ; Ping Google
{
    gui_destroy()
    Run, cmd /K "ping www.google.com"
}
else if Pedersen = date ; What is the date?
{
    gui_destroy()
    FormatTime, date,, LongDate
    MsgBox %date%
    date =
}
else if Pedersen = week ; Which week is it?
{
    gui_destroy()
    FormatTime, weeknumber,, YWeek
    StringTrimLeft, weeknumbertrimmed, weeknumber, 4
    if (weeknumbertrimmed = 53)
        weeknumbertrimmed := 1
    MsgBox It is currently week %weeknumbertrimmed%
    weeknumber =
    weeknumbertrimmed =
}