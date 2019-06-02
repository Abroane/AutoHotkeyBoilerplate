## Usage

1. Edit `Settings.ini` as needed
2. Run `Main.ahk`

## Structure

    .
    |-- Main.ahk                Main.ahk is what starts everything up
    |-- Settings.ini            This is for some basic settings
    |-- Scripts\                Scripts folder holds all the ahk scripts that i directly interact
    |   |-- AppSpecific.ahk
    |   |-- Functions.ahk
    |   |-- HotStrings.ahk
    |   `-- Hotkeys.ahk
    |
    |-- Lib\                    This contains any premade libraries of functions
    |   |-- ini.ahk             allows ini files to be referenced via variables instead of reading or manipulating the file iteself every command
    |   `-- Notify.ahk          For making easy Popup notifications
    |
    |-- Util\                   Util contains scripts that help in the background (ex. traymenu.ahk is not interacted with directly but it can alter the ahk tray context menu)
    |-- programs\               programs contains anything that actively runs
    `-- games\                  games contains odd ahk games people have made (normally launched through PedersonGUI)

## Contributors

## License


## Credits (some things have been altered from their original format but this is where i got the scripts to start from)

Whole starting point            - denolfe           from https://github.com/denolfe/AutoHotkeyBoilerplate

PedersonGUI.ahk                 - plul              from https://github.com/plul/Public-AutoHotKey-Scripts
PedersonGUI_UserCommands.ahk    - plul              from https://github.com/plul/Public-AutoHotKey-Scripts

Hotkeys.ahk
    1a - radiantcabbage     from https://www.reddit.com/r/AutoHotkey/comments/2zd53b/consolidate_lines_hotkey_script_for_you/cpia49p?utm_source=share&utm_medium=web2x

