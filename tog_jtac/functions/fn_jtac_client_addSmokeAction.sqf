//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

if (!hasInterface) exitWith {false};

params ["_shell", "_grp", "_actionText", "_colorKey"];

private _actionId = [[
	_actionText,
	{
		params ["_target", "_caller", "_id", "_args"];
		_args params ["_shell", "_grp", "_colorKey"];
		[_shell, _grp] remoteExec ["TOG_fnc_jtac_server_confirmSmoke", 2];
		["smoke", _colorKey] call TOG_fnc_jtac_client_removeActions;
	},
	[_shell, _grp, _colorKey],
	1.5,
	false,
	true
]] call CBA_fnc_addPlayerAction;

["smoke", _actionId, _colorKey] call TOG_fnc_jtac_client_storeAction;

true
