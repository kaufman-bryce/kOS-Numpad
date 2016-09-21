//Default terminal size: 50x36
//<TERMPREVIEW>
//|0         1         2         3         4          
//|01234567890123456789012345678901234567890123456789|
//|                    Test List                     |0
//|__________________________________________________|1
//|                                                  |2
//|                                                  |3
//|                                                  |4
//|                                                  |5
//|                                                  |6
//|                                                  |7
//|                                                  |8
//|                                                  |9
//|                                                  |10
//|                                                  |11
//|                                                  |12
//|                                                  |13
//|                                                  |14
//|                                                  |15
//|                                                  |16
//|                                                  |17
//|                                                  |18
//|                                                  |19
//|                                                  |20
//|                                                  |21
//|                                                  |22
//|                                                  |23
//|                                                  |24
//|                                                  |25
//|                                                  |26
//|                                                  |27
//|                                                  |28
//|__________________________________________________|29
//|             /:          *:          -:           |30
//| 7:          8:          9:                       |31
//| 4:          5:          6:          +:           |32
//| 1:          2:          3:                       |33
//|             0:          .:          E:           |34
//|--------------<This line off limits>--------------|35
//</TERMPREVIEW>
RUNONCEPATH("lib/lib_numpad.ks").
RUNONCEPATH("lib/lib_scrollList.ks").
GLOBAL exit IS FALSE.
GLOBAL runprog IS FALSE.
GLOBAL testDraw IS FALSE.
LOCAL divider IS "".
LOCAL termMaxY IS TERMINAL:HEIGHT - 8.
LOCAL startMenu IS makeScrollList(4,4,TERMINAL:WIDTH - 4,termMaxY - 5,TRUE).
LOCAL numLabels IS LEXICON(1,"",2,"",3,"",4,"",5,"",6,"",7,"",8,"",9,"",0,"","dot","","slash","","star","","minus","","plus","","enter","").
LOCAL blankLabels IS numLabels:COPY.
FROM {LOCAL i IS 0.} UNTIL i = TERMINAL:WIDTH STEP {SET i TO i+1.} DO {
	SET divider TO divider + "_".
}
LOCAL FUNCTION drawLabels {
	FOR i IN numLabels:KEYS {
		LOCAL s IS numLabels[i].
		SET numLabels[i] TO s:SUBSTRING(0,MIN(s:LENGTH,9)):PADRIGHT(9).
	}
	LOCAL y IS TERMINAL:HEIGHT - 2.
	PRINT divider AT (0,y-5).
	PRINT "             /:" + numLabels["slash"] + " *:" + numLabels["star"] + " -:" + numLabels["minus"] AT (0,y-4).
	PRINT " 7:" + numLabels[7] + " 8:" + numLabels[8] + " 9:" + numLabels[9] AT (0,y-3).
	PRINT " 4:" + numLabels[4] + " 5:" + numLabels[5] + " 6:" + numLabels[6] + " +:" + numLabels["plus"] AT (0,y-2).
	PRINT " 1:" + numLabels[1] + " 2:" + numLabels[2] + " 3:" + numLabels[3] AT (0,y-1).
	PRINT "             0:" + numLabels[0] + " .:" + numLabels["dot"] + " E:" + numLabels["enter"] AT (0,y).
}
LOCAL FUNCTION drawTitle {
	PARAMETER t.
	SET t TO t:SUBSTRING(0,MIN(t:LENGTH,TERMINAL:WIDTH - 2)).
	LOCAL len IS t:LENGTH.
	SET t TO t:PADLEFT(FLOOR((TERMINAL:WIDTH + len)/2)).
	SET t TO t:PADRIGHT(TERMINAL:WIDTH).
	PRINT t AT (0,0).
	PRINT divider AT (0,1).
}
LOCAL FUNCTION buildMainMenu {
	startMenu["content"]:CLEAR.
	FOR f IN OPEN("/menuProg") {
		startMenu["content"]:ADD(f:NAME).
	}
}


LOCAL startMenuAct IS numpad["getBlankActions"]().
LOCAL startMenuLabels IS blankLabels:COPY.

LOCAL FUNCTION mainInit {
	CLEARSCREEN.
	buildMainMenu().
	numpad["setActions"](startMenuAct).
	SET numLabels TO startMenuLabels.
	drawTitle("Main Menu").
	PRINT "Select Program" AT (4,3).
	startMenu["draw"]().
	drawLabels().
	PRINT CHAR(7).
}

SET startMenuAct[7]				TO {SET testDraw TO TRUE.}.
SET startMenuLabels[7]			TO "Inline".
SET startMenuAct[4]				TO mainInit@.
SET startMenuLabels[4]			TO "Trigger".
SET startMenuAct[8]				TO startMenu["cursorUp"].
SET startMenuLabels[8]			TO "CursorUp".
SET startMenuAct[2]				TO startMenu["cursorDn"].
SET startMenuLabels[2]			TO "CursorDn".
SET startMenuAct["minus"]		TO startMenu["pageUp"].
SET startMenuLabels["minus"]	TO "Page Up".
SET startMenuAct["plus"]		TO startMenu["pageDn"].
SET startMenuLabels["plus"]		TO "PageDn".
SET startMenuAct["star"]		TO {SET exit TO TRUE.}.
SET startMenuLabels["star"]		TO "Exit2Term".
SET startMenuAct["enter"]		TO {SET runprog TO TRUE.}.
SET startMenuLabels["enter"]		TO "Run Prog.".


mainInit().
UNTIL exit {
	IF testDraw {
		mainInit().
		//startMenu["draw"]().
		//PRINT CHAR(7).
		//drawLabels().
		//PRINT CHAR(7).
		SET testDraw TO FALSE.
	}
	IF runprog {
		SET runprog TO FALSE.
		RUNPATH("/menuProg/"+startMenu["content"][startMenu["getIndex"]()]).
		mainInit().
	}
	WAIT 0.
}
CLEARSCREEN.