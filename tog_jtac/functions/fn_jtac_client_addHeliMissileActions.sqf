//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

if (!hasInterface) exitWith {false};

params ["_grp", "_markType", "_mrkTgt", "_alterTgt", "_vehClass", "_maxAt", "_maxAp"];

if (_maxAt > 0) then {
	private _actionId = [[
		"<t color='#c48214'>" + (localize "STR_CHOSE_AT") + "</t>",
		{
			params ["_target", "_caller", "_id", "_args"];
			_args remoteExec ["TOG_fnc_jtac_CAS_launchMissile", 2];
		},
		[_grp, _markType, _mrkTgt, 0, _alterTgt, _vehClass],
		1,
		false,
		true
	]] call CBA_fnc_addPlayerAction;

	["heliMissile", _actionId, "AT"] call TOG_fnc_jtac_client_storeAction;
};

if (_maxAp > 0) then {
	private _actionId = [[
		"<t color='#c48214'>" + (localize "STR_CHOSE_AP") + "</t>",
		{
			params ["_target", "_caller", "_id", "_args"];
			_args remoteExec ["TOG_fnc_jtac_CAS_launchMissile", 2];
		},
		[_grp, _markType, _mrkTgt, 1, _alterTgt, _vehClass],
		1,
		false,
		true
	]] call CBA_fnc_addPlayerAction;

	["heliMissile", _actionId, "AP"] call TOG_fnc_jtac_client_storeAction;
};

true
