;-------------------------------------------------------------------------------
;   left OS/WIN mod hotkeys for Capslock "layer"
;       -   mostly commented out to prevent conflict
;-------------------------------------------------------------------------------

    ;Function Keys
        <#F1::
            return
        <#F2::
            return
        <#F3::
            return
        <#F4::
            return
        <#F5::
            return
        <#F6::
            return
        <#F7::
            return
        <#F8::
            return
        <#F9::
            return
        <#F10::
            return
        <#F11::
            return
        <#F12::
            return
    
    ; Numrow
        <#1::
            return
        <#2::
            return
        <#3::
            return
        <#4::
            return
        <#5::
            return
        <#6::
            return
        <#7::
            return
        <#8::
            return
        <#9::
            return
        <#0::
            return

    ; Alphabet    
        <#a::
            return
        <#b::
            return
        <#c::
            return
        <#d::
            return
        <#e::
            return
        <#f::
            return
        <#g::
            return
        <#h::
            return
        <#i::
            return
        <#j::
            return
        <#k::
            return
        ;<#l Windows lock cannot be overridden
        
        <#m::
            return
        <#n::
            return
        <#o::
            return
        <#p::  ;p for pin ,Pins window to top layer so it will show ontop of even other active windows (is a toggle)
            Winset, Alwaysontop, , A  
            return
        <#q::
            return
        <#r::
            return
        <#s::
            return
        <#t::
            return
        <#u::
            return
        <#v::
            return
        <#w::
            return
        <#x::
            return
        <#y::
            return
        <#z::
            return
    
    ; Special Characters
        <#-::
            return
        <#=::
            return
        <#[::
            return
        <#]::
            return
        <#;:: 
            return
        <#'::
            return
        <#,::
            return
        <#.::
            return
        <#/::
            return

    ; Arrow Keys
        <#up::
            return
        <#down::
            return
        <#left::
            return
        <#right::
            return

    ; Numpad (numlock on layer)
        <#numpad0::
            return
        <#numpad1::
            return
        <#numpad2::
            return
        <#numpad3::
            return
        <#numpad4::
            return
        <#numpad5::
            return
        <#numpad6::
            return
        <#numpad7::
            return
        <#numpad8::
            return
        <#numpad9::
            return
        <#numpadDot::
            return

    ; Numpad (numlock off layer)
        <#numpadIns::
            return
        <#numpadEnd::
            return
        <#numpadDown::
            return
        <#numpadPgDn::
            return
        <#numpadLeft::
            return
        <#numpadClear::
            return
        <#numpadRight::
            return
        <#numpadHome::
            return
        <#numpadUp::
            return
        <#numpadPgUp::
            return
        <#numpadDel::
            return

    ; Numpad (layerless)
        <#numpadDiv::
            return
        <#numpadMult::
            return
        <#numpadAdd::
            return
        <#numpadSub::
            return
        <#numpadEnter::
            return