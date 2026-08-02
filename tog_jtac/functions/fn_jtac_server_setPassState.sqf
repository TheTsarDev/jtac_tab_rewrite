//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

if (!isServer) exitWith {false};

params ["_grp", "_state"];

_grp setVariable ["TOG_jtac_passState", _state, true];

true
