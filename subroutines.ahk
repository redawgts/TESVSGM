;subroutines



;----------------------------
subScanForNewProfiles:

		Gui, +Disabled
	
		lstSavegames := doScanForSavegameNames(SAVEGAMESFOLDER)
			
		;create savegame (character) folders
		doCreateSavegameFolders( SAVEGAMESFOLDER, lstSavegames, PROFILESSUBFOLDER)
			
		;copy all files to the approtiate folders
		doCopySavegames( SAVEGAMESFOLDER, lstSavegames, PROFILESSUBFOLDER)

		doUpdateProfileDDL(SAVEGAMESFOLDER, PROFILESSUBFOLDER, ACTIVE)
		
		Gui, -Disabled
		
;subScanForNewProfiles
Return



;---------------------
subSetupApp:

	;check if INI file exists
	IfNotExist, %INIFILENAME%
	{
		MsgBox, 0, ERROR, The INI file doesn't exist!`n(%INIFILENAME%)`n`nCreating new INI file...! 
		gosub subCreateNewINI		
	}

	
	;get the path of the savegame folder
	IniRead, SAVEGAMESFOLDER, %INIFILENAME%, general, savegames,
	
	;IF not setup already
	If SAVEGAMESFOLDER =
	{
		;try to find at standard location
		SAVEGAMESFOLDER = %A_MyDocuments%\My Games\%SHORTNAME%
		IfNotExist, %SAVEGAMESFOLDER%\Saves
		{
			MsgBox, 0, Critical Failure, %LONGNAME% Savegame folder NOT FOUND`n(usually in ..My Documents\My Games\%SHORTNAME%),
			FileSelectFolder, SAVEGAMESFOLDER,,,Critical Failure`n%LONGNAME% Savegame folder NOT FOUNDPlease select %LONGNAME% Savegame folder... `n(usually in ..My Documents\My Games\%SHORTNAME%)
			If ErrorLevel = 1
			{
				SAVEGAMESFOLDER = 	
			}
		}

		;store the "my games\Skyrim" location
		IniWrite, %SAVEGAMESFOLDER%, %INIFILENAME%, general, savegames
		
		;get (from registry) and store the SkyrimLauncher.exe location
		strSteamPath=
		RegRead, strSteamPath, HKEY_CURRENT_USER, Software\Valve\Steam, SteamPath
		
		strGamePath = %strSteamPath%\steamapps\common\%SHORTNAME%\
		
		IniWrite, %strGamePath%%SHORTNAME%.exe, %INIFILENAME%, advanced, playbuttonlink
	}
	
	;get the active profile and active/display
	IniRead, ACTIVE, %INIFILENAME%, general, active
	lstProfiles := doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
	
	
;subSetup:
Return




;-------------------
subRunGame:
	
	IniRead, strRunfile, %INIFILENAME%, advanced, playbuttonlink
	SplitPath, strRunfile,, strRunfilepath
	Run, %strRunfile%, %strRunfilepath%

;subRunGame
Return


;-----------------------
subActivateProfile:

	if ACTIVE =
	{
		ACTIVE = STANDARD
	}
	

	FileSetAttrib, -R, %SAVEGAMESFOLDER%\%SHORTNAME%.ini

	;activate new profile
	;
	
	;only when profile folder exists
	IfExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ddlCharacter%
	{	
		;activate profile
		IniWrite, %PROFILESSUBFOLDER%\%ACTIVE%\, %SAVEGAMESFOLDER%\%SHORTNAME%.ini, General, SLocalSavePath
	}
	else
	{
		ACTIVE=STANDARD
	}

	if ACTIVE = STANDARD
	{
		;activate standard profile
		IniWrite, Saves\, %SAVEGAMESFOLDER%\%SHORTNAME%.ini, General, SLocalSavePath
	}
	
	
	;update TESVSGM ini
	IniWrite, %ddlCharacter%, %INIFILENAME%, general, active	

;subActivateProfile
Return


;-------------------------
subCreateNewINI:

	FileAppend,
(
[general]
active=                                                         
savegames=

[advanced]
playbuttonlink=
), %INIFILENAME%

;subCreateNewINI
Return

;--------------------------
subLaunchNexus:
	Run, %NEXUSLINK%
;subLaunchNexus
Return