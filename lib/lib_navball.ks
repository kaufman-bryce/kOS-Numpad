@LAZYGLOBAL OFF.

FUNCTION eastFor {
  PARAMETER ves.

  RETURN VCRS(ves:UP:VECTOR, ves:NORTH:VECTOR).
}

FUNCTION compassFor {
  PARAMETER ves.

  LOCAL pointing IS ves:FACING:FOREVECTOR.
  LOCAL east IS eastFor(ves).

  LOCAL trig_x IS VDOT(ves:NORTH:vector, pointing).
  LOCAL trig_y IS VDOT(east, pointing).

  LOCAL result IS ARCTAN2(trig_y, trig_x).

  IF result < 0 { 
    RETURN 360 + result.
  } ELSE {
    RETURN result.
  }
}

FUNCTION pitchFor {
  PARAMETER ves.
  RETURN 90 - vang(ves:UP:VECTOR, ves:FACING:FOREVECTOR).
}

FUNCTION rollFor {
  PARAMETER ves.
  
  IF VANG(ves:FACING:VECTOR,ves:UP:VECTOR) < 0.2 { //this is the dead zone for roll when the ship is vertical
    RETURN 0.
  } ELSE {
    LOCAL raw IS VANG(VXCL(ves:FACING:VECTOR,ves:UP:VECTOR), ves:facing:starvector).
    IF VANG(ves:UP:VECTOR, ves:FACING:TOPVECTOR) > 90 {
      IF raw > 90 {
        RETURN 270 - raw.
      } ELSE {
        RETURN -90 - raw.
      }
    } ELSE {
      RETURN raw - 90.
    }
  } 
}.