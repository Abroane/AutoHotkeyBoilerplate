loadItems(csv)
{
	arr:={}
	loop, parse, csv, `n, `r
	{
		if (A_LoopField="" || subStr(trim(A_LoopField), 1, 1)=";")
			continue
		loop, parse, A_LoopField, CSV
		{
			lf:=A_LoopField
			if (A_Index=1)
				name:=trim(lf)
			else if (A_Index=2 || A_Index=3 || A_Index=4)
				arr[name, "stat", A_Index-1]:=trim(lf)
			else if (A_Index=5)
				arr[name, "qty"]:=trim(lf)
			else if (A_Index=6)
				arr[name, "type"]:=(lf="!") ? 1 ; weapons
				: (lf="@") ? 2 ; armors
				: (lf="#") ? 3 ; foods
				: (lf="%") ? 4 ; animals
				: 5 ; $ misc
		}
	}
	return arr
}

loadEnemies(csv)
{
	arr:={}
	loop, parse, csv, `n, `r
	{
		if (A_LoopField="" || subStr(trim(A_LoopField), 1, 1)=";")
			continue
		loop, parse, A_LoopField, CSV
		{
			lf:=trim(A_LoopField)
			if (A_Index=1)
				name:=lf
			else if (A_Index=2)
				arr[name, "level"]:=lf
			else if (A_Index=3)
				arr[name, "hp"]:=strSplit(lf, "|")
			else if (A_Index=4)
				arr[name, "dmg"]:=strSplit(lf, "|")
			else if (A_Index=5)
				arr[name, "w"]:=["",0]
			else if (A_Index=6)
				arr[name, "a"]:=["",0]
		}
	}
	return arr
}

save(mode=1) ; 1 = auto file, 2 = manual, 3 = export log, 4 = temp file
{
	global isFight, autoLoadFile, autoLoadFileL
	global steps, zone, day, dirToMove, inEvent
	
	if (isFight)
	{
		msgBox, 16, You have tried the forbidden, You are not allowed to save while fighting, bad things happen.
		return
	}
	player.settings.steps:=steps
	player.settings.zone:=zone
	player.settings.day:=day
	player.settings.dtm:=dirToMove
	player.settings.inEvent:=inEvent
	
	if (mode=1) ; auto
	{
		if (FileExist(autoLoadFile))
		{
			msgBox, 52, Overwrite?, % "Overwrite the exisiting AutoLoad files with this session?"
			. "`nPlayer: " player.name "`nLevel: " player.level "`nDay: " day
			ifMsgBox, no
				return
		}
		toSave:=autoLoadFile
		toSaveL:=autoLoadFileL
	}
	if (mode=2 || mode=3) ; manual/export
	{
		fileSelectFile, toSave, s16,, Save your current %_name_% settion as what?, *.json
			if (errorLevel=1)
				return
		splitPath, toSave,, ofd, ofe, ofn
			if (trim(ofn)="")
				return
		if (ofe!="json")
			toSave:=ofd "\" ofn ".json"
			, toSaveL:=ofd "\" ofn "-Log.html"
	}

	if (mode=1 || mode=2) ; auto/manual
	{
		; get the existing stuff and join it
		; fileRead, ttt, %toSaveL%
		fileRead, ttt, %A_ScriptDir%\tmp\session-tmp.html
		ttt.="`n" st_glue(dispLog,, "`n") "`n"
		; delete old stuff
		if (FileExist(toSave))
			fileDelete, %toSave%
		if (FileExist(toSaveL))
			fileDelete, %toSaveL%
		; save new stuff
		fileAppend, % json.dump(player), %toSave%
		fileAppend, % "`n" ttt, %toSaveL%
		; dispLog:=[] ; reset it, we don't need the old junk
	}
	
	if (mode=3) ; export
	{
		
	}
	
	if (mode=4) ; temp file
	{
		fileAppend, % st_glue(dispLog,, "`n") "`n", %A_ScriptDir%\tmp\session-tmp.html
		soundPlay, *-1
	}
}
