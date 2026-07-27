//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

_typeCas = _this select 0;
_elev = _this select 1;
_grp = _this select 2;
_mrkTgt = _this select 3;
_callsign = _this select 4;
_ammoType = _this select 5;
_grpType = _this select 6;
_markType = _this select 7;
_tgt = _this select 8;
_alterTgt = _this select 9;
_mrkIp = _this select 10;
_vehClass = _this select 11;
_fireDist = _this select 12;
_pos = _this select 13;

_isAlive = true;
_isAborted = false;

// Hold at BP/IP while JTAC selects munitions or confirms target
_holdPos = getMarkerPos _mrkIp;
_holdAlt = (_elev + 400) max 50;

while {(count (waypoints _grp)) > 0} do {
	deleteWaypoint ((waypoints _grp) select 0);
};

{
	(vehicle _x) flyInHeight _holdAlt;
} forEach units _grp;

_wpHold = _grp addWaypoint [_holdPos, 0];
_wpHold setWaypointType "LOITER";
_wpHold setWaypointLoiterRadius 150;
_wpHold setWaypointSpeed "LIMITED";
_wpHold setWaypointBehaviour "CARELESS";
_wpHold setWaypointCombatMode "BLUE";

if (_ammoType == 0) then {
	if (heliMaxAt > 0) then {
		addATMissile = [[
			"<t color='#c48214'>" + (localize 'STR_CHOSE_AT') + "</t>",
			TOG_fnc_jtac_CAS_launchMissile,
			[_grp,_markType,_mrkTgt,0,_alterTgt,_vehClass],
			1
		]] call CBA_fnc_addPlayerAction;
	};
	if (heliMaxAp > 0) then {
		addAPMissile = [[
			"<t color='#c48214'>" + (localize 'STR_CHOSE_AP') + "</t>",
			TOG_fnc_jtac_CAS_launchMissile,
			[_grp,_markType,_mrkTgt,1,_alterTgt,_vehClass],
			1
		]] call CBA_fnc_addPlayerAction;
	};

	waitUntil {
		_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
		_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;
		sleep 0.5;
		(heliMaxAt < 1 && heliMaxAp < 1) || !_isAlive || _isAborted || (!alive TOG_jtac_operator) || (!isPlayer TOG_jtac_operator)
	};

	_misslArr = [];
	if (!isNil "addATMissile") then {_misslArr pushBack addATMissile;};
	if (!isNil "addAPMissile") then {_misslArr pushBack addAPMissile;};
	{
		if (!isNil "_x") then { [_x] call CBA_fnc_removePlayerAction; };
	} forEach _misslArr;
};

if (_ammoType == 1) then {
	_wp1 = _grp addWaypoint [_pos, 0];
	_wp1 setWaypointType "SAD";
	_wp1 setWaypointCompletionRadius 500;
	_wp1 setWaypointSpeed "FULL";
	_wp1 setWaypointFormation "WEDGE";
	_wp1 setWaypointBehaviour "COMBAT";
	_wp1 setWaypointCombatMode "RED";
	_timeToWait = time + 300;

	waitUntil {
		_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
		_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;
		{ (vehicle _x) setVehicleAmmo 1; } forEach units _grp;
		sleep 0.5;
		!_isAlive || _isAborted || time > _timeToWait
	};
};

[_isAlive, _isAborted]
