@ECHO OFF
SET zip=7za.exe a -tzip -mx9

@ECHO Cleanup...
DEL /F /Q TESVSGM.exe
DEL /F /Q TESVSGM.zip
DEL /F /Q TESVSGM-Src.zip

@ECHO Compiling Script...
"C:\Program Files (x86)\AutoHotkey\Compiler\Ahk2Exe.exe" /in TESVSGM.ahk /out TESVSGM.exe /icon "TESV icon.ico"

@ECHO Creating Release Archive...
%zip% TESVSGM.zip TESVSGM.exe
%zip% TESVSGM.zip TESVSGMreadme.txt
%zip% TESVSGM.zip Standard.jpg
%zip% TESVSGM.zip *.ahk
%zip% TESVSGM.zip *.ico

@ECHO Creating Source Archive...
%zip% TESVSGM-Src.zip TESVSGMreadme.txt
%zip% TESVSGM-Src.zip Standard.jpg
%zip% TESVSGM-Src.zip *.ahk
%zip% TESVSGM-Src.zip *.ico

@ECHO Done.