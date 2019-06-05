/*
 HotString Documentation: http://ahkscript.org/docs/Hotstrings.htm

  !!!! NOTE:IF YOU ARE HAVING ISSUES GETTINGS NON-STANDARD CHARACTERS TO PRINT ON REPLACE
  RESAVE THIS FILE VIA NOTEPAD AND THE ISSUE WILL BE FIXED.  IF THIS MESSAGE IS STILL UP
  I HAVE NOT FOUND A PERMANENT SOLUTION THAT ALLOWS ME TO ONLY USE VISUAL STUDIO PRO !!!!
   -- PS SEEMS TO BE WORKING FINE FOR NOW, WILL LEAVE UP FOR A BIT AS A REMINDER --

 Examples:

 Single Line
 ::btw::by the way
 
 Multi-Line
 ::btw::
      MsgBox You typed "btw".
  Return
*/

;-------------------------------------------------------------------------------
;;; symbols ;;;
;-------------------------------------------------------------------------------

  #include %A_ScriptDir%\scripts\hotstrings\symbols\standard.ahk
        ;normal everyday symbols (like copyright)

  #include %A_ScriptDir%\scripts\hotstrings\symbols\currency.ahk
        ; hotstrings to easily print foreign currency

;-------------------------------------------------------------------------------
;;; foreign characters ;;;
;-------------------------------------------------------------------------------

  #include %A_ScriptDir%\scripts\hotstrings\foreign_chars\greek.ahk
        ; for inputting greek foreign characters