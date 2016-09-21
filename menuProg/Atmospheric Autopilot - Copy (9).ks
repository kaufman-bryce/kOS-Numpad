LOCAL acts IS numpad["getBlankActions"]().
LOCAL labels IS blankLabels:COPY.


SET labels["star"] TO "Main Menu".
SET acts["star"] TO {SET exit TO TRUE.}.

numpad["setActions"](acts).
SET numLabels TO labels.

CLEARSCREEN.
drawTitle("Test Program").
PRINT "This is a test!" AT (10,10).
WAIT 0.
drawLabels().
PRINT CHAR(7).
UNTIL exit {
	WAIT 0.
}
SET exit TO FALSE.