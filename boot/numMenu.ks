CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
COPYPATH("0:/lib/lib_numpad",CORE:VOLUME:NAME + "/lib/lib_numpad").
COPYPATH("0:/lib/lib_navball",CORE:VOLUME:NAME + "/lib/lib_navball").
COPYPATH("0:/lib/lib_scrollList",CORE:VOLUME:NAME + "/lib/lib_scrollList").
COPYPATH("0:/menuProg",CORE:VOLUME:NAME).
COPYPATH("0:/numpad.ks",CORE:VOLUME:NAME).
//SET CORE:BOOTFILENAME TO "".
//DELETEPATH(scriptpath()).
RUN numpad.ks.