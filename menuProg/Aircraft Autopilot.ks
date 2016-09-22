RUNONCEPATH("lib/lib_navball").
LOCAL acts IS numpad["getBlankActions"]().
LOCAL labels IS blankLabels:COPY.
//LOCAL SHIP:CONTROL IS SHIP:CONTROL.
LOCAL confirm IS FALSE.
LOCAL isPaused IS TRUE.
LOCAL mul IS 10.
LOCAL timeout IS 0.
LOCAL dAlt IS 0.
LOCAL altSmooth IS 0.
LOCAL altChangeMax IS 10.
LOCAL dHead IS 0.
LOCAL minq IS 0.1.
LOCAL maxq IS 0.6.
LOCAL oldTime IS TIME:SECONDS.


LOCAL FUNCTION pause {
	isPaused ON.
	SET labels["dot"] TO "ENGAGE".
	SET acts["dot"] TO unPause@.
	drawTitle("! AUTOPILOT DISENGAGED !").
	drawLabels().
	IF AIRSPEED > 0 {SAS ON.}
	SET SHIP:CONTROL:NEUTRALIZE TO TRUE.
}
LOCAL FUNCTION unPause {
	isPaused OFF.
	SET labels["dot"] TO "DISENGAGE".
	SET acts["dot"] TO pause@.
	drawTitle("===AUTOPILOT ENGAGED===").
	drawLabels().
	SAS OFF.
	SET dAlt TO ROUND(ALTITUDE).
	SET altSmooth TO dAlt.
	SET dHead TO ROUND(compassFor(SHIP),1).
	SET pThrot:SETPOINT TO ROUND(AIRSPEED).
}

SET labels[7] TO "Speed Up".
SET acts[7] TO {SET pThrot:SETPOINT TO pThrot:SETPOINT + mul.}.
SET labels[4] TO "Set Speed".
SET acts[4] TO {SET pThrot:SETPOINT TO ROUND(AIRSPEED).}.
SET labels[1] TO "Speed Dn".
SET acts[1] TO {SET pThrot:SETPOINT TO pThrot:SETPOINT - mul.}.

SET labels[8] TO "Alt Up".
SET acts[8] TO {SET dAlt TO dAlt + mul.}.
SET labels[5] TO "Set Alt".
SET acts[5] TO {SET dAlt TO ROUND(ALTITUDE).}.
SET labels[2] TO "Alt Dn".
SET acts[2] TO {SET dAlt TO dAlt - mul.}.

SET labels[9] TO "Head Up".
SET acts[9] TO {SET dHead TO dHead + mul.}.
SET labels[6] TO "Set Head".
SET acts[6] TO {SET dHead TO ROUND(compassFor(SHIP),1).}.
SET labels[3] TO "Head Dn".
SET acts[3] TO {SET dHead TO dHead - mul.}.


SET labels["star"] TO "Main Menu".
SET acts["star"] TO {
	IF confirm {exit ON. confirm OFF.}
	ELSE {confirm ON. SET labels["star"] TO "CONFIRM?". drawLabels(). SET timeout TO TIME:SECONDS + 2.}
}.
SET labels["minus"] TO "Mul/10".
SET acts["minus"] TO {SET mul TO mul/10. PRINT mul:TOSTRING:PADRIGHT(10) AT (12,2).}.
SET labels["plus"] TO "Mul*10".
SET acts["plus"] TO {SET mul TO mul*10. PRINT mul:TOSTRING:PADRIGHT(10) AT (12,2).}.

numpad["setActions"](acts).
SET numLabels TO labels.

LOCAL pThrot IS PIDLOOP(0.06,0.01,0.08,0,1).
LOCAL pPitch IS PIDLOOP(0.02,0.005,0,-1,1).
LOCAL pPitchD IS PIDLOOP(0,0,0.005,-1,1).
LOCAL pTurn IS PIDLOOP(0.05,0.05,0.1,-70,70).
LOCAL pRoll IS PIDLOOP(0.02,0,0.018,-1,1).


CLEARSCREEN.
pause().
PRINT "Multiplier: "+mul:TOSTRING:PADRIGHT(5) AT (0,2).
PRINT "Set Speed:" AT (0,3).
PRINT "Cur Speed:" AT (0,4).

PRINT "  Set Alt:" AT (0,6).
PRINT "  Cur Alt:" AT (0,7).

PRINT " Set Head:" AT (0,9).
PRINT " Cur Head:" AT (0,10).

SET pTurn:SETPOINT TO 0.
SET pRoll:SETPOINT TO 0.
SET pPitchD:SETPOINT TO 0.
UNTIL exit {
	LOCAL dT IS TIME:SECONDS - oldTime.
	SET oldTime TO TIME:SECONDS.
	IF dHead > 360 {SET dHead TO dHead-360.}
	IF dHead < 0 {SET dHead TO dHead+360.}
	IF NOT isPaused {
		LOCAL qMul IS 1-MIN(1,MAX(0,SHIP:Q-minq)/(maxq-minq)).
		LOCAL ctrlMul IS 0.95*qMul+0.05.
		
		SET altSmooth TO altSmooth + MIN(altChangeMax,MAX(-altChangeMax,(dAlt - altSmooth)/dT)). //Setpoint smoothing
		LOCAL vsMax IS AIRSPEED/3.
		//LOCAL vsErr IS ((altSmooth - ALTITUDE)*0.8)^0.7.
		LOCAL vsErr IS (altSmooth - ALTITUDE)/3.
		LOCAL dVS IS MAX(-vsMax,MIN(vsMax,vsErr)).
		SET pPitch:SETPOINT TO dVS.
		pPitch:UPDATE(TIME:SECONDS,VERTICALSPEED).
		SET SHIP:CONTROL:PITCH TO (pPitch:OUTPUT)*ctrlMul +
			pPitch:ITERM*(1-ctrlMul) + 
			pPitchD:UPDATE(TIME:SECONDS,pitchFor(SHIP))*ctrlMul.
		
		LOCAL bear IS compassFor(SHIP) - dHead.
		IF bear > 180 {SET bear TO bear - 360.}
		IF bear < -180 {SET bear TO bear + 360.}
		SET pRoll:SETPOINT TO pTurn:UPDATE(TIME:SECONDS,bear*15).
		SET SHIP:CONTROL:ROLL TO pRoll:UPDATE(TIME:SECONDS,rollFor(SHIP))*0.5*ctrlMul.
		
		SET SHIP:CONTROL:MAINTHROTTLE TO pThrot:UPDATE(TIME:SECONDS,AIRSPEED).
		SET SHIP:CONTROL:PILOTMAINTHROTTLE TO SHIP:CONTROL:MAINTHROTTLE.
	}
	PRINT pThrot:SETPOINT:TOSTRING:PADRIGHT(10) AT (11,3).
	PRINT ROUND(AIRSPEED):TOSTRING:PADRIGHT(10) AT (11,4).
	PRINT dAlt:TOSTRING:PADRIGHT(10) AT (11,6).
	PRINT ROUND(ALTITUDE):TOSTRING:PADRIGHT(10) AT (11,7).
	PRINT dHead:TOSTRING:PADRIGHT(10) AT (11,9).
	PRINT ROUND(compassFor(SHIP),1):TOSTRING:PADRIGHT(10) AT (11,10).
	IF confirm AND timeout < TIME:SECONDS {confirm OFF. SET labels["star"] TO "Main Menu". drawLabels().}
	numpad["check"]().
}
exit OFF.
pause().