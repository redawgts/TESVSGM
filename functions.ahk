;functions

;-------------------
doScanForSavegameNames( in_strSavegamefolder)
{

	lstSavegames =
	strName =
	strNameOld =
	
	Loop, %in_strSavegamefolder%\Saves\*.ess,0,1 
	{
		strName = %A_LoopFileName%
		if strName = autosave1.ess
			Continue
				
		else if strName = autosave2.ess
			Continue
				
		else if strName = autosave3.ess
			Continue
								
		else if strName = quicksave.ess
			Continue
		
		else
		{
			
			;scan for name of character
			;
			
			nPos := InStr(strName, " - ")
			If nPos >0
			{
				strName := SubStr(strName, nPos) ;remove the savegame prefix "Speich. "
				strName := SubStr(strName, 4) ;remove the "- "
			
				nPos := InStr(strName, "  ")
				If nPos >0
				{
					strName := SubStr(strName, 1, nPos-1)
				}

				;Only store char name if not in list already
				if ( strName = "Prisoner" )
				{
					;do nothing, don't sort Prisoner save
				}
				else if ( strName != strNameOld)
				{
					lstSavegames = %lstSavegames%%strName%`n
				}
				strNameOld := strName
				
				
			} ;if nPos >0
			
		} ;else
	} ;loop
	
	Sort, lstSavegames, U
	
Return lstSavegames
} ;doScanForSavegameNames()	


;----------------------------
doCreateSavegameFolders( in_strProfileFolder, in_lstSavegameNames, in_strSubfolder)
{
	Loop, parse, in_lstSavegameNames, `n
	{
		if A_LoopField != 
		{
			strFoldername := A_LoopField
			
			;create character folders
			IfNotExist, %in_strProfileFolder%\%in_strSubfolder%\%strFoldername%
			{
				FileCreateDir, %in_strProfileFolder%\%in_strSubfolder%\%strFoldername%
			}
		}
	}

Return 0
;doCreateSavegameFolders
}


;--------------------
doCopySavegames( in_strSavegameFolder, in_lstSavegameNames, in_strSubfolder)
{

	;scan normal savegame folder for savegames
	Loop, parse, in_lstSavegameNames, `n
	{
		if A_LoopField != 
		{
			strFoldername := A_LoopField
			
			;if profile folder exist
			IfExist, %in_strSavegameFolder%\%in_strSubfolder%\%strFoldername%
			{
				;copy normal savegames to profile folder
				FileCopy, %in_strSavegameFolder%\Saves\* - %strFoldername%*.ess, %in_strSavegameFolder%\%in_strSubfolder%\%strFoldername%
			}
		}
	}


	Return 0
} ;doCopySavegames


;-----------------
doUpdateProfileDDL( in_strSavegamefolder, in_strSubfolder, in_strPreSelect)
{
	
	;check if profile for preselection exists
	if (in_strPreSelect != STANDARD)
	{
		IfNotExist, %in_strSavegamefolder%\%in_strSubfolder%\%in_strPreSelect%
		{
			in_strPreSelect = STANDARD
		}
	}
	
	;clear the dropdownlist
	GuiControl, , ddlCharacter, |

	;add Standard to combobox
	if in_strPreSelect = STANDARD
	{
		;pre-select
		GuiControl, , ddlCharacter, STANDARD||
	}
	else
	{
		GuiControl, , ddlCharacter, STANDARD|
	}

	;scan all folders and add to combobox
	Loop, %in_strSavegamefolder%\%in_strSubfolder%\*.,2,0
	{
		lstProfilenames = %lstProfilenames%%A_LoopFileName%`n
		if A_LoopFileName = %in_strPreSelect%
		{
			;pre-select
			GuiControl, , ddlCharacter, %A_LoopFileName%||
		}
		else
		{
			GuiControl, , ddlCharacter, %A_LoopFileName%|
		}
	}

	iSavegamecount := doCountSavegames(in_strSavegamefolder,in_strSubfolder,in_strPreSelect)
	GuiControl, ,guiSavegameCount, Savegames: %iSavegamecount%

	Gosub, guiDropdownProfile
	;update GUI
	Gui, Show	
	
Return lstProfilenames
} ;doUpdateProfileDDL



;-----------------
doCountSavegames( in_strProfilefolder, in_strProfilesub, in_strActiveProfile)
{
	iCount = 0
	
	strPath=
	
	if in_strActiveProfile=
	{
		iCount = 0
	}
	
	else
	{
		if in_strActiveProfile=STANDARD
		{
			strPath = %in_strProfilefolder%\Saves
		}
		
		else
		{
			strPath = %in_strProfilefolder%\%in_strProfilesub%\%in_strActiveProfile%
		}
		
		Loop, %strPath%\*.ess,0,1
		{
			iCount := A_Index
		}
	}


;doCountSavegames
Return iCount
}
