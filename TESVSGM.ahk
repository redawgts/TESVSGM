
#Persistent
#SingleInstance, Force

myVERSION=1.2

;TESVSGM ini-filename
INIFILENAME=TESVSGM.ini

;Location of the Savegames folder
SAVEGAMESFOLDER=

PROFILESSUBFOLDER=TESVSGM

APPNAME=TESVSGM
LONGNAME=Skyrim: The Elder Scrolls V
SHORTNAME=Skyrim
NEXUSLINK=www.nexusmods.com/skyrim

;the name of the active profile (=foldername)
ACTIVE=

;

;------------------------------------
; G*U*I
;------------------------------------

;------------
; Sub Menus
;------------

;savegames
Menu, subMenuSG, Add, Create New Profile..., submenuSGHandler
Menu, subMenuSG, Add, Scan For New Profiles, submenuSGHandler
Menu, subMenuSG, Add	;a line -----
Menu, subMenuSG, Add, Backup Active Profile..., submenuSGHandler
Menu, subMenuSG, Add, Backup All Profiles..., submenuSGHandler
Menu, subMenuSG, Add	;a line -----
Menu, subMenuSG, Add, Open %LONGNAME% Savegame Folder, submenuSGHandler
Menu, subMenuSG, Add, Open Active Profile Folder, submenuSGHandler

;advanced
Menu, subMenuADV, Add, Change Play-button link..., submenuADVHandler

;help
;Menu, subMenuHELP, Add, Help, submenuHELPHandler
;Menu, subMenuHELP, Add 	;a line -----
Menu, subMenuHELP, Add, About, submenuHELPHandler

;attach menus to app
Menu, menuMain, Add, Savegames, :subMenuSG
Menu, menuMain, Add, Advanced, :subMenuADV
Menu, menuMain, Add, Help, :subMenuHELP

;----------------
; Tray Menu
;----------------


;remove AHK items
Menu, Tray, NoStandard

Menu, Tray, Add		;a line ------
Menu, Tray, Add, Run %LONGNAME%, submenuTrayHandler
Menu, Tray, Add		;a line ------
Menu, Tray, Add, Open %SHORTNAME% window, submenuTrayHandler
Menu, Tray, Add		;a line ------
Menu, Tray, Add, Exit, submenuTrayHandler


;-------------------------------------
;GUI window 1
;-------------------------------------
Gui, Add, GroupBox, x6 y1 w320 h130 ,
Gui, Add, Text, x16 y11 w200 h20 , Select Profile
Gui, Add, DropDownList, x16 y31 w300 h300 vddlCharacter gguiDropdownProfile,
Gui, Add, Text, x16 y60 w180 h20 vguiSavegameCount,
Gui, Add, Button, x16 y80 w300 h40 gsubRunGame, Play
Gui, Add, Picture, x6 y135 w320 h-1 vpic, standard.jpg
Gui, Add, Text, x16 y380 w300 h20 +Center cBlue gsubLaunchNexus, %NEXUSLINK%

; Generated using SmartGUI Creator 4.0
Gui, Show, xCenter yCenter h420 w331, %APPNAME% %myVERSION%
Gui, Menu, menuMain
GuiControl, Focus, ddlCharacter
;------------------------------------------------


;-----------------------
; MAIN
;-----------------------


Gosub subSetupApp

;Mainloop
Return

;------------
FinishApp:
GuiClose:

ExitApp


#Include subroutines.ahk
#Include functions.ahk
#Include guihandler.ahk
