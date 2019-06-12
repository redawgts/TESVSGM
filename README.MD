# Skyrim: The Elder Scrolls V Savegame Manager by RedawgTS


## Quickstart:

* Unpack to your harddrive.
* run TESVSGM.exe
* select "Advanced" -> "Change play-button link" to browse to your Skyrim executable if necessary.
* select "Savegames" -> "Scan For New Profiles".
* select the profile you want to play from the dropdown list
* click "Play" button to lunch Skyrim: The Elder Scrolls V and play with the active profile

Note #1: Quicksaves and Autosaves are not copied over when scanning for new profiles. If you want to keep them you should either copy them over manually or load them in the game and create a proper save.

Note #2: While they are not copied over, any new quicksaves and autosaves made will be associated with their appropriate profile.

Note #3: SkyrimLauncher.exe overwrites the file this program changes. Don't use it to start Skyrim.


## How to uninstall:

* If you've saved any games since using this program:
    - select "Savegames" -> "Open Active Profile Folder"
    - select "Savegame" -> "Open Skyrim: The Elder Scrolls V Savegame Folder"
    - copy all files in the active profile folder to the original savegame folder. you're saves from before using TESVSGM still exist in the original 'standard' saves folder.
    - switch your profile to STANDARD.
    - delete the savegame manager and it's ini file.

* If you haven't saved any game since using this program:
    - switch your profile to STANDARD. you're saves from before using TESVSGM still exist in the original 'standard' saves folder.
    - delete the savegame manager and it's ini file.


This program is based on digitalfun's Fallout 3 Savegame Manager so special thanks to him for releasing the source code. digitalfun's original tool can be found here: http://www.nexusmods.com/fallout3/mods/708/


## Changes:

Version 1.2 beta
---
- Skyrim.exe should now be automatically selected during the first use of the program. SkyrimLauncher.exe overwrites the file this program edits and never should have been made the default.
- Removed Games for Windows Live code.
- Code cleanup and refactoring. This should make porting to a new game easier and quicker.

Version 1.1
---
- Any character named 'Prisoner' will no longer be sorted. This is to deal with any saves made before character creation.
- SkyrimLauncher.exe should now be automatically selected during the first use of the program.

Version 1.0
---
- Initial release.
