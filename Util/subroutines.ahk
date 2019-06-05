/* 
This file is for all the small subroutines or 
*/
return ;stops auto-execution of the following subcommands


;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; Line Break Removal - Replaces line breaks with spaces in selected text
;   Author: radiantcabbage     
;   Source: https://www.reddit.com/r/AutoHotkey/comments/2zd53b/consolidate_lines_hotkey_script_for_you/cpia49p?utm_source=share&utm_medium=web2x
;--------------------------------------------------------------------------------------------------------------------------------------------------------------

    subroutine_LineBreakRemoval:   ;This will clear extra line breaks from selected text (Source = 1a)
        temp := clipboardall
        clipboard :=
        sendinput ^x
        clipwait
        loop parse, clipboard, `n`t, `r%a_space%
            sendinput % a_loopfield a_space
        clipboard := temp
        return  

;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; <code> Tag Surround - Surrounds selected text with <code></code> tags or just prints <code></code>
;   Author: ronjouch 
;   Source: https://gist.github.com/ronjouch/2428558
;--------------------------------------------------------------------------------------------------------------------------------------------------------------

    subroutine_tag_code:
        ClipboardOld = %Clipboard%
        clipboard = 
        Send, ^c
        ClipboardNew = %Clipboard%
        Sleep, 50
        If (ClipboardNew <> "")
        {
            SendInput <code></code>{Left 7}
            SendRaw %ClipboardNew%
        }
        Else SendInput <code></code>{Left 7}
        ClipBoard = %ClipboardOld%
        Return

;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; Process killer - Activate script; Click a window to close or Ctrl-click to kill it; Esc to end script
;   Author: Skrommel
;   Source: http://www.dcmembers.com/skrommel/download/kill/  (has some neat ideas there)
;--------------------------------------------------------------------------------------------------------------------------------------------------------------

    subroutine_ProcessKiller:
        #SingleInstance,Force
        CoordMode,Mouse,Screen

        MouseGetPos,x2,y2,winid,ctrlid
        wx:=x2+15
        wy:=y2+15
        Gui,+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border -ToolWindow
        Gui,Margin,0,0
        Gui,Color,AAAAAA
        Gui,Add,Picture,Icon1,C:\WINDOWS\system32\taskmgr.exe
        Gui,Show,X%wx% Y%wy% W32 H32 NoActivate,KillSkull
        WinSet,TransColor,AAAAAA,KillSkull

        Loop
        {
            MouseGetPos,x1,y1,winid,ctrlid
            If x1=%x2%
            If y1=%y2%
                Continue
            wx:=x1+15
            wy:=y1+15
            WinMove,KillSkull,,%wx%,%wy%
            GetKeyState,esc,Esc,P
            If esc=D
                Break
            GetKeyState,lbutton,LButton,P
            If lbutton=D
            {
                WinKill,ahk_id %winid%
                Break
            }
            x2=%x1%
            y2=%y2%
        }
        Gui,Destroy
        Return

;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; Hide Others (like Mac) - minimizes all windows other then the active window
;   Author: Lowell Heddings
;   Source: https://www.howtogeek.com/howto/windows-vista/get-macs-hide-others-cmdopth-keyboard-shortcut-for-windows/
;--------------------------------------------------------------------------------------------------------------------------------------------------------------

    subroutine_hideOthers:
        #SingleInstance,Force
        SetWinDelay,0

        If WinNotExist,ahk_id %id%
            WinRestore,A

        WinGet,id,ID,A
        WinGet,style,Style,ahk_id %id%
        If (style & 0x20000)
        {
            WinGet,winid_,List,,,Program Manager
            Loop,%winid_% 
            {
                StringTrimRight,winid,winid_%A_Index%,0
                If id=%winid%
                    Continue

                WinGet,style,Style,ahk_id %winid%
                If (style & 0x20000)
                {
                    WinGet,state,MinMax,ahk_id %winid%,
                    If state=-1
                        Continue

                    WinGetClass,class,ahk_id %winid%
                    If class=Shell_TrayWnd
                        Continue

                    IfWinExist,ahk_id %winid%
                        WinMinimize,ahk_id %winid%
                }
        }
        }

        return

;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; get linux drag window functionality
;   Author: Lowell Heddings
;   Source: https://www.howtogeek.com/howto/windows-vista/get-the-linux-altwindow-drag-functionality-in-windows/
;--------------------------------------------------------------------------------------------------------------------------------------------------------------

        ; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm
        ; by The How-To Geek
        ; http://www.howtogeek.com 

    subroutine_windowDrag:
        CoordMode, Mouse  ; Switch to screen/absolute coordinates.
        MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
        WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
        WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
        if EWD_WinState = 0  ; Only if the window isn't maximized 
            SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
        return

        EWD_WatchMouse:
        GetKeyState, EWD_LButtonState, LButton, P
        if EWD_LButtonState = U  ; Button has been released, so drag is complete.
        {
            SetTimer, EWD_WatchMouse, off
            return
        }
        GetKeyState, EWD_EscapeState, Escape, P
        if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
        {
            SetTimer, EWD_WatchMouse, off
            WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
            return
        }
        ; Otherwise, reposition the window to match the change in mouse coordinates
        ; caused by the user having dragged the mouse:
        CoordMode, Mouse
        MouseGetPos, EWD_MouseX, EWD_MouseY
        WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
        SetWinDelay, -1   ; Makes the below move faster/smoother.
        WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
        EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
        EWD_MouseStartY := EWD_MouseY
        return