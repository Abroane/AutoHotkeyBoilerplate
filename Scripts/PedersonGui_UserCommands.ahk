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
if Pedersen = ?main ; Tooltip with list of commands
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_Main
    }

else if Pedersen = ?searchWeb ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_searchWeb
    }
else if Pedersen = ?launchhWeb ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_launchWeb
    }
else if Pedersen = ?launchProgram ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_launchProgram
    }
else if Pedersen = ?launchSubroutine ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_launchSubroutine
    }
else if Pedersen = ?launchGame ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_launchGame
    }
else if Pedersen = ?launchFolder ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_launchFolder
    }
else if Pedersen = ?launchFile ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_launchFile
    }
else if Pedersen = ?guiHotstrings ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_guiHotstrings
    }
else if Pedersen = ?guiAHK ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_guiAHK
    }
else if Pedersen = ?misc ; Lists all commands that search the web or search parts of websites
    {
        GuiControl,, Pedersen, ; Clear the input box
        Gosub, gui_toolTip_misc
    }

;-------------------------------------------------------------------------------
;;; Command files include statements ;;;
;-------------------------------------------------------------------------------

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\searchWeb.ahk
        ;includes any command to search the web (via google for example) or any specific website (ex. youtube)

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchWeb.ahk
        ;Includes any command that just goes to a website without interacting with the site

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchProgram.ahk
        ;Includes any command that launches a program installed on the PC

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchSubroutine.ahk
        ;Includes any command that launches a AHK subroutine/script

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchGame.ahk
        ;includes any command that launches a game (normally the AHK games included)
    
    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchFolder.ahk
        ;Includes any command that launches a specific folder on the pc, network mount, etc

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\launchFile.ahk
        ;Includes any command that launches a specific file (ex. host file)
    
    #include %A_ScriptDir%\scripts\PedersonGui_scripts\guiHotstrings.ahk
        ;This is for any hotstrings that i want included with the gui but don't wish to include in my normal hotstring file.

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\guiAHK.ahk
        ;This has any commands that interact directly with AHK (ex suspend or open the script file)

    #include %A_ScriptDir%\scripts\PedersonGui_scripts\misc.ahk
        ;Random Commands that don't fit anywhere yet
