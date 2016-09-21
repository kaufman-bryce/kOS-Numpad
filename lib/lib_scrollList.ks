//Enables easy creation of scrollable lists, with optional selection functionality.
@LAZYGLOBAL OFF.

//LOCAL TEMPLATE IS LEXICON(
//	"x",0,
//	"y",0,
//	"w",0,
//	"h",0,
//	"start",0,
//	"content",LIST(),
//	"cursor",FALSE,
//	"index",0
//	).

LOCAL FUNCTION tDraw {
	PARAMETER o.
	IF NOT o["content"]:EMPTY.{
		LOCAL w IS o["w"].
		LOCAL x IS o["x"].
		LOCAL y IS o["y"].
		LOCAL st IS o["start"].
		LOCAL len IS o["content"]:LENGTH.
		LOCAL cur IS o["cursor"].
		LOCAL id IS o["index"].
		FROM {LOCAL i IS 0.} UNTIL i = o["h"] STEP {SET i TO i+1.} DO {
			LOCAL s IS "".
			IF i + st < len {SET s TO o["content"][i+st].}
			IF cur {
				IF i + st = id {SET s TO ">"+s.}
				ELSE {SET s TO " "+s.}
			}
			IF s:LENGTH > w {SET s TO s:SUBSTRING(0,w).}
			ELSE {SET s TO s:PADRIGHT(w).}
			PRINT s AT (x,y+i).
		}
	}
}
LOCAL FUNCTION tMoveCur {
	PARAMETER o,d.
	IF NOT o["content"]:EMPTY.{
		LOCAL id IS o["index"].
		SET id TO id + d.
		IF id < 0 {SET id TO 0.}
		ELSE IF id > o["content"]:LENGTH-1 {SET id TO o["content"]:LENGTH-1.}
		ELSE {
			SET o["index"] TO id.
			IF id < o["start"] OR id >= o["start"]+o["h"]{
				SET o["start"] TO o["start"] + (d/ABS(d))*o["h"].
				tDraw(o).
			}
			ELSE {
				PRINT " " AT (o["x"],o["y"]+id-o["start"]-d).
				PRINT ">" AT (o["x"],o["y"]+id-o["start"]).
			}
		}
	}
}
LOCAL FUNCTION tScroll {
	PARAMETER o, arg.
	LOCAL d IS 0.
	IF arg:ISTYPE("String") {
		IF arg = "pageDn" {SET d TO o["h"].}
		IF arg = "pageUp" {SET d TO -o["h"].}
	}
	ELSE IF arg:ISTYPE("Scalar"){
		SET d TO arg.
	}	
	IF NOT o["content"]:EMPTY.{
		LOCAL s IS o["start"].
		LOCAL sOld IS s.
		SET s TO MAX(0,MIN(o["content"]:LENGTH-MOD(o["content"]:LENGTH,o["h"]), s + d)).
		SET o["start"] TO s.
		IF o["cursor"] {SET o["index"] TO MAX(0,MIN(o["content"]:LENGTH-1,o["index"] + d)).}
		tDraw(o).
	}
}
FUNCTION makeScrollList {
	PARAMETER x, y, w, h, cursor IS FALSE.
	
	LOCAL o IS LEXICON(
		"x",x,
		"y",y,
		"w",w,
		"h",h,
		"start",0,
		"content",LIST(),
		"cursor",cursor,
		"index",0
		).
	LOCAL ret IS LEXICON(
		"setX",{PARAMETER n. SET o["x"] TO n. tDraw(o).},
		"setY",{PARAMETER n. SET o["y"] TO n. tDraw(o).},
		"setW",{PARAMETER n. SET o["w"] TO n. tDraw(o).},
		"setH",{PARAMETER n. SET o["h"] TO n. tDraw(o).},
		"getX",{RETURN o["x"].},
		"getY",{RETURN o["y"].},
		"getW",{RETURN o["w"].},
		"getH",{RETURN o["h"].},
		"content",o["content"],
		"draw",tDraw@:BIND(o),
		"scrollUp", tScroll@:BIND(o,-1),
		"scrollDn", tScroll@:BIND(o,1),
		"pageUp", tScroll@:BIND(o,"pageUp"),
		"pageDn", tScroll@:BIND(o,"pageDn")
	).
	IF cursor = TRUE {
		ret:ADD("getIndex", {RETURN o["index"].}).
		ret:ADD("setIndex", {PARAMETER n. tMoveCur(o,-(o["index"]-n)).}).
		ret:ADD("cursorUp", tMoveCur@:BIND(o,-1)).
		ret:ADD("cursorDn", tMoveCur@:BIND(o,1)).
	}
	RETURN ret.
}