CLEARSCREEN.
SET t TO "Copying files...".
LOCAL len IS t:LENGTH.
SET t TO t:PADLEFT(FLOOR((TERMINAL:WIDTH + len)/2)).
SET t TO t:PADRIGHT(TERMINAL:WIDTH).
PRINT t AT (0,TERMINAL:HEIGHT/2-1).
COPYPATH("0:/lib/lib_numpad.ks",CORE:VOLUME:NAME + "/lib/lib_numpad.ks").
COPYPATH("0:/lib/lib_scrollList.ks",CORE:VOLUME:NAME + "/lib/lib_scrollList.ks").
COPYPATH("0:/menuProg",CORE:VOLUME:NAME).
COPYPATH("0:/numpad.ks",CORE:VOLUME:NAME).
