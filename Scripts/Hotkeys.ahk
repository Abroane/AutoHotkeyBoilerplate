/*
    Hotkey Documentation: http://ahkscript.org/docs/Hotkeys.htm

    Modifiers:
    ^ - Ctrl
    ! - Alt
    + - Shift
    # - Win
*/

; NOTE : Almost this entire file is #include statements
;   Keydisable and workaround are really the only exceptions

;-------------------------------------------------------------------------------
;;; KEY DISABLE AND WORKAROUND ;;;
;-------------------------------------------------------------------------------

    ;CAPSLOCK
        ;Stops Capslock from sending keycodes past AHK
        CapsLock::
        Return
    
        ; Stops caps from turning on
        SetCapsLockState, AlwaysOff

        ; Allow normal CapsLock functionality to be toggled by Alt+CapsLock:
        !CapsLock::
            GetKeyState, capsstate, CapsLock, T ;(T indicates a Toggle. capsstate is an arbitrary varible name)
            if capsstate = U
                SetCapsLockState, AlwaysOn
            else
                SetCapsLockState, AlwaysOff
            return

    ;NUMLOCK
        ; Stop numlock from sending keycodes past AHK
        Numlock::
        Return

        ; Stops numlock from turning off
        SetNumlockState, AlwaysOn

        ; Allow normal numlock toggling via alt+numlock
        !NumLock::
            GetKeyState, numstate, NumLock, T ;(T indicates a Toggle. numstate is an arbitrary varible name)
            if numstate = U
                SetNumLockState, AlwaysOn
            else
                SetNumLockState, AlwaysOff
            return

;-------------------------------------------------------------------------------
;;; LAYER 0 --- STANDARD HOTKEYS ;;;
;-------------------------------------------------------------------------------

        #include %A_ScriptDir%\Scripts\hotkeys\base\base_mod_none.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\base\base_mod_shift.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\base\base_mod_ctrl.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\base\base_mod_alt.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\base\base_mod_os.ahk

        ;-------------------------------------------------------------------------------
        ; Oddball key options (like hyper + kc)
        ;-------------------------------------------------------------------------------
            ;list kc here
        ;-------------------------------------------------------------------------------   

;-------------------------------------------------------------------------------
;;; LAYER 1 --- CAPSLOCK LAYER ;;;
;-------------------------------------------------------------------------------

     #If, GetKeyState("CapsLock", "P") ;CapsLock hotkeys go below
        ;all keys set to nothing if not assigned so that when in that layer i do not accidentally type something

        #include %A_ScriptDir%\Scripts\hotkeys\capslock\caps_mod_none.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\capslock\caps_mod_shift.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\capslock\caps_mod_ctrl.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\capslock\caps_mod_alt.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\capslock\caps_mod_os.ahk
        ;-------------------------------------------------------------------------------
        ; Oddball key options (like hyper + kc)
        ;-------------------------------------------------------------------------------
            ;list kc here
        ;-------------------------------------------------------------------------------
    return

;-------------------------------------------------------------------------------
;;; LAYER 2 --- NUMLOCK LAYER ;;;
;-------------------------------------------------------------------------------

    #if, GetKeyState("NumLock", "P") ;Numlock hotkeys go below
        ;all keys set to nothing if not assigned so that when in that layer i do not accidentally type something

        #include %A_ScriptDir%\Scripts\hotkeys\numlock\num_mod_none.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\numlock\num_mod_shift.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\numlock\num_mod_ctrl.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\numlock\num_mod_alt.ahk
        #include %A_ScriptDir%\Scripts\hotkeys\numlock\num_mod_os.ahk

        ;-------------------------------------------------------------------------------
        ; Oddball key options (like hyper + kc)
        ;-------------------------------------------------------------------------------
            ;list kc here
        ;-------------------------------------------------------------------------------
    return