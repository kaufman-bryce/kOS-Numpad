@LAZYGLOBAL OFF.
//Private variables
LOCAL doNothing IS {RETURN FALSE.}.
LOCAL actions IS LEXICON(
	1,doNothing,
	2,doNothing,
	3,doNothing,
	4,doNothing,
	5,doNothing,
	6,doNothing,
	7,doNothing,
	8,doNothing,
	9,doNothing,
	0,doNothing,
	"dot",doNothing,
	"slash",doNothing,
	"star",doNothing,
	"minus",doNothing,
	"plus",doNothing,
	"enter",doNothing
).
LOCAL blankActions IS actions:COPY.

//Public methods
LOCAL FUNCTION setActions {
	PARAMETER act.
	SET actions TO act.
}
LOCAL FUNCTION getBlankActions {
	RETURN blankActions:COPY.
}
LOCAL FUNCTION getCurActions {
	RETURN actions.
}

//Namespace
GLOBAL numpad IS LEXICON(
	"setActions",setActions@,
	"getBlankActions",getBlankActions@,
	"getCurActions",getCurActions@
).

ON AG201 {
	actions[1]().
	RETURN TRUE.
}
ON AG202 {
	actions[2]().
	RETURN TRUE.
}
ON AG203 {
	actions[3]().
	RETURN TRUE.
}
ON AG204 {
	actions[4]().
	RETURN TRUE.
}
ON AG205 {
	actions[5]().
	RETURN TRUE.
}
ON AG206 {
	actions[6]().
	RETURN TRUE.
}
ON AG207 {
	actions[7]().
	RETURN TRUE.
}
ON AG208 {
	actions[8]().
	RETURN TRUE.
}
ON AG209 {
	actions[9]().
	RETURN TRUE.
}
ON AG210 {
	actions[0]().
	RETURN TRUE.
}
ON AG211 {
	actions["dot"]().
	RETURN TRUE.
}
ON AG212 {
	actions["slash"]().
	RETURN TRUE.
}
ON AG213 {
	actions["star"]().
	RETURN TRUE.
}
ON AG214 {
	actions["minus"]().
	RETURN TRUE.
}
ON AG215 {
	actions["plus"]().
	RETURN TRUE.
}
ON AG216 {
	actions["enter"]().
	RETURN TRUE.
}