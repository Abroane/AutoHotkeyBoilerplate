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

        h::Send {`%}
        j::Send {+}
        k::Send {-}
        l::Send {*}
        `;::Send {/}
        '::Send {=}
        y::Send {^}
        u::Send {&}
        i::Send {|}
        o::Send {!}
        p::Send {~}
        [::Send {$}
        ]::Send {@}
        m::Send {#} 

    ;-------------------------------------------------------------------------------
    ;OS/WIN modified Capslock Shortcuts ( All shirtcuts on this modifier are windows specific )
    ;-------------------------------------------------------------------------------

        #p::  Winset, Alwaysontop, , A  ;p for pin

    ;-------------------------------------------------------------------------------
    ;ALT Modified Capslock Shortcuts
    ;-------------------------------------------------------------------------------

        ;alt shortcuts go here

;-------------------------------------------------------------------------------
;;; LAYER 2 --- NUMLOCK LAYER ;;;
;-------------------------------------------------------------------------------