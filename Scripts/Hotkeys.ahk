/*
    Hotkey Documentation: http://ahkscript.org/docs/Hotkeys.htm

    Modifiers:
    ^ - Ctrl
    ! - Alt
    + - Shift
    # - Win
*/

;-------------------------------------------------------------------------------
;;; KEY DISABLE AND WORKAROUND ;;;
;-------------------------------------------------------------------------------

    ;CAPSLOCK
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

;-------------------------------------------------------------------------------
;;; LAYER 0 --- STANDARD HOTKEYS ;;;
;-------------------------------------------------------------------------------

    ;Non Layer Shortcuts go here

;-------------------------------------------------------------------------------
;;; LAYER 1 --- CAPSLOCK LAYER ;;;
;-------------------------------------------------------------------------------
 #If, GetKeyState("CapsLock", "P") ;CapsLock hotkeys go below

    ;-------------------------------------------------------------------------------
    ;Base Capslock Shortcuts
    ;-------------------------------------------------------------------------------
        ; AHK Functions
        F4::Reload     ; Reload entire script
        F12::Suspend   ; Suspends AutoHot Key

        ;

    ;-------------------------------------------------------------------------------
    ;OS/WIN modified Capslock Shortcuts ( All shortcuts on this modifier are general windows shortcuts )
    ;-------------------------------------------------------------------------------

        #p::  Winset, Alwaysontop, , A  ;p for pin

            
        #m::           ;This will clear extra line breaks from selected text (Source = 1a)
            temp := clipboardall
            clipboard :=
            sendinput ^x
            clipwait
            loop parse, clipboard, `n`t, `r%a_space%
                sendinput % a_loopfield a_space
            clipboard := temp
            return

    ;-------------------------------------------------------------------------------
    ;ALT Modified Capslock Shortcuts
    ;-------------------------------------------------------------------------------

        ;alt shortcuts go here

;-------------------------------------------------------------------------------
;;; LAYER 2 --- NUMLOCK LAYER ;;;
;-------------------------------------------------------------------------------