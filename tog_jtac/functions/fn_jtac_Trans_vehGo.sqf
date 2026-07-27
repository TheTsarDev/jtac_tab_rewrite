//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

params ["_grp"];

if (!hasInterface) exitWith {};

if (!isNil "TOG_jtac_trans_goAction") then {
	[TOG_jtac_trans_goAction] call CBA_fnc_removePlayerAction;
};

TOG_jtac_trans_goAction = [[
	"<t color='#c48214'>GO — Release Transport</t>",
	{
		params ["_target", "_caller", "_actionId", "_args"];
		_args call TOG_fnc_jtac_Trans_vehGoRemoveAction;
	},
	[_grp],
	1.5,
	false,
	true
]] call CBA_fnc_addPlayerAction;

hint "Transport on station — scroll wheel: GO";

true
