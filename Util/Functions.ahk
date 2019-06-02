/*
 Function Documentation: http://ahkscript.org/docs/Functions.htm

 Examples:

 Add(x, y)
 {
     return x + y
 }

 Add(2, 3) ; Simply calls the function
 MyNumber := Add(2, 3) ; Stores the value

*/

;------------------------------------------------------------------------------------------------
;A function to open a file for editing in editor listed in settings.ini
;------------------------------------------------------------------------------------------------

    Edit(file)
    {
        global
        Run % Settings.EditorPath " " file
    }

;------------------------------------------------------------------------------------------------
;A function to escape characters like & for use in URLs.
;------------------------------------------------------------------------------------------------
    ;Currently Used by
    ;- PedersonGUI.ahk
    
    uriEncode(str) {
        f = %A_FormatInteger%
        SetFormat, Integer, Hex
        If RegExMatch(str, "^\w+:/{0,2}", pr)
            StringTrimLeft, str, str, StrLen(pr)
        StringReplace, str, str, `%, `%25, All
        Loop
            If RegExMatch(str, "i)[^\w\.~%/:]", char)
            StringReplace, str, str, %char%, % "%" . SubStr(Asc(char),3), All
            Else Break
        SetFormat, Integer, %f%
        Return, pr . str
    }

