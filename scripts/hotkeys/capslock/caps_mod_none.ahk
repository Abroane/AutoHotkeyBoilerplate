;-------------------------------------------------------------------------------
;   unmodified hotkeys for Capslock "layer"
;       -   mostly commented out to prevent conflict
;-------------------------------------------------------------------------------
        
    ;Function Keys
        F1::
            return
        F2::
            return
        F3::
            return
        F4::
            return
        F5:: ; Reload entire AHK script
            Reload   
            return
        F6::
            return
        F7::
            return
        F8::
            return
        F9::
            return
        F10::
            return
        F11::
            return
        F12:: ; Suspends AutoHot Key
            Suspend   
            return
    
    ; Numrow
        1::
            return
        2::
            return
        3::
            return
        4::
            return
        5::
            return
        6::
            return
        7::
            return
        8::
            return
        9::
            return
        0::
            return

    ; Alphabet    
        a:: ;Sends arrow key left
            send {left}
            return
        b::
            return
        c::
            return
        d:: ;Sends arrow key right
            send {right}
            return
        e::
            return
        f::
            return
        g::
            return
        h::
            return
        i::
            return
        j::
            return
        k::
            return
        l::
            return
        m:: ;removes line breaks by swapping them with spaces (also seems to remove excess spaces)
            gosub, subroutine_LineBreakRemoval
            return
        n::
            return
        o::
            return
        p::  
            return
        q::
            return
        r::
            return
        s:: ;Sends arrow key down
            send {down}
            return
        t::
            return
        u::
            return
        v::
            return
        w:: ;Sends arrow key up
            Send {Up}
            return
        x::
            return
        y::
            return
        z::
            return
    
    ; Special Characters
        -::
            return
        =::
            return
        [::
            return
        ]::
            return
        ;::  ;doesn't seem to work for some reason.
            return
        '::
            return
        ,::
            return
        .::
            return
        /::
            return

    ; Arrow Keys
        up:: ;enters superscript mode (toggle) - Currently only works in word that i know of
	        sendinput {RCtrl down}^+={RCtrl up}
            return
        down:: ;enters Subscript mode (toggle) - Currently only works in word that i know of
		    sendinput {Rctrl down}={Rctrl up}
            return
        left::
            return
        right::
            return

    ; Numpad (numlock on layer)
        numpad0::
            return
        numpad1::
            return
        numpad2::
            return
        numpad3::
            return
        numpad4::
            return
        numpad5::
            return
        numpad6::
            return
        numpad7::
            return
        numpad8::
            return
        numpad9::
            return
        numpadDot::
            return

    ; Numpad (numlock off layer)
        numpadIns::
            return
        numpadEnd::
            return
        numpadDown::
            return
        numpadPgDn::
            return
        numpadLeft::
            return
        numpadClear::
            return
        numpadRight::
            return
        numpadHome::
            return
        numpadUp::
            return
        numpadPgUp::
            return
        numpadDel::
            return

    ; Numpad (layerless)
        numpadDiv::
            return
        numpadMult::
            return
        numpadAdd::
            return
        numpadSub::
            return
        numpadEnter::
            return