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

   ;Disable capslock
   SetCapsLockState, AlwaysOff
   ; Allow normal CapsLock functionality to be toggled by Alt+CapsLock:
   !CapsLock::
      GetKeyState, capsstate, CapsLock, T ;(T indicates a Toggle. capsstate is an arbitrary varible name)
      if capsstate = U
         SetCapsLockState, AlwaysOn
      else
         SetCapsLockState, AlwaysOff
      return

   /*

   ;Disable Numlock
   SetNumLockState, AlwaysOn
   ; Allow normal numlock functionality to be toggled by Alt+CapsLock:
   !NumLock::
      GetKeyState, numstate, Numlock, T ;(T indicates a Toggle. numstate is an arbitrary varible name)
      if numstate = U
         SetNumLockState, AlwaysOn
      else
         SetNumLockState, AlwaysOff
      return

      ;Disable ScrollLock
   SetScrollLockState, AlwaysOn
   ; Allow normal numlock functionality to be toggled by Alt+CapsLock:
   !ScrollLock::
      GetKeyState, scrollstate, ScrollLock, T ;(T indicates a Toggle. scrollstate is an arbitrary varible name)
      if numstate = U
         SetScrollLockState, AlwaysOn
      else
         SetScrollLockState, AlwaysOff
      return

   */

;-------------------------------------------------------------------------------
;;; LAYER 0 --- No Modifier ;;;
;-------------------------------------------------------------------------------
   ;For regular hotkeys without the use of layer keys


;-------------------------------------------------------------------------------
;;; LAYER 1 --- CAPSLOCK ;;;
;-------------------------------------------------------------------------------
   ; Capslock functionality turned off in PedersonGui Host.ahk with optional use via Miscellaneous.ahk from pederson GUI

   #If, GetKeyState("CapsLock", "P") ;CapsLock hotkeys go below




   ; AHK Functions
   F4::Reload     ; Reload entire script
   F12::Suspend   ; Suspends AutoHot Key


   ;Shortcuts

   w::Send {up}
   a::Send {left}
   s::Send {down}
   d::Send {right}

   ;WIN Shortcuts

   #n::
      Run, Notepad
   Return

;-------------------------------------------------------------------------------
;;; LAYER 2 --- Numlock ;;;
;-------------------------------------------------------------------------------
   #If, GetKeyState("Numlock", "P") ;CapsLock hotkeys go below

;-------------------------------------------------------------------------------
;;; LAYER 3 --- Scroll Lock ;;;
;-------------------------------------------------------------------------------
   #If, GetKeyState("ScrollLock", "P") ;CapsLock hotkeys go below

