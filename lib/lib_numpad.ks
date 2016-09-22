@LAZYGLOBAL OFF.
//Private variables
LOCAL n IS {RETURN FALSE.}.
LOCAL actions IS LEXICON(1,n,2,n,3,n,4,n,5,n,6,n,7,n,8,n,9,n,0,n,"dot",n,"slash",n,"star",n,"minus",n,"plus",n,"enter",n).
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
LOCAL FUNCTION checkKeys {
	IF AG201 = TRUE      {bel(). AG201 OFF. actions[1]().}
	ELSE IF AG202 = TRUE {bel(). AG202 OFF. actions[2]().}
	ELSE IF AG203 = TRUE {bel(). AG203 OFF. actions[3]().}
	ELSE IF AG204 = TRUE {bel(). AG204 OFF. actions[4]().}
	ELSE IF AG205 = TRUE {bel(). AG205 OFF. actions[5]().}
	ELSE IF AG206 = TRUE {bel(). AG206 OFF. actions[6]().}
	ELSE IF AG207 = TRUE {bel(). AG207 OFF. actions[7]().}
	ELSE IF AG208 = TRUE {bel(). AG208 OFF. actions[8]().}
	ELSE IF AG209 = TRUE {bel(). AG209 OFF. actions[9]().}
	ELSE IF AG210 = TRUE {bel(). AG210 OFF. actions[0]().}
	ELSE IF AG211 = TRUE {bel(). AG211 OFF. actions["dot"]().}
	ELSE IF AG212 = TRUE {bel(). AG212 OFF. actions["slash"]().}
	ELSE IF AG213 = TRUE {bel(). AG213 OFF. actions["star"]().}
	ELSE IF AG214 = TRUE {bel(). AG214 OFF. actions["minus"]().}
	ELSE IF AG215 = TRUE {bel(). AG215 OFF. actions["plus"]().}
	ELSE IF AG216 = TRUE {bel(). AG216 OFF. actions["enter"]().}
	WAIT 0.
}

//Namespace
GLOBAL numpad IS LEXICON(
	"setActions",setActions@,
	"getBlankActions",getBlankActions@,
	"getCurActions",getCurActions@,
	"check",checkKeys@
).