//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

params ["_grp"];

if (isNull _grp) exitWith {};

leader _grp setVariable ["waitForLoad", false, true];

if (!isNil "TOG_jtac_trans_goAction") then {
	[TOG_jtac_trans_goAction] call CBA_fnc_removePlayerAction;
	TOG_jtac_trans_goAction = nil;
};

{
	private _veh = vehicle _x;
	{
		_veh removeAction _x;
	} forEach (_veh getVariable ["TOG_jtac_goActions", []]);
	_veh setVariable ["TOG_jtac_goActions", []];
} forEach units _grp;

true
