#SingleInstance, Force
SetBatchLines, -1
;Thanks to tic (Tariq Porter) for his GDI+ Library
;ahkscript.org/boards/viewtopic.php?t=6517

; Start gdi+
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

; GUI 2 IS THE MENU GUI. 
Gui, 2:  +E0x80000 +LastFound +AlwaysOnTop +OwnDialogs -Caption +ToolWindow
Gui, 2: Show,, ArchMage Gray
hwnd2 := WinExist()

LoadMenuSprites()

If !pBitmapMenu
{
	MsgBox, 48, File loading error!, Could not load the background image.
	ExitApp
}

Width := 512, Height := 512
hbm2 := CreateDIBSection(Width, Height)
hdc2 := CreateCompatibleDC()
obm2 := SelectObject(hdc2, hbm2)
G2 := Gdip_GraphicsFromHDC(hdc2)
Gdip_SetInterpolationMode(G2, 7)

; GUI 3 IS THE FRAME GUI.
Gui, 3: +E0x80000 +LastFound +AlwaysOnTop +OwnDialogs -Caption +ToolWindow
Gui, 3: Show, NA, ARCHMAGE_FRAME
hwnd3 := WinExist()

Width_Frame := 658, Height_Frame := 638
hbm3 := CreateDIBSection(Width_Frame, Height_Frame)
hdc3 := CreateCompatibleDC()
obm3 := SelectObject(hdc3, hbm3)
G3 := Gdip_GraphicsFromHDC(hdc3)
Gdip_SetInterpolationMode(G3, 7)
Gdip_DrawImage(G3, pBitmapFrame, 0, 0, 658, 638, 0, 0, 658, 638)
Window_X_Pos_Frame := (A_ScreenWidth - 658) / 2
Window_Y_Pos_Frame := (A_ScreenHeight - 638) / 2
UpdateLayeredWindow(hwnd3, hdc3, Window_X_Pos_Frame, Window_Y_Pos_Frame, Width_Frame, Height_Frame)

ReturnToMenu:
Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
Window_X_Pos := (A_ScreenWidth - 512) / 2
Window_Y_Pos := (A_ScreenHeight - 512) / 2
UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)

If !(IsObject(WMAPING))
{
	WMAPING := ComObjCreate("WMPlayer.OCX")
	WMAPING.url := A_ScriptDir . "/Sounds/PING.wav"
}
if (WMAPING.controls.isAvailable("stop"))
{
	WMAPING.controls.stop		
}

SetTimer, PlayIntro, 142000
Gosub, PlayIntro

Sleep 4000

if (WMAPING.controls.isAvailable("play"))
{
	WMAPING.controls.play		
}

Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)

Sleep 750
Gdip_DrawImage(G2, pBitmapPlayOption, 0, 0, 512, 512, 0, 0, 512, 512)
UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)

Sleep 750
Gdip_DrawImage(G2, pBitmapIntroOption, 0, 0, 512, 512, 0, 0, 512, 512)
UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)

Sleep 750
Gdip_DrawImage(G2, pBitmapInstructionsOption, 0, 0, 512, 512, 0, 0, 512, 512)
UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)

Sleep 750
Gdip_DrawImage(G2, pBitmapCreditsOption, 0, 0, 512, 512, 0, 0, 512, 512)
UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)

Sleep 750
Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)

Sleep 1000
if (WMAPING.controls.isAvailable("play"))
{
	WMAPING.controls.play		
}
Gdip_DrawImage(G2, pBitmapPlayOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)

CURRENT_MENU_OPTION := 1
IS_MENU_ACTIVE := 1
OnMessage(0x100, "CheckInputDown")
OnMessage(0x201, "CheckMouseLeftClickDown")
Return



PlayIntro:
	If !(IsObject(WMA1))
	{
		WMA1 := ComObjCreate("WMPlayer.OCX")
		WMA1.url := A_ScriptDir . "/Sounds/Intro.wav"
	}
	if (WMA1.controls.isAvailable("stop"))
	{
		wma1.controls.stop		
	}
	if (WMA1.controls.isAvailable("play"))
	{
		wma1.controls.play		
	}
Return

CheckInputDown(WParam, LParam, msg, hwnd)
{
	Global 
	If (WParam = 0x28) ; Down Arrow Key
	{
		If ((CURRENT_MENU_OPTION = 4) AND (IS_MENU_ACTIVE = 1))
		{
			Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapIntroOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapCreditsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapInstructionsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
			
			Gdip_DrawImage(G2, pBitmapPlayOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			CURRENT_MENU_OPTION := 1
		}
		Else if ((CURRENT_MENU_OPTION = 1) AND (IS_MENU_ACTIVE = 1))
		{
			Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapPlayOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapCreditsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapInstructionsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
			
			Gdip_DrawImage(G2, pBitmapIntroOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			CURRENT_MENU_OPTION := 2
		}
		Else if ((CURRENT_MENU_OPTION = 2) AND (IS_MENU_ACTIVE = 1))
		{
			Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapPlayOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapIntroOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapCreditsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
			
			Gdip_DrawImage(G2, pBitmapInstructionsOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			CURRENT_MENU_OPTION := 3
		}
		Else if ((CURRENT_MENU_OPTION = 3) AND (IS_MENU_ACTIVE = 1))
		{
			Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapPlayOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapIntroOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapInstructionsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
			
			Gdip_DrawImage(G2, pBitmapCreditsOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			CURRENT_MENU_OPTION := 4
		}
	}
	Else If (WParam = 0x26) ; Up Arrow Key
	{
		If ((CURRENT_MENU_OPTION = 1) AND (IS_MENU_ACTIVE = 1))
		{
			Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapPlayOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapIntroOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapInstructionsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
			
			Gdip_DrawImage(G2, pBitmapCreditsOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			CURRENT_MENU_OPTION := 4
		}
		Else if ((CURRENT_MENU_OPTION = 4) AND (IS_MENU_ACTIVE = 1))
		{
			Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapPlayOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapIntroOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapCreditsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
			
			Gdip_DrawImage(G2, pBitmapInstructionsOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			CURRENT_MENU_OPTION := 3
		}
		Else if ((CURRENT_MENU_OPTION = 3) AND (IS_MENU_ACTIVE = 1))
		{
			Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapPlayOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapCreditsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapInstructionsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
			
			Gdip_DrawImage(G2, pBitmapIntroOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			CURRENT_MENU_OPTION := 2
		}
		Else if ((CURRENT_MENU_OPTION = 2) AND (IS_MENU_ACTIVE = 1))
		{
			Gdip_DrawImage(G2, pBitmapMenu, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapTitle, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapIntroOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapCreditsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapInstructionsOption, 0, 0, 512, 512, 0, 0, 512, 512)
			Gdip_DrawImage(G2, pBitmapVersionInfo, 0, 0, 512, 512, 0, 0, 512, 512)
			
			Gdip_DrawImage(G2, pBitmapPlayOptionLit, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			CURRENT_MENU_OPTION := 1
		}
	}
	Else If (WParam = 0x0D) ; Enter Key
	{
		If ((CURRENT_MENU_OPTION = 2) AND (IS_MENU_ACTIVE = 1)) ; Intro selected
		{
			IS_MENU_ACTIVE := 0
			Gdip_DrawImage(G2, pBitmapIntroBackGround, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			STORY_TEXT_CURRENT_Y := 512
			DRAW_STORY_PIXEL_COUNTER := 0
			SetTimer, DrawStory, 80
			LAST_MENU_OPTION := 2
			Return
		}
		Else if ((IS_MENU_ACTIVE = 0) AND (LAST_MENU_OPTION = 2) AND (CURRENT_MENU_OPTION = 2))
		{
			IS_MENU_ACTIVE := 1
			SetTimer, DrawStory, Off
			LAST_MENU_OPTION := 0
			Gosub, ReturnToMenu
			Return
		}
		
		Else If ((CURRENT_MENU_OPTION = 1) AND (IS_MENU_ACTIVE = 1)) ; Play selected
		{
			Gui, 2: Destroy
			IS_MENU_ACTIVE := 0
			Gosub PlayGame
			Return
		}
		Else If ((CURRENT_MENU_OPTION = 3) AND (IS_MENU_ACTIVE = 1)) ; Instructions selected.
		{
			IS_MENU_ACTIVE := 0
			Gdip_DrawImage(G2, pBitmapInstructions1, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			SECOND_INSTR_PAGE := 0
		}
		Else If ((CURRENT_MENU_OPTION = 3) AND (IS_MENU_ACTIVE = 0) AND (SECOND_INSTR_PAGE = 0)) 
		{
			Gdip_DrawImage(G2, pBitmapInstructions2, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			SECOND_INSTR_PAGE := 1
		}
		Else If ((CURRENT_MENU_OPTION = 3) AND (IS_MENU_ACTIVE = 0) AND (SECOND_INSTR_PAGE = 1)) ; Instructions selected.
		{
			Gosub, ReturnToMenu
			Return
		}
		Else If ((CURRENT_MENU_OPTION = 4) AND (IS_MENU_ACTIVE = 1)) ; Credits selected.
		{
			IS_MENU_ACTIVE := 0
			Gdip_DrawImage(G2, pBitmapCredits, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
		}
		Else If ((CURRENT_MENU_OPTION = 4) AND (IS_MENU_ACTIVE = 0))
		{
			Gosub, ReturnToMenu
			Return
		}
	}
}
Return

DrawStory:
If (DRAW_STORY_PIXEL_COUNTER <= 1277) ; 765 (Y of the first pixel to remain visible after animation finishes) + 512 (screen height)
{
	Gdip_DrawImage(G2, pBitmapIntroBackGround, 0, 0, 512, 512, 0, 0, 512, 512)
	STORY_TEXT_CURRENT_Y := STORY_TEXT_CURRENT_Y - 1
	Gdip_DrawImage(G2, pBitmapIntroStory, 0, STORY_TEXT_CURRENT_Y, 512, 800, 0, 0, 512, 800)
	UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
	DRAW_STORY_PIXEL_COUNTER++
}
Return

LoadMenuSprites()
{
	Global
	pBitmapMenu := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\MenuBackGround.png")
	pBitmapFrame := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\GoldFrame.png")
	pBitmapTitle := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Title.png")
	pBitmapPlayOption := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\PlayOption.png")
	pBitmapIntroOption := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\IntroOption.png")
	pBitmapInstructionsOption := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\InstructionsOption.png")
	pBitmapCreditsOption := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\CreditsOption.png")
	pBitmapVersionInfo := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\VersionInfo.png")

	pBitmapPlayOptionLit := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\PlayOptionLit.png")
	pBitmapIntroOptionLit := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\IntroOptionLit.png")
	pBitmapInstructionsOptionLit := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\InstructionsOptionLit.png")
	pBitmapCreditsOptionLit := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\CreditsOptionLit.png")

	pBitmapIntroBackGround := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\ArchMageIntro.png")
	pBitmapIntroStory := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Story.png")
	pBitmapCredits := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Credits.png")
	pBitmapFinalScene := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\EndingScene.png")
	pBitmapEndingStory := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\EndingMessage.png")

	pBitmapInstructions1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Instructions1.png")
	pBitmapInstructions2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Instructions2.png")
}
Return

PlayGame:
FINAL_SCENE_PLAYING := 0
OnMessage(0x201, "")

; GUI 1 IS THE PLAY SESSION GUI.
Gui, 1:  +E0x80000 +LastFound +AlwaysOnTop +OwnDialogs -Caption +ToolWindow
Gui, 1: Show, NA, ARCHMAGE_PLAY_SESSION
hwnd1 := WinExist()

LoadTextures()

; Check to ensure we actually got a bitmap from the file, in case the file was corrupt or some other error occured
If !pBitmap
{
	MsgBox, 48, File loading error!, Could not load the background image.
	ExitApp
}

Width := 512, Height := 512



hbm := CreateDIBSection(Width, Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetInterpolationMode(G, 7)
Window_X_Pos := (A_ScreenWidth - 512) / 2
Window_Y_Pos := (A_ScreenHeight - 512) / 2
Gdip_DrawImage(G, pBitmapNewJourney, 0, 0, 512, 512, 0, 0, 512, 512)
UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)

OnMessage(0x100, "") ; This turns off the monitoring of messages 0x100.

SPRITE_COUNTER_INTRO_PLAY := 1
Loop % 20
{
	CURRENT_SPRITE_TO_USE := Mod(A_Index, 4)
	If (CURRENT_SPRITE_TO_USE = 0)
	{
		CURRENT_SPRITE_TO_USE := 4
	}
	Gdip_DrawImage(G, pBitmapNewJourney, 0, 0, 512, 512, 0, 0, 512, 512)
	Gdip_DrawImage(G, pBitmapPlayer_Mov_Up_%CURRENT_SPRITE_TO_USE%, 242, 238, 512, 512, 0, 0, 512, 512)
	UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
	Sleep 200
}

Load_Scenary()
Load_Objects()
Load_Items()
Load_Enemies()
Load_Sounds()
SetTimer, Restore_Sounds, 4000 ; Check every 4 seconds if a sound has failed 3x or more and if so, restores all sounds.

counter_bkg := 0

Current_Y := 0
DrawSign_Post()
Gdip_DrawImage(G, pBitmapPlayer_Idle_Down, 242, 238, 28, 35, 0, 0, 28, 35)
Current_Sprite_Player := pBitmapPlayer_Idle_Down
UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
OnMessage(0x201, "CheckMouseLeftClickDown")
WinActivate, ARCHMAGE_PLAY_SESSION

W_Count := 0
D_Count := 0
A_Count := 0
S_Count := 0
Create_Player()
Current_Start_Y := 0
SetTimer, DrawScene, 50 ; This can limit the max FPS if needed. Around 20 FPS atm (50 ms intervals between drawings). The FPS can also be further limited by a sleep command set to 40 ms intervals in the drawscene routine (no longer used).
ObjAttacks := Object()
Return

Load_Sounds()
{
	Global
	If !(IsObject(WMA2))
	{
		WMA2 := ComObjCreate("WMPlayer.OCX")
		WMA2.url := A_ScriptDir . "/Sounds/ClaymanDeath.wav"
	}
	if (WMA2.controls.isAvailable("stop"))
	{
		wma2.controls.stop		
	}
	
	If !(IsObject(WMA3))
	{
		WMA3 := ComObjCreate("WMPlayer.OCX")
		WMA3.url := A_ScriptDir . "/Sounds/Hit.wav"
	}
	if (WMA3.controls.isAvailable("stop"))
	{
		wma3.controls.stop		
	}
	
	If !(IsObject(WMA4))
	{
		WMA4 := ComObjCreate("WMPlayer.OCX")
		WMA4.url := A_ScriptDir . "/Sounds/SpiderDeath.wav"
	}
	if (WMA4.controls.isAvailable("stop"))
	{
		wma4.controls.stop		
	}
	
	If !(IsObject(WMA5))
	{
		WMA5 := ComObjCreate("WMPlayer.OCX")
		WMA5.url := A_ScriptDir . "/Sounds/MageScream.wav"
	}
	if (WMA5.controls.isAvailable("stop"))
	{
		wma5.controls.stop		
	}
	
	If !(IsObject(WMA6))
	{
		WMA6 := ComObjCreate("WMPlayer.OCX")
		WMA6.url := A_ScriptDir . "/Sounds/MageDeath.wav"
	}
	if (WMA6.controls.isAvailable("stop"))
	{
		wma6.controls.stop		
	}
	
	If !(IsObject(WMA7))
	{
		WMA7 := ComObjCreate("WMPlayer.OCX")
		WMA7.url := A_ScriptDir . "/Sounds/Teleport.wav"
	}
	if (WMA7.controls.isAvailable("stop"))
	{
		wma7.controls.stop		
	}
	
	If !(IsObject(WMA8))
	{
		WMA8 := ComObjCreate("WMPlayer.OCX")
		WMA8.url := A_ScriptDir . "/Sounds/MagicFailed.wav"
	}
	if (WMA8.controls.isAvailable("stop"))
	{
		wma8.controls.stop		
	}
	
	If !(IsObject(WMA9))
	{
		WMA9 := ComObjCreate("WMPlayer.OCX")
		WMA9.url := A_ScriptDir . "/Sounds/Pickup.wav"
	}
	if (WMA9.controls.isAvailable("stop"))
	{
		wma9.controls.stop		
	}
	
	If !(IsObject(WMA10))
	{
		WMA10 := ComObjCreate("WMPlayer.OCX")
		WMA10.url := A_ScriptDir . "/Sounds/Restore.wav"
	}
	if (WMA10.controls.isAvailable("stop"))
	{
		wma10.controls.stop		
	}
	
	If !(IsObject(WMA11))
	{
		WMA11 := ComObjCreate("WMPlayer.OCX")
		WMA11.url := A_ScriptDir . "/Sounds/Speed.wav"
	}
	if (WMA11.controls.isAvailable("stop"))
	{
		wma11.controls.stop		
	}
	
}
Return

Restore_Sounds:
If ((COUNTER_WMA2_FAIL >= 3) OR (COUNTER_WMA3_FAIL >= 3) OR (COUNTER_WMA4_FAIL >= 3))
{
	;tooltip % "sound restored."
	Load_Sounds()
	COUNTER_WMA2_FAIL := 0
	COUNTER_WMA3_FAIL := 0
	COUNTER_WMA4_FAIL := 0
}
Return

Load_Scenary()
{
	Global
	hbm2 := CreateDIBSection(Width, Height * 70)
	hdc2 := CreateCompatibleDC()
	obm2 := SelectObject(hdc2, hbm2)
	G2 := Gdip_GraphicsFromHDC(hdc2)
	Gdip_SetInterpolationMode(G2, 7)
	Window_X_Pos := (A_ScreenWidth - 512) / 2
	Window_Y_Pos := (A_ScreenHeight - 512) / 2
	Loop 70
	{
		Gdip_DrawImage(G2, pBitmap, 0, (A_Index - 1) * 512, 512, 512, 0, 0, 512, 512)
	}
}
Return


; ENEMIES LIST:
; 1. Clayman
; 2. Spider
; 3. Bat
; 4. Poison Spider
; 5. Rockman
; 6. Iceman
; 7. Blood Bat
; 8. Fireman
Load_Enemies()
{
	Global
	ENEMIES_ARE_PARALYZED := 0
	ENEMIES_COUNTER := 0
	Loop 68
	{
		CURRENT_VIEW := A_Index
		If (A_Index <= 10) ; Basic wave
		{
			Random, Enemies_Per_View, 1, 2
			Loop % Enemies_Per_View
			{
				Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
				Random, X_to_use, 1, 512
				Random, Which_Enemy, 1, 3
				ENEMIES_COUNTER := ENEMIES_COUNTER + 1
				Enemy_%ENEMIES_COUNTER% := New Enemy(X_To_Use, Y_to_use, Which_Enemy)
			}
		}
		Else if (A_Index <= 20) ; Upping the dificulty just a bit.
		{
			Random, Enemies_Per_View, 2, 3
			Loop % Enemies_Per_View
			{
				Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
				Random, X_to_use, 1, 512
				Random, Which_Enemy, 2, 5
				ENEMIES_COUNTER := ENEMIES_COUNTER + 1
				Enemy_%ENEMIES_COUNTER% := New Enemy(X_To_Use, Y_to_use, Which_Enemy)
			}
		}
		Else if (A_Index <= 30) ; Introducing the first high leveled enemy.
		{
			Random, Enemies_Per_View, 3, 4
			Loop % Enemies_Per_View
			{
				Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
				Random, X_to_use, 1, 512
				Random, Which_Enemy, 2, 6
				ENEMIES_COUNTER := ENEMIES_COUNTER + 1
				Enemy_%ENEMIES_COUNTER% := New Enemy(X_To_Use, Y_to_use, Which_Enemy)
			}
		}
		Else if (A_Index <= 40) ; Introducing yet another higher level enemy.
		{
			Random, Enemies_Per_View, 3, 5
			Loop % Enemies_Per_View
			{
				Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
				Random, X_to_use, 1, 512
				Random, Which_Enemy, 2, 7
				ENEMIES_COUNTER := ENEMIES_COUNTER + 1
				Enemy_%ENEMIES_COUNTER% := New Enemy(X_To_Use, Y_to_use, Which_Enemy)
			}
		}
		Else if (A_Index <= 50) ; Introducing the hardest enemy.
		{
			Random, Enemies_Per_View, 4, 6
			Loop % Enemies_Per_View
			{
				Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
				Random, X_to_use, 1, 512
				Random, Which_Enemy, 2, 8
				ENEMIES_COUNTER := ENEMIES_COUNTER + 1
				Enemy_%ENEMIES_COUNTER% := New Enemy(X_To_Use, Y_to_use, Which_Enemy)
			}
		}
		Else if (A_Index <= 60) ; Waves are now mid-to-high level enemies only.
		{
			Random, Enemies_Per_View, 4, 6
			Loop % Enemies_Per_View
			{
				Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
				Random, X_to_use, 1, 512
				Random, Which_Enemy, 4, 8
				ENEMIES_COUNTER := ENEMIES_COUNTER + 1
				Enemy_%ENEMIES_COUNTER% := New Enemy(X_To_Use, Y_to_use, Which_Enemy)
			}
		}
		Else if (A_Index < 67) ; Waves are now high level only.
		{
			Random, Enemies_Per_View, 4, 6
			Loop % Enemies_Per_View
			{
				Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
				Random, X_to_use, 1, 512
				Random, Which_Enemy, 6, 8
				ENEMIES_COUNTER := ENEMIES_COUNTER + 1
				Enemy_%ENEMIES_COUNTER% := New Enemy(X_To_Use, Y_to_use, Which_Enemy)
			}
		}
		If (A_Index = 67)
		{
			Y_to_use := 35100
			X_to_use := 256
			ENEMIES_COUNTER := ENEMIES_COUNTER + 1
			Enemy_%ENEMIES_COUNTER% := New Enemy(X_To_Use, Y_to_use, 9) ; Final boss.
		}
	}
}
Return

; OBJECT LIST:
		; NOT-COLISIONABLE:
		; Scene_Object_Type can be:
		; 1. SquareBush
		; 2. StarBush
		; 3. LongLeafTreeW
		
		;COLISIONABLE:
		; 31. SmallTree
		; 32. PineBush
		; 33. Tree
		; 34. Tree2
Load_Objects()
{
	Global
	
	OBJ_COUNTER := 0
	COLISIONABLE_OBJ_COUNTER := 0
	
	Loop 68
	{
		CURRENT_VIEW := A_Index
		Random, Artifact_Objects_To_Draw, 16, 25
		Loop % Artifact_Objects_To_Draw
		{
			Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
			Random, X_to_use, 1, 512
			Random, Which_To_Draw, 1, 6
			OBJ_COUNTER := OBJ_COUNTER + 1
			Object_%OBJ_COUNTER% := New Scene_Object(X_To_Use, Y_to_use, Which_To_Draw)
		}
	}
	
	Loop 68
	{
		CURRENT_VIEW := A_Index
		Random, Non_Colisionable_Objects_To_Draw, 16, 25
		Loop % Non_Colisionable_Objects_To_Draw
		{
			Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
			Random, X_to_use, 1, 512
			Random, Which_To_Draw, 11, 16
			OBJ_COUNTER := OBJ_COUNTER + 1
			Object_%OBJ_COUNTER% := New Scene_Object(X_To_Use, Y_to_use, Which_To_Draw)
		}
	}
	Loop 68
	{
		CURRENT_VIEW := A_Index
		Random, Colisionable_Objects_To_Draw, 4, 8
		Loop % Colisionable_Objects_To_Draw
		{
			Random, Y_to_use, % CURRENT_VIEW * 512, CURRENT_VIEW * 512 + 512
			Random, X_to_use, 1, 512
			Random, Which_To_Draw, 31, 44
			OBJ_COUNTER := OBJ_COUNTER + 1
			Object_%OBJ_COUNTER% := New Scene_Object(X_To_Use, Y_to_use, Which_To_Draw)
			If (Object_%OBJ_COUNTER%.Has_Missile_Colision = 1) ; REDUNDANT, SINCE ALL OBJECTS FROM 31 TO 40 HAVE MISSILE COLISION. KEPT FOR REFERENCE.
			{
				COLISIONABLE_OBJ_COUNTER := COLISIONABLE_OBJ_COUNTER + 1
				Col_Obj_%COLISIONABLE_OBJ_COUNTER% := Object_%OBJ_COUNTER%
			}
		}
	}
	
	Total_Objects := OBJ_COUNTER
	Loop % Total_Objects
	{
		Gdip_DrawImage(G2, Object_%A_Index%.Scene_Object_Bitmap, Object_%A_Index%.PosX, Object_%A_Index%.Initial_Y, Object_%A_Index%.Scene_Object_Width, Object_%A_Index%.Scene_Object_Height, 0, 0, Object_%A_Index%.Scene_Object_Width, Object_%A_Index%.Scene_Object_Height)
	}
	
	pBitmapScenary := Gdip_CreateBitmapFromHBITMAP(hbm2)
}
Return

Load_Items()
{
	Global
	ITEM_COUNTER := 0 ; This variable is used now as a future reminder, (in a later date, we may choose to do loop-insertion of items).
	; 3 Lexikos are loaded in every game (out of 5 possible). This means the player must learn to use different combinations to deal with the evil wizard (he teoretically cannot be dealt with by shooting only).
	Random, X_to_Use_1, 20, 492
	Random, Y_to_Use_1, 27500, 30000 ; Between waves 10 and 15 the player should get the first Lexiko scroll.
	;Y_To_Use_1 := 35000
	Random, Which_Item_1, 1, 5
	ITEM_COUNTER++
	Item_%ITEM_COUNTER% := New Item_Object(X_To_Use_1, Y_to_use_1, Which_Item_1)
	
	Random, X_to_Use_2, 20, 492
	Random, Y_to_Use_2, 11000, 24000 ; Around the middle of the run the player will get the second Lexiko scroll. Luck plays a major role in this one though (it can take longer or not for the scroll to hop up)
	;Y_To_Use_2 := 34500
	Random, Which_Item_2, 1, 5
	While (Which_Item_2 = Which_Item_1) ; Ensures the second lexiko is not the same as the first.
	{
		Random, Which_Item_2, 1, 5
	}
	ITEM_COUNTER++
	Item_%ITEM_COUNTER% := New Item_Object(X_To_Use_2, Y_to_use_2, Which_Item_2)
	
	Random, X_to_Use_3, 20, 492
	Random, Y_to_Use_3, 1000, 5000 ; Player gets the last scroll when he is nearing the final boss.
	;Y_To_Use_3 := 34000
	Random, Which_Item_3, 1, 5
	While ((Which_Item_3 = Which_Item_2) OR (Which_Item_3 = Which_Item_1))
	{
		Random, Which_Item_3, 1, 5 ; Ensures the third lexiko is not the same as the first or the second
	}
	ITEM_COUNTER++
	Item_%ITEM_COUNTER% := New Item_Object(X_To_Use_3, Y_to_use_3, Which_Item_3)
	;ToolTip % Which_Item_1 . "     "  . Which_Item_2 . "    " . Which_Item_3
}
Return

CheckColision(X_Pos, Y_Pos, Hit_Type)
{
	Global
	Loop % COLISIONABLE_OBJ_COUNTER
	{
		; FIRST, WE CHECK IF THE OBJECT IS IN RENDERABLE AREA (OR AT LEAST A PORTION OF IT IS). SCREEN IS 512 AND WE SHOULD ADD  TWICE THE HEIGHT OF THE OBJECT (SO THAT EVEN IF ONLY 1 PIXEL IS VISIBLE, COLISION IS STILL POSSIBLE).
		If ((Col_Obj_%A_Index%.Initial_Y > (69 * 512) - CURRENT_Y - Col_Obj_%A_Index%.Scene_Object_Height) AND (Col_Obj_%A_Index%.Initial_Y < (69 * 512) - CURRENT_Y + 512 + Col_Obj_%A_Index%.Scene_Object_Height))
		{
			PLAYER_ABSOLUTE_Y := (69 * 512) - CURRENT_Y + 256
			If ((X_Pos > Col_Obj_%A_Index%.PosX - 50 + Col_Obj_%A_Index%.ColBox_X1)
			AND (X_Pos < (Col_Obj_%A_Index%.PosX + Col_Obj_%A_Index%.ColBox_X2))
			AND (PLAYER_ABSOLUTE_Y - 256 + Y_Pos > Col_Obj_%A_Index%.Initial_Y + Col_Obj_%A_Index%.ColBox_Y1 - 25)
			AND (PLAYER_ABSOLUTE_Y - 256 + Y_Pos < Col_Obj_%A_Index%.Initial_Y + Col_Obj_%A_Index%.ColBox_Y2 - 25))
			{
				if (WMA3.controls.isAvailable("play"))
				{
					wma3.controls.play		
					COUNTER_WMA3_FAIL := 0
				}
				else
				{
					COUNTER_WMA3_FAIL++
				}
				Return 1 ; COLISION HAPPENED.
			}
		}
	}
}
Return


; Player colision is on a different function because the colision of hits required us to take into the account the akwardness of the bitmap rotation routine (it does not rotate the missile from its center). Player colision thus has a different math.
CheckPlayerColision(X_Pos, Y_Pos)
{
	Global
	Loop % COLISIONABLE_OBJ_COUNTER
	{
		; FIRST, WE CHECK IF THE OBJECT IS IN RENDERABLE AREA (OR AT LEAST A PORTION OF IT IS). SCREEN IS 512 AND WE SHOULD ADD  TWICE THE HEIGHT OF THE OBJECT (SO THAT EVEN IF ONLY 1 PIXEL IS VISIBLE, COLISION IS STILL POSSIBLE).
		If ((Col_Obj_%A_Index%.Initial_Y > (69 * 512) - CURRENT_Y - Col_Obj_%A_Index%.Scene_Object_Height) AND (Col_Obj_%A_Index%.Initial_Y < (69 * 512) - CURRENT_Y + 512 + Col_Obj_%A_Index%.Scene_Object_Height))
		{
			PLAYER_ABSOLUTE_Y := (69 * 512) - CURRENT_Y + 256
			If ((X_Pos > Col_Obj_%A_Index%.PosX - 30 + Col_Obj_%A_Index%.ColBox_X1)
			AND (X_Pos < (Col_Obj_%A_Index%.PosX + Col_Obj_%A_Index%.ColBox_X2))
			AND (PLAYER_ABSOLUTE_Y - 256 + Y_Pos > Col_Obj_%A_Index%.Initial_Y + Col_Obj_%A_Index%.ColBox_Y1 - 25)
			AND (PLAYER_ABSOLUTE_Y - 256 + Y_Pos < Col_Obj_%A_Index%.Initial_Y + Col_Obj_%A_Index%.ColBox_Y2 - 25))
			{
				if (WMA3.controls.isAvailable("play"))
				{
					wma3.controls.play		
					COUNTER_WMA3_FAIL := 0
				}
				else
				{
					COUNTER_WMA3_FAIL++
				}
				Return 1 ; COLISION HAPPENED.
			}
		}
	}
}
Return


; Monster colision was made a separate function to avoid confusion. Also, no sound is played when a monster colides against a tree.
CheckMonsterColision(X_Pos, Y_Pos)
{
	Global
	Loop % COLISIONABLE_OBJ_COUNTER
	{
		; FIRST, WE CHECK IF THE OBJECT IS IN RENDERABLE AREA (OR AT LEAST A PORTION OF IT IS). SCREEN IS 512 AND WE SHOULD ADD  TWICE THE HEIGHT OF THE OBJECT (SO THAT EVEN IF ONLY 1 PIXEL IS VISIBLE, COLISION IS STILL POSSIBLE).
		If ((Col_Obj_%A_Index%.Initial_Y > (69 * 512) - CURRENT_Y - Col_Obj_%A_Index%.Scene_Object_Height) AND (Col_Obj_%A_Index%.Initial_Y < (69 * 512) - CURRENT_Y + 512 + Col_Obj_%A_Index%.Scene_Object_Height))
		{
			PLAYER_ABSOLUTE_Y := (69 * 512) - CURRENT_Y + 256
			If ((X_Pos > Col_Obj_%A_Index%.PosX - 30 + Col_Obj_%A_Index%.ColBox_X1)
			AND (X_Pos < (Col_Obj_%A_Index%.PosX + Col_Obj_%A_Index%.ColBox_X2))
			AND (PLAYER_ABSOLUTE_Y - 256 + Y_Pos > Col_Obj_%A_Index%.Initial_Y + Col_Obj_%A_Index%.ColBox_Y1 - 25)
			AND (PLAYER_ABSOLUTE_Y - 256 + Y_Pos < Col_Obj_%A_Index%.Initial_Y + Col_Obj_%A_Index%.ColBox_Y2 - 25))
			{
				Return 1 ; COLISION HAPPENED.
			}
		}
	}
}
Return


; Enemy_Rockman.Current_Y_Pos
; Enemy_Rockman.Current_X_Pos
; Mod(Current_Y, Enemy_RockMan.Current_Y_Pos) - 70

CheckHitColision(X_Pos, Y_Pos, Hit_Type)
{
	Global
	Loop % ENEMIES_COUNTER
	{
		If ((X_Pos > Enemy_%A_Index%.Current_X_Pos - 28) AND (X_Pos < Enemy_%A_Index%.Current_X_Pos + 28) AND (Y_Pos > (Mod(Current_Y, Enemy_%A_Index%.Current_Y_Pos) - 70)) AND (Y_Pos < (Mod(Current_Y, Enemy_%A_Index%.Current_Y_Pos) - 70 + 35)) AND (Enemy_%A_Index%.Active = 1))
		{
			If (Hit_Type = 1) ; Spiky Fungus Hit
			{
				Enemy_%A_Index%.Current_Hitpoints := Enemy_%A_Index%.Current_Hitpoints - 10
			}
			Else if (Hit_Type = 2) ; Beam Hit
			{
				Enemy_%A_Index%.Current_Hitpoints := Enemy_%A_Index%.Current_Hitpoints - 100
			}
			If (Enemy_%A_Index%.Current_Hitpoints <= 0) ; ENEMY DIED. DRAW CORPSE INTO THE BACKGROUND.
			{
				If (Enemy_%A_Index%.pBitmap_Dead = pBitmapClayman_Dead)
				{
					if (WMA2.controls.isAvailable("play"))
					{
						wma2.controls.play
						COUNTER_WMA2_FAIL := 0
					}
					else
					{
						COUNTER_WMA2_FAIL++
					}
				}
				Else If (Enemy_%A_Index%.pBitmap_Dead = pBitmapSpider_Dead)
				{
					if (WMA4.controls.isAvailable("play"))
					{
						wma4.controls.play
						COUNTER_WMA4_FAIL := 0
					}
					else
					{
						COUNTER_WMA4_FAIL++
					}
				}
				Else If (Enemy_%A_Index%.pBitmap_Dead = pBitmapBat_Dead)
				{
					if (WMA4.controls.isAvailable("play"))
					{
						wma4.controls.play		
						COUNTER_WMA4_FAIL := 0
					}
					else
					{
						COUNTER_WMA4_FAIL++
					}
				}
				Else If (Enemy_%A_Index%.pBitmap_Dead = pBitmapPoison_Spider_Dead)
				{
					if (WMA4.controls.isAvailable("play"))
					{
						wma4.controls.play		
						COUNTER_WMA4_FAIL := 0
					}
					else
					{
						COUNTER_WMA4_FAIL++
					}
				}
				Else If (Enemy_%A_Index%.pBitmap_Dead = pBitmapRockman_Dead)
				{
					if (WMA2.controls.isAvailable("play"))
					{
						wma2.controls.play		
						COUNTER_WMA2_FAIL := 0
					}
					else
					{
						COUNTER_WMA2_FAIL++
					}
				}
				Else If (Enemy_%A_Index%.pBitmap_Dead = pBitmapIceman_Dead)
				{
					if (WMA2.controls.isAvailable("play"))
					{
						wma2.controls.play		
						COUNTER_WMA2_FAIL := 0
					}
					else
					{
						COUNTER_WMA2_FAIL++
					}
				}
				Else If (Enemy_%A_Index%.pBitmap_Dead = pBitmapBlood_Bat_Dead)
				{
					if (WMA4.controls.isAvailable("play"))
					{
						wma4.controls.play		
						COUNTER_WMA4_FAIL := 0
					}
					else
					{
						COUNTER_WMA4_FAIL++
					}
				}
				Else If (Enemy_%A_Index%.pBitmap_Dead = pBitmapFireman_Dead)
				{
					if (WMA2.controls.isAvailable("play"))
					{
						wma2.controls.play		
						COUNTER_WMA2_FAIL := 0
					}
					else
					{
						COUNTER_WMA2_FAIL++
					}
				}
				Else If (Enemy_%A_Index%.pBitmap_Dead = pBitmapWiz_Dead)
				{
					if (WMA6.controls.isAvailable("play"))
					{
						wma6.controls.play		
					}
					WIZ_BOSS_DEAD := 1
				}
				
				Enemy_%A_Index%.Active := 0
				; THE CODE BELOW UPDATES DE BACKGROUND BITMAP TO INCLUDE THE PICTURE OF THE BODY OF THE ENEMY.
				; THE METHOD USED, HOWEVER, SOMETIMES BREAKS THE BITMAP, THEREBY, WE ADDED A TEST TO SEE IF THE NEW BITMAP WIS BROKEN AND ONLY IF NOT, IT WILL REPLACE THE BACKGROUND.
				; THIS MAY CAUSE THE ENEMY  BODY TO DISAPPEAR SOMETIMES, BUT IT ENSURES THE BACKGROUND DOES NOT CRASH (AND THE FORMER CAN BE FIXED ON A LATER DATE).
				
				Random, Which_Dead_Body, 1, 2
				If (Which_Dead_Body = 1)
				{
					pBitmap_Body_To_Use := Enemy_%A_Index%.pBitmap_Dead
				}
				Else if (Which_Dead_Body = 2)
				{
					pBitmap_Body_To_Use := Enemy_%A_Index%.pBitmap_Dead_2
				}
				Gdip_DrawImage(G2, pBitmap_Body_To_Use, Enemy_%A_Index%.Current_X_Pos, 35840 - Enemy_%A_Index%.Current_Y_Pos - 512 - 70, 56, 70, 0, 0, 56, 70)
				pBitmapScenary2 := Gdip_CreateBitmapFromHBITMAP(hbm2)
				PIXEL_TEST := Gdip_GetPixel(pBitmapScenary2, 1, 100)
				If (PIXEL_TEST = "4284840448") 
				{
					Gdip_DisposeImage(pBitmapScenary)
					pBitmapScenary := pBitmapScenary2
				}
			}
			if (WMA3.controls.isAvailable("play"))
			{
				wma3.controls.play		
				COUNTER_WMA3_FAIL := 0
			}
			else
			{
				COUNTER_WMA3_FAIL++
			}
			Return 1 ; COLISION HAPPENED.
		}
	}
}
Return


CheckItemColision(X_Pos, Y_Pos) ; Check if the player has colided against an item.
{
	Global
	Loop % ITEM_COUNTER
	{
		If ((Item_%A_Index%.Initial_Y > (69 * 512) - CURRENT_Y - Item_%A_Index%.Item_Object_Height) AND (Item_%A_Index%.Initial_Y < (69 * 512) - CURRENT_Y + 512 + Item_%A_Index%.Item_Object_Height) AND (ITEM_%A_Index%.Was_collected = 0))
		{
			PLAYER_ABSOLUTE_Y := (69 * 512) - CURRENT_Y + 256
			If ((X_Pos > Item_%A_Index%.PosX - 30 + Item_%A_Index%.ColBox_X1)
			AND (X_Pos < (Item_%A_Index%.PosX + Item_%A_Index%.ColBox_X2))
			AND (PLAYER_ABSOLUTE_Y - 256 + Y_Pos > Item_%A_Index%.Initial_Y + Item_%A_Index%.ColBox_Y1 - 25)
			AND (PLAYER_ABSOLUTE_Y - 256 + Y_Pos < Item_%A_Index%.Initial_Y + Item_%A_Index%.ColBox_Y2 - 25))
			{
				Return A_index ; COLISION HAPPENED. WE RETURN THE INDEX OF THE ITEM.
			}
		}
	}
}
Return


CheckMouseLeftClickDown(WParam, LParam, msg, hwnd)
{
	Global
	If (hwnd = hwnd3) ; ignore clicks in the frame window.
	{
		Return
	}
	Else If (hwnd = hwnd2) ; If the click was in the menu window, check if the user clicked one of the menu options.
	{
		VarSetCapacity(MPOS, 4, 0)
		NumPut(LParam, MPOS, 0, "Int") ; We have to NumPut before we NumGet because AHK normally stores numbers as strings in variables (for performance).
		Click_Pos_Y := NumGet(MPOS, 2, "UShort")
		Click_Pos_X :=  NumGet(MPOS, 0, "UShort")
		
		If ((Click_Pos_X > 317) AND (Click_Pos_X < 396) AND (Click_Pos_Y > 262) AND (Click_Pos_Y < 311) AND (IS_MENU_ACTIVE = 1)) ; Clicked on Play
		{
			;ToolTip % "Play"
			CURRENT_MENU_OPTION := 1
			Gui, 2: Destroy
			IS_MENU_ACTIVE := 0
			Gosub PlayGame
			Return
		}
		
		If ((Click_Pos_X > 306) AND (Click_Pos_X < 402) AND (Click_Pos_Y > 321) AND (Click_Pos_Y < 358) AND (IS_MENU_ACTIVE = 1)) ; Clicked on Intro
		{
			;ToolTip % "Intro"
			CURRENT_MENU_OPTION := 2
			IS_MENU_ACTIVE := 0
			Gdip_DrawImage(G2, pBitmapIntroBackGround, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			STORY_TEXT_CURRENT_Y := 512
			DRAW_STORY_PIXEL_COUNTER := 0
			SetTimer, DrawStory, 80
			LAST_MENU_OPTION := 2
			Return
		}
		
		If ((Click_Pos_X > 271) AND (Click_Pos_X < 451) AND (Click_Pos_Y > 375) AND (Click_Pos_Y < 415) AND (IS_MENU_ACTIVE = 1)) ; Clicked on Instructions
		{
			;ToolTip % "Instructions"
			CURRENT_MENU_OPTION := 3
			IS_MENU_ACTIVE := 0
			Gdip_DrawImage(G2, pBitmapInstructions1, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
			SECOND_INSTR_PAGE := 0
		}
		
		If ((Click_Pos_X > 299) AND (Click_Pos_X < 414) AND (Click_Pos_Y > 430) AND (Click_Pos_Y < 468) AND (IS_MENU_ACTIVE = 1)) ; Clicked on Credits
		{
			;ToolTip % "Credits"
			CURRENT_MENU_OPTION := 4
			IS_MENU_ACTIVE := 0
			Gdip_DrawImage(G2, pBitmapCredits, 0, 0, 512, 512, 0, 0, 512, 512)
			UpdateLayeredWindow(hwnd2, hdc2, Window_X_Pos, Window_Y_Pos, Width, Height)
		}
		
	}
	Else If (hwnd = hwnd1)
	{
		VarSetCapacity(MPOS, 4, 0)
		NumPut(LParam, MPOS, 0, "Int") ; We have to NumPut before we NumGet because AHK normally stores numbers as strings in variables (for performance).
		Click_Pos_Y := NumGet(MPOS, 2, "UShort")
		Click_Pos_X :=  NumGet(MPOS, 0, "UShort")
		If (ObjAttacks.MaxIndex() = "")
		{
			ObjAttacks[1,1] := Player.PosX - 12
			ObjAttacks[1,2] := Player.PosY - 10
			Y_DIF := (Click_Pos_Y - Player.PosY - 17) * - 1
			X_DIF := Click_Pos_X - Player.PosX - 14
		
			% ((Y_DIF = 0) ? (Y_DIF := 0.01) : (""))
			% ((X_DIF = 0) ? (X_DIF := 0.01) : (""))
		
			Tangent_Of_Angle := Y_DIF / X_DIF
			Angle_Of_Attack := ATan(Tangent_Of_Angle) / 0.01745329252
			If (X_DIF >= 0)
			{
				ObjAttacks[1, 3] := Gdip_RotateBitmap(pBitmapTinyBlast, 90 - Angle_Of_Attack) ; Input the Angle
				ObjAttacks[1, 7] := Gdip_RotateBitmap(pBitmapTinyBlastHit, 90 - Angle_Of_Attack) ; Input the Angle
			}
			else
			{
				ObjAttacks[1, 3] := Gdip_RotateBitmap(pBitmapTinyBlast, 270 - Angle_Of_Attack) ; Input the Angle
				ObjAttacks[1, 7] := Gdip_RotateBitmap(pBitmapTinyBlastHit, 270 - Angle_Of_Attack) ; Input the Angle
			}
			ObjAttacks[1, 4] := X_DIF
			ObjAttacks[1, 5] := Y_DIF
			ObjAttacks[1, 6] := 1 ; 1 = Active, 2 = Inactive (Has colisioned)
			ObjAttacks[1, 8] := "SpikyFungus"
		}
		else
		{
			New_Index := ObjAttacks.MaxIndex() + 1
			ObjAttacks[New_Index,1] := Player.PosX - 12
			ObjAttacks[New_Index,2] := Player.PosY - 10
			X_DIF := Click_Pos_X - Player.PosX - 14 ; Players X position starts at the left-uppermost pixel of the sprite. Therefore, the middle of the sprite is 14 pixels away.
			Y_DIF := (Click_Pos_Y - Player.PosY - 17) * - 1
			
			% ((Y_DIF = 0) ? (Y_DIF := 0.01) : (""))
			% ((X_DIF = 0) ? (X_DIF := 0.01) : (""))
			
			Tangent_Of_Angle := Y_DIF / X_DIF ; Oposite / Adjacent
			Angle_Of_Attack := ATan(Tangent_Of_Angle) / 0.01745329252 ; Conversion between radians and degrees
			If (X_DIF > 0)
			{
				ObjAttacks[New_Index, 3] := Gdip_RotateBitmap(pBitmapTinyBlast, 90 - Angle_Of_Attack) ; Input the Angle
				ObjAttacks[New_Index, 7] := Gdip_RotateBitmap(pBitmapTinyBlastHit, 90 - Angle_Of_Attack) ; Input the Angle
			}
			Else If (X_DIF = 0)
			{
				ObjAttacks[New_Index, 3] := pBitmapTinyBlast ; Input the Angle
			}
			else
			{
				ObjAttacks[New_Index, 3] := Gdip_RotateBitmap(pBitmapTinyBlast, 270 - Angle_Of_Attack) ; Input the Angle
				ObjAttacks[New_Index, 7] := Gdip_RotateBitmap(pBitmapTinyBlastHit, 270 - Angle_Of_Attack) ; Input the Angle
			}
			ObjAttacks[New_Index, 4] := X_DIF
			ObjAttacks[New_Index, 5] := Y_DIF
			ObjAttacks[New_Index, 6] := 1 ; 1 = Ativo, 2 = Inativo (já houve colisão)
			ObjAttacks[New_Index, 8] := "SpikyFungus"
		}
		SoundPlay, %A_ScriptDir%/Sounds/FungusShot.wav
	}
}
Return

ShootBeamHability(Click_X_Pos, Click_Y_Pos)
{
	Global
	Click_Pos_X :=  Click_X_Pos
	Click_Pos_Y := Click_Y_Pos
	
	If (ObjAttacks.MaxIndex() = "")
	{
		ObjAttacks[1,1] := Player.PosX - 12
		ObjAttacks[1,2] := Player.PosY - 10
		Y_DIF := (Click_Pos_Y - Player.PosY - 17) * - 1
		X_DIF := Click_Pos_X - Player.PosX - 14
		
		% ((Y_DIF = 0) ? (Y_DIF := 0.01) : (""))
		% ((X_DIF = 0) ? (X_DIF := 0.01) : (""))
		
		Tangent_Of_Angle := Y_DIF / X_DIF
		Angle_Of_Attack := ATan(Tangent_Of_Angle) / 0.01745329252
		If (X_DIF >= 0)
		{
			ObjAttacks[1, 3] := Gdip_RotateBitmap(pBitmapBeam, 90 - Angle_Of_Attack) ; Input the Angle
			ObjAttacks[1, 7] := Gdip_RotateBitmap(pBitmapbeamblasthit, 90 - Angle_Of_Attack) ; Input the Angle
		}
		else
		{
			ObjAttacks[1, 3] := Gdip_RotateBitmap(pBitmapBeam, 270 - Angle_Of_Attack) ; Input the Angle
			ObjAttacks[1, 7] := Gdip_RotateBitmap(pBitmapbeamblasthit, 270 - Angle_Of_Attack) ; Input the Angle
		}
		ObjAttacks[1, 4] := X_DIF
		ObjAttacks[1, 5] := Y_DIF
		ObjAttacks[1, 6] := 1 ; 1 = Ativo, 2 = Inativo (já houve colisão)
		ObjAttacks[1, 8] := "Beam"
	}
	else
	{
		New_Index := ObjAttacks.MaxIndex() + 1
		ObjAttacks[New_Index,1] := Player.PosX - 12
		ObjAttacks[New_Index,2] := Player.PosY - 10
		X_DIF := Click_Pos_X - Player.PosX - 14 ; Players X position starts at the left-uppermost pixel of the sprite. Therefore, the middle of the sprite is 14 pixels away.
		Y_DIF := (Click_Pos_Y - Player.PosY - 17) * - 1
		
		% ((Y_DIF = 0) ? (Y_DIF := 0.01) : (""))
		% ((X_DIF = 0) ? (X_DIF := 0.01) : (""))
		
		Tangent_Of_Angle := Y_DIF / X_DIF ; Oposite / Adjacent
		Angle_Of_Attack := ATan(Tangent_Of_Angle) / 0.01745329252 ; Conversion between radians and degrees
		If (X_DIF > 0)
		{
			ObjAttacks[New_Index, 3] := Gdip_RotateBitmap(pBitmapBeam, 90 - Angle_Of_Attack) ; Input the Angle
			ObjAttacks[New_Index, 7] := Gdip_RotateBitmap(pBitmapbeamblasthit, 90 - Angle_Of_Attack) ; Input the Angle
		}
		Else If (X_DIF = 0)
		{
			ObjAttacks[New_Index, 3] := pBitmapTinyBlast ; Input the Angle
		}
		else
		{
			ObjAttacks[New_Index, 3] := Gdip_RotateBitmap(pBitmapBeam, 270 - Angle_Of_Attack) ; Input the Angle
			ObjAttacks[New_Index, 7] := Gdip_RotateBitmap(pBitmapbeamblasthit, 270 - Angle_Of_Attack) ; Input the Angle
		}
		ObjAttacks[New_Index, 4] := X_DIF
		ObjAttacks[New_Index, 5] := Y_DIF
		ObjAttacks[New_Index, 6] := 1 ; 1 = Ativo, 2 = Inativo (já houve colisão)
		ObjAttacks[New_Index, 8] := "Beam"
	}
	SoundPlay, %A_ScriptDir%/Sounds/BeamShot.wav
}
Return


;f3::
;Current_Y := 34800
;Return


~1::
If (TELEPORT_HABILITY_ACTIVATED)
{
	TELEPORT_SELECTED := 1, BEAM_SELECTED := 0, RECOVER_SELECTED := 0, PARALYZE_SELECTED := 0, SPEED_SELECTED := 0
	if (WMA9.controls.isAvailable("play"))
	{
		wma9.controls.play		
	}
}
Return

~2::
If (BEAM_HABILITY_ACTIVATED)
{
	TELEPORT_SELECTED := 0, BEAM_SELECTED := 1, RECOVER_SELECTED := 0, PARALYZE_SELECTED := 0, SPEED_SELECTED := 0
	if (WMA9.controls.isAvailable("play"))
	{
		wma9.controls.play		
	}
}
Return

~3::
If (RECOVER_HABILITY_ACTIVATED)
{
	TELEPORT_SELECTED := 0, BEAM_SELECTED := 0, RECOVER_SELECTED := 1, PARALYZE_SELECTED := 0, SPEED_SELECTED := 0
	if (WMA9.controls.isAvailable("play"))
	{
		wma9.controls.play		
	}
}
Return

~4::
If (PARALYZE_HABILITY_ACTIVATED)
{
	TELEPORT_SELECTED := 0, BEAM_SELECTED := 0, RECOVER_SELECTED := 0, PARALYZE_SELECTED := 1, SPEED_SELECTED := 0
	if (WMA9.controls.isAvailable("play"))
	{
		wma9.controls.play		
	}
}
Return

~5::
If (SPEED_HABILITY_ACTIVATED)
{
	TELEPORT_SELECTED := 0, BEAM_SELECTED := 0, RECOVER_SELECTED := 0, PARALYZE_SELECTED := 0, SPEED_SELECTED := 1
	if (WMA9.controls.isAvailable("play"))
	{
		wma9.controls.play		
	}
}
Return

~Space::
IfWinNotActive, ARCHMAGE_PLAY_SESSION
{
	Return
}
If ((TELEPORT_SELECTED = 1) AND (TELEPORT_HABILITY_ACTIVATED = 1))
{
	MouseGetPos, MousePosX, MousePosY
	Teleport(MousePosX, MousePosY)
}
If ((BEAM_SELECTED = 1) AND (BEAM_HABILITY_ACTIVATED = 1))
{
	If (BEAM_COOLDOWN > A_TickCount - 10000) ; If this is true, cooldown has not passed yet.
	{
		If (WMA8.controls.isAvailable("play"))
		{
			wma8.controls.play		
		}
	}
	else ; If not, than we can proceed with the routine.
	{
		MouseGetPos, MousePosX, MousePosY
		ShootBeamHability(MousePosX, MousePosY)
		BEAM_COOLDOWN := A_TickCount
	}
}
Else If ((RECOVER_SELECTED = 1) AND (RECOVER_HABILITY_ACTIVATED = 1))
{
	If (RECOVER_COOLDOWN > A_TickCount - 30000)  ; If this is true, cooldown has not passed yet.
	{
		If (WMA8.controls.isAvailable("play"))
		{
			wma8.controls.play		
		}
	}
	else ; If not, than we can proceed with the routine.
	{
		Player.Hitpoints := 100
		RECOVER_COOLDOWN := A_TickCount
		if (WMA10.controls.isAvailable("play"))
		{
			wma10.controls.play		
		}
	}
}
Else If ((PARALYZE_SELECTED = 1) AND (PARALYZE_HABILITY_ACTIVATED = 1))
{
	If (PARALYZE_COOLDOWN > A_TickCount - 20000) ; If this is true, cooldown has not passed yet.
	{
		If (WMA8.controls.isAvailable("play"))
		{
			wma8.controls.play		
		}
	}
	else ; If not, than we can proceed with the routine.
	{
		ENEMIES_ARE_PARALYZED := 1
		SetTimer, PARALYZE_OFF, 5000
		PARALYZE_COOLDOWN := A_TickCount
		if (WMA10.controls.isAvailable("play"))
		{
			wma10.controls.play		
		}
	}
}
Else If ((SPEED_SELECTED = 1) AND (SPEED_HABILITY_ACTIVATED = 1))
{
	If (SPEED_COOLDOWN > A_TickCount - 20000)
	{
		If (WMA8.controls.isAvailable("play"))
		{
			wma8.controls.play		
		}
	}
	else
	{
		Player.Speed := 9
		;Tooltip % "Speedy !"
		SetTimer, SPEED_OFF, 5000
		SPEED_COOLDOWN := A_TickCount
		if (WMA11.controls.isAvailable("play"))
		{
			wma11.controls.play		
		}
	}
}

Return


PARALYZE_OFF:
ENEMIES_ARE_PARALYZED := 0
SetTimer, PARALYZE_OFF, Off
Return


SPEED_OFF:
Player.Speed := 6
SetTimer, SPEED_OFF, Off
Return


Teleport(PosX, PosY)
{
	Global
	If !(TELEPORT_HABILITY_ACTIVATED)
	{
		Return
	}
	If (TELEPORT_COOLDOWN > A_TickCount - 10000)
	{
		If (WMA8.controls.isAvailable("play"))
		{
			wma8.controls.play		
		}
		Return
	}
	; First, we check if the desired target has a X value beyond the walking area. If so, we reset the X value to the Max/Min X value in the walkable area.
	If (PosX < 5)
	{
		PosX := 5
	}
	If (PosX > 479)
	{
		PosX := 479
	}

	; Next, we check if the target has a Y value beyond the visible area. If so, we reset the Y value to the Max/Min within the visible area.
	If (PosY < 5)
	{
		PosY := 5
	}
	If (PosY > 472)
	{
		PosY := 472
	}
	
	Player.PosX := PosX
	Current_Y := Current_Y - (PosY - 238)
	
	TELEPORT_COOLDOWN := A_TickCount
	
	if (WMA7.controls.isAvailable("play"))
	{
		wma7.controls.play		
	}
}
Return


DrawScene:
DrawBackGround()
DrawAttacks()
DrawPlayer()
DrawEnemies()
DrawHud()
If (FINAL_SCENE_PLAYING = 0)
{
	UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
}
Return

DrawBackground()
{
	Global
	Gdip_DrawImage(G, pBitmapScenary, 0, 0, 512, 512, 0, (70 * 512) - (CURRENT_Y + 512), 512, 512)
	

	If (Current_Y < 256)
	{
		DrawSign_Post()
	}
	
	If (Current_Y > 34816)
	{
		DrawSign_Post_2()
	}
	
	;y_to_use is a big number
	Loop % ITEM_COUNTER
	{
		If ((ITEM_%A_Index%.Initial_Y >= (69 * 512) - Current_Y + Player.PosY - 256 - ITEM_%A_Index%.Item_Object_Height) AND (ITEM_%A_Index%.Initial_Y <= (69 * 512) - Current_Y + Player.PosY + ITEM_%A_Index%.Item_Object_Height + 256) AND (ITEM_%A_Index%.Was_collected = 0))
		{
			Gdip_DrawImage(G, ITEM_%A_Index%.Item_Object_Bitmap, ITEM_%A_Index%.PosX, -1 * (((69 * 512) - ITEM_%A_Index%.Initial_Y) - Current_Y), ITEM_%A_Index%.Item_Object_Width, ITEM_%A_Index%.Item_Object_Height, 0, 0, ITEM_%A_Index%.Item_Object_Width, ITEM_%A_Index%.Item_Object_Height)
		}
	}
	
	
	If (Current_Y > 35272) ; If the player reaches the endpoint of the scenary...
	{
		If (WIZ_BOSS_DEAD) ; We check to see if he killed the wizard. If he did, we jump to the ending screen.
		{
		Gui, -AlwaysOnTop
		SetTimer, DrawScene, Off
		Msgbox, 0x0, End Point Reached, Congratulations !! You have succesfully defeated the enemy wizard lord and saved the kingdom from his evil !!
		Draw_Final_Scene()
		FINAL_SCENE_PLAYING := 1
		}
		else ; Otherwise, we just cancel out the players movement.
		{
			Current_Y := Current_Y - Player.Speed
		}
	}
}
Return

Draw_Final_Scene()
{
	Global
	Gdip_DrawImage(G, pBitmapFinalScene, 0, 0, 512, 512, 0, 0, 512, 512)
	UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
	OnMessage(0x201, "") ; Turn off monitoring of mouse clicks. 
	STORY_TEXT_CURRENT_Y := 512
	DRAW_STORY_PIXEL_COUNTER := 0
	SetTimer, DrawFinalScene, 80
}
Return


DrawFinalScene:
If (DRAW_STORY_PIXEL_COUNTER < 1277) ; This number is just a renmnant o the DrawStory routine (this routine is a copy of it). It does implement a nice delay of after the message ends though.
{
	Gdip_DrawImage(G, pBitmapFinalScene, 0, 0, 512, 512, 0, 0, 512, 512)
	STORY_TEXT_CURRENT_Y := STORY_TEXT_CURRENT_Y - 1
	Gdip_DrawImage(G, pBitmapEndingStory, 0, STORY_TEXT_CURRENT_Y, 512, 600, 0, 0, 512, 600)
	UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
	DRAW_STORY_PIXEL_COUNTER++
}
If (DRAW_STORY_PIXEL_COUNTER = 1277)
{
	Reload
	ExitApp
}
Return

DrawHud()
{
	Global
	Gdip_DrawImage(G, pBitmapHud, 381, 433, 121, 68, 0, 0, 121, 68)
	
	LIFE_TO_DRAW := Player.hitpoints / 10
	
	Loop % Round(LIFE_TO_DRAW, 0)
	{
		Gdip_DrawImage(G, pBitmap10Life, 387 + ((A_Index - 1) * 11), 465, 11, 12, 0, 0, 11, 12)
	}
	
	If (TELEPORT_HABILITY_ACTIVATED = 1)
	{
		Gdip_DrawImage(G, pBitmapLexiko1, 385, 438, 20, 25, 0, 0, 20, 25)
	}
	If (BEAM_HABILITY_ACTIVATED = 1)
	{
		Gdip_DrawImage(G, pBitmapLexiko2, 408, 438, 20, 25, 0, 0, 20, 25)
	}
	If (RECOVER_HABILITY_ACTIVATED = 1)
	{
		Gdip_DrawImage(G, pBitmapLexiko3, 431, 438, 20, 25, 0, 0, 20, 25)
	}
	If (PARALYZE_HABILITY_ACTIVATED = 1)
	{
		Gdip_DrawImage(G, pBitmapLexiko4, 454, 438, 20, 25, 0, 0, 20, 25)
	}
	If (SPEED_HABILITY_ACTIVATED = 1)
	{
		Gdip_DrawImage(G, pBitmapLexiko5, 477, 438, 20, 25, 0, 0, 20, 25)
	}
	
	If (TELEPORT_SELECTED = 1)
	{
		Gdip_DrawImage(G, pBitmapScrollSelected, 385, 439, 20, 25, 0, 0, 20, 25)
		COOLDOWN_PASSED := A_tickCount - TELEPORT_COOLDOWN
		If (COOLDOWN_PASSED >= 10000) OR (TELEPORT_COOLDOWN = "")
		{
			Loop % 10
			{
				Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
			}
		}
		else
		{
			BLOCKS_TO_DRAW := Floor(((COOLDOWN_PASSED / 10000) * 10))
			{
				Loop % BLOCKS_TO_DRAW
				{
					Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
				}
			}
		}
	}
	
	If (BEAM_SELECTED = 1)
	{
		Gdip_DrawImage(G, pBitmapScrollSelected, 408, 439, 20, 25, 0, 0, 20, 25)
		COOLDOWN_PASSED := A_tickCount - BEAM_COOLDOWN
		If (COOLDOWN_PASSED >= 10000) OR (BEAM_COOLDOWN = "")
		{
			Loop % 10
			{
				Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
			}
		}
		else
		{
			BLOCKS_TO_DRAW := Floor(((COOLDOWN_PASSED / 10000) * 10))
			{
				Loop % BLOCKS_TO_DRAW
				{
					Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
				}
			}
		}
	}
	
	If (RECOVER_SELECTED = 1)
	{
		Gdip_DrawImage(G, pBitmapScrollSelected, 431, 439, 20, 25, 0, 0, 20, 25)
		COOLDOWN_PASSED := A_tickCount - RECOVER_COOLDOWN
		If (COOLDOWN_PASSED >= 30000) OR (RECOVER_COOLDOWN = "")
		{
			Loop % 10
			{
				Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
			}
		}
		else
		{
			BLOCKS_TO_DRAW := Floor(((COOLDOWN_PASSED / 30000) * 10))
			{
				Loop % BLOCKS_TO_DRAW
				{
					Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
				}
			}
		}
	}
	
	If (PARALYZE_SELECTED = 1)
	{
		Gdip_DrawImage(G, pBitmapScrollSelected, 454, 439, 20, 25, 0, 0, 20, 25)
		COOLDOWN_PASSED := A_tickCount - PARALYZE_COOLDOWN
		If (COOLDOWN_PASSED >= 20000) OR (PARALYZE_COOLDOWN = "")
		{
			Loop % 10
			{
				Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
			}
		}
		else
		{
			BLOCKS_TO_DRAW := Floor(((COOLDOWN_PASSED / 20000) * 10))
			{
				Loop % BLOCKS_TO_DRAW
				{
					Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
				}
			}
		}
	}
	
	If (SPEED_SELECTED = 1)
	{
		Gdip_DrawImage(G, pBitmapScrollSelected, 477, 439, 20, 25, 0, 0, 20, 25)
		COOLDOWN_PASSED := A_tickCount - SPEED_COOLDOWN
		If (COOLDOWN_PASSED >= 20000) OR (SPEED_COOLDOWN = "")
		{
			Loop % 10
			{
				Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
			}
		}
		else
		{
			BLOCKS_TO_DRAW := Floor(((COOLDOWN_PASSED / 20000) * 10))
			{
				Loop % BLOCKS_TO_DRAW
				{
					Gdip_DrawImage(G, pBitmap10Mana, 387 + ((A_Index - 1) * 11), 483, 11, 12, 0, 0, 11, 12)
				}
			}
		}
	}
}

class Item_Object
{
	__New(X_Pos, Initial_Y, Item_Object_Type)
	{
		Global pBitmapLexiko1, pBitmapLexiko2, pBitmapLexiko3, pBitmapLexiko4, pBitmapLexiko5
		; Item objects can be
		; 1. LEXIKOS: These are scrolls the player can pick to activate hidden habilities upon selecting and pressing the spacebar.
		; 1.1 Teleport. Teleports the player to the position of the cursor. CoolDown 10 secs.
		; 1.2 Beam. Shoots a beam of light that hits an enemy for 100 damage. CoolDown 10 secs.
		; 1.3 Recover. Restores the players hitpoints to 100. CoolDown 30 secs.
		; 1.4 Paralyze. Enemies will not move towards the player for 5 secs. CoolDown 20 secs.
		; 1.5 Speed. The player gains a 50% speed boost for 5 secs. CoolDown 20 secs.
		
		this.PosX := X_Pos
		this.Initial_Y := Initial_Y
		
		If (Item_Object_Type = 1)
		{
			this.Item_Object_Bitmap := pBitmapLexiko1
			this.Item_Object_Width := 20
			this.Item_Object_Height := 25
			this.Has_Missile_Colision := 0
			this.Was_collected := 0
			this.ColBox_X1 := 1
			this.ColBox_X2 := 20
			this.ColBox_Y1 := 1
			this.ColBox_Y2 := 25
		}
		
		Else If (Item_Object_Type = 2)
		{
			this.Item_Object_Bitmap := pBitmapLexiko2
			this.Item_Object_Width := 20
			this.Item_Object_Height := 25
			this.Has_Missile_Colision := 0
			this.Was_collected := 0
			this.ColBox_X1 := 1
			this.ColBox_X2 := 20
			this.ColBox_Y1 := 1
			this.ColBox_Y2 := 25
		}
		
		Else If (Item_Object_Type = 3)
		{
			this.Item_Object_Bitmap := pBitmapLexiko3
			this.Item_Object_Width := 20
			this.Item_Object_Height := 25
			this.Has_Missile_Colision := 0
			this.Was_collected := 0
			this.ColBox_X1 := 1
			this.ColBox_X2 := 20
			this.ColBox_Y1 := 1
			this.ColBox_Y2 := 25
		}
		
		Else If (Item_Object_Type = 4)
		{
			this.Item_Object_Bitmap := pBitmapLexiko4
			this.Item_Object_Width := 20
			this.Item_Object_Height := 25
			this.Has_Missile_Colision := 0
			this.Was_collected := 0
			this.ColBox_X1 := 1
			this.ColBox_X2 := 20
			this.ColBox_Y1 := 1
			this.ColBox_Y2 := 25
		}
		
		Else If (Item_Object_Type = 5)
		{
			this.Item_Object_Bitmap := pBitmapLexiko5
			this.Item_Object_Width := 20
			this.Item_Object_Height := 25
			this.Has_Missile_Colision := 0
			this.Was_collected := 0
			this.ColBox_X1 := 1
			this.ColBox_X2 := 20
			this.ColBox_Y1 := 1
			this.ColBox_Y2 := 25
		}
	}
}
Return

class Scene_Object
{
	__New(X_Pos, Initial_Y, Scene_Object_Type)
	{
		Global pBitmapTree, pBitmapTree2, pBitmapTree3, pBitmapTree4, pBitmapTree5, pBitmapTree6, pBitmapTree7, pBitmapSmallTree, pBitmapSmallTree2, pBitmapSmallTree3, pBitmapSmallTree4, pBitmapSquareBush, pBitmapStarBush, pBitmapStarBush2, pBitmapStarBush3, pBitmapPineBush, pBitmapLongLeafBush, pBitmapBranch1, pBitmapBranch2, pBitmapPatch1, pBitmapPatch2, pBitmapPatch3, pBitmapPatch4, pBitmapArtifact1, pBitmapArtifact2, pBitmapArtifact3, pBitmapArtifact4, pBitmapArtifact5, pBitmapArtifact6
		this.PosX := X_Pos
		this.Initial_Y := Initial_Y
		
		; Scene_Object_Type can be:
		; ARTIFACTS:
		; 1. Artifact 1
		; 2. Artifact 2
		; 3. Artifact 3
		; 4. Artifact 4
		; 5. Artifact 5
		; 6. Artifact 6
		
		; NON-COLISIONABLE OBJECTS:
		; 11. SquareBush
		; 12. StarBush
		; 13. LongLeafTree
		
		;COLISIONABLE OBJECTS:
		; 31. SmallTree
		; 32. PineBush
		; 33. Tree
		; 34. Tree2
		
		; ARTIFACTS 
		; DESCRIPTION: These are shadows of various distorted forms that serve to create an illusion of dust/water and/or small lump areas in the soil. This gives a more realistic feel to the ground texture.
		
		If (Scene_Object_Type = "1")
		{
			this.Scene_Object_Bitmap := pBitmapArtifact1
			this.Scene_Object_Width := 80
			this.Scene_Object_Height := 100
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		Else If (Scene_Object_Type = "2")
		{
			this.Scene_Object_Bitmap := pBitmapArtifact2
			this.Scene_Object_Width := 80
			this.Scene_Object_Height := 100
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		Else If (Scene_Object_Type = "3")
		{
			this.Scene_Object_Bitmap := pBitmapArtifact3
			this.Scene_Object_Width := 80
			this.Scene_Object_Height := 100
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		Else If (Scene_Object_Type = "4")
		{
			this.Scene_Object_Bitmap := pBitmapArtifact4
			this.Scene_Object_Width := 80
			this.Scene_Object_Height := 100
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		Else If (Scene_Object_Type = "5")
		{
			this.Scene_Object_Bitmap := pBitmapArtifact5
			this.Scene_Object_Width := 80
			this.Scene_Object_Height := 100
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		Else If (Scene_Object_Type = "6")
		{
			this.Scene_Object_Bitmap := pBitmapArtifact6
			this.Scene_Object_Width := 80
			this.Scene_Object_Height := 100
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		
		; NON-COLISIONABLE OBJECTS 
		; DESCRIPTION: These are folliage/vegetation/loose branches and other small objects that the player should be able to trample or transpose with ease in the real world. Also, the player should be able to aim above these, so they will not block player movement or missiles.
		
		Else If (Scene_Object_Type = "11")
		{
			this.Scene_Object_Bitmap := pBitmapStarBush
			this.Scene_Object_Width := 25
			this.Scene_Object_Height := 20
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		Else If (Scene_Object_Type = "12")
		{
			this.Scene_Object_Bitmap := pBitmapStarBush2
			this.Scene_Object_Width := 25
			this.Scene_Object_Height := 20
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		Else If (Scene_Object_Type = "13")
		{
			this.Scene_Object_Bitmap := pBitmapStarBush3
			this.Scene_Object_Width := 25
			this.Scene_Object_Height := 20
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 0
			this.ColBox_X2 := 0 
			this.ColBox_Y1 := 0 
			this.ColBox_Y2 := 0
		}
		Else If (Scene_Object_Type = "14")
		{
			this.Scene_Object_Bitmap := pBitmapLongLeafBush
			this.Scene_Object_Width := 40
			this.Scene_Object_Height := 50
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 13
			this.ColBox_X2 := 24 
			this.ColBox_Y1 := 9 
			this.ColBox_Y2 := 34
		}
		Else If (Scene_Object_Type = "15")
		{
			this.Scene_Object_Bitmap := pBitmapBranch1
			this.Scene_Object_Width := 40
			this.Scene_Object_Height := 25
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 13
			this.ColBox_X2 := 24 
			this.ColBox_Y1 := 9 
			this.ColBox_Y2 := 34
		}
		Else If (Scene_Object_Type = "16")
		{
			this.Scene_Object_Bitmap := pBitmapBranch2
			this.Scene_Object_Width := 30
			this.Scene_Object_Height := 30
			this.Has_Missile_Colision := 0
			this.ColBox_X1 := 13
			this.ColBox_X2 := 24 
			this.ColBox_Y1 := 9 
			this.ColBox_Y2 := 34
		}
		
		; COLISIONABLE OBJETS
		; DESCRIPTION: These are large objects (trees, etc) that should impose a dificulty for the player or a missile to transpose. Instead of walking or shooting right past them, the player will have to move around them.
		
		Else If (Scene_Object_Type = 31)
		{
			this.Scene_Object_Bitmap := pBitmapSmallTree
			this.Scene_Object_Width := 50
			this.Scene_Object_Height := 60
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 15
			this.ColBox_X2 := 35 
			this.ColBox_Y1 := 11 
			this.ColBox_Y2 := 56
		}
		Else If (Scene_Object_Type = 32)
		{
			this.Scene_Object_Bitmap := pBitmapSmallTree2
			this.Scene_Object_Width := 65
			this.Scene_Object_Height := 67
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 18
			this.ColBox_X2 := 42 
			this.ColBox_Y1 := 14 
			this.ColBox_Y2 := 55
		}
		Else If (Scene_Object_Type = 33)
		{
			this.Scene_Object_Bitmap := pBitmapSmallTree3
			this.Scene_Object_Width := 65
			this.Scene_Object_Height := 67
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 18
			this.ColBox_X2 := 42 
			this.ColBox_Y1 := 14 
			this.ColBox_Y2 := 55
		}
		Else If (Scene_Object_Type = 34)
		{
			this.Scene_Object_Bitmap := pBitmapSmallTree4
			this.Scene_Object_Width := 40
			this.Scene_Object_Height := 50
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 12
			this.ColBox_X2 := 26 
			this.ColBox_Y1 := 15 
			this.ColBox_Y2 := 47
		}
		Else If Scene_Object_Type between 35 and 36  ; This comparisson using between makes it twice more likely for a grown tree to be selected than of a small tree.
		{
			this.Scene_Object_Bitmap := pBitmapTree3
			this.Scene_Object_Width := 130
			this.Scene_Object_Height := 130
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 42
			this.ColBox_X2 := 81
			this.ColBox_Y1 := 40
			this.ColBox_Y2 := 111
		}
		Else If Scene_Object_Type between 37 and 38
		{
			this.Scene_Object_Bitmap := pBitmapTree4
			this.Scene_Object_Width := 100
			this.Scene_Object_Height := 120
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 36
			this.ColBox_X2 := 67
			this.ColBox_Y1 := 35
			this.ColBox_Y2 := 108
		}
		Else If Scene_Object_Type between 39 and 40
		{
			this.Scene_Object_Bitmap := pBitmapTree5
			this.Scene_Object_Width := 130
			this.Scene_Object_Height := 130
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 42
			this.ColBox_X2 := 81
			this.ColBox_Y1 := 40
			this.ColBox_Y2 := 111
		}
		Else If Scene_Object_Type between 41 and 42
		{
			this.Scene_Object_Bitmap := pBitmapTree6
			this.Scene_Object_Width := 100
			this.Scene_Object_Height := 120
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 36
			this.ColBox_X2 := 67
			this.ColBox_Y1 := 35
			this.ColBox_Y2 := 108
		}
		Else If Scene_Object_Type between 43 and 44
		{
			this.Scene_Object_Bitmap := pBitmapTree7
			this.Scene_Object_Width := 80
			this.Scene_Object_Height := 100
			this.Has_Missile_Colision := 1
			this.ColBox_X1 := 22
			this.ColBox_X2 := 55
			this.ColBox_Y1 := 25
			this.ColBox_Y2 := 94
		}
	}
}
Return


DrawPlayer()
{
	Global
	W_State := GetKeyState("W")
	If ((W_State) AND !(CheckPlayerColision(Player.PosX, 238 - Player.Speed)))
	{
		If (Sprite_Count < 8)
		{
			Sprite_Count++
		}
		else
		{
			Sprite_Count := 1
		}
		Current_Y := Current_Y + Player.Speed
		Sprite_Number := Round(Sprite_Count / 2, 0)
		Current_Sprite_Player := pBitmapPlayer_Mov_Up_%Sprite_Number%
	}
	
	S_State := GetKeyState("S")
	If ((S_State) AND (Current_Y > 0) AND !(CheckPlayerColision(Player.PosX, 238 + Player.Speed)))
	{
		If (Sprite_Count < 8)
		{
			Sprite_Count++
		}
		else
		{
			Sprite_Count := 1
		}
		Current_Y := Current_Y - Player.Speed
		Sprite_Number := Round(Sprite_Count / 2, 0)
		Current_Sprite_Player := pBitmapPlayer_Mov_Up_%Sprite_Number%
	}
	
	D_State := GetKeyState("D")
	If ((D_State) AND (Player.PosX < 479) AND !(CheckPlayerColision(Player.PosX + Player.Speed, 238)))
	{
		If (Sprite_Count < 8)
		{
			Sprite_Count++
		}
		else
		{
			Sprite_Count := 1
		}
		Sprite_Number := Round(Sprite_Count / 2, 0)
		Player.PosX := Player.PosX + Player.Speed
		Current_Sprite_Player := pBitmapPlayer_Mov_Up_%Sprite_Number%
	}
	
	A_State := GetKeyState("A")
	If ((A_State) AND (Player.PosX > 5) AND !(CheckPlayerColision(Player.PosX - Player.Speed, 238)))
	{
		If (Sprite_Count < 8)
		{
			Sprite_Count++
		}
		else
		{
			Sprite_Count := 1
		}
		Sprite_Number := Round(Sprite_Count / 2, 0)
		Player.PosX := Player.PosX - Player.Speed
		Current_Sprite_Player := pBitmapPlayer_Mov_Up_%Sprite_Number%
	}
	
	If (PLAYER_IS_HURT)
	{
		PLAYER_IS_HURT := 0
		Current_Sprite_Player := pBitmapPlayer_Hurt
	}
	
	Gdip_DrawImage(G, Current_Sprite_Player, Player.PosX, Player.PosY, 28, 35, 0, 0, 28, 35)
	
	WHICH_ITEM := 0
	If (WHICH_ITEM := CheckItemColision(Player.PosX, 238))
	{
		Item_%WHICH_ITEM%.WAS_collected := 1 ; This property is used for rendering purposes and for hability enabling.
		If (Item_%WHICH_ITEM%.Item_Object_Bitmap = pBitmapLexiko1)
		{
			TELEPORT_HABILITY_ACTIVATED := 1
			TELEPORT_SELECTED := 1, BEAM_SELECTED := 0, RECOVER_SELECTED := 0, PARALYZE_SELECTED := 0, SPEED_SELECTED := 0
			Gdip_DrawImage(G3, pBitmapLexiko3, , Player.PosY, 28, 35, 0, 0, 28, 35)
		}
		Else if (Item_%WHICH_ITEM%.Item_Object_Bitmap = pBitmapLexiko2)
		{
			BEAM_HABILITY_ACTIVATED := 1
			TELEPORT_SELECTED := 0, BEAM_SELECTED := 1, RECOVER_SELECTED := 0, PARALYZE_SELECTED := 0, SPEED_SELECTED := 0
		}
		Else if (Item_%WHICH_ITEM%.Item_Object_Bitmap = pBitmapLexiko3)
		{
			RECOVER_HABILITY_ACTIVATED := 1
			TELEPORT_SELECTED := 0, BEAM_SELECTED := 0, RECOVER_SELECTED := 1, PARALYZE_SELECTED := 0, SPEED_SELECTED := 0
		}
		Else if (Item_%WHICH_ITEM%.Item_Object_Bitmap = pBitmapLexiko4)
		{
			PARALYZE_HABILITY_ACTIVATED := 1
			TELEPORT_SELECTED := 0, BEAM_SELECTED := 0, RECOVER_SELECTED := 0, PARALYZE_SELECTED := 1, SPEED_SELECTED := 0
		}
		Else if (Item_%WHICH_ITEM%.Item_Object_Bitmap = pBitmapLexiko5)
		{
			SPEED_HABILITY_ACTIVATED := 1
			TELEPORT_SELECTED := 0, BEAM_SELECTED := 0, RECOVER_SELECTED := 0, PARALYZE_SELECTED := 0, SPEED_SELECTED := 1
		}
		
		if (WMA9.controls.isAvailable("play")) ; Item Collected
		{
			wma9.controls.play		
		}
	}
}
Return


DrawEnemies()
{
	Global
	Loop % ENEMIES_COUNTER
	{
		If ((Current_Y > Enemy_%A_index%.Current_Y_Pos) and (Current_Y < (Enemy_%A_index%.Current_Y_Pos + 512)) and (Enemy_%A_index%.Active = 0) and (Enemy_%A_Index%.Current_Hitpoints > 0)) ; enemy goes into active mode when current y > 1024.
		{
			;Tooltip % "Bingo!"
			Enemy_%A_index%.Active := 1
		}
		
		; Variable below will make sure the enemy can move in more than 1 direction (i.e: both down and to the left) but his sprite will only display 1 change (so that movement animation is always regular).
		Enemy_%A_Index%.Yet_To_Draw_Move := 1
		
		If ((Enemy_%A_Index%.Active = 1) AND (Enemy_%A_Index%.Current_Hitpoints > 0))
		{
			;ToolTip % Enemy_%A_Index%.Current_Y_Pos . "`n" . CURRENT_Y - 238
			If ((CURRENT_Y - 270  < Enemy_%A_Index%.Current_Y_Pos) AND (ENEMIES_ARE_PARALYZED = 0))
			{
				Enemy_%A_Index%.Move_Down(Current_Y)
				If (((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_1) OR (Enemy_%A_Index%.Current_Sprite = "") OR (Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Up_1) OR (Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Up_2) OR (Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Up_3) OR (Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Up_4)) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					;ToolTip % Enemy_%A_Index%.Current_Sprite
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_2
				}
				Else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_2) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_3
				}
				Else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_3) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_4
				}
				else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_4) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_1
				}
				Enemy_%A_Index%.Yet_To_Draw_Move := 0
			}
			Else If ((CURRENT_Y - 270 > Enemy_%A_Index%.Current_Y_Pos) AND (ENEMIES_ARE_PARALYZED = 0))
			{
				Enemy_%A_Index%.Move_Up(Current_Y)
				;ToolTip % "UP!"
				If (((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Up_1) OR (Enemy_%A_Index%.Current_Sprite = "") OR (Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_1) OR (Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_2) OR (Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_3) OR (Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_4)) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Up_2
				}
				Else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Up_2) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Up_3
				}
				Else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Up_3) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Up_4
				}
				else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Up_4) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Up_1
				}
				Enemy_%A_Index%.Yet_To_Draw_Move := 0
			}
			If ((Player.PosX <  Enemy_%A_Index%.Current_X_Pos) AND (ENEMIES_ARE_PARALYZED = 0))
			{
				Enemy_%A_Index%.Move_Left(Current_Y)
				If (((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_1) OR (Enemy_%A_Index%.Current_Sprite = "")) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_2
				}
				Else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_2)  AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_3
				}
				Else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_3)  AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_4
				}
				else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_4) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_1
				}
				Enemy_%A_Index%.Yet_To_Draw_Move := 0
			}
			If ((Player.PosX > Enemy_%A_Index%.Current_X_Pos) AND (ENEMIES_ARE_PARALYZED = 0))
			{
				Enemy_%A_Index%.Move_Right(Current_Y)
				If (((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_1) OR (Enemy_%A_Index%.Current_Sprite = "")) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_2
				}
				Else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_2) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_3
				}
				Else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_3) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_4
				}
				else If ((Enemy_%A_Index%.Current_Sprite = Enemy_%A_Index%.pBitmap_Down_4) AND (Enemy_%A_Index%.Yet_To_Draw_Move = 1))
				{
					Enemy_%A_Index%.Current_Sprite := Enemy_%A_Index%.pBitmap_Down_1
				}
				Enemy_%A_Index%.Yet_To_Draw_Move := 0
			}
			
			
			Gdip_DrawImage(G, Enemy_%A_Index%.Current_Sprite, Enemy_%A_Index%.Current_X_Pos, Mod(Current_Y, Enemy_%A_Index%.Current_Y_Pos) - 70, 56, 70, 0, 0, 56, 70)
			;UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
			
			If (( Player.PosY >= (  Mod(Current_Y, Enemy_%A_Index%.Current_Y_Pos) - 30 - Enemy_%A_Index%.Speed)) and (Player.PosY <= (  Mod(Current_Y, Enemy_%A_Index%.Current_Y_Pos) - 30 + Enemy_%A_Index%.Speed)) and (Player.PosX >= Enemy_%A_index%.Current_X_Pos - Enemy_%A_index%.Speed) and (Player.PosX <= Enemy_%A_index%.Current_X_Pos + Enemy_%A_index%.Speed) and (A_TickCount - Player.CoolDown > 1000))
			{
				Player.HitPoints := Player.Hitpoints - Enemy_%A_index%.Power
				PLAYER_IS_HURT := 1 ; Used for drawing a red sprite
				
				Player.CoolDown := A_TickCount
				If (Player.HitPoints <= 0) ; If this is true, the player has died.
				{
					if (WMA6.controls.isAvailable("play"))
					{
						wma6.controls.play		
					}
					Gui, -AlwaysOnTop
					Game_Over := 1 ; This variable turns the hotkey Enter ON (it reloads the script if the player died).
					SetTimer, DrawScene, Off
					OnMessage(0x201, "") ; Turns off the shooting routine.
					Gdip_DrawImage(G, pBitmapNewJourney, 0, 0, 512, 512, 0, 0, 512, 512) ; Draw everything black first.
					Gdip_DrawImage(G, pBitmapGameOver, 0, 0, 512, 512, 0, 0, 512, 512) ; Then draws the gameover screen.
					UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
					Sleep 30000 ; Wait 30 secs for the user to press the enter key. If not pressed, proceed to reload regardless.
					Reload
				}
				else
				{
					if (WMA5.controls.isAvailable("play"))
					{
						wma5.controls.play		
					}
				}
			}
		}
	}
}
Return

#If (Game_Over)
Enter::
Reload
Return
#If

; CURRENT_Y OF THE ENEMIES IS RELATIVE TO SCREEN AT THE MOMENT. IT SHOULD BE MADE RELATIVE TO THE MAP.
Class Enemy
{
	__New(X_Pos, Initial_Y, Enemy_Type)
	{
		Global pBitmapClayman_Down_1, pBitmapClayman_Down_2, pBitmapClayman_Down_3, pBitmapClayman_Down_4, pBitmapClayman_Up_1, pBitmapClayman_Up_2, pBitmapClayman_Up_3, pBitmapClayman_Up_4, pBitmapClayman_Dead, pBitmapClayman_Dead_2, pBitmapSpider_Down_1, pBitmapSpider_Down_2, pBitmapSpider_Down_3, pBitmapSpider_Down_4, pBitmapSpider_Up_1, pBitmapSpider_Up_2, pBitmapSpider_Up_3, pBitmapSpider_Up_4, pBitmapSpider_Dead, pBitmapSpider_Dead_2, pBitmapBat_Down_1, pBitmapBat_Down_2, pBitmapBat_Down_3, pBitmapBat_Down_4, pBitmapBat_Up_1, pBitmapBat_Up_2, pBitmapBat_Up_3, pBitmapBat_Up_4, pBitmapBat_Dead, pBitmapBat_Dead_2, pBitmapPoison_Spider_Down_1, pBitmapPoison_Spider_Down_2, pBitmapPoison_Spider_Down_3, pBitmapPoison_Spider_Down_4, pBitmapPoison_Spider_Up_1, pBitmapPoison_Spider_Up_2, pBitmapPoison_Spider_Up_3, pBitmapPoison_Spider_Up_4, pBitmapPoison_Spider_Dead, pBitmapPoison_Spider_Dead_2, pBitmapRockman_Down_1, pBitmapRockman_Down_2, pBitmapRockman_Down_3, pBitmapRockman_Down_4, pBitmapRockman_Up_1, pBitmapRockman_Up_2, pBitmapRockman_Up_3, pBitmapRockman_Up_4, pBitmapRockman_Dead, pBitmapRockman_Dead_2, pBitmapIceman_Down_1, pBitmapIceman_Down_2, pBitmapIceman_Down_3, pBitmapIceman_Down_4, pBitmapIceman_Up_1, pBitmapIceman_Up_2, pBitmapIceman_Up_3, pBitmapIceman_Up_4, pBitmapIceman_Dead, pBitmapIceman_Dead_2, pBitmapBlood_Bat_Down_1, pBitmapBlood_Bat_Down_2, pBitmapBlood_Bat_Down_3, pBitmapBlood_Bat_Down_4, pBitmapBlood_Bat_Up_1, pBitmapBlood_Bat_Up_2, pBitmapBlood_Bat_Up_3, pBitmapBlood_Bat_Up_4, pBitmapBlood_Bat_Dead, pBitmapBlood_Bat_Dead_2, pBitmapFireman_Down_1, pBitmapFireman_Down_2, pBitmapFireman_Down_3, pBitmapFireman_Down_4, pBitmapFireman_Up_1, pBitmapFireman_Up_2, pBitmapFireman_Up_3, pBitmapFireman_Up_4, pBitmapFireman_Dead, pBitmapFireman_Dead_2, pBitmapWiz_Down_1, pBitmapWiz_Down_2, pBitmapWiz_Down_3, pBitmapWiz_Down_4, pBitmapWiz_Up_1, pBitmapWiz_Up_2, pBitmapWiz_Up_3, pBitmapWiz_Up_4, pBitmapWiz_Dead, pBitmapWiz_Dead_2
		
		this.Initial_Y_Pos := Initial_Y ; This one will not change (Current_Y_Pos on the other hand will change as soon as the enemy is activated).
		this.Current_X_Pos := X_Pos ; Current X position of the monster.
		this.Current_Y_Pos := Initial_Y ; Current Y position of the monster.
		this.Active := 0 ; Wether the monster is currently active (thus needing to be moved every tic) or not.
		this.Yet_To_Draw_Move := 0
		this.Current_Sprite := ""
		
		; ENEMIES LIST:
		; 1. Clayman
		; 2. SPIDER
		
		If (Enemy_Type = 1) ; Clayman. Basic enemy: Slow, average HP.
		{
			this.pBitmap_Down_1 := pBitmapClayman_Down_1
			this.pBitmap_Down_2 := pBitmapClayman_Down_2
			this.pBitmap_Down_3 := pBitmapClayman_Down_3
			this.pBitmap_Down_4 := pBitmapClayman_Down_4
			this.pBitmap_Up_1 := pBitmapClayman_Up_1
			this.pBitmap_Up_2 := pBitmapClayman_Up_2
			this.pBitmap_Up_3 := pBitmapClayman_Up_3
			this.pBitmap_Up_4 := pBitmapClayman_Up_4
			this.pBitmap_Dead := pBitmapClayman_Dead
			this.pBitmap_Dead_2 := pBitmapClayman_Dead_2
			this.Speed := 3
			this.Current_Hitpoints := 50
			this.Power := 10
		}
		Else If (Enemy_Type = 2) ; Spider. Another basic enemy. A little faster than clayman, but weaker.
		{
			this.pBitmap_Down_1 := pBitmapSpider_Down_1
			this.pBitmap_Down_2 := pBitmapSpider_Down_2
			this.pBitmap_Down_3 := pBitmapSpider_Down_3
			this.pBitmap_Down_4 := pBitmapSpider_Down_4
			this.pBitmap_Up_1 := pBitmapSpider_Up_1
			this.pBitmap_Up_2 := pBitmapSpider_Up_2
			this.pBitmap_Up_3 := pBitmapSpider_Up_3
			this.pBitmap_Up_4 := pBitmapSpider_Up_4
			this.pBitmap_Dead := pBitmapSpider_Dead
			this.pBitmap_Dead_2 := pBitmapSpider_Dead_2
			this.Speed := 4
			this.Current_Hitpoints := 30
			this.Power := 10
		}
		Else If (Enemy_Type = 3) ; Bat. An improvement over the spider. Above average speed and average HP.
		{
			this.pBitmap_Down_1 := pBitmapBat_Down_1
			this.pBitmap_Down_2 := pBitmapBat_Down_2
			this.pBitmap_Down_3 := pBitmapBat_Down_3
			this.pBitmap_Down_4 := pBitmapBat_Down_4
			this.pBitmap_Up_1 := pBitmapBat_Up_1
			this.pBitmap_Up_2 := pBitmapBat_Up_2
			this.pBitmap_Up_3 := pBitmapBat_Up_3
			this.pBitmap_Up_4 := pBitmapBat_Up_4
			this.pBitmap_Dead := pBitmapBat_Dead
			this.pBitmap_Dead_2 := pBitmapBat_Dead_2
			this.Speed := 5
			this.Current_Hitpoints := 50
			this.Power := 10
		}
		Else If (Enemy_Type = 4) ; Poison Spider. Very fast, but below average HP.
		{
			this.pBitmap_Down_1 := pBitmapPoison_Spider_Down_1
			this.pBitmap_Down_2 := pBitmapPoison_Spider_Down_2
			this.pBitmap_Down_3 := pBitmapPoison_Spider_Down_3
			this.pBitmap_Down_4 := pBitmapPoison_Spider_Down_4
			this.pBitmap_Up_1 := pBitmapPoison_Spider_Up_1
			this.pBitmap_Up_2 := pBitmapPoison_Spider_Up_2
			this.pBitmap_Up_3 := pBitmapPoison_Spider_Up_3
			this.pBitmap_Up_4 := pBitmapPoison_Spider_Up_4
			this.pBitmap_Dead := pBitmapPoison_Spider_Dead
			this.pBitmap_Dead_2 := pBitmapPoison_Spider_Dead_2
			this.Speed := 7
			this.Current_Hitpoints := 40
			this.Power := 20
		}
		Else If (Enemy_Type = 5) ; Rockman. Hard basic enemy. Fast and strong.
		{
			this.pBitmap_Down_1 := pBitmapRockman_Down_1
			this.pBitmap_Down_2 := pBitmapRockman_Down_2
			this.pBitmap_Down_3 := pBitmapRockman_Down_3
			this.pBitmap_Down_4 := pBitmapRockman_Down_4
			this.pBitmap_Up_1 := pBitmapRockman_Up_1
			this.pBitmap_Up_2 := pBitmapRockman_Up_2
			this.pBitmap_Up_3 := pBitmapRockman_Up_3
			this.pBitmap_Up_4 := pBitmapRockman_Up_4
			this.pBitmap_Dead := pBitmapRockman_Dead
			this.pBitmap_Dead_2 := pBitmapRockman_Dead_2
			this.Speed := 6
			this.Current_Hitpoints := 70
			this.Power := 20
		}
		Else If (Enemy_Type = 6) ; Iceman. Hard basic enemy. Very fast and very strong.
		{
			this.pBitmap_Down_1 := pBitmapIceman_Down_1
			this.pBitmap_Down_2 := pBitmapIceman_Down_2
			this.pBitmap_Down_3 := pBitmapIceman_Down_3
			this.pBitmap_Down_4 := pBitmapIceman_Down_4
			this.pBitmap_Up_1 := pBitmapIceman_Up_1
			this.pBitmap_Up_2 := pBitmapIceman_Up_2
			this.pBitmap_Up_3 := pBitmapIceman_Up_3
			this.pBitmap_Up_4 := pBitmapIceman_Up_4
			this.pBitmap_Dead := pBitmapIceman_Dead
			this.pBitmap_Dead_2 := pBitmapIceman_Dead_2
			this.Speed := 7
			this.Current_Hitpoints := 80
			this.Power := 30
		}
		Else If (Enemy_Type = 7) ; Blood Bat. An improvement over the ordinary bat. Fastest and strong.
		{
			this.pBitmap_Down_1 := pBitmapBlood_Bat_Down_1
			this.pBitmap_Down_2 := pBitmapBlood_Bat_Down_2
			this.pBitmap_Down_3 := pBitmapBlood_Bat_Down_3
			this.pBitmap_Down_4 := pBitmapBlood_Bat_Down_4
			this.pBitmap_Up_1 := pBitmapBlood_Bat_Up_1
			this.pBitmap_Up_2 := pBitmapBlood_Bat_Up_2
			this.pBitmap_Up_3 := pBitmapBlood_Bat_Up_3
			this.pBitmap_Up_4 := pBitmapBlood_Bat_Up_4
			this.pBitmap_Dead := pBitmapBlood_Bat_Dead
			this.pBitmap_Dead_2 := pBitmapBlood_Bat_Dead_2
			this.Speed := 8
			this.Current_Hitpoints := 70
			this.Power := 30
		}
		Else If (Enemy_Type = 8) ; Fireman. Hardest basic enemy. Fastest and strongest.
		{
			this.pBitmap_Down_1 := pBitmapFireman_Down_1
			this.pBitmap_Down_2 := pBitmapFireman_Down_2
			this.pBitmap_Down_3 := pBitmapFireman_Down_3
			this.pBitmap_Down_4 := pBitmapFireman_Down_4
			this.pBitmap_Up_1 := pBitmapFireman_Up_1
			this.pBitmap_Up_2 := pBitmapFireman_Up_2
			this.pBitmap_Up_3 := pBitmapFireman_Up_3
			this.pBitmap_Up_4 := pBitmapFireman_Up_4
			this.pBitmap_Dead := pBitmapFireman_Dead
			this.pBitmap_Dead_2 := pBitmapFireman_Dead_2
			this.Speed := 8
			this.Current_Hitpoints := 120
			this.Power := 30
		}
		Else If (Enemy_Type = 9) ; The Evil Wizard. Final Boss. Fastest and strongest.
		{
			this.pBitmap_Down_1 := pBitmapWiz_Down_1
			this.pBitmap_Down_2 := pBitmapWiz_Down_2
			this.pBitmap_Down_3 := pBitmapWiz_Down_3
			this.pBitmap_Down_4 := pBitmapWiz_Down_4
			this.pBitmap_Up_1 := pBitmapWiz_Up_1
			this.pBitmap_Up_2 := pBitmapWiz_Up_2
			this.pBitmap_Up_3 := pBitmapWiz_Up_3
			this.pBitmap_Up_4 := pBitmapWiz_Up_4
			this.pBitmap_Dead := pBitmapWiz_Dead
			this.pBitmap_Dead_2 := pBitmapWiz_Dead_2
			this.Speed := 8
			this.Current_Hitpoints := 500
			this.Power := 30
		}
	}
		;Mod(Current_Y, Enemy_%A_Index%.Current_Y_Pos) - 70
		Move_Up(Current_Y)
		{
			;ToolTip % "Up"
			If !(CheckMonsterColision(this.Current_X_Pos, Mod(Current_Y, this.Current_Y_Pos + this.Speed) - 70))
			{
				this.Current_Y_Pos := this.Current_Y_Pos + this.Speed
			}
		}
		
		Move_Down(Current_Y)
		{
			;ToolTip % this.Current_X_Pos . "`n" . Mod(Current_Y, this.Current_Y_Pos - this.Speed)
			If !(CheckMonsterColision(this.Current_X_Pos, Mod(Current_Y, this.Current_Y_Pos - this.Speed)))
			{
				this.Current_Y_Pos := this.Current_Y_Pos - this.Speed
			}
		}
		
		Move_Left(Current_Y)
		{
			;ToolTip % "Left"
			If !(CheckMonsterColision(this.Current_X_Pos - this.Speed, Mod(Current_Y,this.Current_Y_Pos) - 35))
			{
				this.Current_X_Pos := this.Current_X_Pos - this.Speed
			}
		}
		
		Move_Right(Current_Y)
		{
			;ToolTip % "Right"
			If !(CheckMonsterColision(this.Current_X_Pos + this.Speed, Mod(Current_Y,this.Current_Y_Pos) - 35))
			{
				this.Current_X_Pos := this.Current_X_Pos + this.Speed
			}
		}
}
Return


DrawAttacks()
{
	Global
	Loop % ObjAttacks.MaxIndex()
	{
		; Object must be active for the routine to draw it - hence why an [A_Index,6] = 1 conditional.
		If ((ObjAttacks[A_Index, 1] < 512) AND (ObjAttacks[A_Index, 1] > -50) AND (ObjAttacks[A_Index, 6] = 1)) ; X must be above 0 and below 512 for the projectile to be in renderable area. 50 is the width of the projectile sprite file. 
		{
			If ((ObjAttacks[A_Index, 2] > -50) AND (ObjAttacks[A_Index, 2] < 512)) ; Y must be above 0 and below 512 for the projectile to be in renderable area. 50 is the height of projectile sprite file.
			{
				
				;ToolTip % ObjAttacks[A_Index, 1] . "`n" . ObjAttacks[A_Index, 2]
				
				If (ObjAttacks[A_Index, 8] = "SpikyFungus")
				{
					Hit_Type := 1
				}
				Else If (ObjAttacks[A_Index, 8] = "Beam")
				{
					Hit_Type := 2
				}
				
				; CONDITIONAL BELOW CHECKS FOR HITS ON TREES OR ENEMIES..
				If (CheckColision(ObjAttacks[A_Index, 1], ObjAttacks[A_Index, 2], Hit_Type)) ; THIS CHECKS FOR HITS ON TREES
				{
					ObjAttacks[A_Index, 6] := 0
					Gdip_DrawImage(G, ObjAttacks[A_Index, 7], Round(ObjAttacks[A_Index, 1], 0), Round(ObjAttacks[A_Index, 2],0), 50, 50, 0, 0, 50, 50)
					Gdip_DisposeImage(ObjAttacks[A_Index, 7])
					Gdip_DisposeImage(ObjAttacks[A_Index, 3])
				}
				else if (CheckHitColision(ObjAttacks[A_Index, 1], ObjAttacks[A_Index, 2], Hit_Type)) ; THIS CHECKS FOR HITS ON ENEMIES.
				{
					ObjAttacks[A_Index, 6] := 0
					Gdip_DrawImage(G, ObjAttacks[A_Index, 7], Round(ObjAttacks[A_Index, 1], 0), Round(ObjAttacks[A_Index, 2],0), 50, 50, 0, 0, 50, 50)
					Gdip_DisposeImage(ObjAttacks[A_Index, 7])
					Gdip_DisposeImage(ObjAttacks[A_Index, 3])
					;Enemy_Rockman.Current_Hitpoints := Enemy_Rockman.Current_Hitpoints - 10
				}
				else
				{
					Gdip_DrawImage(G, ObjAttacks[A_Index, 3], Round(ObjAttacks[A_Index, 1], 0), Round(ObjAttacks[A_Index, 2],0), 50, 50, 0, 0, 50, 50)
				}
				
				; HERE WE ARE SUPPOSED TO CHECK COLISION WITH AN ENEMY
				
				If ((ObjAttacks[A_Index, 4] >= 0) AND (ObjAttacks[A_Index, 5] >= 0))
				{
					PROPORTION_XY := ObjAttacks[A_Index, 4] / ObjAttacks[A_Index, 5]
					PROPORTION_YX := ObjAttacks[A_Index, 5] / ObjAttacks[A_Index, 4]
					
					% ((PROPORTION_XY > 1) ? (PROPORTION_XY := 1) : (""))
					% ((PROPORTION_YX > 1) ? (PROPORTION_YX := 1) : (""))
					% ((PROPORTION_XY < 0.01) ? (PROPORTION_XY := 0.01) : (""))
					% ((PROPORTION_YX < 0.01) ? (PROPORTION_YX := 0.01) : (""))
					
					If !(PROPORTION_XY = 0.01 AND PROPORTION_YX = 0.01)
					{
						ObjAttacks[A_Index, 1] := ObjAttacks[A_Index, 1] + ( PROPORTION_XY * Player.AttackSpeed )
						ObjAttacks[A_Index, 2] := ObjAttacks[A_Index, 2] - ( PROPORTION_YX * Player.AttackSpeed )
					}
					else ; If we shoot at 0,0, we get a hardtime calculating proportions. Thereby we consider an arbitrary proportion that is similar to a close call for these coordinates.
					{
						ObjAttacks[A_Index, 2] := ObjAttacks[A_Index, 2] - (0.99 * Player.AttackSpeed)
					}
				}
				If ((ObjAttacks[A_Index, 4] > 0) AND (ObjAttacks[A_Index, 5] < 0))
				{
					Y_TO_USE := ObjAttacks[A_Index, 5] * -1
					PROPORTION_XY := ObjAttacks[A_Index, 4] / Y_TO_USE
					PROPORTION_YX := Y_TO_USE / ObjAttacks[A_Index, 4]
					
					% ((PROPORTION_XY > 1) ? (PROPORTION_XY := 1) : (""))
					% ((PROPORTION_YX > 1) ? (PROPORTION_YX := 1) : (""))
					% ((PROPORTION_XY < 0.01) ? (PROPORTION_XY := 0.01) : (""))
					% ((PROPORTION_YX < 0.01) ? (PROPORTION_YX := 0.01) : (""))
					
					ObjAttacks[A_Index, 1] := ObjAttacks[A_Index, 1] + ( PROPORTION_XY * Player.AttackSpeed )
					ObjAttacks[A_Index, 2] := ObjAttacks[A_Index, 2] + ( PROPORTION_YX * Player.AttackSpeed )
				}
				
				If ((ObjAttacks[A_Index, 4] < 0) AND (ObjAttacks[A_Index, 5] > 0))
				{
					X_TO_USE := ObjAttacks[A_Index, 4] * -1
					PROPORTION_XY := X_TO_USE / ObjAttacks[A_Index, 5]
					PROPORTION_YX := ObjAttacks[A_Index, 5] / X_TO_USE
					
					% ((PROPORTION_XY > 1) ? (PROPORTION_XY := 1) : (""))
					% ((PROPORTION_YX > 1) ? (PROPORTION_YX := 1) : (""))
					% ((PROPORTION_XY < 0.01) ? (PROPORTION_XY := 0.01) : (""))
					% ((PROPORTION_YX < 0.01) ? (PROPORTION_YX := 0.01) : (""))
					
					ObjAttacks[A_Index, 1] := ObjAttacks[A_Index, 1] - ( PROPORTION_XY * Player.AttackSpeed )
					ObjAttacks[A_Index, 2] := ObjAttacks[A_Index, 2] - ( PROPORTION_YX * Player.AttackSpeed )
				}
				If ((ObjAttacks[A_Index, 4] < 0) AND (ObjAttacks[A_Index, 5] < 0))
				{
					Y_TO_USE := ObjAttacks[A_Index, 5] * -1
					X_TO_USE := ObjAttacks[A_Index, 4] * -1
					PROPORTION_XY := X_TO_USE / Y_TO_USE
					PROPORTION_YX := Y_TO_USE / X_TO_USE
					
					% ((PROPORTION_XY > 1) ? (PROPORTION_XY := 1) : (""))
					% ((PROPORTION_YX > 1) ? (PROPORTION_YX := 1) : (""))
					% ((PROPORTION_XY < 0.01) ? (PROPORTION_XY := 0.01) : (""))
					% ((PROPORTION_YX < 0.01) ? (PROPORTION_YX := 0.01) : (""))
					
					ObjAttacks[A_Index, 1] := ObjAttacks[A_Index, 1] - ( PROPORTION_XY * Player.AttackSpeed )
					ObjAttacks[A_Index, 2] := ObjAttacks[A_Index, 2] + ( PROPORTION_YX * Player.AttackSpeed )
				}
			}
		}
	}
}

Return


LoadTextures()
{
	Global
	
	; 1.  These are the intro play screen sprite and the game over sprite.
	pBitmapNewJourney := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\NewJourney.png")
	pBitmapGameOver := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\GameOverScreen.png")
	
	; 2. These are the background sprites.
	pBitmap := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\GrassyAutumn.png")
	pBitmapHud := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Hud.png")
	pBitmap10Life := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\10Life.png")
	pBitmap10Mana := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\10Mana.png")
	pBitmapScrollSelected := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\ScrollSelected.png")

	; 3. These sprites are the player sprites (Archmage gray).
	pBitmapPlayer_Idle_Down := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Arch_U_1.png")
	pBitmapPlayer_Mov_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Arch_U_1.png")
	pBitmapPlayer_Mov_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Arch_U_2.png")
	pBitmapPlayer_Mov_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Arch_U_3.png")
	pBitmapPlayer_Mov_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Arch_U_4.png")
	pBitmapPlayer_Hurt := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Arch_Hurt.png")
	
	; 4. These sprites are the missiles.
	pBitmapTinyBlast := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpikyFungus.png")
	pBitmapTinyBlastHit := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpikyFungusHit.png")
	pBitmapBeam := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Beam.png")
	pBitmapbeamblasthit := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\beamblasthit.png")
	
	; 5. This sprite is for future reference (Starting point marker)
	pBitmapSign_Post := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Sign_Post.png")
	pBitmapSign_Post_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Sign_Post_2.png")
	
	; 6. These sprites are the scenary objects (trees and rocks):
	pBitmapSmallTree := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SmallTree.png")
	pBitmapSmallTree2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SmallTree2.png")
	pBitmapSmallTree3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SmallTree3.png")
	pBitmapSmallTree4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SmallTree4.png")
	pBitmapStarBush := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\StarBush.png")
	pBitmapStarBush2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\StarBush2.png")
	pBitmapStarBush3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\StarBush3.png")
	pBitmapTree3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Tree3.png")
	pBitmapTree4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Tree4.png")
	pBitmapTree5 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Tree5.png")
	pBitmapTree6 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Tree6.png")
	pBitmapTree7 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Tree7.png")
	pBitmapLongLeafBush := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\LongLeafBush.png")
	pBitmapBranch1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\TreeBranch1.png")
	pBitmapBranch2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\TreeBranch2.png")
	
	pBitmapArtifact1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Artifact1.png")
	pBitmapArtifact2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Artifact2.png")
	pBitmapArtifact3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Artifact3.png")
	pBitmapArtifact4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Artifact4.png")
	pBitmapArtifact5 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Artifact5.png")
	pBitmapArtifact6 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Artifact6.png")

	
	; 7. These sprites make up the enemies:
	pBitmapClayman_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Up_1.png")
	pBitmapClayman_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Up_2.png")
	pBitmapClayman_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Up_3.png")
	pBitmapClayman_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Up_4.png")
	pBitmapClayman_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Down_1.png")
	pBitmapClayman_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Down_2.png")
	pBitmapClayman_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Down_3.png")
	pBitmapClayman_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Down_4.png")
	pBitmapClayman_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Dead.png")
	pBitmapClayman_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Clayman_Dead_2.png")
	
	pBitmapSpider_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Up_1.png")
	pBitmapSpider_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Up_2.png")
	pBitmapSpider_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Up_3.png")
	pBitmapSpider_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Up_4.png")
	pBitmapSpider_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Down_1.png")
	pBitmapSpider_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Down_2.png")
	pBitmapSpider_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Down_3.png")
	pBitmapSpider_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Down_4.png")
	pBitmapSpider_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Dead.png")
	pBitmapSpider_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Spider_Dead_2.png")
	
	pBitmapPoison_Spider_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Up_1.png")
	pBitmapPoison_Spider_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Up_2.png")
	pBitmapPoison_Spider_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Up_3.png")
	pBitmapPoison_Spider_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Up_4.png")
	pBitmapPoison_Spider_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Down_1.png")
	pBitmapPoison_Spider_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Down_2.png")
	pBitmapPoison_Spider_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Down_3.png")
	pBitmapPoison_Spider_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Down_4.png")
	pBitmapPoison_Spider_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Dead.png")
	pBitmapPoison_Spider_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Poison_Spider_Dead_2.png")
	
	pBitmapBat_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Up_1.png")
	pBitmapBat_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Up_2.png")
	pBitmapBat_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Up_3.png")
	pBitmapBat_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Up_4.png")
	pBitmapBat_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Down_1.png")
	pBitmapBat_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Down_2.png")
	pBitmapBat_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Down_3.png")
	pBitmapBat_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Down_4.png")
	pBitmapBat_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Dead.png")
	pBitmapBat_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Bat_Dead_2.png")
	
	pBitmapRockman_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Up_1.png")
	pBitmapRockman_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Up_2.png")
	pBitmapRockman_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Up_3.png")
	pBitmapRockman_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Up_4.png")
	pBitmapRockman_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Down_1.png")
	pBitmapRockman_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Down_2.png")
	pBitmapRockman_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Down_3.png")
	pBitmapRockman_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Down_4.png")
	pBitmapRockman_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Dead.png")
	pBitmapRockman_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Rockman_Dead_2.png")
	
	pBitmapIceman_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Up_1.png")
	pBitmapIceman_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Up_2.png")
	pBitmapIceman_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Up_3.png")
	pBitmapIceman_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Up_4.png")
	pBitmapIceman_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Down_1.png")
	pBitmapIceman_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Down_2.png")
	pBitmapIceman_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Down_3.png")
	pBitmapIceman_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Down_4.png")
	pBitmapIceman_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Dead.png")
	pBitmapIceman_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Iceman_Dead_2.png")
	
	pBitmapBlood_Bat_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Up_1.png")
	pBitmapBlood_Bat_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Up_2.png")
	pBitmapBlood_Bat_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Up_3.png")
	pBitmapBlood_Bat_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Up_4.png")
	pBitmapBlood_Bat_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Down_1.png")
	pBitmapBlood_Bat_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Down_2.png")
	pBitmapBlood_Bat_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Down_3.png")
	pBitmapBlood_Bat_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Down_4.png")
	pBitmapBlood_Bat_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Dead.png")
	pBitmapBlood_Bat_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Blood_Bat_Dead_2.png")
	
	pBitmapFireman_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Up_1.png")
	pBitmapFireman_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Up_2.png")
	pBitmapFireman_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Up_3.png")
	pBitmapFireman_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Up_4.png")
	pBitmapFireman_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Down_1.png")
	pBitmapFireman_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Down_2.png")
	pBitmapFireman_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Down_3.png")
	pBitmapFireman_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Down_4.png")
	pBitmapFireman_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Dead.png")
	pBitmapFireman_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Fireman_Dead_2.png")
	
	pBitmapWiz_Up_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Down_1.png")
	pBitmapWiz_Up_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Down_1.png")
	pBitmapWiz_Up_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Down_1.png")
	pBitmapWiz_Up_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Down_1.png")
	pBitmapWiz_Down_1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Down_1.png")
	pBitmapWiz_Down_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Down_1.png")
	pBitmapWiz_Down_3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Down_1.png")
	pBitmapWiz_Down_4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Down_1.png")
	pBitmapWiz_Dead := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Dead.png")
	pBitmapWiz_Dead_2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\SpoilerAlert\Wiz_Dead.png")
	
	; 8. These sprites are the items that the player can pick up (the lexikos and staves)
	pBitmapLexiko1 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Lexiko1.png") ; Teleport. CoolDown 10 secs.
	pBitmapLexiko2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Lexiko2.png") ; Beam. CoolDown 10 secs. Hits for 100.
	pBitmapLexiko3 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Lexiko3.png") ; Recover. CoolDown 30 secs. Restores Player HP to 100.
	pBitmapLexiko4 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Lexiko4.png") ; Paralyze. Enemies stop moving for 5 secs. CoolDown 20 secs.
	pBitmapLexiko5 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\Sprites\Lexiko5.png") ; Speed. CoolDown 20 secs. Player gains a 50% speed boost for 5 secs.
	
}
Return

Create_Player()
{
	Global Player
	Player := Object()
	Player.PosX := 242
	Player.PosY := 238
	Player.AttackSpeed := 10
	Player.HitPoints := 100
	Player.CoolDown := 0
	Player.Speed := 6
}
Return

DrawSign_Post() ; Example of a static object (i.e.: could be a Scene_Object, a rock bolder or whatever).
{
	Global
	Gdip_DrawImage(G, pBitmapSign_Post, 202, 238 + Current_Y, 28, 35, 0, 0, 28, 35)
	;UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
}
Return

DrawSign_Post_2() ; Example of a static object (i.e.: could be a Scene_Object, a rock bolder or whatever).
{
	Global
	Gdip_DrawImage(G, pBitmapSign_Post_2, 202, -1 * (34816 - Current_Y), 28, 35, 0, 0, 28, 35)
	;UpdateLayeredWindow(hwnd1, hdc, Window_X_Pos, Window_Y_Pos, Width, Height)
}
Return


GuiClose:
ExitApp

ESC::
Exit:
; gdi+ may now be shutdown on exiting the program
; Select the object back into the hdc
SelectObject(hdc, obm)
SelectObject(hdc2, obm2)
SelectObject(hdc3, obm3)


; Now the bitmap may be deleted
DeleteObject(hbm)
DeleteObject(hbm2)
DeleteObject(hbm3)

; Also the device context related to the bitmap may be deleted
DeleteDC(hdc)
DeleteDC(hdc2)
DeleteDC(hdc3)

; The graphics may now be deleted
Gdip_DeleteGraphics(G)
Gdip_DeleteGraphics(G2)
Gdip_DeleteGraphics(G3)

; The bitmap we made from the image may be deleted
Gdip_DisposeImage(pBitmap)
Gdip_DisposeImage(pBitmapFrame)
Gdip_DisposeImage(pBitmapMenu)
Gdip_DisposeImage(pBitmapTitle)
Gdip_DisposeImage(pBitmapIntroOption)
Gdip_DisposeImage(pBitmapPlayOption)
Gdip_DisposeImage(pBitmapInstructionsOption)
Gdip_DisposeImage(pBitmapCreditsOption)
Gdip_DisposeImage(pBitmapVersionInfo)

Gdip_DisposeImage(pBitmapPlayOptionLit)
Gdip_DisposeImage(pBitmapInstructionsOptionLit)
Gdip_DisposeImage(pBitmapIntroOptionLit)
Gdip_DisposeImage(pBitmapCreditsOptionLit)
Gdip_DisposeImage(pBitmapIntroBackGround)
Gdip_DisposeImage(pBitmapIntroStory)
Gdip_DisposeImage(pBitmapCredits)
Gdip_DisposeImage(pBitmapFinalScene)
Gdip_DisposeImage(pBitmapEndingStory)
Gdip_DisposeImage(pBitmapInstructions1)
Gdip_DisposeImage(pBitmapInstructions2)

Gdip_DisposeImage(pBitmapNewJourney)
Gdip_DisposeImage(pBitmapGameOver)

Gdip_DisposeImage(pBitmapHud)
Gdip_DisposeImage(pBitmap10Life)
Gdip_DisposeImage(pBitmap10Life)
Gdip_DisposeImage(pBitmap10Mana)
Gdip_DisposeImage(pBitmapScrollSelected)
Gdip_DisposeImage(pBitmapPlayer_Mov_Up_1)
Gdip_DisposeImage(pBitmapPlayer_Idle_Down)
Gdip_DisposeImage(pBitmapPlayer_Mov_Up_2)
Gdip_DisposeImage(pBitmapPlayer_Mov_Up_4)
Gdip_DisposeImage(pBitmapPlayer_Mov_Up_3)
Gdip_DisposeImage(pBitmapPlayer_Hurt)
Gdip_DisposeImage(pBitmapTinyBlast)
Gdip_DisposeImage(pBitmapTinyBlastHit)
Gdip_DisposeImage(pBitmapBeam)
Gdip_DisposeImage(pBitmapbeamblasthit)
Gdip_DisposeImage(pBitmapSign_Post)
Gdip_DisposeImage(pBitmapSign_Post_2)
Gdip_DisposeImage(pBitmapSmallTree)
Gdip_DisposeImage(pBitmapSmallTree3)
Gdip_DisposeImage(pBitmapSmallTree2)
Gdip_DisposeImage(pBitmapSmallTree4)
Gdip_DisposeImage(pBitmapStarBush)
Gdip_DisposeImage(pBitmapStarBush2)
Gdip_DisposeImage(pBitmapStarBush3)
Gdip_DisposeImage(pBitmapTree4)
Gdip_DisposeImage(pBitmapTree3)
Gdip_DisposeImage(pBitmapTree5)
Gdip_DisposeImage(pBitmapTree6)
Gdip_DisposeImage(pBitmapTree7)
Gdip_DisposeImage(pBitmapLongLeafBush)
Gdip_DisposeImage(pBitmapBranch1)
Gdip_DisposeImage(pBitmapBranch2)
Gdip_DisposeImage(pBitmapArtifact1)
Gdip_DisposeImage(pBitmapArtifact2)
Gdip_DisposeImage(pBitmapArtifact3)
Gdip_DisposeImage(pBitmapArtifact4)
Gdip_DisposeImage(pBitmapArtifact5)
Gdip_DisposeImage(pBitmapArtifact6)


Gdip_DisposeImage(pBitmapClayman_Up_1)
Gdip_DisposeImage(pBitmapClayman_Up_2)
Gdip_DisposeImage(pBitmapClayman_Up_4)
Gdip_DisposeImage(pBitmapClayman_Up_3)
Gdip_DisposeImage(pBitmapClayman_Down_1)
Gdip_DisposeImage(pBitmapClayman_Down_3)
Gdip_DisposeImage(pBitmapClayman_Down_2)
Gdip_DisposeImage(pBitmapClayman_Down_4)
Gdip_DisposeImage(pBitmapClayman_Dead)
Gdip_DisposeImage(pBitmapClayman_Dead_2)

Gdip_DisposeImage(pBitmapSpider_Up_1)
Gdip_DisposeImage(pBitmapSpider_Up_2)
Gdip_DisposeImage(pBitmapSpider_Up_3)
Gdip_DisposeImage(pBitmapSpider_Up_4)
Gdip_DisposeImage(pBitmapSpider_Down_1)
Gdip_DisposeImage(pBitmapSpider_Down_2)
Gdip_DisposeImage(pBitmapSpider_Down_3)
Gdip_DisposeImage(pBitmapSpider_Down_4)
Gdip_DisposeImage(pBitmapSpider_Dead)
Gdip_DisposeImage(pBitmapSpider_Dead_2)

Gdip_DisposeImage(pBitmapPoison_Spider_Up_1)
Gdip_DisposeImage(pBitmapPoison_Spider_Up_2)
Gdip_DisposeImage(pBitmapPoison_Spider_Up_3)
Gdip_DisposeImage(pBitmapPoison_Spider_Up_4)
Gdip_DisposeImage(pBitmapPoison_Spider_Down_2)
Gdip_DisposeImage(pBitmapPoison_Spider_Down_1)
Gdip_DisposeImage(pBitmapPoison_Spider_Down_3)
Gdip_DisposeImage(pBitmapPoison_Spider_Down_4)
Gdip_DisposeImage(pBitmapPoison_Spider_Dead)
Gdip_DisposeImage(pBitmapPoison_Spider_Dead_2)

Gdip_DisposeImage(pBitmapBat_Up_1)
Gdip_DisposeImage(pBitmapBat_Up_2)
Gdip_DisposeImage(pBitmapBat_Up_3)
Gdip_DisposeImage(pBitmapBat_Up_4)
Gdip_DisposeImage(pBitmapBat_Down_1)
Gdip_DisposeImage(pBitmapBat_Down_2)
Gdip_DisposeImage(pBitmapBat_Down_3)
Gdip_DisposeImage(pBitmapBat_Down_4)
Gdip_DisposeImage(pBitmapBat_Dead_2)
Gdip_DisposeImage(pBitmapBat_Dead)

Gdip_DisposeImage(pBitmapRockman_Up_1)
Gdip_DisposeImage(pBitmapRockman_Up_3)
Gdip_DisposeImage(pBitmapRockman_Up_2)
Gdip_DisposeImage(pBitmapRockman_Up_4)
Gdip_DisposeImage(pBitmapRockman_Down_2)
Gdip_DisposeImage(pBitmapRockman_Down_1)
Gdip_DisposeImage(pBitmapRockman_Down_3)
Gdip_DisposeImage(pBitmapRockman_Dead)
Gdip_DisposeImage(pBitmapRockman_Down_4)
Gdip_DisposeImage(pBitmapRockman_Dead_2)

Gdip_DisposeImage(pBitmapIceman_Up_1)
Gdip_DisposeImage(pBitmapIceman_Up_2)
Gdip_DisposeImage(pBitmapIceman_Up_3)
Gdip_DisposeImage(pBitmapIceman_Up_4)
Gdip_DisposeImage(pBitmapIceman_Down_1)
Gdip_DisposeImage(pBitmapIceman_Down_2)
Gdip_DisposeImage(pBitmapIceman_Down_3)
Gdip_DisposeImage(pBitmapIceman_Down_4)
Gdip_DisposeImage(pBitmapIceman_Dead)
Gdip_DisposeImage(pBitmapIceman_Dead_2)

Gdip_DisposeImage(pBitmapBlood_Bat_Up_1)
Gdip_DisposeImage(pBitmapBlood_Bat_Up_2)
Gdip_DisposeImage(pBitmapBlood_Bat_Up_3)
Gdip_DisposeImage(pBitmapBlood_Bat_Up_4)
Gdip_DisposeImage(pBitmapBlood_Bat_Down_1)
Gdip_DisposeImage(pBitmapBlood_Bat_Down_2)
Gdip_DisposeImage(pBitmapBlood_Bat_Down_3)
Gdip_DisposeImage(pBitmapBlood_Bat_Down_4)
Gdip_DisposeImage(pBitmapBlood_Bat_Dead)
Gdip_DisposeImage(pBitmapBlood_Bat_Dead_2)

Gdip_DisposeImage(pBitmapFireman_Up_1)
Gdip_DisposeImage(pBitmapFireman_Up_2)
Gdip_DisposeImage(pBitmapFireman_Up_3)
Gdip_DisposeImage(pBitmapFireman_Up_4)
Gdip_DisposeImage(pBitmapFireman_Down_1)
Gdip_DisposeImage(pBitmapFireman_Down_2)
Gdip_DisposeImage(pBitmapFireman_Down_4)
Gdip_DisposeImage(pBitmapFireman_Down_3)
Gdip_DisposeImage(pBitmapFireman_Dead)
Gdip_DisposeImage(pBitmapFireman_Dead_2)

Gdip_DisposeImage(pBitmapWiz_Up_2)
Gdip_DisposeImage(pBitmapWiz_Up_1)
Gdip_DisposeImage(pBitmapWiz_Up_3)
Gdip_DisposeImage(pBitmapWiz_Up_4)
Gdip_DisposeImage(pBitmapWiz_Down_1)
Gdip_DisposeImage(pBitmapWiz_Down_3)
Gdip_DisposeImage(pBitmapWiz_Down_2)
Gdip_DisposeImage(pBitmapWiz_Down_4)
Gdip_DisposeImage(pBitmapWiz_Dead)
Gdip_DisposeImage(pBitmapWiz_Dead_2)

Gdip_DisposeImage(pBitmapLexiko1)
Gdip_DisposeImage(pBitmapLexiko2)
Gdip_DisposeImage(pBitmapLexiko3)
Gdip_DisposeImage(pBitmapLexiko4)
Gdip_DisposeImage(pBitmapLexiko5)
Gdip_Shutdown(pToken)
ExitApp
Return



; Gdip standard library v1.45 by tic (Tariq Porter) 07/09/11
; Modifed by Rseding91 using fincs 64 bit compatible Gdip library 5/1/2013
; Supports: Basic, _L ANSi, _L Unicode x86 and _L Unicode x64
;
; Updated 2/20/2014 - fixed Gdip_CreateRegion() and Gdip_GetClipRegion() on AHK Unicode x86
; Updated 5/13/2013 - fixed Gdip_SetBitmapToClipboard() on AHK Unicode x64
;
;#####################################################################################
;#####################################################################################
; STATUS ENUMERATION
; Return values for functions specified to have status enumerated return type
;#####################################################################################
;
; Ok =						= 0
; GenericError				= 1
; InvalidParameter			= 2
; OutOfMemory				= 3
; ObjectBusy				= 4
; InsufficientBuffer		= 5
; NotImplemented			= 6
; Win32Error				= 7
; WrongState				= 8
; Aborted					= 9
; FileNotFound				= 10
; ValueOverflow				= 11
; AccessDenied				= 12
; UnknownImageFormat		= 13
; FontFamilyNotFound		= 14
; FontStyleNotFound			= 15
; NotTrueTypeFont			= 16
; UnsupportedGdiplusVersion	= 17
; GdiplusNotInitialized		= 18
; PropertyNotFound			= 19
; PropertyNotSupported		= 20
; ProfileNotFound			= 21
;
;#####################################################################################
;#####################################################################################
; FUNCTIONS
;#####################################################################################
;
; UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
; BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
; StretchBlt(dDC, dx, dy, dw, dh, sDC, sx, sy, sw, sh, Raster="")
; SetImage(hwnd, hBitmap)
; Gdip_BitmapFromScreen(Screen=0, Raster="")
; CreateRectF(ByRef RectF, x, y, w, h)
; CreateSizeF(ByRef SizeF, w, h)
; CreateDIBSection
;
;#####################################################################################

; Function:     			UpdateLayeredWindow
; Description:  			Updates a layered window with the handle to the DC of a gdi bitmap
; 
; hwnd        				Handle of the layered window to update
; hdc           			Handle to the DC of the GDI bitmap to update the window with
; Layeredx      			x position to place the window
; Layeredy      			y position to place the window
; Layeredw      			Width of the window
; Layeredh      			Height of the window
; Alpha         			Default = 255 : The transparency (0-255) to set the window transparency
;
; return      				If the function succeeds, the return value is nonzero
;
; notes						If x or y omitted, then layered window will use its current coordinates
;							If w or h omitted then current width and height will be used

UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")

	if (w = "") ||(h = "")
		WinGetPos,,, w, h, ahk_id %hwnd%
   
	return DllCall("UpdateLayeredWindow"
					, Ptr, hwnd
					, Ptr, 0
					, Ptr, ((x = "") && (y = "")) ? 0 : &pt
					, "int64*", w|h<<32
					, Ptr, hdc
					, "int64*", 0
					, "uint", 0
					, "UInt*", Alpha<<16|1<<24
					, "uint", 2)
}

;#####################################################################################

; Function				BitBlt
; Description			The BitBlt function performs a bit-block transfer of the color data corresponding to a rectangle 
;						of pixels from the specified source device context into a destination device context.
;
; dDC					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of the area to copy
; dh					height of the area to copy
; sDC					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used, which copies the source directly to the destination rectangle
;
; BLACKNESS				= 0x00000042
; NOTSRCERASE			= 0x001100A6
; NOTSRCCOPY			= 0x00330008
; SRCERASE				= 0x00440328
; DSTINVERT				= 0x00550009
; PATINVERT				= 0x005A0049
; SRCINVERT				= 0x00660046
; SRCAND				= 0x008800C6
; MERGEPAINT			= 0x00BB0226
; MERGECOPY				= 0x00C000CA
; SRCCOPY				= 0x00CC0020
; SRCPAINT				= 0x00EE0086
; PATCOPY				= 0x00F00021
; PATPAINT				= 0x00FB0A09
; WHITENESS				= 0x00FF0062
; CAPTUREBLT			= 0x40000000
; NOMIRRORBITMAP		= 0x80000000

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdi32\BitBlt"
					, Ptr, dDC
					, "int", dx
					, "int", dy
					, "int", dw
					, "int", dh
					, Ptr, sDC
					, "int", sx
					, "int", sy
					, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				StretchBlt
; Description			The StretchBlt function copies a bitmap from a source rectangle into a destination rectangle, 
;						stretching or compressing the bitmap to fit the dimensions of the destination rectangle, if necessary.
;						The system stretches or compresses the bitmap according to the stretching mode currently set in the destination device context.
;
; ddc					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination rectangle
; dh					height of destination rectangle
; sdc					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used. It uses the same raster operations as BitBlt		

StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdi32\StretchBlt"
					, Ptr, ddc
					, "int", dx
					, "int", dy
					, "int", dw
					, "int", dh
					, Ptr, sdc
					, "int", sx
					, "int", sy
					, "int", sw
					, "int", sh
					, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				SetStretchBltMode
; Description			The SetStretchBltMode function sets the bitmap stretching mode in the specified device context
;
; hdc					handle to the DC
; iStretchMode			The stretching mode, describing how the target will be stretched
;
; return				If the function succeeds, the return value is the previous stretching mode. If it fails it will return 0
;
; STRETCH_ANDSCANS 		= 0x01
; STRETCH_ORSCANS 		= 0x02
; STRETCH_DELETESCANS 	= 0x03
; STRETCH_HALFTONE 		= 0x04

SetStretchBltMode(hdc, iStretchMode=4)
{
	return DllCall("gdi32\SetStretchBltMode"
					, A_PtrSize ? "UPtr" : "UInt", hdc
					, "int", iStretchMode)
}

;#####################################################################################

; Function				SetImage
; Description			Associates a new image with a static control
;
; hwnd					handle of the control to update
; hBitmap				a gdi bitmap to associate the static control with
;
; return				If the function succeeds, the return value is nonzero

SetImage(hwnd, hBitmap)
{
	SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
	E := ErrorLevel
	DeleteObject(E)
	return E
}

;#####################################################################################

; Function				SetSysColorToControl
; Description			Sets a solid colour to a control
;
; hwnd					handle of the control to update
; SysColor				A system colour to set to the control
;
; return				If the function succeeds, the return value is zero
;
; notes					A control must have the 0xE style set to it so it is recognised as a bitmap
;						By default SysColor=15 is used which is COLOR_3DFACE. This is the standard background for a control
;
; COLOR_3DDKSHADOW				= 21
; COLOR_3DFACE					= 15
; COLOR_3DHIGHLIGHT				= 20
; COLOR_3DHILIGHT				= 20
; COLOR_3DLIGHT					= 22
; COLOR_3DSHADOW				= 16
; COLOR_ACTIVEBORDER			= 10
; COLOR_ACTIVECAPTION			= 2
; COLOR_APPWORKSPACE			= 12
; COLOR_BACKGROUND				= 1
; COLOR_BTNFACE					= 15
; COLOR_BTNHIGHLIGHT			= 20
; COLOR_BTNHILIGHT				= 20
; COLOR_BTNSHADOW				= 16
; COLOR_BTNTEXT					= 18
; COLOR_CAPTIONTEXT				= 9
; COLOR_DESKTOP					= 1
; COLOR_GRADIENTACTIVECAPTION	= 27
; COLOR_GRADIENTINACTIVECAPTION	= 28
; COLOR_GRAYTEXT				= 17
; COLOR_HIGHLIGHT				= 13
; COLOR_HIGHLIGHTTEXT			= 14
; COLOR_HOTLIGHT				= 26
; COLOR_INACTIVEBORDER			= 11
; COLOR_INACTIVECAPTION			= 3
; COLOR_INACTIVECAPTIONTEXT		= 19
; COLOR_INFOBK					= 24
; COLOR_INFOTEXT				= 23
; COLOR_MENU					= 4
; COLOR_MENUHILIGHT				= 29
; COLOR_MENUBAR					= 30
; COLOR_MENUTEXT				= 7
; COLOR_SCROLLBAR				= 0
; COLOR_WINDOW					= 5
; COLOR_WINDOWFRAME				= 6
; COLOR_WINDOWTEXT				= 8

SetSysColorToControl(hwnd, SysColor=15)
{
   WinGetPos,,, w, h, ahk_id %hwnd%
   bc := DllCall("GetSysColor", "Int", SysColor, "UInt")
   pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
   pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
   Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
   hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
   SetImage(hwnd, hBitmap)
   Gdip_DeleteBrush(pBrushClear)
   Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
   return 0
}

;#####################################################################################

; Function				Gdip_BitmapFromScreen
; Description			Gets a gdi+ bitmap from the screen
;
; Screen				0 = All screens
;						Any numerical value = Just that screen
;						x|y|w|h = Take specific coordinates with a width and height
; Raster				raster operation code
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1:		one or more of x,y,w,h not passed properly
;
; notes					If no raster operation is specified, then SRCCOPY is used to the returned bitmap

Gdip_BitmapFromScreen(Screen=0, Raster="")
{
	if (Screen = 0)
	{
		Sysget, x, 76
		Sysget, y, 77	
		Sysget, w, 78
		Sysget, h, 79
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:")
	{
		Screen := SubStr(Screen, 6)
		if !WinExist( "ahk_id " Screen)
			return -2
		WinGetPos,,, w, h, ahk_id %Screen%
		x := y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if (Screen&1 != "")
	{
		Sysget, M, Monitor, %Screen%
		x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
	}
	else
	{
		StringSplit, S, Screen, |
		x := S1, y := S2, w := S3, h := S4
	}

	if (x = "") || (y = "") || (w = "") || (h = "")
		return -1

	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
	ReleaseDC(hhdc)
	
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	return pBitmap
}

;#####################################################################################

; Function				Gdip_BitmapFromHWND
; Description			Uses PrintWindow to get a handle to the specified window and return a bitmap from it
;
; hwnd					handle to the window to get a bitmap from
;
; return				If the function succeeds, the return value is a pointer to a gdi+ bitmap
;
; notes					Window must not be not minimised in order to get a handle to it's client area

Gdip_BitmapFromHWND(hwnd)
{
	WinGetPos,,, Width, Height, ahk_id %hwnd%
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	PrintWindow(hwnd, hdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	return pBitmap
}

;#####################################################################################

; Function    			CreateRectF
; Description			Creates a RectF object, containing a the coordinates and dimensions of a rectangle
;
; RectF       			Name to call the RectF object
; x            			x-coordinate of the upper left corner of the rectangle
; y            			y-coordinate of the upper left corner of the rectangle
; w            			Width of the rectangle
; h            			Height of the rectangle
;
; return      			No return value

CreateRectF(ByRef RectF, x, y, w, h)
{
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}

;#####################################################################################

; Function    			CreateRect
; Description			Creates a Rect object, containing a the coordinates and dimensions of a rectangle
;
; RectF       			Name to call the RectF object
; x            			x-coordinate of the upper left corner of the rectangle
; y            			y-coordinate of the upper left corner of the rectangle
; w            			Width of the rectangle
; h            			Height of the rectangle
;
; return      			No return value

CreateRect(ByRef Rect, x, y, w, h)
{
	VarSetCapacity(Rect, 16)
	NumPut(x, Rect, 0, "uint"), NumPut(y, Rect, 4, "uint"), NumPut(w, Rect, 8, "uint"), NumPut(h, Rect, 12, "uint")
}
;#####################################################################################

; Function		    	CreateSizeF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF         		Name to call the SizeF object
; w            			w-value for the SizeF object
; h            			h-value for the SizeF object
;
; return      			No Return value

CreateSizeF(ByRef SizeF, w, h)
{
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")     
}
;#####################################################################################

; Function		    	CreatePointF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF         		Name to call the SizeF object
; w            			w-value for the SizeF object
; h            			h-value for the SizeF object
;
; return      			No Return value

CreatePointF(ByRef PointF, x, y)
{
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")     
}
;#####################################################################################

; Function				CreateDIBSection
; Description			The CreateDIBSection function creates a DIB (Device Independent Bitmap) that applications can write to directly
;
; w						width of the bitmap to create
; h						height of the bitmap to create
; hdc					a handle to the device context to use the palette from
; bpp					bits per pixel (32 = ARGB)
; ppvBits				A pointer to a variable that receives a pointer to the location of the DIB bit values
;
; return				returns a DIB. A gdi bitmap
;
; notes					ppvBits will receive the location of the pixels in the DIB

CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	
	NumPut(w, bi, 4, "uint")
	, NumPut(h, bi, 8, "uint")
	, NumPut(40, bi, 0, "uint")
	, NumPut(1, bi, 12, "ushort")
	, NumPut(0, bi, 16, "uInt")
	, NumPut(bpp, bi, 14, "ushort")
	
	hbm := DllCall("CreateDIBSection"
					, Ptr, hdc2
					, Ptr, &bi
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "uint*", ppvBits
					, Ptr, 0
					, "uint", 0, Ptr)

	if !hdc
		ReleaseDC(hdc2)
	return hbm
}

;#####################################################################################

; Function				PrintWindow
; Description			The PrintWindow function copies a visual window into the specified device context (DC), typically a printer DC
;
; hwnd					A handle to the window that will be copied
; hdc					A handle to the device context
; Flags					Drawing options
;
; return				If the function succeeds, it returns a nonzero value
;
; PW_CLIENTONLY			= 1

PrintWindow(hwnd, hdc, Flags=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("PrintWindow", Ptr, hwnd, Ptr, hdc, "uint", Flags)
}

;#####################################################################################

; Function				DestroyIcon
; Description			Destroys an icon and frees any memory the icon occupied
;
; hIcon					Handle to the icon to be destroyed. The icon must not be in use
;
; return				If the function succeeds, the return value is nonzero

DestroyIcon(hIcon)
{
	return DllCall("DestroyIcon", A_PtrSize ? "UPtr" : "UInt", hIcon)
}

;#####################################################################################

PaintDesktop(hdc)
{
	return DllCall("PaintDesktop", A_PtrSize ? "UPtr" : "UInt", hdc)
}

;#####################################################################################

CreateCompatibleBitmap(hdc, w, h)
{
	return DllCall("gdi32\CreateCompatibleBitmap", A_PtrSize ? "UPtr" : "UInt", hdc, "int", w, "int", h)
}

;#####################################################################################

; Function				CreateCompatibleDC
; Description			This function creates a memory device context (DC) compatible with the specified device
;
; hdc					Handle to an existing device context					
;
; return				returns the handle to a device context or 0 on failure
;
; notes					If this handle is 0 (by default), the function creates a memory device context compatible with the application's current screen

CreateCompatibleDC(hdc=0)
{
   return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}

;#####################################################################################

; Function				SelectObject
; Description			The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type
;
; hdc					Handle to a DC
; hgdiobj				A handle to the object to be selected into the DC
;
; return				If the selected object is not a region and the function succeeds, the return value is a handle to the object being replaced
;
; notes					The specified object must have been created by using one of the following functions
;						Bitmap - CreateBitmap, CreateBitmapIndirect, CreateCompatibleBitmap, CreateDIBitmap, CreateDIBSection (A single bitmap cannot be selected into more than one DC at the same time)
;						Brush - CreateBrushIndirect, CreateDIBPatternBrush, CreateDIBPatternBrushPt, CreateHatchBrush, CreatePatternBrush, CreateSolidBrush
;						Font - CreateFont, CreateFontIndirect
;						Pen - CreatePen, CreatePenIndirect
;						Region - CombineRgn, CreateEllipticRgn, CreateEllipticRgnIndirect, CreatePolygonRgn, CreateRectRgn, CreateRectRgnIndirect
;
; notes					If the selected object is a region and the function succeeds, the return value is one of the following value
;
; SIMPLEREGION			= 2 Region consists of a single rectangle
; COMPLEXREGION			= 3 Region consists of more than one rectangle
; NULLREGION			= 1 Region is empty

SelectObject(hdc, hgdiobj)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
}

;#####################################################################################

; Function				DeleteObject
; Description			This function deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources associated with the object
;						After the object is deleted, the specified handle is no longer valid
;
; hObject				Handle to a logical pen, brush, font, bitmap, region, or palette to delete
;
; return				Nonzero indicates success. Zero indicates that the specified handle is not valid or that the handle is currently selected into a device context

DeleteObject(hObject)
{
   return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
}

;#####################################################################################

; Function				GetDC
; Description			This function retrieves a handle to a display device context (DC) for the client area of the specified window.
;						The display device context can be used in subsequent graphics display interface (GDI) functions to draw in the client area of the window. 
;
; hwnd					Handle to the window whose device context is to be retrieved. If this value is NULL, GetDC retrieves the device context for the entire screen					
;
; return				The handle the device context for the specified window's client area indicates success. NULL indicates failure

GetDC(hwnd=0)
{
	return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
}

;#####################################################################################

; DCX_CACHE = 0x2
; DCX_CLIPCHILDREN = 0x8
; DCX_CLIPSIBLINGS = 0x10
; DCX_EXCLUDERGN = 0x40
; DCX_EXCLUDEUPDATE = 0x100
; DCX_INTERSECTRGN = 0x80
; DCX_INTERSECTUPDATE = 0x200
; DCX_LOCKWINDOWUPDATE = 0x400
; DCX_NORECOMPUTE = 0x100000
; DCX_NORESETATTRS = 0x4
; DCX_PARENTCLIP = 0x20
; DCX_VALIDATE = 0x200000
; DCX_WINDOW = 0x1

GetDCEx(hwnd, flags=0, hrgnClip=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
    return DllCall("GetDCEx", Ptr, hwnd, Ptr, hrgnClip, "int", flags)
}

;#####################################################################################

; Function				ReleaseDC
; Description			This function releases a device context (DC), freeing it for use by other applications. The effect of ReleaseDC depends on the type of device context
;
; hdc					Handle to the device context to be released
; hwnd					Handle to the window whose device context is to be released
;
; return				1 = released
;						0 = not released
;
; notes					The application must call the ReleaseDC function for each call to the GetWindowDC function and for each call to the GetDC function that retrieves a common device context
;						An application cannot use the ReleaseDC function to release a device context that was created by calling the CreateDC function; instead, it must use the DeleteDC function. 

ReleaseDC(hdc, hwnd=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("ReleaseDC", Ptr, hwnd, Ptr, hdc)
}

;#####################################################################################

; Function				DeleteDC
; Description			The DeleteDC function deletes the specified device context (DC)
;
; hdc					A handle to the device context
;
; return				If the function succeeds, the return value is nonzero
;
; notes					An application must not delete a DC whose handle was obtained by calling the GetDC function. Instead, it must call the ReleaseDC function to free the DC

DeleteDC(hdc)
{
   return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
;#####################################################################################

; Function				Gdip_LibraryVersion
; Description			Get the current library version
;
; return				the library version
;
; notes					This is useful for non compiled programs to ensure that a person doesn't run an old version when testing your scripts

Gdip_LibraryVersion()
{
	return 1.45
}

;#####################################################################################

; Function				Gdip_LibrarySubVersion
; Description			Get the current library sub version
;
; return				the library sub version
;
; notes					This is the sub-version currently maintained by Rseding91
Gdip_LibrarySubVersion()
{
	return 1.47
}

;#####################################################################################

; Function:    			Gdip_BitmapFromBRA
; Description: 			Gets a pointer to a gdi+ bitmap from a BRA file
;
; BRAFromMemIn			The variable for a BRA file read to memory
; File					The name of the file, or its number that you would like (This depends on alternate parameter)
; Alternate				Changes whether the File parameter is the file name or its number
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1 = The BRA variable is empty
;						-2 = The BRA has an incorrect header
;						-3 = The BRA has information missing
;						-4 = Could not find file inside the BRA

Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate=0)
{
	Static FName = "ObjRelease"
	
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else
			break
	}
	if !Alternate
		StringReplace, File, File, \, \\, All
	RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", FileInfo)
	if !FileInfo
		return -4
	
	hData := DllCall("GlobalAlloc", "uint", 2, Ptr, FileInfo2, Ptr)
	pData := DllCall("GlobalLock", Ptr, hData, Ptr)
	DllCall("RtlMoveMemory", Ptr, pData, Ptr, &BRAFromMemIn+Info2+FileInfo1, Ptr, FileInfo2)
	DllCall("GlobalUnlock", Ptr, hData)
	DllCall("ole32\CreateStreamOnHGlobal", Ptr, hData, "int", 1, A_PtrSize ? "UPtr*" : "UInt*", pStream)
	DllCall("gdiplus\GdipCreateBitmapFromStream", Ptr, pStream, A_PtrSize ? "UPtr*" : "UInt*", pBitmap)
	If (A_PtrSize)
		%FName%(pStream)
	Else
		DllCall(NumGet(NumGet(1*pStream)+8), "uint", pStream)
	return pBitmap
}

;#####################################################################################

; Function				Gdip_DrawRectangle
; Description			This function uses a pen to draw the outline of a rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawRectangle", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_DrawRoundedRectangle
; Description			This function uses a pen to draw the outline of a rounded rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	return E
}

;#####################################################################################

; Function				Gdip_DrawEllipse
; Description			This function uses a pen to draw the outline of an ellipse into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle the ellipse will be drawn into
; y						y-coordinate of the top left of the rectangle the ellipse will be drawn into
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawEllipse", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_DrawBezier
; Description			This function uses a pen to draw the outline of a bezier (a weighted curve) into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the bezier
; y1					y-coordinate of the start of the bezier
; x2					x-coordinate of the first arc of the bezier
; y2					y-coordinate of the first arc of the bezier
; x3					x-coordinate of the second arc of the bezier
; y3					y-coordinate of the second arc of the bezier
; x4					x-coordinate of the end of the bezier
; y4					y-coordinate of the end of the bezier
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawBezier"
					, Ptr, pgraphics
					, Ptr, pPen
					, "float", x1
					, "float", y1
					, "float", x2
					, "float", y2
					, "float", x3
					, "float", y3
					, "float", x4
					, "float", y4)
}

;#####################################################################################

; Function				Gdip_DrawArc
; Description			This function uses a pen to draw the outline of an arc into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the arc
; y						y-coordinate of the start of the arc
; w						width of the arc
; h						height of the arc
; StartAngle			specifies the angle between the x-axis and the starting point of the arc
; SweepAngle			specifies the angle between the starting and ending points of the arc
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawArc"
					, Ptr, pGraphics
					, Ptr, pPen
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "float", StartAngle
					, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_DrawPie
; Description			This function uses a pen to draw the outline of a pie into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the pie
; y						y-coordinate of the start of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawPie", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_DrawLine
; Description			This function uses a pen to draw a line into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the line
; y1					y-coordinate of the start of the line
; x2					x-coordinate of the end of the line
; y2					y-coordinate of the end of the line
;
; return				status enumeration. 0 = success		

Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawLine"
					, Ptr, pGraphics
					, Ptr, pPen
					, "float", x1
					, "float", y1
					, "float", x2
					, "float", y2)
}

;#####################################################################################

; Function				Gdip_DrawLines
; Description			This function uses a pen to draw a series of joined lines into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success				

Gdip_DrawLines(pGraphics, pPen, Points)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}
	return DllCall("gdiplus\GdipDrawLines", Ptr, pGraphics, Ptr, pPen, Ptr, &PointF, "int", Points0)
}

;#####################################################################################

; Function				Gdip_FillRectangle
; Description			This function uses a brush to fill a rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillRectangle"
					, Ptr, pGraphics
					, Ptr, pBrush
					, "float", x
					, "float", y
					, "float", w
					, "float", h)
}

;#####################################################################################

; Function				Gdip_FillRoundedRectangle
; Description			This function uses a brush to fill a rounded rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success

Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return E
}

;#####################################################################################

; Function				Gdip_FillPolygon
; Description			This function uses a brush to fill a polygon in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success
;
; notes					Alternate will fill the polygon as a whole, wheras winding will fill each new "segment"
; Alternate 			= 0
; Winding 				= 1

Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}   
	return DllCall("gdiplus\GdipFillPolygon", Ptr, pGraphics, Ptr, pBrush, Ptr, &PointF, "int", Points0, "int", FillMode)
}

;#####################################################################################

; Function				Gdip_FillPie
; Description			This function uses a brush to fill a pie in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the pie
; y						y-coordinate of the top left of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success

Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillPie"
					, Ptr, pGraphics
					, Ptr, pBrush
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "float", StartAngle
					, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_FillEllipse
; Description			This function uses a brush to fill an ellipse in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the ellipse
; y						y-coordinate of the top left of the ellipse
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success

Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillEllipse", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_FillRegion
; Description			This function uses a brush to fill a region in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Region				Pointer to a Region
;
; return				status enumeration. 0 = success
;
; notes					You can create a region Gdip_CreateRegion() and then add to this

Gdip_FillRegion(pGraphics, pBrush, Region)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillRegion", Ptr, pGraphics, Ptr, pBrush, Ptr, Region)
}

;#####################################################################################

; Function				Gdip_FillPath
; Description			This function uses a brush to fill a path in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Region				Pointer to a Path
;
; return				status enumeration. 0 = success

Gdip_FillPath(pGraphics, pBrush, Path)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillPath", Ptr, pGraphics, Ptr, pBrush, Ptr, Path)
}

;#####################################################################################

; Function				Gdip_DrawImagePointsRect
; Description			This function draws a bitmap into the Graphics of another bitmap and skews it
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; Points				Points passed as x1,y1|x2,y2|x3,y3 (3 points: top left, top right, bottom left) describing the drawing of the bitmap
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter

Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx="", sy="", sw="", sh="", Matrix=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}

	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
		
	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		sx := 0, sy := 0
		sw := Gdip_GetImageWidth(pBitmap)
		sh := Gdip_GetImageHeight(pBitmap)
	}

	E := DllCall("gdiplus\GdipDrawImagePointsRect"
				, Ptr, pGraphics
				, Ptr, pBitmap
				, Ptr, &PointF
				, "int", Points0
				, "float", sx
				, "float", sy
				, "float", sw
				, "float", sh
				, "int", 2
				, Ptr, ImageAttr
				, Ptr, 0
				, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}

;#####################################################################################

; Function				Gdip_DrawImage
; Description			This function draws a bitmap into the Graphics of another bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination image
; dh					height of destination image
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source image
; sh					height of source image
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Gdip_DrawImage performs faster
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter. For example:
;						MatrixBright=
;						(
;						1.5		|0		|0		|0		|0
;						0		|1.5	|0		|0		|0
;						0		|0		|1.5	|0		|0
;						0		|0		|0		|1		|0
;						0.05	|0.05	|0.05	|0		|1
;						)
;
; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1

Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}

	E := DllCall("gdiplus\GdipDrawImageRectRect"
				, Ptr, pGraphics
				, Ptr, pBitmap
				, "float", dx
				, "float", dy
				, "float", dw
				, "float", dh
				, "float", sx
				, "float", sy
				, "float", sw
				, "float", sh
				, "int", 2
				, Ptr, ImageAttr
				, Ptr, 0
				, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}

;#####################################################################################

; Function				Gdip_SetImageAttributesColorMatrix
; Description			This function creates an image matrix ready for drawing
;
; Matrix				a matrix used to alter image attributes when drawing
;						passed with any delimeter
;
; return				returns an image matrix on sucess or 0 if it fails
;
; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1

Gdip_SetImageAttributesColorMatrix(Matrix)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", A_PtrSize ? "UPtr*" : "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", Ptr, ImageAttr, "int", 1, "int", 1, Ptr, &ColourMatrix, Ptr, 0, "int", 0)
	return ImageAttr
}

;#####################################################################################

; Function				Gdip_GraphicsFromImage
; Description			This function gets the graphics for a bitmap used for drawing functions
;
; pBitmap				Pointer to a bitmap to get the pointer to its graphics
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					a bitmap can be drawn into the graphics of another bitmap

Gdip_GraphicsFromImage(pBitmap)
{
	DllCall("gdiplus\GdipGetImageGraphicsContext", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
	return pGraphics
}

;#####################################################################################

; Function				Gdip_GraphicsFromHDC
; Description			This function gets the graphics from the handle to a device context
;
; hdc					This is the handle to the device context
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					You can draw a bitmap into the graphics of another bitmap

Gdip_GraphicsFromHDC(hdc)
{
    DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
    return pGraphics
}

;#####################################################################################

; Function				Gdip_GetDC
; Description			This function gets the device context of the passed Graphics
;
; hdc					This is the handle to the device context
;
; return				returns the device context for the graphics of a bitmap

Gdip_GetDC(pGraphics)
{
	DllCall("gdiplus\GdipGetDC", A_PtrSize ? "UPtr" : "UInt", pGraphics, A_PtrSize ? "UPtr*" : "UInt*", hdc)
	return hdc
}

;#####################################################################################

; Function				Gdip_ReleaseDC
; Description			This function releases a device context from use for further use
;
; pGraphics				Pointer to the graphics of a bitmap
; hdc					This is the handle to the device context
;
; return				status enumeration. 0 = success

Gdip_ReleaseDC(pGraphics, hdc)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipReleaseDC", Ptr, pGraphics, Ptr, hdc)
}

;#####################################################################################

; Function				Gdip_GraphicsClear
; Description			Clears the graphics of a bitmap ready for further drawing
;
; pGraphics				Pointer to the graphics of a bitmap
; ARGB					The colour to clear the graphics to
;
; return				status enumeration. 0 = success
;
; notes					By default this will make the background PARALYZED
;						Using clipping regions you can clear a particular area on the graphics rather than clearing the entire graphics

Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff)
{
    return DllCall("gdiplus\GdipGraphicsClear", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", ARGB)
}

;#####################################################################################

; Function				Gdip_BlurBitmap
; Description			Gives a pointer to a blurred bitmap from a pointer to a bitmap
;
; pBitmap				Pointer to a bitmap to be blurred
; Blur					The Amount to blur a bitmap by from 1 (least blur) to 100 (most blur)
;
; return				If the function succeeds, the return value is a pointer to the new blurred bitmap
;						-1 = The blur parameter is outside the range 1-100
;
; notes					This function will not dispose of the original bitmap

Gdip_BlurBitmap(pBitmap, Blur)
{
	if (Blur > 100) || (Blur < 1)
		return -1	
	
	sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
	dWidth := sWidth//Blur, dHeight := sHeight//Blur

	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
	G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)

	Gdip_DeleteGraphics(G1)

	pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)

	Gdip_DeleteGraphics(G2)
	Gdip_DisposeImage(pBitmap1)
	return pBitmap2
}

;#####################################################################################

; Function:     		Gdip_SaveBitmapToFile
; Description:  		Saves a bitmap to a file in any supported format onto disk
;   
; pBitmap				Pointer to a bitmap
; sOutput      			The name of the file that the bitmap will be saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality      			If saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; return      			If the function succeeds, the return value is zero, otherwise:
;						-1 = Extension supplied is not a supported file format
;						-2 = Could not get a list of encoders on system
;						-3 = Could not find matching encoder for specified file format
;						-4 = Could not get WideChar name of output file
;						-5 = Could not save file to disk
;
; notes					This function will use the extension supplied from the sOutput parameter to determine the output format

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=75)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	SplitPath, sOutput,,, Extension
	if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Extension

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
	if !(nCount && nSize)
		return -2
	
	If (A_IsUnicode){
		StrGet_Name := "StrGet"
		Loop, %nCount%
		{
			sString := %StrGet_Name%(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+idx
			break
		}
	} else {
		Loop, %nCount%
		{
			Location := NumGet(ci, 76*(A_Index-1)+44)
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+76*(A_Index-1)
			break
		}
	}
	
	if !pCodec
		return -3

	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
			Loop, % NumGet(EncoderParameters, "UInt")      ;%
			{
				elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
				if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
				{
					p := elem+&EncoderParameters-pad-4
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20, "UInt")), "UInt")
					break
				}
			}      
		}
	}

	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &wOutput, Ptr, pCodec, "uint", p ? p : 0)
	}
	else
		E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &sOutput, Ptr, pCodec, "uint", p ? p : 0)
	return E ? -5 : 0
}

;#####################################################################################

; Function				Gdip_GetPixel
; Description			Gets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				Returns the ARGB value of the pixel

Gdip_GetPixel(pBitmap, x, y)
{
	DllCall("gdiplus\GdipBitmapGetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "uint*", ARGB)
	return ARGB
}

;#####################################################################################

; Function				Gdip_SetPixel
; Description			Sets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				status enumeration. 0 = success

Gdip_SetPixel(pBitmap, x, y, ARGB)
{
   return DllCall("gdiplus\GdipBitmapSetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "int", ARGB)
}

;#####################################################################################

; Function				Gdip_GetImageWidth
; Description			Gives the width of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the width in pixels of the supplied bitmap

Gdip_GetImageWidth(pBitmap)
{
   DllCall("gdiplus\GdipGetImageWidth", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Width)
   return Width
}

;#####################################################################################

; Function				Gdip_GetImageHeight
; Description			Gives the height of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the height in pixels of the supplied bitmap

Gdip_GetImageHeight(pBitmap)
{
   DllCall("gdiplus\GdipGetImageHeight", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Height)
   return Height
}

;#####################################################################################

; Function				Gdip_GetDimensions
; Description			Gives the width and height of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	DllCall("gdiplus\GdipGetImageWidth", Ptr, pBitmap, "uint*", Width)
	DllCall("gdiplus\GdipGetImageHeight", Ptr, pBitmap, "uint*", Height)
}

;#####################################################################################

Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Gdip_GetImageDimensions(pBitmap, Width, Height)
}

;#####################################################################################

Gdip_GetImagePixelFormat(pBitmap)
{
	DllCall("gdiplus\GdipGetImagePixelFormat", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", Format)
	return Format
}

;#####################################################################################

; Function				Gdip_GetDpiX
; Description			Gives the horizontal dots per inch of the graphics of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetDpiX(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiX", A_PtrSize ? "UPtr" : "uint", pGraphics, "float*", dpix)
	return Round(dpix)
}

;#####################################################################################

Gdip_GetDpiY(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiY", A_PtrSize ? "UPtr" : "uint", pGraphics, "float*", dpiy)
	return Round(dpiy)
}

;#####################################################################################

Gdip_GetImageHorizontalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageHorizontalResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float*", dpix)
	return Round(dpix)
}

;#####################################################################################

Gdip_GetImageVerticalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageVerticalResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float*", dpiy)
	return Round(dpiy)
}

;#####################################################################################

Gdip_BitmapSetResolution(pBitmap, dpix, dpiy)
{
	return DllCall("gdiplus\GdipBitmapSetResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float", dpix, "float", dpiy)
}

;#####################################################################################

Gdip_CreateBitmapFromFile(sFile, IconNumber=1, IconSize="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	, PtrA := A_PtrSize ? "UPtr*" : "UInt*"
	
	SplitPath, sFile,,, ext
	if ext in exe,dll
	{
		Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
		BufSize := 16 + (2*(A_PtrSize ? A_PtrSize : 4))
		
		VarSetCapacity(buf, BufSize, 0)
		Loop, Parse, Sizes, |
		{
			DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, PtrA, hIcon, PtrA, 0, "uint", 1, "uint", 0)
			
			if !hIcon
				continue

			if !DllCall("GetIconInfo", Ptr, hIcon, Ptr, &buf)
			{
				DestroyIcon(hIcon)
				continue
			}
			
			hbmMask  := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4))
			hbmColor := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4) + (A_PtrSize ? A_PtrSize : 4))
			if !(hbmColor && DllCall("GetObject", Ptr, hbmColor, "int", BufSize, Ptr, &buf))
			{
				DestroyIcon(hIcon)
				continue
			}
			break
		}
		if !hIcon
			return -1

		Width := NumGet(buf, 4, "int"), Height := NumGet(buf, 8, "int")
		hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
		if !DllCall("DrawIconEx", Ptr, hdc, "int", 0, "int", 0, Ptr, hIcon, "uint", Width, "uint", Height, "uint", 0, Ptr, 0, "uint", 3)
		{
			DestroyIcon(hIcon)
			return -2
		}
		
		VarSetCapacity(dib, 104)
		DllCall("GetObject", Ptr, hbm, "int", A_PtrSize = 8 ? 104 : 84, Ptr, &dib) ; sizeof(DIBSECTION) = 76+2*(A_PtrSize=8?4:0)+2*A_PtrSize
		Stride := NumGet(dib, 12, "Int"), Bits := NumGet(dib, 20 + (A_PtrSize = 8 ? 4 : 0)) ; padding
		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, Ptr, Bits, PtrA, pBitmapOld)
		pBitmap := Gdip_CreateBitmap(Width, Height)
		G := Gdip_GraphicsFromImage(pBitmap)
		, Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
		DestroyIcon(hIcon)
	}
	else
	{
		if (!A_IsUnicode)
		{
			VarSetCapacity(wFile, 1024)
			DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sFile, "int", -1, Ptr, &wFile, "int", 512)
			DllCall("gdiplus\GdipCreateBitmapFromFile", Ptr, &wFile, PtrA, pBitmap)
		}
		else
			DllCall("gdiplus\GdipCreateBitmapFromFile", Ptr, &sFile, PtrA, pBitmap)
	}
	
	return pBitmap
}

;#####################################################################################

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", Ptr, hBitmap, Ptr, Palette, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff)
{
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", hbm, "int", Background)
	return hbm
}

;#####################################################################################

Gdip_CreateBitmapFromHICON(hIcon)
{
	DllCall("gdiplus\GdipCreateBitmapFromHICON", A_PtrSize ? "UPtr" : "UInt", hIcon, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_CreateHICONFromBitmap(pBitmap)
{
	DllCall("gdiplus\GdipCreateHICONFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", hIcon)
	return hIcon
}

;#####################################################################################

Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, A_PtrSize ? "UPtr" : "UInt", 0, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
    Return pBitmap
}

;#####################################################################################

Gdip_CreateBitmapFromClipboard()
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if !DllCall("OpenClipboard", Ptr, 0)
		return -1
	if !DllCall("IsClipboardFormatAvailable", "uint", 8)
		return -2
	if !hBitmap := DllCall("GetClipboardData", "uint", 2, Ptr)
		return -3
	if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
		return -4
	if !DllCall("CloseClipboard")
		return -5
	DeleteObject(hBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_SetBitmapToClipboard(pBitmap)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	off1 := A_PtrSize = 8 ? 52 : 44, off2 := A_PtrSize = 8 ? 32 : 24
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	DllCall("GetObject", Ptr, hBitmap, "int", VarSetCapacity(oi, A_PtrSize = 8 ? 104 : 84, 0), Ptr, &oi)
	hdib := DllCall("GlobalAlloc", "uint", 2, Ptr, 40+NumGet(oi, off1, "UInt"), Ptr)
	pdib := DllCall("GlobalLock", Ptr, hdib, Ptr)
	DllCall("RtlMoveMemory", Ptr, pdib, Ptr, &oi+off2, Ptr, 40)
	DllCall("RtlMoveMemory", Ptr, pdib+40, Ptr, NumGet(oi, off2 - (A_PtrSize ? A_PtrSize : 4), Ptr), Ptr, NumGet(oi, off1, "UInt"))
	DllCall("GlobalUnlock", Ptr, hdib)
	DllCall("DeleteObject", Ptr, hBitmap)
	DllCall("OpenClipboard", Ptr, 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "uint", 8, Ptr, hdib)
	DllCall("CloseClipboard")
}

;#####################################################################################

Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format=0x26200A)
{
	DllCall("gdiplus\GdipCloneBitmapArea"
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "int", Format
					, A_PtrSize ? "UPtr" : "UInt", pBitmap
					, A_PtrSize ? "UPtr*" : "UInt*", pBitmapDest)
	return pBitmapDest
}

;#####################################################################################
; Create resources
;#####################################################################################

Gdip_CreatePen(ARGB, w)
{
   DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
   return pPen
}

;#####################################################################################

Gdip_CreatePenFromBrush(pBrush, w)
{
	DllCall("gdiplus\GdipCreatePen2", A_PtrSize ? "UPtr" : "UInt", pBrush, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
	return pPen
}

;#####################################################################################

Gdip_BrushCreateSolid(ARGB=0xff000000)
{
	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}

;#####################################################################################

; HatchStyleHorizontal = 0
; HatchStyleVertical = 1
; HatchStyleForwardDiagonal = 2
; HatchStyleBackwardDiagonal = 3
; HatchStyleCross = 4
; HatchStyleDiagonalCross = 5
; HatchStyle05Percent = 6
; HatchStyle10Percent = 7
; HatchStyle20Percent = 8
; HatchStyle25Percent = 9
; HatchStyle30Percent = 10
; HatchStyle40Percent = 11
; HatchStyle50Percent = 12
; HatchStyle60Percent = 13
; HatchStyle70Percent = 14
; HatchStyle75Percent = 15
; HatchStyle80Percent = 16
; HatchStyle90Percent = 17
; HatchStyleLightDownwardDiagonal = 18
; HatchStyleLightUpwardDiagonal = 19
; HatchStyleDarkDownwardDiagonal = 20
; HatchStyleDarkUpwardDiagonal = 21
; HatchStyleWideDownwardDiagonal = 22
; HatchStyleWideUpwardDiagonal = 23
; HatchStyleLightVertical = 24
; HatchStyleLightHorizontal = 25
; HatchStyleNarrowVertical = 26
; HatchStyleNarrowHorizontal = 27
; HatchStyleDarkVertical = 28
; HatchStyleDarkHorizontal = 29
; HatchStyleDashedDownwardDiagonal = 30
; HatchStyleDashedUpwardDiagonal = 31
; HatchStyleDashedHorizontal = 32
; HatchStyleDashedVertical = 33
; HatchStyleSmallConfetti = 34
; HatchStyleLargeConfetti = 35
; HatchStyleZigZag = 36
; HatchStyleWave = 37
; HatchStyleDiagonalBrick = 38
; HatchStyleHorizontalBrick = 39
; HatchStyleWeave = 40
; HatchStylePlaid = 41
; HatchStyleDivot = 42
; HatchStyleDottedGrid = 43
; HatchStyleDottedDiamond = 44
; HatchStyleShingle = 45
; HatchStyleTrellis = 46
; HatchStyleSphere = 47
; HatchStyleSmallGrid = 48
; HatchStyleSmallCheckerBoard = 49
; HatchStyleLargeCheckerBoard = 50
; HatchStyleOutlinedDiamond = 51
; HatchStyleSolidDiamond = 52
; HatchStyleTotal = 53
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0)
{
	DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "UInt", ARGBfront, "UInt", ARGBback, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}

;#####################################################################################

Gdip_CreateTextureBrush(pBitmap, WrapMode=1, x=0, y=0, w="", h="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	, PtrA := A_PtrSize ? "UPtr*" : "UInt*"
	
	if !(w && h)
		DllCall("gdiplus\GdipCreateTexture", Ptr, pBitmap, "int", WrapMode, PtrA, pBrush)
	else
		DllCall("gdiplus\GdipCreateTexture2", Ptr, pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, PtrA, pBrush)
	return pBrush
}

;#####################################################################################

; WrapModeTile = 0
; WrapModeTileFlipX = 1
; WrapModeTileFlipY = 2
; WrapModeTileFlipXY = 3
; WrapModeClamp = 4
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", Ptr, &PointF1, Ptr, &PointF2, "Uint", ARGB1, "Uint", ARGB2, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}

;#####################################################################################

; LinearGradientModeHorizontal = 0
; LinearGradientModeVertical = 1
; LinearGradientModeForwardDiagonal = 2
; LinearGradientModeBackwardDiagonal = 3
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1)
{
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", A_PtrSize ? "UPtr" : "UInt", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}

;#####################################################################################

Gdip_CloneBrush(pBrush)
{
	DllCall("gdiplus\GdipCloneBrush", A_PtrSize ? "UPtr" : "UInt", pBrush, A_PtrSize ? "UPtr*" : "UInt*", pBrushClone)
	return pBrushClone
}

;#####################################################################################
; Delete resources
;#####################################################################################

Gdip_DeletePen(pPen)
{
   return DllCall("gdiplus\GdipDeletePen", A_PtrSize ? "UPtr" : "UInt", pPen)
}

;#####################################################################################

Gdip_DeleteBrush(pBrush)
{
   return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
}

;#####################################################################################

Gdip_DisposeImage(pBitmap)
{
   return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
}

;#####################################################################################

Gdip_DeleteGraphics(pGraphics)
{
   return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

;#####################################################################################

Gdip_DisposeImageAttributes(ImageAttr)
{
	return DllCall("gdiplus\GdipDisposeImageAttributes", A_PtrSize ? "UPtr" : "UInt", ImageAttr)
}

;#####################################################################################

Gdip_DeleteFont(hFont)
{
   return DllCall("gdiplus\GdipDeleteFont", A_PtrSize ? "UPtr" : "UInt", hFont)
}

;#####################################################################################

Gdip_DeleteStringFormat(hFormat)
{
   return DllCall("gdiplus\GdipDeleteStringFormat", A_PtrSize ? "UPtr" : "UInt", hFormat)
}

;#####################################################################################

Gdip_DeleteFontFamily(hFamily)
{
   return DllCall("gdiplus\GdipDeleteFontFamily", A_PtrSize ? "UPtr" : "UInt", hFamily)
}

;#####################################################################################

Gdip_DeleteMatrix(Matrix)
{
   return DllCall("gdiplus\GdipDeleteMatrix", A_PtrSize ? "UPtr" : "UInt", Matrix)
}

;#####################################################################################
; Text functions
;#####################################################################################

Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
{
	IWidth := Width, IHeight:= Height
	
	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, "i)NoWrap", NoWrap)
	RegExMatch(Options, "i)R(\d)", Rendering)
	RegExMatch(Options, "i)S(\d+)(p*)", Size)

	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
		PassBrush := 1, pBrush := Colour2
	
	if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
		return -1

	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	Loop, Parse, Styles, |
	{
		if RegExMatch(Options, "\b" A_loopField)
		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
	}
  
	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	Loop, Parse, Alignments, |
	{
		if RegExMatch(Options, "\b" A_loopField)
			Align |= A_Index//2.1      ; 0|0|1|1|2|2
	}

	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
	if !PassBrush
		Colour := "0x" (Colour2 ? Colour2 : "ff000000")
	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
   
	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

	if vPos
	{
		StringSplit, ReturnRC, ReturnRC, |
		
		if (vPos = "vCentre") || (vPos = "vCenter")
			ypos += (Height-ReturnRC4)//2
		else if (vPos = "Top") || (vPos = "Up")
			ypos := 0
		else if (vPos = "Bottom") || (vPos = "Down")
			ypos := Height-ReturnRC4
		
		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}

	if !Measure
		E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)   
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	return E ? E : ReturnRC
}

;#####################################################################################

Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}
	
	return DllCall("gdiplus\GdipDrawString"
					, Ptr, pGraphics
					, Ptr, A_IsUnicode ? &sString : &wString
					, "int", -1
					, Ptr, hFont
					, Ptr, &RectF
					, Ptr, hFormat
					, Ptr, pBrush)
}

;#####################################################################################

Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	VarSetCapacity(RC, 16)
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)   
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}
	
	DllCall("gdiplus\GdipMeasureString"
					, Ptr, pGraphics
					, Ptr, A_IsUnicode ? &sString : &wString
					, "int", -1
					, Ptr, hFont
					, Ptr, &RectF
					, Ptr, hFormat
					, Ptr, &RC
					, "uint*", Chars
					, "uint*", Lines)
	
	return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}

; Near = 0
; Center = 1
; Far = 2
Gdip_SetStringFormatAlign(hFormat, Align)
{
   return DllCall("gdiplus\GdipSetStringFormatAlign", A_PtrSize ? "UPtr" : "UInt", hFormat, "int", Align)
}

; StringFormatFlagsDirectionRightToLeft    = 0x00000001
; StringFormatFlagsDirectionVertical       = 0x00000002
; StringFormatFlagsNoFitBlackBox           = 0x00000004
; StringFormatFlagsDisplayFormatControl    = 0x00000020
; StringFormatFlagsNoFontFallback          = 0x00000400
; StringFormatFlagsMeasureTrailingSpaces   = 0x00000800
; StringFormatFlagsNoWrap                  = 0x00001000
; StringFormatFlagsLineLimit               = 0x00002000
; StringFormatFlagsNoClip                  = 0x00004000 
Gdip_StringFormatCreate(Format=0, Lang=0)
{
   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, A_PtrSize ? "UPtr*" : "UInt*", hFormat)
   return hFormat
}

; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8
Gdip_FontCreate(hFamily, Size, Style=0)
{
   DllCall("gdiplus\GdipCreateFont", A_PtrSize ? "UPtr" : "UInt", hFamily, "float", Size, "int", Style, "int", 0, A_PtrSize ? "UPtr*" : "UInt*", hFont)
   return hFont
}

Gdip_FontFamilyCreate(Font)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wFont, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, Ptr, &wFont, "int", nSize)
	}
	
	DllCall("gdiplus\GdipCreateFontFamilyFromName"
					, Ptr, A_IsUnicode ? &Font : &wFont
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "UInt*", hFamily)
	
	return hFamily
}

;#####################################################################################
; Matrix functions
;#####################################################################################

Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
   DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, A_PtrSize ? "UPtr*" : "UInt*", Matrix)
   return Matrix
}

Gdip_CreateMatrix()
{
   DllCall("gdiplus\GdipCreateMatrix", A_PtrSize ? "UPtr*" : "UInt*", Matrix)
   return Matrix
}

;#####################################################################################
; GraphicsPath functions
;#####################################################################################

; Alternate = 0
; Winding = 1
Gdip_CreatePath(BrushMode=0)
{
	DllCall("gdiplus\GdipCreatePath", "int", BrushMode, A_PtrSize ? "UPtr*" : "UInt*", Path)
	return Path
}

Gdip_AddPathEllipse(Path, x, y, w, h)
{
	return DllCall("gdiplus\GdipAddPathEllipse", A_PtrSize ? "UPtr" : "UInt", Path, "float", x, "float", y, "float", w, "float", h)
}

Gdip_AddPathPolygon(Path, Points)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}   

	return DllCall("gdiplus\GdipAddPathPolygon", Ptr, Path, Ptr, &PointF, "int", Points0)
}

Gdip_DeletePath(Path)
{
	return DllCall("gdiplus\GdipDeletePath", A_PtrSize ? "UPtr" : "UInt", Path)
}

;#####################################################################################
; Quality functions
;#####################################################################################

; SystemDefault = 0
; SingleBitPerPixelGridFit = 1
; SingleBitPerPixel = 2
; AntiAliasGridFit = 3
; AntiAlias = 4
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
{
	return DllCall("gdiplus\GdipSetTextRenderingHint", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", RenderingHint)
}

; Default = 0
; LowQuality = 1
; HighQuality = 2
; Bilinear = 3
; Bicubic = 4
; NearestNeighbor = 5
; HighQualityBilinear = 6
; HighQualityBicubic = 7
Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
{
   return DllCall("gdiplus\GdipSetInterpolationMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", InterpolationMode)
}

; Default = 0
; HighSpeed = 1
; HighQuality = 2
; None = 3
; AntiAlias = 4
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
   return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
}

; CompositingModeSourceOver = 0 (blended)
; CompositingModeSourceCopy = 1 (overwrite)
Gdip_SetCompositingMode(pGraphics, CompositingMode=0)
{
   return DllCall("gdiplus\GdipSetCompositingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", CompositingMode)
}

;#####################################################################################
; Extra functions
;#####################################################################################

Gdip_Startup()
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}

Gdip_Shutdown(pToken)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)
	return 0
}

; Prepend = 0; The new operation is applied before the old operation.
; Append = 1; The new operation is applied after the old operation.
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipRotateWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", Angle, "int", MatrixOrder)
}

Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipScaleWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipTranslateWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_ResetWorldTransform(pGraphics)
{
	return DllCall("gdiplus\GdipResetWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation)
{
	pi := 3.14159, TAngle := Angle*(pi/180)	

	Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
	if ((Bound >= 0) && (Bound <= 90))
		xTranslation := Height*Sin(TAngle), yTranslation := 0
	else if ((Bound > 90) && (Bound <= 180))
		xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
	else if ((Bound > 180) && (Bound <= 270))
		xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
	else if ((Bound > 270) && (Bound <= 360))
		xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}

Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight)
{
	pi := 3.14159, TAngle := Angle*(pi/180)
	if !(Width && Height)
		return -1
	RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
	RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}

; RotateNoneFlipNone   = 0
; Rotate90FlipNone     = 1
; Rotate180FlipNone    = 2
; Rotate270FlipNone    = 3
; RotateNoneFlipX      = 4
; Rotate90FlipX        = 5
; Rotate180FlipX       = 6
; Rotate270FlipX       = 7
; RotateNoneFlipY      = Rotate180FlipX
; Rotate90FlipY        = Rotate270FlipX
; Rotate180FlipY       = RotateNoneFlipX
; Rotate270FlipY       = Rotate90FlipX
; RotateNoneFlipXY     = Rotate180FlipNone
; Rotate90FlipXY       = Rotate270FlipNone
; Rotate180FlipXY      = RotateNoneFlipNone
; Rotate270FlipXY      = Rotate90FlipNone 

Gdip_ImageRotateFlip(pBitmap, RotateFlipType=1)
{
	return DllCall("gdiplus\GdipImageRotateFlip", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", RotateFlipType)
}

; Replace = 0
; Intersect = 1
; Union = 2
; Xor = 3
; Exclude = 4
; Complement = 5
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipRect",  A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}

Gdip_SetClipPath(pGraphics, Path, CombineMode=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipSetClipPath", Ptr, pGraphics, Ptr, Path, "int", CombineMode)
}

Gdip_ResetClip(pGraphics)
{
   return DllCall("gdiplus\GdipResetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

Gdip_GetClipRegion(pGraphics)
{
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics, "UInt*", Region)
	return Region
}

Gdip_SetClipRegion(pGraphics, Region, CombineMode=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipSetClipRegion", Ptr, pGraphics, Ptr, Region, "int", CombineMode)
}

Gdip_CreateRegion()
{
	DllCall("gdiplus\GdipCreateRegion", "UInt*", Region)
	return Region
}

Gdip_DeleteRegion(Region)
{
	return DllCall("gdiplus\GdipDeleteRegion", A_PtrSize ? "UPtr" : "UInt", Region)
}

;#####################################################################################
; BitmapLockBits
;#####################################################################################

Gdip_LockBits(pBitmap, x, y, w, h, ByRef Stride, ByRef Scan0, ByRef BitmapData, LockMode = 3, PixelFormat = 0x26200a)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	CreateRect(Rect, x, y, w, h)
	VarSetCapacity(BitmapData, 16+2*(A_PtrSize ? A_PtrSize : 4), 0)
	E := DllCall("Gdiplus\GdipBitmapLockBits", Ptr, pBitmap, Ptr, &Rect, "uint", LockMode, "int", PixelFormat, Ptr, &BitmapData)
	Stride := NumGet(BitmapData, 8, "Int")
	Scan0 := NumGet(BitmapData, 16, Ptr)
	return E
}

;#####################################################################################

Gdip_UnlockBits(pBitmap, ByRef BitmapData)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("Gdiplus\GdipBitmapUnlockBits", Ptr, pBitmap, Ptr, &BitmapData)
}

;#####################################################################################

Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride)
{
	Numput(ARGB, Scan0+0, (x*4)+(y*Stride), "UInt")
}

;#####################################################################################

Gdip_GetLockBitPixel(Scan0, x, y, Stride)
{
	return NumGet(Scan0+0, (x*4)+(y*Stride), "UInt")
}

;#####################################################################################

Gdip_PixelateBitmap(pBitmap, ByRef pBitmapOut, BlockSize)
{
	static PixelateBitmap
	
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (!PixelateBitmap)
	{
		if A_PtrSize != 8 ; x86 machine code
		MCode_PixelateBitmap =
		(LTrim Join
		558BEC83EC3C8B4514538B5D1C99F7FB56578BC88955EC894DD885C90F8E830200008B451099F7FB8365DC008365E000894DC88955F08945E833FF897DD4
		397DE80F8E160100008BCB0FAFCB894DCC33C08945F88945FC89451C8945143BD87E608B45088D50028BC82BCA8BF02BF2418945F48B45E02955F4894DC4
		8D0CB80FAFCB03CA895DD08BD1895DE40FB64416030145140FB60201451C8B45C40FB604100145FC8B45F40FB604020145F883C204FF4DE475D6034D18FF
		4DD075C98B4DCC8B451499F7F98945148B451C99F7F989451C8B45FC99F7F98945FC8B45F899F7F98945F885DB7E648B450C8D50028BC82BCA83C103894D
		C48BC82BCA41894DF48B4DD48945E48B45E02955E48D0C880FAFCB03CA895DD08BD18BF38A45148B7DC48804178A451C8B7DF488028A45FC8804178A45F8
		8B7DE488043A83C2044E75DA034D18FF4DD075CE8B4DCC8B7DD447897DD43B7DE80F8CF2FEFFFF837DF0000F842C01000033C08945F88945FC89451C8945
		148945E43BD87E65837DF0007E578B4DDC034DE48B75E80FAF4D180FAFF38B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945CC0F
		B6440E030145140FB60101451C0FB6440F010145FC8B45F40FB604010145F883C104FF4DCC75D8FF45E4395DE47C9B8B4DF00FAFCB85C9740B8B451499F7
		F9894514EB048365140033F63BCE740B8B451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB
		038975F88975E43BDE7E5A837DF0007E4C8B4DDC034DE48B75E80FAF4D180FAFF38B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955CC8A55
		1488540E038A551C88118A55FC88540F018A55F888140183C104FF4DCC75DFFF45E4395DE47CA68B45180145E0015DDCFF4DC80F8594FDFFFF8B451099F7
		FB8955F08945E885C00F8E450100008B45EC0FAFC38365DC008945D48B45E88945CC33C08945F88945FC89451C8945148945103945EC7E6085DB7E518B4D
		D88B45080FAFCB034D108D50020FAF4D18034DDC8BF08BF88945F403CA2BF22BFA2955F4895DC80FB6440E030145140FB60101451C0FB6440F010145FC8B
		45F40FB604080145F883C104FF4DC875D8FF45108B45103B45EC7CA08B4DD485C9740B8B451499F7F9894514EB048365140033F63BCE740B8B451C99F7F9
		89451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975103975EC7E5585DB7E468B4DD88B450C
		0FAFCB034D108D50020FAF4D18034DDC8BF08BF803CA2BF22BFA2BC2895DC88A551488540E038A551C88118A55FC88540F018A55F888140183C104FF4DC8
		75DFFF45108B45103B45EC7CAB8BC3C1E0020145DCFF4DCC0F85CEFEFFFF8B4DEC33C08945F88945FC89451C8945148945103BC87E6C3945F07E5C8B4DD8
		8B75E80FAFCB034D100FAFF30FAF4D188B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945C80FB6440E030145140FB60101451C0F
		B6440F010145FC8B45F40FB604010145F883C104FF4DC875D833C0FF45108B4DEC394D107C940FAF4DF03BC874068B451499F7F933F68945143BCE740B8B
		451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975083975EC7E63EB0233F639
		75F07E4F8B4DD88B75E80FAFCB034D080FAFF30FAF4D188B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955108A551488540E038A551C8811
		8A55FC88540F018A55F888140883C104FF4D1075DFFF45088B45083B45EC7C9F5F5E33C05BC9C21800
		)
		else ; x64 machine code
		MCode_PixelateBitmap =
		(LTrim Join
		4489442418488954241048894C24085355565741544155415641574883EC28418BC1448B8C24980000004C8BDA99488BD941F7F9448BD0448BFA8954240C
		448994248800000085C00F8E9D020000418BC04533E4458BF299448924244C8954241041F7F933C9898C24980000008BEA89542404448BE889442408EB05
		4C8B5C24784585ED0F8E1A010000458BF1418BFD48897C2418450FAFF14533D233F633ED4533E44533ED4585C97E5B4C63BC2490000000418D040A410FAF
		C148984C8D441802498BD9498BD04D8BD90FB642010FB64AFF4403E80FB60203E90FB64AFE4883C2044403E003F149FFCB75DE4D03C748FFCB75D0488B7C
		24188B8C24980000004C8B5C2478418BC59941F7FE448BE8418BC49941F7FE448BE08BC59941F7FE8BE88BC69941F7FE8BF04585C97E4048639C24900000
		004103CA4D8BC1410FAFC94863C94A8D541902488BCA498BC144886901448821408869FF408871FE4883C10448FFC875E84803D349FFC875DA8B8C249800
		0000488B5C24704C8B5C24784183C20448FFCF48897C24180F850AFFFFFF8B6C2404448B2424448B6C24084C8B74241085ED0F840A01000033FF33DB4533
		DB4533D24533C04585C97E53488B74247085ED7E42438D0C04418BC50FAF8C2490000000410FAFC18D04814863C8488D5431028BCD0FB642014403D00FB6
		024883C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC17CB28BCD410FAFC985C9740A418BC299F7F98BF0EB0233F685C9740B418BC3
		99F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585C97E4D4C8B74247885ED7E3841
		8D0C14418BC50FAF8C2490000000410FAFC18D04814863C84A8D4431028BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2413BD17CBD
		4C8B7424108B8C2498000000038C2490000000488B5C24704503E149FFCE44892424898C24980000004C897424100F859EFDFFFF448B7C240C448B842480
		000000418BC09941F7F98BE8448BEA89942498000000896C240C85C00F8E3B010000448BAC2488000000418BCF448BF5410FAFC9898C248000000033FF33
		ED33F64533DB4533D24533C04585FF7E524585C97E40418BC5410FAFC14103C00FAF84249000000003C74898488D541802498BD90FB642014403D00FB602
		4883C2044403D80FB642FB03F00FB642FA03E848FFCB75DE488B5C247041FFC0453BC77CAE85C9740B418BC299F7F9448BE0EB034533E485C9740A418BC3
		99F7F98BD8EB0233DB85C9740A8BC699F7F9448BD8EB034533DB85C9740A8BC599F7F9448BD0EB034533D24533C04585FF7E4E488B4C24784585C97E3541
		8BC5410FAFC14103C00FAF84249000000003C74898488D540802498BC144886201881A44885AFF448852FE4883C20448FFC875E941FFC0453BC77CBE8B8C
		2480000000488B5C2470418BC1C1E00203F849FFCE0F85ECFEFFFF448BAC24980000008B6C240C448BA4248800000033FF33DB4533DB4533D24533C04585
		FF7E5A488B7424704585ED7E48418BCC8BC5410FAFC94103C80FAF8C2490000000410FAFC18D04814863C8488D543102418BCD0FB642014403D00FB60248
		83C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC77CAB418BCF410FAFCD85C9740A418BC299F7F98BF0EB0233F685C9740B418BC399
		F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585FF7E4E4585ED7E42418BCC8BC541
		0FAFC903CA0FAF8C2490000000410FAFC18D04814863C8488B442478488D440102418BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2
		413BD77CB233C04883C428415F415E415D415C5F5E5D5BC3
		)
		
		VarSetCapacity(PixelateBitmap, StrLen(MCode_PixelateBitmap)//2)
		Loop % StrLen(MCode_PixelateBitmap)//2		;%
			NumPut("0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1, "UChar")
		DllCall("VirtualProtect", Ptr, &PixelateBitmap, Ptr, VarSetCapacity(PixelateBitmap), "uint", 0x40, A_PtrSize ? "UPtr*" : "UInt*", 0)
	}

	Gdip_GetImageDimensions(pBitmap, Width, Height)
	
	if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
		return -1
	if (BlockSize > Width || BlockSize > Height)
		return -2

	E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
	E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
	if (E1 || E2)
		return -3

	E := DllCall(&PixelateBitmap, Ptr, Scan01, Ptr, Scan02, "int", Width, "int", Height, "int", Stride1, "int", BlockSize)
	
	Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
	return 0
}

;#####################################################################################

Gdip_ToARGB(A, R, G, B)
{
	return (A << 24) | (R << 16) | (G << 8) | B
}

;#####################################################################################

Gdip_FromARGB(ARGB, ByRef A, ByRef R, ByRef G, ByRef B)
{
	A := (0xff000000 & ARGB) >> 24
	R := (0x00ff0000 & ARGB) >> 16
	G := (0x0000ff00 & ARGB) >> 8
	B := 0x000000ff & ARGB
}

;#####################################################################################

Gdip_AFromARGB(ARGB)
{
	return (0xff000000 & ARGB) >> 24
}

;#####################################################################################

Gdip_RFromARGB(ARGB)
{
	return (0x00ff0000 & ARGB) >> 16
}

;#####################################################################################

Gdip_GFromARGB(ARGB)
{
	return (0x0000ff00 & ARGB) >> 8
}

;#####################################################################################

Gdip_BFromARGB(ARGB)
{
	return 0x000000ff & ARGB
}

;#####################################################################################

StrGetB(Address, Length=-1, Encoding=0)
{
	; Flexible parameter handling:
	if Length is not integer
	Encoding := Length,  Length := -1

	; Check for obvious errors.
	if (Address+0 < 1024)
		return

	; Ensure 'Encoding' contains a numeric identifier.
	if Encoding = UTF-16
		Encoding = 1200
	else if Encoding = UTF-8
		Encoding = 65001
	else if SubStr(Encoding,1,2)="CP"
		Encoding := SubStr(Encoding,3)

	if !Encoding ; "" or 0
	{
		; No conversion necessary, but we might not want the whole string.
		if (Length == -1)
			Length := DllCall("lstrlen", "uint", Address)
		VarSetCapacity(String, Length)
		DllCall("lstrcpyn", "str", String, "uint", Address, "int", Length + 1)
	}
	else if Encoding = 1200 ; UTF-16
	{
		char_count := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "uint", 0, "uint", 0, "uint", 0, "uint", 0)
		VarSetCapacity(String, char_count)
		DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "str", String, "int", char_count, "uint", 0, "uint", 0)
	}
	else if Encoding is integer
	{
		; Convert from target encoding to UTF-16 then to the active code page.
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", 0, "int", 0)
		VarSetCapacity(String, char_count * 2)
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", &String, "int", char_count * 2)
		String := StrGetB(&String, char_count, 1200)
	}
	
	return String
}

Return


;============================================
; Gdip_RotateBitmap() by Learning One (Requires GDIP)
;============================================

;https://autohotkey.com/board/topic/86978-rotate-gui-picture/
Gdip_RotateBitmap(pBitmap, Angle, Dispose=0) 
{ ; returns rotated bitmap. By Learning one.
	Gdip_GetImageDimensions(pBitmap, Width, Height)
	Gdip_GetRotatedDimensions(Width, Height, Angle, RWidth, RHeight)
	Gdip_GetRotatedTranslation(Width, Height, Angle, xTranslation, yTranslation)

	pBitmap2 := Gdip_CreateBitmap(RWidth, RHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2), Gdip_SetSmoothingMode(G2, 4), Gdip_SetInterpolationMode(G2, 7)
	Gdip_TranslateWorldTransform(G2, xTranslation, yTranslation)
	Gdip_RotateWorldTransform(G2, Angle)
	Gdip_DrawImage(G2, pBitmap, 0, 0, Width, Height)

	Gdip_ResetWorldTransform(G2)
	Gdip_DeleteGraphics(G2)
	if Dispose
	{
		Gdip_DisposeImage(pBitmap)
	}
	return pBitmap2
} ; http://www.autohotkey.com/community/viewtopic.php?p=477333#p477333