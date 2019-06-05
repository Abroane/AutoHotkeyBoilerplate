; http://ahkscript.org/germans/forums/viewtopic.php?t=6803
; Klavier Hero 2010 (AHK v1.1  x32-x64 Unicode-ANSI - UK-US  Keyboard).ahk
; Klavier Hero by Bentschi
; Modified version to support AHK v1.1 x64/x32 Unicode/ANSI and UK keyboard

#SingleInstance, force

Volume=100
Device=0 ;(0=Standard)
Instrument=1 ;Klavier
Channel=1
Oktav=1

KbdW = 400
KbdH = 80
DrawMode = 1 ;OpenGL

Instruments =
(Join|
1 Acoustic Grand Piano|
2 Bright Piano
3 Electric Grand Piano
4 Honky-tonk piano
5 Electric Piano 1
6 Electric Piano 2
7 Harpsichord
8 Clav
9 Celesta
10 Glockenspiel
11 Music Box
12 Vibraphone
13 Marimba
14 Xylophone
15 Tubular Bells
16 Dulcimer
17 Drawbar Organ
18 Percussive Organ
19 Rock Organ
20 Church Organ
21 Reed Organ
22 Accordian
23 Harmonica
24 Tango Accordian
25 Nylon String Guitar
26 Steel String Guitar
27 Jazz Guitar
28 Clean Electric Guitar
29 Muted Electric Guitar
30 Overdrive Guitar
31 Distortion Guitar
32 Guitar Harmonics
33 Acoustic Bass
34 Fingered Bass
35 Picked Bass
36 Fretless Bass
37 Slap Bass 1
38 Slap Bass 2
39 Synth Bass 1
40 Synth Bass 2
41 Violin
42 Viola
43 Cello
44 Contrabass
45 Tremolo Strings
46 Pizzicato Strings
47 Orchestral Harp
48 Timpani
49 String Ensemble 1
50 String Ensemble 2
51 Synth Strings 1
52 Synth Strings 2
53 Choir Ahh
54 Choir Oohh
55 Synth Voice
56 Orchestral Hit
57 Trumpet
58 Trombone
59 Tuba
60 Muted Trumpet
61 French Horn
62 Brass Section
63 Synth Brass 1
64 Synth Brass 2
65 Soprano Sax
66 Alto Sax
67 Tenor Sax
68 Baritone Sax
69 Oboe
70 English Horn
71 Bassoon
72 Clarinet
73 Piccolo
74 Flute
75 Recorder
76 Pan Flute
77 Blown Bottle
78 Shakuhachi
79 Whistle
80 Ocarina
81 Square Wav
82 Sawtooth Wav
83 Caliope
84 Chiff
85 Charang
86 Voice
87 Fifth's
88 Bass&Lead
89 New Age
90 Warm
91 Polysynth
92 Choir
93 Bowed
94 Metallic
95 Halo
96 Sweep
97 FX Rain
98 FX Soundtrack
99 FX Crystal
100 FX Atmosphere
101 FX Brightness
102 FX Goblins
103 FX Echo Drops
104 FX Star Theme
105 Sitar
106 Banjo
107 Shamisen
108 Koto
109 Kalimba
110 Bagpipe
111 Fiddle
112 Shanai
113 Tinkle Bell
114 Agogo
115 Steel Drums
116 Woodblock
117 Taiko Drum
118 Melodic Tom
119 Synth Drum
120 Reverse Cymbal
121 Guitar Fret Noise
122 Breath Noise
123 Seashore
124 Bird Tweet
125 Telephone Ring
126 Helicopter
127 Applause
128 Gunshot
)
WM_KEYDOWN = 0x100
WM_KEYUP = 0x101
WM_LBUTTONDOWN = 0x201
WM_LBUTTONUP = 0x202

/* ;German keyboard
HotkeysLine1 = 226, 65, 89, 83, 88, 68, 67, 86, 71, 66, 72, 78, 77, 75, 188, 76, 190, 192, 189
; <aysxdcvgbhnmk,l.�-
HotkeysLine2 = 81, 50, 87, 51, 69, 82, 53, 84, 54, 90, 55, 85, 73, 57, 79, 48, 80
; q2w3er5t6z7ui9o0p��+
*/

; UK/US keyboard
HotkeysLine1 = 220,65,90,83,88,68,67,86,71,66,72,78,77,75,188,76,190,186,191
; \azsxdcvgbhnmk,l.;/
HotkeysLine2 = 81,50,87,51,69,82,53,84,54,89,55,85,73,57,79,48,80,219,187,221
; q2w3er5t6y7ui9o0p[=]

Hotkeys := HotkeysLine1 ", " HotkeysLine2
Loop, parse, HotKeys, `,, % A_Space A_Tab
{
  Key%A_Loopfield% := A_Index
  MKey%A_Index% := A_Loopfield
  NumKeys := A_Index
}

WinMM_Lib := DllCall("LoadLibrary", Str, "Winmm.dll", Ptr)
NumDevs := DllCall("winmm.dll\midiOutGetNumDevs", UInt)
loop, % NumDevs
{
  VarSetCapacity(DevCaps, 52, 0)
  DllCall("winmm.dll\midiOutGetDevCapsA", UPtr, A_Index-1, Ptr, &DevCaps, UInt, 52, UInt)
  Name =
  Loop, 32
  {
    Name .= Chr(NumGet(DevCaps, A_Index+7, "UChar"))
  }
  VarSetCapacity(DevCaps, 0)
  DevName%A_Index% := Name
  if A_Index = 1
    DevNames := Name
  else
    DevNames .= "|" Name
}
Gui, add, ddl, x-200 y-200 w0 h0 vFocusButton
Gui, add, text, x10 y10 cBlue, Instrument:
Gui, add, listbox, xp y+3 w150 h300 +Altsubmit gChooseInstr vList, % Instruments
Gui, add, text, x+10 y10 cBlue, Treiber:
Gui, add, ddl, xp y+3 w200 +Altsubmit vDev gChooseDev, % DevNames
GuiControl, Choose, Dev, % Device+1
Gui, add, text, xp y+15 cBlue, Velocity:
Gui, add, slider, xp y+3 w200 vVol gChooseVol +0x100 range0-127, % Volume
Gui, add, text, xp y+5 cBlue, Kanal:
Gui, add, ddl, xp y+3 w200 +Altsubmit vChannel gChooseChannel, Kanal 1||Kanal 2|Kanal 3|Kanal 4
Gui, add, text, xp y+15 cBlue, Virtuelles Klavier:
Gui, add, ddl, xp y+3 w200 +AltSubmit vDrawMode gChooseDrawMode, [Ausblenden]|OpenGL
Gui, add, text, xp y+15 cBlue, Oktav:
Gui, add, edit, xp y+3 w200
Gui, add, updown, range-2-4 vOktav gChooseOktav, % Oktav
GuiControl, Choose, DrawMode, % DrawMode+1
Gui +LastFound
hWnd := WinExist()
Gui, show,, Klavier Hero 2010
Gosub, InitMidi
OnExit, ExitSub
OnMessage(WM_KEYDOWN, "PlayTone", 10)
OnMessage(WM_KEYUP, "ReleaseTone", 10)
OnMessage(WM_LBUTTONDOWN, "MouseClick")
OnMessage(WM_LBUTTONUP, "MouseRelease")
Gosub, EnableDraw
return

ChooseDev:
GuiControlGet, Device,, Dev
Device -= 1
return

ChooseVol:
GuiControlGet, Volume,, Vol
return

ChooseChannel:
GuiControlGet, Channel
return

ChooseOktav:
GuiControlGet, Oktav
return

InitMidi:
if (Device > NumDevs)
  Device = 0
if (hMidiOut)
  Gosub, FreeMidi
midiOutShortMsg := DllCall("GetProcAddress", Ptr, WinMM_Lib, AStr, "midiOutShortMsg", Ptr)
VarSetCapacity(hMidiOutp, A_PtrSize, 0)
DllCall("winmm.dll\midiOutOpen", Ptr, &hMidiOutp, UInt, Device, UPtr, 0, UPtr, 0, UInt, 0, UInt)
hMidiOut := NumGet(hMidiOutp, 0, "Ptr")
VarSetCapacity(hMidiOutp, 0)
return

ChooseInstr:
GuiControlGet, Instrument,, List
Instrument -= 1
return

FreeMidi:
DllCall("winmm.dll\midiOutReset", Ptr, hMidiOut, UInt)
DllCall("winmm.dll\midiOutClose", Ptr, hMidiOut, UInt)
return

GuiClose:
ExitSub:
Gui, hide
GoSub, DisableDraw
GoSub, FreeMidi
DllCall("FreeLibrary", Ptr, WinMM_Lib)
ExitApp

PlayTone(wParam, lParam)
{
  Global
  Local cTone
  ;Tooltip, % wParam

  if (Key%wParam%) && (Key%wParam%down!=1)
  {
    cTone := (Key%wParam% + 52) + ((Oktav - 1) * 12)
    GuiControl, Focus, Focusbutton
    DllCall(midiOutShortMsg, Ptr, hMidiOut, UInt, (256 * Instrument) + Channel+191, UInt)
    DllCall(midiOutShortMsg, Ptr, hMidiOut, UInt, (65536 * Volume) + (256 * cTone) + Channel+143, UInt)
    KeyIndex := Key%wParam%
    Key%wParam%down=1
    KeyI%KeyIndex%down=1
  }
  return
}

ReleaseTone(wParam, lParam)
{
  Global
  Local cTone
  if (Key%wParam%down=1)
  {
    KeyIndex := Key%wParam%
    Key%wParam%down=0
    KeyI%KeyIndex%down=0
    cTone := (Key%wParam% + 52) + ((Oktav - 1) * 12)
    DllCall(midiOutShortMsg, Ptr, hMidiOut, UInt, (65536 * Volume) + (256 * cTone) + Channel+127, UInt)
  }
  return
}

MouseClick(wParam, lParam, msg, handle)
{
  Global
  if (DrawMode) && (handle=hWnd2)
  {
    MouseClick = 0
    MouseX := (lParam & 0xFFFF) / KbdW * 100
    MouseY := (lParam >> 16) / KbdH * 10
    CalcXPos := KeyWW - (KeyBW / 2)
    Index = 1
    Loop, % NumKeys
    {
      if Index in 2,4,6,9,11
      {
        if (MouseX < (CalcXPos + KeyBW)) && (MouseX > CalcXPos) && (MouseY < 10/4*2.5)
        {
          MouseClick := A_Index
          break
        }
        CalcXPos := CalcXPos + KeyWW
      }
      if Index in 6,11
        CalcXPos := CalcXPos + KeyWW
      Index++
      if Index > 12
        Index = 1
    }
    if !(MouseClick)
    {
      CalcXPos = 0
      Index = 1
      Loop, % NumKeys
      {
        if Index in 1,3,5,7,8,10,12
        {
          if (MouseX > CalcXPos) && (MouseX < (CalcXPos + KeyWW))
          {
            MouseClick := A_Index
            break
          }
          CalcXPos := CalcXPos + KeyWW
        }
        Index++
        if Index > 12
          Index = 1
      }
    }
    PlayTone(MKey%MouseClick%, 0)
  }
  return
}

MouseRelease(wParam, lParam, msg, handle)
{
  Global
  ReleaseTone(MKey%MouseClick%, 0)
  MouseClick = 0
  return
}

ChooseDrawMode:
GuiControlGet, DrawMode
DrawMode--

EnableDraw:
Gui, 2: +LastFound +Resize -MinimizeBox -MaximizeBox -dpiscale
hWnd2 := WinExist()
if (DrawModeInit)
  gosub, DisableDraw
if (DrawMode=1)
  goto, InitOpenGL
return

2GuiClose:
GuiControl, 1:Choose, DrawMode, 1
DisableDraw:
Gui, 2:hide
if (DrawModeInit=1)
{
  SetTimer, UpdateOpenGL, Off
  DllCall("opengl32.dll\wglMakeCurrent", Ptr, 0, Ptr, 0)
  DllCall("opengl32.dll\wglDeleteContext", Ptr, hRC)
  DllCall("ReleaseDC", Ptr, hWnd2, Ptr, hDC)
  DllCall("FreeLibrary", Ptr, hOpenGL)
  DllCall("FreeLibrary", Ptr, hGdi32)
}
DrawModeInit=0
return

2GuiSize:
KbdW := A_GuiWidth
KbdH := A_GuiHeight
return

InitOpenGL:
DrawModeInit=1
hOpenGL := DllCall("LoadLibrary", Str, "opengl32.dll", Ptr)
hGdi32  := DllCall("LoadLibrary", Str, "gdi32.dll", Ptr)
hDC := DllCall("GetDC", Ptr, hWnd2, Ptr)
VarSetCapacity(pfd, 40, 0)
NumPut(40, pfd, 0, "UShort")
NumPut(1, pfd, 2, "UShort")
NumPut((0x04 | 0x20 | 0x01), pfd, 4, "UInt")
NumPut(32, pfd, 9, "UChar")
NumPut(16, pfd, 23, "UChar")
NumPut(0, pfd, 8, "UChar")
NumPut(0, pfd, 26, "UChar")
PixelFormat := DllCall("ChoosePixelFormat", Ptr, hDC, Ptr, &pfd)
DllCall("SetPixelFormat", Ptr, hDC, Int, PixelFormat, Ptr, &pfd)
hRC := DllCall("opengl32.dll\wglCreateContext", Ptr, hDC, Ptr)
DllCall("opengl32.dll\wglMakeCurrent", Ptr, hDC, Ptr, hRC)
SwapBuffers := DllCall("GetProcAddress", Ptr, hGdi32, AStr, "SwapBuffers", Ptr)
glClear := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glClear", Ptr)
glViewport := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glViewport", Ptr)
glMatrixMode := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glMatrixMode", Ptr)
glLoadIdentity := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glLoadIdentity", Ptr)
glOrtho := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glOrtho", Ptr)
glVertex2f := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glVertex2f", Ptr)
glScalef := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glScalef", Ptr)
glTranslatef := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glTranslatef", Ptr)
glCallList := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glCallList", Ptr)
glPushMatrix := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glPushMatrix", Ptr)
glPopMatrix := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glPopMatrix", Ptr)
glColor4f := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glColor4f", Ptr)
glEnable := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glEnable", Ptr)
glDisable := DllCall("GetProcAddress", Ptr, hOpenGL, AStr, "glDisable", Ptr)
GL_COLOR_BUFFER_BIT := 0x00004000
GL_MODELVIEW := 0x1700

GL_PROJECTION := 0x1701
GL_COMPILE := 0x1300
GL_TRIANGLES := 0x0004
GL_QUADS := 0x0007
GL_LINE_LOOP := 0x0002
GL_BLEND := 0x0BE2
GL_SRC_ALPHA := 0x0302

GL_ONE_MINUS_SRC_ALPHA := 0x0303
GL_LINE_SMOOTH := 0x0B20
DllCall("opengl32.dll\glBlendFunc", Int, GL_SRC_ALPHA, Int, GL_ONE_MINUS_SRC_ALPHA)

NumWKeys=0
Index = 1
Loop, % NumKeys
{
  if Index in 1,3,5,7,8,10,12
    NumWKeys++
  Index++
  if Index > 12
    Index = 1
}
KeyWW := 100/NumWKeys
KeyBW := KeyWW/4*2.5
KeyC := 5
List := DllCall("opengl32.dll\glGenLists", Int, 6, UInt)
DllCall("opengl32.dll\glNewList", UInt, List+0, Int, GL_COMPILE)
DllCall(glLoadIdentity)
DllCall("opengl32.dll\glColor4f", Float, 0, Float, 0, Float, 0, Float, 1)
DllCall("opengl32.dll\glBegin", Int, GL_LINE_LOOP)
DllCall(glVertex2f, Float, 0.001, Float, 0.001)
DllCall(glVertex2f, Float, 0.001, Float, 9.999)
DllCall(glVertex2f, Float, 99.999, Float, 9.999)
DllCall(glVertex2f, Float, 99.999, Float, 0.001)
DllCall("opengl32.dll\glEnd")
DllCall("opengl32.dll\glEndList")

DllCall("opengl32.dll\glNewList", UInt, List+1, Int, GL_COMPILE)
DllCall("opengl32.dll\glBegin", Int, GL_QUADS)
DllCall("opengl32.dll\glColor4f", Float, 0.5, Float, 0.5, Float, 0.5, Float, 1)
DllCall(glVertex2f, Float, 0, Float, 0)
DllCall(glVertex2f, Float, KeyWW, Float, 0)
DllCall("opengl32.dll\glColor4f", Float, 1, Float, 1, Float, 1, Float, 1)
DllCall(glVertex2f, Float, KeyWW, Float, 1)
DllCall(glVertex2f, Float, 0, Float, 1)
DllCall(glVertex2f, Float, 0, Float, 1)
DllCall(glVertex2f, Float, KeyWW, Float, 1)
DllCall(glVertex2f, Float, KeyWW, Float, 9.6)
DllCall(glVertex2f, Float, 0, Float, 9.6)
DllCall("opengl32.dll\glEnd")
DllCall("opengl32.dll\glColor4f", Float, 0, Float, 0, Float, 0, Float, 1)
DllCall("opengl32.dll\glBegin", Int, GL_LINE_LOOP)
DllCall(glVertex2f, Float, 0, Float, 0)
DllCall(glVertex2f, Float, KeyWW, Float, 0)
DllCall(glVertex2f, Float, KeyWW, Float, 9.6)
DllCall(glVertex2f, Float, 0, Float, 9.6)
DllCall("opengl32.dll\glEnd")
DllCall("opengl32.dll\glTranslatef", Float, KeyWW, Float, 0, Float, 0)
DllCall("opengl32.dll\glEndList")

DllCall("opengl32.dll\glNewList", UInt, List+2, Int, GL_COMPILE)
DllCall("opengl32.dll\glTranslatef", Float, KeyWW, Float, 0, Float, 0)
DllCall("opengl32.dll\glBegin", Int, GL_QUADS)
DllCall("opengl32.dll\glColor4f", Float, 0.15, Float, 0.15, Float, 0.15, Float, 1)
DllCall(glVertex2f, Float, -(KeyBW/2), Float, 0)
DllCall(glVertex2f, Float, KeyBW/2, Float, 0)
DllCall(glVertex2f, Float, KeyBW/2, Float, 10/4*2.5)
DllCall(glVertex2f, Float, -(KeyBW/2), Float, 10/4*2.5)
DllCall("opengl32.dll\glColor4f", Float, 0.2, Float, 0.2, Float, 0.2, Float, 1)
DllCall(glVertex2f, Float, -(KeyBW/4), Float, 0.5)
DllCall(glVertex2f, Float, KeyBW/4, Float, 0.5)
DllCall("opengl32.dll\glColor4f", Float, 0.5, Float, 0.5, Float, 0.5, Float, 1)
DllCall(glVertex2f, Float, KeyBW/4, Float, 10/4*2.0)
DllCall(glVertex2f, Float, -(KeyBW/4), Float, 10/4*2.0)
DllCall("opengl32.dll\glColor4f", Float, 0.2, Float, 0.2, Float, 0.2, Float, 1)
DllCall(glVertex2f, Float, -(KeyBW/4), Float, 0.5)
DllCall(glVertex2f, Float, KeyBW/4, Float, 0.5)
DllCall("opengl32.dll\glColor4f", Float, 0.5, Float, 0.5, Float, 0.5, Float, 1)
DllCall(glVertex2f, Float, KeyBW/2, Float, 0)
DllCall(glVertex2f, Float, -(KeyBW/2), Float, 0)
DllCall("opengl32.dll\glColor4f", Float, 0.3, Float, 0.3, Float, 0.3, Float, 1)
DllCall(glVertex2f, Float, -(KeyBW/4), Float, 10/4*2.0)
DllCall(glVertex2f, Float, KeyBW/4, Float, 10/4*2.0)
DllCall("opengl32.dll\glColor4f", Float, 0.2, Float, 0.2, Float, 0.2, Float, 1)
DllCall(glVertex2f, Float, KeyBW/2, Float, 10/4*2.5)
DllCall(glVertex2f, Float, -(KeyBW/2), Float, 10/4*2.5)
DllCall("opengl32.dll\glEnd")
DllCall("opengl32.dll\glEndList")

DllCall("opengl32.dll\glNewList", UInt, List+3, Int, GL_COMPILE)
DllCall("opengl32.dll\glBegin", Int, GL_QUADS)
DllCall("opengl32.dll\glColor4f", Float, 0.4, Float, 0.4, Float, 0.4, Float, 1)
DllCall(glVertex2f, Float, 0, Float, 0)
DllCall(glVertex2f, Float, KeyWW, Float, 0)
DllCall("opengl32.dll\glColor4f", Float, 0.9, Float, 0.9, Float, 0.9, Float, 1)
DllCall(glVertex2f, Float, KeyWW, Float, 1.5)
DllCall(glVertex2f, Float, 0, Float, 1.5)
DllCall(glVertex2f, Float, 0, Float, 1.5)
DllCall(glVertex2f, Float, KeyWW, Float, 1.5)
DllCall("opengl32.dll\glColor4f", Float, 0.7, Float, 0.7, Float, 0.7, Float, 1)
DllCall(glVertex2f, Float, KeyWW, Float, 9.6)
DllCall(glVertex2f, Float, 0, Float, 9.6)
DllCall(glVertex2f, Float, 0, Float, 9.6)
DllCall(glVertex2f, Float, KeyWW, Float, 9.6)
DllCall(glVertex2f, Float, KeyWW-0.4, Float, 9.7)
DllCall(glVertex2f, Float, 0.4, Float, 9.7)
DllCall("opengl32.dll\glEnd")
DllCall("opengl32.dll\glColor4f", Float, 0, Float, 0, Float, 0, Float, 1)
DllCall("opengl32.dll\glBegin", Int, GL_LINE_LOOP)
DllCall(glVertex2f, Float, 0, Float, 0)
DllCall(glVertex2f, Float, KeyWW, Float, 0)
DllCall(glVertex2f, Float, KeyWW, Float, 9.6)
DllCall(glVertex2f, Float, KeyWW-0.4, Float, 9.7)
DllCall(glVertex2f, Float, 0.4, Float, 9.7)
DllCall(glVertex2f, Float, 0, Float, 9.6)
DllCall("opengl32.dll\glEnd")
DllCall("opengl32.dll\glTranslatef", Float, KeyWW, Float, 0, Float, 0)
DllCall("opengl32.dll\glEndList")

DllCall("opengl32.dll\glNewList", UInt, List+4, Int, GL_COMPILE)
DllCall("opengl32.dll\glTranslatef", Float, KeyWW, Float, 0, Float, 0)
DllCall("opengl32.dll\glBegin", Int, GL_QUADS)
DllCall("opengl32.dll\glColor4f", Float, 0, Float, 0, Float, 0, Float, 1)
DllCall(glVertex2f, Float, -(KeyBW/2), Float, 0)
DllCall(glVertex2f, Float, KeyBW/2, Float, 0)
DllCall(glVertex2f, Float, KeyBW/2, Float, 10/4*2.5)
DllCall(glVertex2f, Float, -(KeyBW/2), Float, 10/4*2.5)
DllCall("opengl32.dll\glColor4f", Float, 0.1, Float, 0.1, Float, 0.1, Float, 1)
DllCall(glVertex2f, Float, -(KeyBW/4), Float, 0.5)
DllCall(glVertex2f, Float, KeyBW/4, Float, 0.5)
DllCall("opengl32.dll\glColor4f", Float, 0.25, Float, 0.25, Float, 0.25, Float, 1)
DllCall(glVertex2f, Float, KeyBW/4, Float, 10/4*2.0)
DllCall(glVertex2f, Float, -(KeyBW/4), Float, 10/4*2.0)
DllCall("opengl32.dll\glColor4f", Float, 0.1, Float, 0.1, Float, 0.1, Float, 1)
DllCall(glVertex2f, Float, -(KeyBW/4), Float, 0.5)
DllCall(glVertex2f, Float, KeyBW/4, Float, 0.5)
DllCall("opengl32.dll\glColor4f", Float, 0.25, Float, 0.25, Float, 0.25, Float, 1)
DllCall(glVertex2f, Float, KeyBW/2, Float, 0)
DllCall(glVertex2f, Float, -(KeyBW/2), Float, 0)
DllCall("opengl32.dll\glColor4f", Float, 0.15, Float, 0.15, Float, 0.15, Float, 1)
DllCall(glVertex2f, Float, -(KeyBW/4), Float, 10/4*2.0)
DllCall(glVertex2f, Float, KeyBW/4, Float, 10/4*2.0)
DllCall("opengl32.dll\glColor4f", Float, 0.1, Float, 0.1, Float, 0.1, Float, 1)
DllCall(glVertex2f, Float, KeyBW/2, Float, 10/4*2.5)
DllCall(glVertex2f, Float, -(KeyBW/2), Float, 10/4*2.5)
DllCall("opengl32.dll\glEnd")
DllCall("opengl32.dll\glEndList")

PointSize = 1
DllCall("opengl32.dll\glNewList", UInt, List+5, Int, GL_COMPILE)
DllCall("opengl32.dll\glEnable", Int, GL_BLEND)
DllCall("opengl32.dll\glBegin", Int, GL_TRIANGLES)
DllCall("opengl32.dll\glColor4f", Float, 1, Float, 0, Float, 0, Float, 1)
DllCall(glVertex2f, Float, 0, Float, 0)
DllCall("opengl32.dll\glColor4f", Float, 1, Float, 0, Float, 0, Float, 0)
DllCall(glVertex2f, Float, 0, Float, PointSize)
DllCall(glVertex2f, Float, sin(10.0531)*PointSize, Float, -(cos(10.0531)*PointSize))
DllCall("opengl32.dll\glEnd")
DllCall("opengl32.dll\glDisable", Int, GL_BLEND)
DllCall("opengl32.dll\glEndList")

DllCall("opengl32.dll\glNewList", UInt, List+6, Int, GL_COMPILE)
DllCall("opengl32.dll\glTranslatef", Float, 0, Float, 8, Float, 0)
DllCall(glScalef, Float, 1.2, Float, 1, Float, 1)
Loop, 10
{
  DllCall(glCallList, UInt, List+5)
  DllCall("opengl32.dll\glRotatef", Float, 36, Float, 0, Float, 0, Float, 1)
}
DllCall("opengl32.dll\glEndList")
FontOut := DllCall("opengl32.dll\glGenLists", Int, Asc("Z")-Asc("A")+1, UInt)
FontIn := DllCall("opengl32.dll\glGenLists", Int, Asc("Z")-Asc("A")+1, UInt)
hFont := DllCall("CreateFont", Int, -1, Int, 0, Int, 0, Int, 0, Int, 800, UInt, 0, UInt, 0, UInt, 0, UInt, 0, UInt, 4, UInt, 0, UInt, 4, UInt, 0, Ptr, 0, Ptr)
DllCall("SelectObject", Ptr, hDC, Ptr, hFont, Ptr)
VarSetCapacity(gmf, (Asc("Z")-Asc("A")+1)*24, 0)
DllCall("opengl32.dll\wglUseFontOutlinesA", Ptr, hDC, UInt, Asc("A"), UInt, Asc("Z")-Asc("A")+1, UInt, FontOut, Float, 0, Float, 0.2, Int, 0, Ptr, &gmf)
DllCall("opengl32.dll\wglUseFontOutlinesA", Ptr, hDC, UInt, Asc("A"), UInt, Asc("Z")-Asc("A")+1, UInt, FontIn, Float, 0, Float, 0.2, Int, 1, Ptr, 0)
Gui, 2:show, w%KbdW% h%KbdH%, Virtuelles Klavier
SetTimer, UpdateOpenGL, 50
return

UpdateOpenGL:
Critical
DllCall(glClear, UInt, GL_COLOR_BUFFER_BIT)
DllCall(glViewport, Int, 0, Int, 0, Int, KbdW, Int, KbdH)
DllCall(glMatrixMode, Int, GL_PROJECTION)
DllCall(glLoadIdentity)
DllCall(glOrtho, Double, 0, Double, 100, Double, 10, Double, 0, Double, -1, Double, 1)
DllCall(glMatrixMode, Int, GL_MODELVIEW)
DllCall(glLoadIdentity)
Index = 1
cOktav = 1
Loop, % NumKeys
{
  if Index in 1,3,5,7,8,10,12
  {
    DllCall(glCallList, UInt, ((KeyI%A_Index%down) ? List+3 : List+1))
    if (MKey%A_Index% >= Asc("A")) && (MKey%A_Index% <= Asc("Z"))
    {
      DllCall(glPushMatrix)
      DllCall(glTranslatef, Float, -(KeyWW*0.8), Float, 9, Float, 0)
      DllCall(glScalef, Float, 3, Float, -3, Float, 1)
      DllCall(glPushMatrix)
      if (Index = 8) && (cOktav = Oktav)
        DllCall(glColor4f, Float, 1, Float, 0.5, Float, 0.5, Float, 0.5)
      else
        DllCall(glColor4f, Float, 0.7, Float, 0.7, Float, 0.7, Float, 0.5)
      DllCall(glEnable, Int, GL_BLEND)
      DllCall(glEnable, Int, GL_LINE_SMOOTH)
      DllCall(glCallList, UInt, FontOut+MKey%A_Index%-Asc("A"))
      DllCall(glDisable, Int, GL_LINE_SMOOTH)
      DllCall(glDisable, Int, GL_BLEND)
      DllCall(glPopMatrix)
      if (Index = 8) && (cOktav = Oktav)
        DllCall(glColor4f, Float, 1, Float, 0.5, Float, 0.5, Float, 1)
      else
        DllCall(glColor4f, Float, 0.7, Float, 0.7, Float, 0.7, Float, 1)
      DllCall(glCallList, UInt, FontIn+MKey%A_Index%-Asc("A"))
      DllCall(glPopMatrix)
    }
  }
  Index++
  if Index > 12
  {
    Index = 1
    cOktav--
  }
}
DllCall(glLoadIdentity)
Index = 1
Loop, % NumKeys
{
  if Index in 2,4,6,9,11
    DllCall(glCallList, UInt, ((KeyI%A_Index%down) ? List+4 : List+2))
  if Index in 6,11
    DllCall(glTranslatef, Float, KeyWW, Float, 0, Float, 0)
  Index++
  if Index > 12
    Index = 1
}
;DllCall(glLoadIdentity)
;DllCall("opengl32.dll\glTranslatef", Float, KeyWW*4.5, Float, 0, Float, 0)
;DllCall(glCallList, UInt, List+6)
DllCall(SwapBuffers, Ptr, hDC)
return