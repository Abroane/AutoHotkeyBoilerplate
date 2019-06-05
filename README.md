## Usage

1. Edit `Settings.ini` as needed
2. Run `Main.ahk`

## Structure (listed in load order in folders instead of alphanumerically, folders are also generally listed in load order.)

    .
    |-- Main.ahk                Main.ahk is what starts everything up
    |
    |-- Util\                   Util contains scripts that help two scripts interact (ie specific / see library desc for opposite)
    |   |
    |   |-- Functions.ahk                   These scripts can pass variables back.
    |   |-- Subroutines.ahk                 These scripts just run commands without being able to pass a variable back
    |   |-- init.ahk                        not really sure, mostly empty
    |   |-- parseSettings.ahk               used to help scripts know how to read the Settings.ini
    |   `-- traymenu.ahk                    for altering the AHK tray menu
    |
    |-- Settings.ini            This is for some basic settings and switching certain scripts off and on.
    |
    |-- Scripts\                Scripts folder holds all the ahk scripts that i directly interact with
    |   |
    |   |-- Hotkeys.ahk                     Hotkeyfile for remapping keys and key combos to certain actions
    |   |-- Hotkeys\                        Folder that holds all the scripts included in hotkeys.ahk
    |   |   |
    |   |   |--base\                        Folder holding 
    |   |   |   |
    |   |   |   |--base_mod_none.ahk            base layer hotkeys for plain keyboard without modifiers held down
    |   |   |   |--base_mod_shift.ahk           base layer hotkeys for shift modifier + kc
    |   |   |   |--base_mod_ctrl.ahk            base layer hotkeys for ctrl modifier + kc
    |   |   |   |--base_mod_alt.ahk             base layer hotkeys for alt modifier + kc
    |   |   |   `--base_mod_os.ahk              base layer hotkeys for os modifier + kc
    |   |   |
    |   |   |--capslock\
    |   |   |   |
    |   |   |   |--caps_mod_none.ahk            capslock layer hotkeys for plain keyboard without modifiers held down
    |   |   |   |--caps_mod_shift.ahk           capslock layer hotkeys for shift modifier + kc
    |   |   |   |--caps_mod_ctrl.ahk            capslock layer hotkeys for ctrl modifier + kc
    |   |   |   |--caps_mod_alt.ahk             capslock layer hotkeys for alt modifier + kc
    |   |   |   `--caps_mod_os.ahk              capslock layer hotkeys for os modifier + kc
    |   |   |
    |   |   `--numlock\
    |   |       |
    |   |       |--num_mod_none.ahk             numlock layer hotkeys for plain keyboard without modifiers held down
    |   |       |--num_mod_shift.ahk            numlock layer hotkeys for shift modifier + kc
    |   |       |--num_mod_ctrl.ahk             numlock layer hotkeys for ctrl modifier + kc
    |   |       |--num_mod_alt.ahk              numlock layer hotkeys for alt modifier + kc
    |   |       `--num_mod_os.ahk               numlock layer hotkeys for os modifier + kc
    |   |
    |   |-- AppSpecific.ahk                 Script that pulls all the app specific scripts together
    |   |-- Appspecific\                    Folder that holds all the scripts included in AppSpecific.ahk
    |   |   |
    |   |   `--Notepad
    |   |   
    |   |-- Hotstrings.ahk                  Script that is used for replacing strings that are typed with something else
    |   |-- HotStrings\                     Folder that holds all the scripts included in Hotstrings.ahk
    |   |   |
    |   |   |--
    |   |   `--
    |   |   
    |   |-- PedersonGui_UserCommands.ahk    Commands for the PedersonGUI ( Loaded by perdersonGui instead of directly by main.ahk )
    |   `-- PedersonGui_scripts\            Folder that holds all the scripts included in PedersonGui_UserCommands.shk
    |       |
    |       |-- 
    |       |--
    |       `--
    |
    |-- programs\               programs contains anything that actively runs
    |   |
    |   |--AutoCorrect.ahk                  Autocorrect script file that is loaded (or not) via configuration of settings.ini
    |   |--Mirrored_Keyboard.ahk            Mirrors the right hand of the keyboard to the left for one handed typing
    |   `--PedersonGui.ahk                  GUI that has a hotstring namespace allowing easy execution of commands without interfering with anything else
    |
    |-- Lib\                    This contains any script that is generic in that any script can reference it (not loaded by main but called as needed)
    |   |
    |   |-- ini.ahk                         allows ini files to be referenced via variables instead of reading or manipulating the file iteself every command
    |   `-- Notify.ahk                      For making easy Popup notifications
    |
    |
    `-- games\                  games contains odd ahk games people have made (normally launched through PedersonGUI)
        |
        |-- 2048\
        |-- AHKban\
        |-- Archmage_Gray\                  UZp and Down scrolling shooter using mouse to aim.
        |-- background_power\
        |-- Bulldozer\                      Contains the files for the bulldozer game
        |-- Ishido\                     
        |-- Klondike_Solitaire\
        |-- Labyrinth3D\                    Simple Maze Game / does not work with 64-bit AHK (keeping for reference more than anything)
        |-- Mahjong_Solitaire\
        |-- Poek\
        |-- REGEX_Frogger\                  Frogger clone using regular expressions (ASCII Frogger essentially)
        |-- RogueV2                         V2 of a simple Roguelike script
        |-- snake\
        |-- ASCII_Rescue_Adventure.ahk
        |-- hello.ahk
        |-- Klavier Hero 2010.ahk
        `-- tetris.ahk
    
    

## Contributors

## License


## Credits

Whole starting point            - denolfe           from https://github.com/denolfe/AutoHotkeyBoilerplate

Other Credit will be with the script in comments.  Not all scripts remain unaltered (though games normally are in complete original code)



