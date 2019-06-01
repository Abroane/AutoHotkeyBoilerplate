# AutoHotkey Boilerplate

A boilerplate to help jumpstart a script for personal productivity

## Goal

- Provide easy access to all the features of AutoHotkey 
- Understandable structure for future additions

## Installation

Prerequisite: Install [AutoHotkey](http://ahkscript.org/) from [ahkscript.org](http://ahkscript.org/)

Options: 

- `git clone https://github.com/denolfe/AutoHotkey-Boilerplate.git`
- Download the repo and unzip
- Fork to your own repo, then clone or download

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