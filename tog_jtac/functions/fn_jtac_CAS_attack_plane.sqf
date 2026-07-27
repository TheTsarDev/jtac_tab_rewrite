//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_CAS_attack_plane

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


//Atak dla samolotu


if (_elev > 0) then {
	{(vehicle _x) flyInHeight _elev + 250;} foreach units _grp;
};
_wp1 = _grp addWaypoint [_pos,0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointCompletionRadius 10;
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointFormation "WEDGE";

waitUntil {
	_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
	_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;

	sleep 0.2;
	[leader _grp, waypointPosition _wp1] call BIS_fnc_distance2D < _fireDist || _isAborted || !_isAlive
};

if (!_isAborted && _isAlive) then {
	if (_ammoType == 0) then {
		{ [_x,_tgt,200,"Bo_GBU12_LGB",_markType,"BOMB",_alterTgt] spawn TOG_fnc_jtac_CAS_launchGuided; } foreach units _grp;
	};
	if (_ammoType == 1) then {
		{ [_x,_tgt,200,"Bo_GBU12_LGB",_markType,"CARPET",_alterTgt] spawn TOG_fnc_jtac_CAS_launchGuided; sleep 5; } foreach units _grp;
	};
	if (_ammoType == 2) then {
		leader _grp setVariable["casDirect",true,false];
		{ [_x, _tgt, _mrkTgt, _mrkIp, _vehClass,_alterTgt,_callsign] spawn TOG_fnc_jtac_CAS_direct; sleep 8; } foreach units _grp;
		waitUntil {!(leader _grp getVariable["casDirect",true]) || {alive _X} count (units _grp) < 1};
		{
			_x enableAi "MOVE";
			(vehicle _x) enableAi "MOVE";
		} foreach units _grp;
	};
};

if (_ammoType < 0) then { waitUntil {[leader _grp, waypointPosition _wp1] call BIS_fnc_distance2D > _fireDist || {alive _X} count (units _grp) < 1}; };

[_isAlive, _isAborted]
