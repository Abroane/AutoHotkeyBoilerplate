/* =======================================================================================================================
	Written By: Hellbent
	Youtube: https://www.youtube.com/user/CivReborn
	Date Started: May 15th, 2018
	Date Of Last Edit: May 15th, 2018
	Last PasteBin Save: https://pastebin.com/WdQ0UWY0
	Description:
		Recreation of the game 2048.
		Use arrow keys to move tiles around. Goal: Slide tiles of the same value together to form new tiles of a higher value.
		Game ends when there is no free spaces/moves.
*/ ;======================================================================================================================

#SingleInstance,Force
IfNotExist,%A_ScriptDir%/2048 Assets
	Create_Game_Assets()
SetWorkingDir,%A_ScriptDir%/2048 Assets
global row_col_Positions:={1:36,2:121,3:206,4:291},WB,score_x:=400,Grid_Array:=[],Tiles:={},Can_Move:=1,Value_Array:=[],Game_Active:=0,High_Scores:="" ,My_Score:=0,Scores:=[],Names:=[]
FileRead,temp_score,Scores.txt
Loop, Parse,temp_Score,*
	Scores[A_Index]:=A_LoopField
i:=1
Loop 3
	{
		tempp:=StrSplit(Scores[A_Index]," ")
		Loop,% tempp.Length()-1
			Names[i].=tempp[A_Index]
		Scores[A_Index]:=tempp[tempp.MaxIndex()],i++
	}
game:=New Game_Board()
return
GuiClose:
GuiEscape:
*^ESC::
	ExitApp
Move_Window:
	PostMessage,0xA1,2
	return
Min_Window:	
	Gui,1:Minimize
	return
Tag:
	Try	{
	 Run,https://www.youtube.com/user/CivReborn
	}
	return
New_Game:
	My_Score:=0,Game_Active:=1
	GuiControl,1:,My_Score,% My_Score
	Remove_Bot()
	game.Build_Grid()
	Loop 2
		Tiles[Tiles.Length()+1]:=New Game_Tile()
	return
Score_Scroll:
	if(score_x<0-posw)
		score_x:=396
	score_x--
	GuiControl,3:Move,ss,x%Score_X%
	return
#IfWinActive, 2048
~up::
	if(!Key_Pressed)
		{
			key_Pressed:=1
			SetTimer,Score_Scroll,Off
			Move_Tiles(3,4,2,1,1,1,-1,0,-1,0,1)
			Check_Game_State()
			SetTimer,Score_Scroll,On
			While(GetKeyState("Up"))
				sleep,10
			key_Pressed:=0
		}
	return
~Down::
	if(!Key_Pressed)
		{
			key_Pressed:=1
			SetTimer,Score_Scroll,Off
			Move_Tiles(3,4,3,1,-1,1,1,0,1,0,3)
			Check_Game_State()
			SetTimer,Score_Scroll,On
			While(GetKeyState("Down"))
				sleep,10
			key_Pressed:=0
		}
	return
~Left::
	if(!Key_Pressed)
		{
			key_Pressed:=1
			SetTimer,Score_Scroll,Off
			Move_Tiles(4,3,1,2,1,1,0,-1,0,-1,4)
			Check_Game_State()
			SetTimer,Score_Scroll,On
			While(GetKeyState("Left"))
				sleep,10
			key_Pressed:=0
		}
	return
~Right::
	if(!Key_Pressed)
		{
			key_Pressed:=1
			SetTimer,Score_Scroll,Off
			Move_Tiles(4,3,1,3,1,-1,0,1,0,1,2) 
			Check_Game_State()
			SetTimer,Score_Scroll,On
			While(GetKeyState("Right"))
				sleep,10
			key_Pressed:=0
		}
	return	
#If
Check_Game_State()
	{
		if(Game_Active=1)
			{
				i:=1
				loop 4
					{
						j:=1
						Loop 4
							{
								if(Grid_Array[i,j]=0)
									return
								j++
							}
						i++
					}
				k:=1
				Loop,% Tiles.Length()
					{
						i:=1	
						Loop, 4
							{
								j:=1
								Loop, 4
									{
										if(Tiles[k].Y=i&&Tiles[k].X=j)
											{
												Value_Array[i,j]:=Tiles[k].Value
											}
										j++	
									}
								i++	
							}
						k++	
					}
				i:=1	
				Loop 4	
					{
						j:=1
						Loop 4
							{
								if(Value_Array[i,j]=Value_Array[i-1,j]||Value_Array[i,j]=Value_Array[i+1,j]||Value_Array[i,j]=Value_Array[i,j-1]||Value_Array[i,j]=Value_Array[i,j+1])
									{
										return
									}
								j++	
							}
						i++	
					}
				Game_Over()
			}		
	}
Game_Over()
	{
		Game_Active:=0,New_Score:=0
		Remove_Bot()
		loop 3
			{
				if(My_Score>Scores[A_Index])
					{
						Gui,1:+OwnDialogs
						InputBox,name,New High Score,Enter Your Name
						New_Score:=1
						break
					}
			}
		if(New_Score=1)
			{
				if(My_Score>Scores[1])
					Scores[3]:=Scores[2],Names[3]:=Names[2],Scores[2]:=Scores[1],Names[2]:=Names[1],Scores[1]:=My_Score,Names[1]:=Name
				else if(My_Score>Scores[2])
					Scores[3]:=Scores[2],Names[3]:=Names[2],Scores[2]:=My_Score,Names[2]:=Name
				else if(My_Score>Scores[3])
					Scores[3]:=My_Score,Names[3]:=Name
				FileSetAttrib, -RH,scores.txt
				FileDelete,%A_ScriptDir%/2048 Assets/scores.txt
				FileAppend,% Names[1] " " Scores[1] "*" Names[2] " " Scores[2] "*" Names[3] " " Scores[3] "*",%A_ScriptDir%/2048 Assets/scores.txt
				FileSetAttrib, +RH,%A_ScriptDir%/2048 Assets/scores.txt         
				GuiControl,3:,ss,% "1: " Names[1] " " Scores[1] "          2: " Names[2] " " Scores[2] "          3: " Names[3] " " Scores[3] "          "
			}
		else
			{
				Gui,1:+OwnDialogs
				MsgBox,Game Over
			}
	}
Merge(new_pos,old_pos)
	{
		global
		Tiles[new_Pos].Value *= 2,My_Score+=Tiles[new_Pos].Value
		GuiControl,1:,My_Score,% My_Score
		Tiles[new_Pos].Has_Merged:=1,Grid_Array[Tiles[old_pos].Y,Tiles[old_pos].X]:=0,img:=Tiles[old_pos].img
		img.ParentNode.RemoveChild(img)
		Tiles.RemoveAt(old_pos)
		Loop,% Tiles.Length()
			Tiles[A_Index].img.src:=A_WorkingDir "\" Tiles[A_Index].Value ".png"
	}
Remove_Bot()
	{
		n:=Tiles.Length()
		Loop, % Tiles.length()+1
			{
				img:=Tiles[n].img
				img.ParentNode.RemoveChild(img)
				Tiles.RemoveAt(n)
				n--
			}	
	}
Move_Tiles(i_Loop,j_Loop,i_Start,j_Start,i_Count,j_Count,i_Array,j_Array,y_Add,x_Add,Dir)
	{
		if(Can_Move=1)
		{
			Something_Moved:=0
			Can_Move:=0
			Loop, % Tiles.Length()
				Tiles[A_Index].Has_Merged:=0
			redo:		
			i:=i_Start
			Loop % i_Loop
				{
					j:=j_Start
					Loop % j_Loop
						{
							Loop,% Tiles.Length()
								{
									if(Tiles[A_Index].Y=i&&Tiles[A_Index].X=j)
										{
											if(Grid_Array[i+i_Array,j+j_Array]=0)
												Tiles[A_Index].Is_Moving:=1,Tiles[A_Index].X+=x_Add,Tiles[A_Index].Y+=y_Add,Grid_Array[i+i_Array,j+j_Array]:=1,Grid_Array[i,j]:=0,Something_Moved:=1
											else if(Grid_Array[i+i_Array,j+j_Array]=1&&Tiles[A_Index].Is_Moving=0)
												{
													k:=A_Index
													Loop,% Tiles.Length()
														{
															if(Tiles[A_Index].Y=i+i_Array&&Tiles[A_Index].X=j+j_Array&&Tiles[A_Index].Is_Moving=0&&Tiles[A_Index].Value=Tiles[k].Value&&Tiles[A_index].Has_Merged=0&&Tiles[k].Has_Merged=0)
																{
																	Merge(A_Index,k)
																	Something_Moved:=1
																}
														}
												}
										}
								}
							j+=j_Count	
						}
					i+=i_Count	
					
				}
		m:=0
		Loop,% Tiles.Length()
			{
				if(Tiles[A_Index].Is_Moving=1)
						m++
			}
		if(m>0)
			{
				Loop 17
					{
						Loop, % Tiles.Length()
							{
								if(Dir=1)
									{
										if(Tiles[A_Index].Is_Moving=1&&Tiles[A_Index].ry>row_col_Positions[Tiles[A_Index].Y])
											Tiles[A_Index].ry-=5,Style:=Tiles[A_Index].img.Style,Style.Top:=Tiles[A_Index].ry
										else if(Tiles[A_Index].Is_Moving:=1&&Tiles[A_Index].ry<=row_col_Positions[Tiles[A_Index].Y])
											Tiles[A_Index].Is_Moving:=0,Tiles[A_Index].ry:=row_col_Positions[Tiles[A_Index].Y],Style:=Tiles[A_Index].img.Style,Style.Top:=Tiles[A_Index].ry
									}
								else if(Dir=2)
									{
										if(Tiles[A_Index].Is_Moving=1&&Tiles[A_Index].rx>row_col_Positions[Tiles[A_Index].X])
											Tiles[A_Index].rx+=5,Style:=Tiles[A_Index].img.Style,Style.Left:=Tiles[A_Index].rx
										else if(Tiles[A_Index].Is_Moving:=1&&Tiles[A_Index].rx<=row_col_Positions[Tiles[A_Index].X])
											Tiles[A_Index].Is_Moving:=0,Tiles[A_Index].rx:=row_col_Positions[Tiles[A_Index].X],Style:=Tiles[A_Index].img.Style,Style.Left:=Tiles[A_Index].rx
										else
											Tiles[A_Index].Is_Moving:=0
									}
								else if(Dir=3)
									{
										if(Tiles[A_Index].Is_Moving=1&&Tiles[A_Index].ry<row_col_Positions[Tiles[A_Index].Y])
											Tiles[A_Index].ry+=15,Style:=Tiles[A_Index].img.Style,Style.Top:=Tiles[A_Index].ry
										else if(Tiles[A_Index].Is_Moving:=1&&Tiles[A_Index].ry>=row_col_Positions[Tiles[A_Index].Y])
											Tiles[A_Index].Is_Moving:=0,Tiles[A_Index].ry:=row_col_Positions[Tiles[A_Index].Y],Style:=Tiles[A_Index].img.Style,Style.Top:=Tiles[A_Index].ry
										else
											Tiles[A_Index].Is_Moving:=0	
									}
								else if(Dir=4)
									{
										if(Tiles[A_Index].Is_Moving=1&&Tiles[A_Index].rx>row_col_Positions[Tiles[A_Index].X])
											Tiles[A_Index].rx-=5,Style:=Tiles[A_Index].img.Style,Style.Left:=Tiles[A_Index].rx
										else if(Tiles[A_Index].Is_Moving:=1&&Tiles[A_Index].rx<=row_col_Positions[Tiles[A_Index].X])
											Tiles[A_Index].Is_Moving:=0,Tiles[A_Index].rx:=row_col_Positions[Tiles[A_Index].X],Style:=Tiles[A_Index].img.Style,Style.Left:=Tiles[A_Index].rx
										else
											Tiles[A_Index].Is_Moving:=0
									}
								
							}
							
					}
				goto, redo
			}
			
			While(GetKeyState("Down"))
					Sleep,10
			Can_Move:=1		
			if(Something_Moved=1)
				Tiles[Tiles.Length()+1]:=New Game_Tile()
		}
	}
	
Class Game_Tile
	{
		__New()
			{
				i:=1,free:=0
				Loop 4
					{
						j:=1
						Loop 4
							{
								if(Grid_Array[i,j]=0)
									{
										free:=1
										break
									}
								j++
							}
						i++	
					}
				if(!free)
					{
						MsgBox, 262144, ,Game Over
						game:=New Game_Board()
					}
				else 
					{
						Loop 
							{
								Random,tx,1,4
								Random,ty,1,4
								Random,value,1,10
								if(value<7)
									This.Value:=2
								else
									This.Value:=4
								if(Grid_Array[ty,tx]=0)
									{
										This.X:=tx,This.Y:=ty,Grid_Array[ty,tx]:=1
										break
									}
							}
						This.Has_Merged:=0,This.Is_Moving:=0
						This.Draw_Tile()
					}
			}
		Draw_Tile()
			{
				
				tx:=row_col_Positions[This.X],ty:=row_col_Positions[This.Y],This.rx:=tx,This.ry:=ty
				img:=WB.CreateElement("img"),This.img:=img,img.src:=A_WorkingDir "\" This.Value ".png",Style:=img.Style
				for a,b in {Left:tx,top:ty,position:"absolute",width:75,height:75}
				Style[a]:=b
				WB.Body.AppendChild(This.img)
			}
		
	}

Class Game_Board
	{
		__New()
			{
				global
				Remove_Bot()
				score_x:=396,Can_Move:=1,Game_Active:=1
				Gui,1:Destroy
				Gui,1:+AlwaysOnTop -Caption Border
				Gui,1:Color,111111
				Gui,1:Add,Picture,x8 y8 w30 h30 gTag,Tag.png
				Gui,1:Font,c004B76 s24 Underline Q4, Segoe UI Black
				Gui,1:Add,Text,cWhite center x82 y-2 w250 BackgroundTrans,2048
				Gui,1:Add,Text, center x81 y-3 w250 BackgroundTrans gMove_Window,2048
				Gui,1:Font,
				Gui,1:Font,c004B76 s22 Q4, Segoe UI Black
				Gui,1:Add,Text,cWhite x346 y-3 w20 r1 Center BackgroundTrans,-
				Gui,1:Add,Text, x345 y-4 w20 r1 Center BackgroundTrans gMin_Window,-
				Gui,1:Add,Text,cWhite x371 y-3 w23 r1 Center BackgroundTrans,x
				Gui,1:Add,Text, x370 y-4 w23 r1 Center BackgroundTrans gGuiClose,x
				Gui,1:Font,
				Gui,1:Font,c004B76 s16 Q4, Segoe UI Black
				Gui,1:Add,Picture, x48 y50 w2 h42,border.png
				Gui,1:Add,Picture, x50 y52 w2 h38,border2.png
				Gui,1:Add,Picture, x350 y50 w2 h42,border.png
				Gui,1:Add,Picture, x348 y52 w2 h38,border2.png
				Gui,1:Add,Picture, x50 y50 w300 ,border.png
				Gui,1:Add,Picture, x52 y52 w296 ,border2.png
				Gui,1:Add,Picture, x50 y90 w300 ,border.png
				Gui,1:Add,Picture, x52 y88 w296 ,border2.png
				Gui,1:Add,Text, x-1400 y-1170  Center BackgroundTrans vgw,% "1: " Names[1] " " Scores[1] "          2: " Names[2] " " Scores[2] "          3: " Names[3] " " Scores[3] "          "
				GuiControlGet,pos,1:pos,gw
				Gui,1:Add,Text,cWhite x30 y95 w65 r1 BackgroundTrans,Score:
				Gui,1:Add,Text,x29 y94 w65 r1 BackgroundTrans,Score:
				Gui,1:Add,Text,cWhite x+10 y95 w100 r1 BackgroundTrans vMy_Score,% My_Score
				Gui,1:Add,Picture,x0 y0 w400 h2,Border.png
				Gui,1:Add,Picture,x2 y2 w400 h2,Border2.png
				Gui,1:Add,Picture,x0 y0 w2 h560,Border.png
				Gui,1:Add,Picture,x2 y2 w2 h556,Border2.png
				Gui,1:Add,Picture,x398 y0 w2 h560,Border.png
				Gui,1:Add,Picture,x396 y2 w2 h556,Border2.png
				Gui,1:Add,Picture,x0 y558 w400 h2,Border.png
				Gui,1:Add,Picture,x2 y556 w396 h2,Border2.png
				Gui,1:Add,Picture,x125 y500 w150 h40 gNew_Game,New Game.png
				Gui,3:+Parent1 -caption
				Gui,3:Color,111111
				Gui,3:Font,c004B76 s16 Q4, Segoe UI Black
				Gui,3:Add,Text,cffffff x%score_x% y0 w%posw% r1 BackgroundTrans vss,% "1: " Names[1] " " Scores[1] "          2: " Names[2] " " Scores[2] "          3: " Names[3] " " Scores[3] "          "
				Gui,2:+parent1 -Caption +LastFound +AlwaysOnTop
				Gui,2:Add,ActiveX,x0 y0 w400 h400 vWB,MSHTML:
				WB.Body.Style.Position:="Absolute"
				Style:=WB.Body.Style
				for k,v in {margin:"0px"}
					Style[k]:=v
				WB.Body.Style.BackgroundColor:="#111111"
				img:=WB.CreateElement("img")
				This.img:=img
				img.src:=A_WorkingDir "\Background.png"
				Style:=img.Style
				for a,b in {Left:25,top:25,position:"absolute",width:350,height:350}
				Style[a]:=b
				WB.Body.AppendChild(This.img)
				sleep,300
				Gui,1:Show,w400 h560,2048
				Gui,2:Show,x0 y110 w400 h400
				Gui,3:Show,x52 y55 w298
				SetTimer,Score_Scroll,30	
				This.Build_Grid()
				Loop 2
					Tiles[Tiles.Length()+1]:=New Game_Tile()
			}
		Build_Grid()
			{
				i:=1
				Loop 4
					{
						j:=1
						Loop 4
							{
								Grid_Array[i,j]:=0,j++
							}
						i++	
					}
			}
	}
Create_Game_Assets()
	{
		FileCreateDir,%A_ScriptDir%/2048 Assets
		SetWorkingDir,%A_ScriptDir%/2048 Assets
		FileSetAttrib, -RH,scores.txt
		FileDelete,%A_ScriptDir%/2048 Assets/scores.txt
		FileAppend,Hellbent 5555*CivReborn 2000*HB 1000,%A_ScriptDir%/2048 Assets/scores.txt
		FileSetAttrib, +RH,%A_ScriptDir%/2048 Assets/scores.txt
		If !pToken := Gdip_Startup()
			{
				MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
				ExitApp
			}
		Colours:= ["0xffFF6A00","0xff108Bb6","0xffB6FF00","0xff00FF21","0xff9bFFb0","0xffaaa4FF","0xff0026FF","0xff4800FF","0xffFF00DC","0xff7F0037","0xff007F7F","0xFF3388aa","0xFFaa5509"]
		Text_:=[2,4,8,16,32,64,128,256,512,1024,2048,4096,8192],Font_Size:=[48,48,48,38,38,38,28,28,28,22,22,22,22],y_Pos1:=[4,4,4,12,12,12,20,20,20,24,24,24,24],y_Pos2:=[2,2,2,10,10,10,18,18,18,22,22,22,22]
		Loop 13
			{
				pBitmap := Gdip_CreateBitmap(75,75),G := Gdip_GraphicsFromImage(pBitmap)
				Gdip_SetSmoothingMode(G, 1)
				pBrush := Gdip_BrushCreateSolid(Colours[A_Index])
				Gdip_FillRectangle(G, pBrush, 1,1 , 75, 75)
				Gdip_DeleteBrush(pBrush)
				pPen := Gdip_CreatePen(0xffffffff, 2)
				Gdip_DrawRectangle(G, pPen, 1, 1, 73, 73)
				Gdip_DeleteBrush(pPen)
				pPen := Gdip_CreatePen(0xff000000, 2)
				Gdip_DrawRectangle(G, pPen, 3, 3, 69, 69)
				Gdip_DeleteBrush(pPen)
				Font = Segoe UI Black
				If !Gdip_FontFamilyCreate(Font)
					{
					  ; MsgBox, 48, Font error!, The font you have specified does not exist on the system
					  ; ExitApp
					  Font = Arial
					}	
				Options =% "x4 y" y_Pos1[A_Index]  "cffffffff Center s" Font_Size[A_Index] 
				Gdip_TextToGraphics(G, Text_[A_Index], Options, Font, 75, 75)	
				Options =% "x1 y" y_Pos2[A_Index]  "cff000000  Center s" Font_Size[A_Index]  
				Gdip_TextToGraphics(G, Text_[A_Index], Options, Font, 75, 75)	
				Gdip_SaveBitmapToFile(pBitmap,Text_[A_Index] ".png")
				Gdip_DisposeImage(pBitmap)	
			}
		pBitmap := Gdip_CreateBitmap(350,350),G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_SetSmoothingMode(G, 1)
		pBrush := Gdip_BrushCreateSolid("0xFF004B76")
		Gdip_FillRectangle(G, pBrush, 1,1 , 350, 350)
		Gdip_DeleteBrush(pBrush)
		pBrush := Gdip_BrushCreateSolid("0xFF222222")
		Gdip_FillRectangle(G, pBrush, 11,11 , 329, 329)
		Gdip_DeleteBrush(pBrush)
		pBrush := Gdip_BrushCreateSolid("0xFF004B76"),x:=86
		Loop 3
			{
				Gdip_FillRectangle(G, pBrush,x,11 ,10, 340)
				x+=85
			}
		y:=86
		Loop 3
			{
				Gdip_FillRectangle(G, pBrush,11,y ,340, 10)
				y+=85	
			}
		Gdip_DeleteBrush(pBrush)
		pPen := Gdip_CreatePen(0xffffffff, 2)
		Gdip_DrawRectangle(G, pPen, 1, 1, 348, 348)
		Gdip_DeleteBrush(pPen)
		Gdip_SaveBitmapToFile(pBitmap,"Background.png")
		Gdip_DisposeImage(pBitmap)	
		pBitmap := Gdip_CreateBitmap(30,30)
		G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_SetSmoothingMode(G, 1)
		pBrush := Gdip_BrushCreateSolid("0xff004B76") 
		Gdip_FillRectangle(G, pBrush, 0,0 , 30, 30)
		Gdip_DeleteBrush(pBrush)
		pPen := Gdip_CreatePen(0xffffffff, 2)
		Gdip_DrawRectangle(G, pPen, 1, 1, 28, 28)
		Gdip_DeleteBrush(pPen)
		Font = Segoe UI Black
		If !Gdip_FontFamilyCreate(Font)
		{
		      ; MsgBox, 48, Font error!, The font you have specified does not exist on the system
		      ; ExitApp
		      Font = Arial
		}	
		Options =x1 y6  cff000000 Center s14 
		Gdip_TextToGraphics(G, "HB", Options, Font, 30, 30)	
		Options =x0 y5  cffffffff Center s14 
		Gdip_TextToGraphics(G, "HB", Options, Font, 30, 30)	
		Gdip_SaveBitmapToFile(pBitmap,"Tag.png")
		Gdip_DisposeImage(pBitmap)	
		pBitmap := Gdip_CreateBitmap(150,40)
		G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_SetSmoothingMode(G, 1)
		pBrush := Gdip_BrushCreateSolid("0xFF333333")
		Gdip_FillRectangle(G, pBrush, 0,0 , 150, 40)
		Gdip_DeleteBrush(pBrush)
		pPen := Gdip_CreatePen(0xffffffff, 2)
		Gdip_DrawRectangle(G, pPen, 1, 1, 148, 38)
		Gdip_DeleteBrush(pPen)
		Font = Segoe UI Black
		If !Gdip_FontFamilyCreate(Font)
		{
		      ; MsgBox, 48, Font error!, The font you have specified does not exist on the system
		      ; ExitApp
		      Font = Arial
		}	
		Options =x0 y4  cffffffff Center s24
		Gdip_TextToGraphics(G, "New Game", Options, Font, 150, 40)	
		Options =x-1 y3  cff004B76 Center s24
		Gdip_TextToGraphics(G, "New Game", Options, Font, 150, 40)	
		Gdip_SaveBitmapToFile(pBitmap,"New Game.png")
		Gdip_DisposeImage(pBitmap)	
		pBitmap := Gdip_CreateBitmap(2,2)
		G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_SetSmoothingMode(G, 1)
		pBrush := Gdip_BrushCreateSolid("0xFF004B76")
		Gdip_FillRectangle(G, pBrush, 0,0 , 2,2)
		Gdip_DeleteBrush(pBrush)
		Gdip_SaveBitmapToFile(pBitmap,"border.png")
		Gdip_DisposeImage(pBitmap)	
		pBitmap := Gdip_CreateBitmap(2,2)
		G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_SetSmoothingMode(G, 1)
		pBrush := Gdip_BrushCreateSolid("0xFFFaFaFa")
		Gdip_FillRectangle(G, pBrush, 0,0 , 2,2)
		Gdip_DeleteBrush(pBrush)
		Gdip_SaveBitmapToFile(pBitmap,"border2.png")
		Gdip_DisposeImage(pBitmap)	
		Gdip_Shutdown(pToken)
	}
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
Gdip_CreateBitmap(Width, Height, Format=0x26200A)
	{
		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, A_PtrSize ? "UPtr" : "UInt", 0, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
		Return pBitmap
	}
Gdip_GraphicsFromImage(pBitmap)
	{
		DllCall("gdiplus\GdipGetImageGraphicsContext", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
		return pGraphics
	}
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
	{
	   return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
	}
Gdip_BrushCreateSolid(ARGB=0xff000000)
	{
		DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
		return pBrush
	}
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
Gdip_DeleteBrush(pBrush)
	{
	   return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
	}
Gdip_CreatePen(ARGB, w)
	{
	   DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
	   return pPen
	}
Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		return DllCall("gdiplus\GdipDrawRectangle", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
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
Gdip_DisposeImage(pBitmap)
	{
	   return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
	}	
Gdip_CloneBrush(pBrush)
	{
		DllCall("gdiplus\GdipCloneBrush", A_PtrSize ? "UPtr" : "UInt", pBrush, A_PtrSize ? "UPtr*" : "UInt*", pBrushClone)
		return pBrushClone
	}	
Gdip_FontCreate(hFamily, Size, Style=0)
	{
	   DllCall("gdiplus\GdipCreateFont", A_PtrSize ? "UPtr" : "UInt", hFamily, "float", Size, "int", Style, "int", 0, A_PtrSize ? "UPtr*" : "UInt*", hFont)
	   return hFont
	}	
Gdip_StringFormatCreate(Format=0, Lang=0)
	{
	   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, A_PtrSize ? "UPtr*" : "UInt*", hFormat)
	   return hFormat
	}	
CreateRectF(ByRef RectF, x, y, w, h)
	{
	   VarSetCapacity(RectF, 16)
	   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
	}	
Gdip_SetStringFormatAlign(hFormat, Align)
	{
	   return DllCall("gdiplus\GdipSetStringFormatAlign", A_PtrSize ? "UPtr" : "UInt", hFormat, "int", Align)
	}	
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
	{
		return DllCall("gdiplus\GdipSetTextRenderingHint", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", RenderingHint)
	}	
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
Gdip_DeleteStringFormat(hFormat)
	{
	   return DllCall("gdiplus\GdipDeleteStringFormat", A_PtrSize ? "UPtr" : "UInt", hFormat)
	}	
Gdip_DeleteFont(hFont)
	{
	   return DllCall("gdiplus\GdipDeleteFont", A_PtrSize ? "UPtr" : "UInt", hFont)
	}	
Gdip_DeleteFontFamily(hFamily)
	{
	   return DllCall("gdiplus\GdipDeleteFontFamily", A_PtrSize ? "UPtr" : "UInt", hFamily)
	}