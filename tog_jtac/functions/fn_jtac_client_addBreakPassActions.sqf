//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

if (!hasInterface) exitWith {false};

params ["_grp", "_actionText", "_allowPass"];

_grp setVariable ["TOG_jtac_passState", "", true];

private _actionIdHit = [[
	localize "STR_CONFIRM_HIT",
	{
		params ["_target", "_caller", "_id", "_args"];
		_args params ["_grp"];
		[_grp, "hit"] remoteExec ["TOG_fnc_jtac_server_setPassState", 2];
		["breakPass"] call TOG_fnc_jtac_client_removeActions;
	},
	[_grp],
	1.5,
	false,
	true
]] call CBA_fnc_addPlayerAction;

["breakPass", _actionIdHit, "hit"] call TOG_fnc_jtac_client_storeAction;

private _actionIdPass = [[
	_actionText,
	{
		params ["_target", "_caller", "_id", "_args"];
		_args params ["_grp", "_allowPass"];
		private _state = if (_allowPass) then {"nextPass"} else {"notHit"};
		[_grp, _state] remoteExec ["TOG_fnc_jtac_server_setPassState", 2];
		["breakPass"] call TOG_fnc_jtac_client_removeActions;
	},
	[_grp, _allowPass],
	1.5,
	false,
	true
]] call CBA_fnc_addPlayerAction;

["breakPass", _actionIdPass, "pass"] call TOG_fnc_jtac_client_storeAction;

true
