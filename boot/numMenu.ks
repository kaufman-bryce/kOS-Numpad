CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
SET CORE:BOOTFILENAME TO "".
COPYPATH("0:/lib/lib_numpad.ks",CORE:VOLUME:NAME + "/lib/lib_numpad.ks").
COPYPATH("0:/lib/lib_scrollList.ks",CORE:VOLUME:NAME + "/lib/lib_scrollList.ks").
COPYPATH("0:/menuProg",CORE:VOLUME:NAME).
COPYPATH("0:/numpad.ks",CORE:VOLUME:NAME).
DELETEPATH(scriptpath()).
CLEARSCREEN.
PRINT "Flight Computer Initialized".
PRINT "Type --RUN numpad-- to begin".