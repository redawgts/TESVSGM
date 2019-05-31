;subroutines for gui

;-------------------
submenuSGHandler:

	If A_ThisMenuItem = Create New Profile...
	{
	
		InputBox, strNewProfileName, Create New Profile, Enter the name of your new profile`nNew Profilename:
		
		;user click OK
		If (ErrorLevel = 0 AND StrLen( strNewProfileName) > 0)
		{
			
			;abort if profile exist already
			IfExist %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%strNewProfileName%
			{
				MsgBox, 0, ERROR, The Profile exists already!
			}
			
			Else
			{
				FileCreateDir %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%strNewProfileName%
				MsgBox, 4, Create New Profile Folder,Explore the new profile folder?
				
				ACTIVE=%strNewProfileName%
				doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
				
				IfMsgBox, Yes
				{
					Run, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%strNewProfileName%
					
				}	
			}
		}
	}
	
	Else If A_ThisMenuItem = Backup Active Profile...
	{

		;profile = STANDARD
		If ACTIVE = STANDARD
		{
			FileSelectFolder, strBackupFolder,,, Backup -%ACTIVE%- to ...
			
			;folderselect OK
			if strBackupFolder!= 
			{	
							
				FileCopyDir, %SAVEGAMESFOLDER%\Saves, %strBackupFolder%\STANDARD, 1
			}
		Return
 		}

		;profile folder not found
		IfNotExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
		{
			MsgBox, 0, Error, Profile folder not found!`n(%SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%)
			return
 		}

		;if profile folder exists
		IfExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
		{
			FileSelectFolder, strBackupFolder,,, Backup -%ACTIVE%- to ...`n
			
			;folderselect OK
			if strBackupFolder!= 
			{
							
				FileCopyDir, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%, %strBackupFolder%\%ACTIVE%, 1
			}
		}

	}

	Else If A_ThisMenuItem = Backup All Profiles...
	{
		FileSelectFolder, strBackupFolder,,, Backup -%ACTIVE%- to ...`n
			
		;folderselect OK
		if strBackupFolder!= 
		{
			
			FileCopyDir, %SAVEGAMESFOLDER%\Saves, %strBackupFolder%\STANDARD, 1							
			FileCopyDir, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%, %strBackupFolder%, 1
		}
	}

	
	Else If A_ThisMenuItem = Scan For New Profiles
	{

		MsgBox, Note that your actual AUTO- and QUICKSAVE will stay in the STANDARD profile.`n`nTo move it to your character's profile:`n`n*Activate STANDARD profile`n*Run %LONGNAME% and load your AUTO/QUICKSAVE`n*Save as New Savegame`n*Run Scan again

		gosub subScanForNewProfiles
		
		;Activate STANDARD profile
		IniWrite, STANDARD, %INIFILENAME%, general, active
		ACTIVE = STANDARD
		Gosub, subActivateProfile
		doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
		
	}

	else if A_ThisMenuItem = Open %LONGNAME% Savegame Folder
	{
		If SAVEGAMESFOLDER != ""
		{
			Run, "%SAVEGAMESFOLDER%\Saves"
		}
	}

	else if A_ThisMenuItem = Open Active Profile Folder
	{
		If SAVEGAMESFOLDER != ""
		{
			IfExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
			{
				Run, "%SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%"
			}
			
			Else
			{
				Run, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\
			}
		}
	}
	
;submenuSGHandler
Return




;-------------------
submenuADVHandler:

	if A_ThisMenuItem = Change Play-button link...
	{
		FileSelectFile, strRunfile,1,, Select the file you want to run...
		If ErrorLevel = 0
		{
			IniWrite, %strRunfile%, %INIFILENAME%, advanced, playbuttonlink
		}
	}
	
;submenuADVHandler
Return



;----------------------
submenuHELPHandler:

;	if A_ThisMenuItem = Help
;	{
;		Run, helpfile.html
;	}

;	else
    if A_ThisMenuItem = About
	{
		MsgBox, 0, About %LONGNAME% Savegame Manager, %LONGNAME% Savegame Manager`nVersion %myVERSION%`n`nAuthor: RedawgTS`nSpecial thanks to: -digitalfun-`n`n%APPNAME% is published exclusively on: `n%NEXUSLINK%,
	}

;submenuHELPHandler
Return


;------------------
submenuTrayHandler:

	If A_ThisMenuItem = Run %LONGNAME%
	{
		gosub subRunGame
	}

	Else If A_ThisMenuItem = Open %APPNAME% window
	{
		Gui, Show
	}

	Else if A_ThisMenuItem = Exit
	{
		goto FinishApp
	}

;submenuTrayHandler
Return


;-------------------------
guiDropdownProfile:

	Gui, Submit, NoHide
		;after submit -> ddlCharacter = savegame profile folder (or STANDARD)
	
	strPicFilename=

	;activate selected profile
	ACTIVE := ddlCharacter
	gosub subActivateProfile

	iSavegamecount := doCountSavegames(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
	GuiControl, ,guiSavegameCount, Savegames: %iSavegamecount%

	;show profile picture
	;
	
	;if standard, use standard pic
	If ddlCharacter = STANDARD 
	{
		strPicFilename = standard.jpg
	}	

	else 
	{
		;scan profile folder for jpg
		Loop, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ddlCharacter%\*.jpg, 0, 1 
		{
			If A_LoopFileName != 
			{
				strPicFilename=%SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ddlCharacter%\%A_LoopFileName%
				Break
			}
		}

		If strPicFilename = 
		{
			;scan profile folder for jpg
			Loop, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ddlCharacter%\*.bmp, 0, 1 
			{
				If A_LoopFileName != 
				{
					strPicFilename=%SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ddlCharacter%\%A_LoopFileName%
					Break
				}
			}
		}
	}
	
	if strPicFilename = 
	{
		strPicFilename = standard.jpg
	}
	
	;set picture control
	GuiControl, ,pic, %strPicFilename%

	
;guiDropdownProfile:
Return


;-----------------
GuiDropFiles:

	; Extract filename (only the first if multiple files were dropped)
	Loop, parse, A_GuiEvent, `n
	{
		strFilename = %A_LoopField%
		Break
	}

	;if strFilename is a JPG or BMP
	SplitPath, strFilename,,, strExt
	if (strExt = "JPG" OR strExt = "BMP")
	{
		if ACTIVE=
		{
		}
		
		else if ACTIVE=STANDARD
		{
			MsgBox, You cannot change the STANDARD profile picture!
		}
		
		else
		{
			;remove previous pic
			FileDelete, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\*.jpg
			FileDelete, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%\*.bmp
			
			;copy the picture to the profilefolder	
			FileCopy, %strFilename%,  %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ACTIVE%
			
			;show the new pic
			gosub guiDropdownProfile
		}
		
		
	}

;GuiDropFiles
Return
