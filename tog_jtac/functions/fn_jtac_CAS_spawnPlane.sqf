//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_CAS_spawnPlane

////Zmienne
/*
*[_finalArr,TOG_jtac_CAS_vehNum,TOG_jtac_CAS_markType,TOG_jtac_CAS_mrkTgt,TOG_jtac_CAS_mrkIp,TOG_jtac_CAS_ammoType, TOG_jtac_CAS_Heading,_elevVal]
*Heli: [_typeCas,_callsign,_vehicleClass,_maxCasNumber,_thisModulePosition,_thisModule,_maxPassNumber,_maxAt,_maxAp,_custom]
*Plane: [_typeCas,_callsign, _vehicleClass, _maxCasNumber, _thisModulePosition, _thisModule,_maxPassNumber,[],[],_custom];
*/
private ["_vehArr","_typeCas","_callsign","_vehClass","_vehSpawnPos","_custom","_vehNumber","_markType","_mrkIp","_mrkTgt","_ammoType","_vehHeading","_maxAt","_maxAp","_maxPassNumber","_spawnArr","_grpFlying","_isAborted"];
_vehArr = _this select 0;

_typeCas = _vehArr select 0;
_callsign = _vehArr select 1;
_vehClass = _vehArr select 2;
_vehSpawnPos = _vehArr select 4;
_thisModule =  _vehArr select 5;
_maxPassNumber = _vehArr select 6;
_maxAt = _vehArr select 7;
_maxAp = _vehArr select 8;
_custom = _vehArr select 9;

_vehNumber = _this select 1;
_markType = _this select 2;
_mrkTgt = _this select 3;
_mrkIp = _this select 4;
_elev = _this select 7;
_operator = _this param [8, objNull, [objNull]];
_mrkTgtPos = _this param [9, [], [[]]];
_mrkIpPos = _this param [10, [], [[]]];

if (!isNull _operator) then { TOG_jtac_operator = _operator; };
if (_mrkTgtPos isEqualTo []) then { _mrkTgtPos = getMarkerPos _mrkTgt; };
if (_mrkIpPos isEqualTo []) then { _mrkIpPos = getMarkerPos _mrkIp; };

_ammoType = _this select 5;
_vehHeading = _this select 6;

//uzupełnianie zmiennych
_tgt = objNull;
_spawnArr = [_vehClass,""];
if (_vehNumber > 1) then { _spawnArr = [_vehClass, _vehClass]; };
_vehSpawnPos = [_vehSpawnPos, _vehClass, _custom] call TOG_fnc_jtac_getAirSpawnPos;

_grpFlying = true;
_isAborted = false;
_isAlive = true;
_wpDist = 1500;
_requestType = 1;
_grpType = _requestType;
if (_typeCas == 2) then {_wpDist = 200;};
_alterTgt = if (_markType == 1) then {
	createAgent ["Logic", _mrkTgtPos, [], 0, "CAN_COLLIDE"]
} else {
	createAgent ["Logic", [(_mrkTgtPos select 0) + (random 10) - 10, (_mrkTgtPos select 1) + (random 10) - 10, 0], [], 0, "CAN_COLLIDE"]
};
_fireDist = 250;
if (_typeCas == 1 && _ammoType == 2) then { _fireDist = 3000; } else {
	if (_markType == 1) then { _fireDist = 150; };
};






_breakPlanePass = false;



//////////////////////////////////////Tworzenie

_grp = [_vehSpawnPos, side TOG_jtac_operator,_spawnArr,[[10,30],[40,20]]] call BIS_fnc_spawnGroup;
_grp setGroupId [_callsign];
_grp setBehaviour "CARELESS";
_grp setCombatMode "BLUE";
{
		[_x] spawn {_plane = _this select 0; while {alive (vehicle _plane)} do {_plane action ["CollisionLightOff", (vehicle _plane)]; sleep 1;};};
		_x allowfleeing 0;
} foreach units _grp;
//dodanie do tablicy all groups

_arrAll = [_callsign,_grp,_grpType,_typeCas];
TOG_jtac_All_Groups_arr = TOG_jtac_All_Groups_arr + [_arrAll];
publicVariable "TOG_jtac_All_Groups_arr";
//// Dodanie WP
_wp = _grp addWaypoint [_mrkIpPos,0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 400;
_wp setWaypointSpeed "FULL";
_wp setWaypointFormation "WEDGE";

////Ustawianie pozycji
//custom class fix
if (_custom) then {
	{
		(vehicle _x) engineOn true;
		(vehicle _x) setPosAsl [getPosAsl _x select 0, getPosAsl _x select 1, 3000];
	} foreach units _grp;
};
//jesli samolot i direct
if (_typeCas == 1 && _ammoType == 2) then {
	{
		(vehicle _x) flyInHeight 4900;
		(vehicle _x) setPosAsl [getPosAsl _x select 0, getPosAsl _x select 1, +5000];
	} foreach units _grp;
};

//TALK
leader _grp sideChat format["%1 %2 %3 %4. %5",[] call TOG_fnc_jtac_operatorGroupId,(localize "STR_RADIO_THISIS"),_callsign,(localize 'STR_RADIO_OSCARMIKE'),(localize 'STR_RADIO_OUT')];
////Ustawienie WP

////Dodanie amunicji jesli heli
if (_typeCas == 2 && _ammoType == 0) then {
	{
		(vehicle _x) setVariable ["maxAt",_maxAt,true];
		(vehicle _x) setVariable ["maxAp",_maxAp,true];
	} foreach units _grp;
	heliMaxAt = _maxAt * _vehNumber;
	heliMaxAp = _maxAp * _vehNumber;
	{(vehicle _x) flyinheight ((_elev + 400) max 50); } foreach units _grp;
};

//////////////////////////////////////Lot do IP
while {_grpFlying && _isAlive && !_isAborted} do {
	_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
	_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;
	if ([leader _grp, waypointPosition _wp] call BIS_fnc_distance2D < _wpDist) then {
		_grpFlying = false;
	};
	sleep 0.2;
};

// Hold rotary-wing at IP/BP before target marking and engagement
if (_typeCas == 2 && _isAlive && !_isAborted) then {
	while {(count (waypoints _grp)) > 0} do {
		deleteWaypoint ((waypoints _grp) select 0);
	};
	_holdAlt = (_elev + 400) max 50;
	{ (vehicle _x) flyInHeight _holdAlt; } forEach units _grp;
	_wpHold = _grp addWaypoint [_mrkIpPos, 0];
	_wpHold setWaypointType "LOITER";
	_wpHold setWaypointLoiterRadius 150;
	_wpHold setWaypointSpeed "LIMITED";
	_wpHold setWaypointBehaviour "CARELESS";
	_wpHold setWaypointCombatMode "BLUE";
	if (_vehHeading != 0) then { _grp setFormDir _vehHeading; };
};


////////////////////////////////////Oczekiwanie na oznaczenie celu
_waitForMark = {
	if (_isAlive && !_isAborted) then {
		if (_markType > 0) then {
			//TALK
			leader _grp sideChat format["%3 %5. %6",[] call TOG_fnc_jtac_operatorGroupId,(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_ENTERING'),(localize 'STR_RADIO_MARK'),(localize 'STR_RADIO_OVER')];

			_targetMarked = [_markType,_callsign,_mrkTgtPos,_grp,_grpType] call TOG_fnc_jtac_Search_Mark; // czeka na oznaczenie i potwierdzenie
			_tgt = _targetMarked select 0;
			_isAborted = _targetMarked select 1;
		} else {
			_tgt = _alterTgt;
			_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
		};
	};

	[_tgt, _isAborted];
};



/////////////////////////////////////////ROZPOCZĘCIE ATAKU

if (!_isAborted && _isAlive ) then {
	//TALK
	leader _grp sideChat format["%1 %2 %3 %4. %5",[] call TOG_fnc_jtac_operatorGroupId,(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_ENTERING'),(localize 'STR_RADIO_OVER')];
	// DLA SAMOLOTU
	if (_typeCas == 1) then {
		while {!_breakPlanePass} do {
			//CZEKANIE NA MARK
			_isMarked = [] call _waitForMark;
			_tgt = _isMarked select 0;
			_pos = getPosATL _tgt;
			if (_markType == 1) then { _pos set [2, 0]; };
			_isAborted = _isMarked select 1;
			_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;

			//atak

			if (_isAlive && !_isAborted && !isNull _tgt) then {
				//TALK
				leader _grp sideChat format["%3 %4. %5",[] call TOG_fnc_jtac_operatorGroupId,(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_ENGAGING'),(localize 'STR_RADIO_OUT')];
				_attack = [_typeCas,_elev,_grp,_mrkTgtPos,_callsign,_ammoType,_grpType,_markType,_tgt,_alterTgt,_mrkIpPos,_vehClass,_fireDist,_pos] call TOG_fnc_jtac_CAS_attack_plane;
				_isAlive = _attack select 0;
				_isAborted = _attack select 1;
			};
			//koniec ataku
			if (!isNull _tgt) then {
				_confirmAfter = [_grp,_callsign,_grpType,_typeCas,_maxPassNumber,_mrkIpPos,_mrkTgtPos] call TOG_fnc_jtac_break_pass;
				_breakPlanePass = _confirmAfter;
				if (!_breakPlanePass) then {_maxPassNumber = _maxPassNumber -1;};
			} else {
				_breakPlanePass = true;
			};
			if (_breakPlanePass) exitWith {};

		};
	} else {
		//DLA HELI
		if (_typeCas == 2) then {
			while {!_breakPlanePass} do {
			//CZEKANIE NA MARK
				_isMarked = [] call _waitForMark;
				_tgt = _isMarked select 0;
				_isAborted = _isMarked select 1;
				_pos = getPosATL _tgt;
			if (_markType == 1) then { _pos set [2, 0]; };
				_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;

				//atak
				if (_isAlive && !_isAborted && !isNull _tgt) then {
					//TALK
					leader _grp sideChat format["%3 %4. %5",[] call TOG_fnc_jtac_operatorGroupId,(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_ENGAGING'),(localize 'STR_RADIO_OUT')];
					_attack = [_typeCas,_elev,_grp,_mrkTgtPos,_callsign,_ammoType,_grpType,_markType,_tgt,_alterTgt,_mrkIpPos,_vehClass,_fireDist,_pos] call TOG_fnc_jtac_CAS_attack_heli;
					_isAlive = _attack select 0;
					_isAborted = _attack select 1;
				};
				_breakPlanePass = true;
				// koniec atak

				if (_ammoType == 1 && !isNull _tgt ) then {
					_confirmAfter = [_grp,_callsign,_grpType,_typeCas,_maxPassNumber,_mrkIpPos,_mrkTgtPos] call TOG_fnc_jtac_break_pass;
					_breakPlanePass = _confirmAfter;
					if (!_breakPlanePass) then {_maxPassNumber = _maxPassNumber -1;};

				} else {
					_breakPlanePass = true;
				};

				if (_breakPlanePass) exitWith {};
			};
		};
	};
};




//KONIEC

if(!_isAlive) exitWith {hint format["%1 is destroyed",_callsign]; if (_markType != 1) then { deleteVehicle _tgt; };};
sleep 6;
[_grp,_callsign,_grpType,_typeCas,_vehSpawnPos] spawn TOG_fnc_jtac_Rtb;
if (_markType != 1) then { deleteVehicle _tgt; };

