/*
 Hotkey Documentation: http://ahkscript.org/docs/Hotkeys.htm

 Modifiers:
   ^ - Ctrl
   ! - Alt
   + - Shift
   # - Win

*/

;-------------------------------------------------------------------------------
;;; kEY DISABLE AND WORKAROUND ;;;
;-------------------------------------------------------------------------------
;Enable original capslock functionality
CapsLock::
Return
#If, GetKeyState("CapsLock", "P") ;CapsLock hotkeys go below

SetCapsLockState, AlwaysOff

; Allow normal CapsLock functionality to be toggled by Alt+CapsLock:
!CapsLock::
    GetKeyState, capsstate, CapsLock, T ;(T indicates a Toggle. capsstate is an arbitrary varible name)
    if capsstate = U
        SetCapsLockState, AlwaysOn
    else
        SetCapsLockState, AlwaysOff
    return

;-------------------------------------------------------------------------------
;;; LAYER 0 --- STANDARD HOTKEYS ;;;
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;;; LAYER 1 --- CAPSLOCK LAYER ;;;
;-------------------------------------------------------------------------------
; AHK Functions
F4::Reload     ; Reload entire script
F12::Suspend   ; Suspends AutoHot Key

;Shortcuts

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

;WIN Shortcuts

#n::
   Run, Notepad
Return

;-------------------------------------------------------------------------------
;;; LAYER 2 --- NUMLOCK LAYER ;;;
;-------------------------------------------------------------------------------