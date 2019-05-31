/*
 Hotkey Documentation: http://ahkscript.org/docs/Hotkeys.htm

 Modifiers:
   ^ - Ctrl
   ! - Alt
   + - Shift
   # - Win

*/
 ;layer2 --- CapsLock

;Enable original capslock functionality
CapsLock::
Return
#If, GetKeyState("CapsLock", "P") ;CapsLock hotkeys go below

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
