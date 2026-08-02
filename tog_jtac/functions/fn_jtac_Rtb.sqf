//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//[_grp,_callsign,_grpType,_typeCas,_vehSpawnPos]

_grp = _this select 0;
_callsign = _this select 1;
_grpType = _this select 2;
_requestType = _this select 3;
_pos = +(_this select 4);
_alive = {alive _x} count (units _grp);
_arr = [];
_mrkArr = [];

if (_grpType == 1) then {
	_mrkArr = ["TGT","IP","FRIENDS"];
	switch (_requestType) do {
		case 1: { _arr = TOG_jtac_CAS_Plane_arr; };
		case 2: { _arr = TOG_jtac_CAS_Heli_arr; };
	};
} else {
	_mrkArr = ["PICK","DEST"];
	_arr = TOG_jtac_Trans_Heli_arr;
};

if ({alive _x} count (units _grp) < 1) exitWith {};

//TALK
if (!isNil "_callsign") then {
	leader _grp sideChat format["%1 %2 %3 %4. %5 ",[] call TOG_fnc_jtac_operatorGroupId,(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_RTB'),(localize 'STR_RADIO_OUT')];
};

// Clean up escort if transport mission stored one
_escortGrp = leader _grp getVariable ["TOG_jtac_escortGrp", grpNull];
if (!isNull _escortGrp) then {
	{ deleteVehicle (vehicle _x); deleteVehicle _x; } forEach units _escortGrp;
};

//Usuwanie waypointów
while {(count (waypoints _grp)) > 0} do {
	deleteWaypoint ((waypoints _grp) select 0);
};

// Re-enable AI and reset attack state
{
	_x enableAi "ALL";
	(vehicle _x) enableAi "ALL";
	(vehicle _x) setFuel 1;
} forEach units _grp;
leader _grp setVariable ["casDirect", false, false];

_grp setBehaviour "CARELESS";
_grp setCombatMode "BLUE";

// RTB altitude for air assets
_isAir = false;
_rtbAlt = 0;
if (_grpType == 1) then {
	_isAir = true;
	_rtbAlt = if (_requestType == 1) then {500} else {150};
} else {
	if (leader _grp isKindOf "Air") then {
		_isAir = true;
		_rtbAlt = 150;
	};
};

if (_isAir) then {
	_pos set [2, (_pos select 2) + _rtbAlt];
	{ (vehicle _x) flyInHeight _rtbAlt; } forEach units _grp;
};

_wp = _grp addWaypoint [_pos,0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 500;
_wp setWaypointSpeed "FULL";
_wp setWaypointFormation "WEDGE";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointCombatMode "BLUE";

//Usuwanie markerow
{
	_mrk_name = _callsign + _x;
	_distMrkName = _mrk_name + "dist";
	deleteMarker _mrk_name;
	deleteMarker _distMrkName;
} forEach _mrkArr;

_rtbTimeout = time + 600;
waitUntil {
	sleep 0.2;
	({alive _x} count (units _grp) < 1)
	|| ([leader _grp, waypointPosition _wp] call BIS_fnc_distance2D < 300)
	|| (time > _rtbTimeout)
};

//Czy nadal żyją
_isAlive = [_grp,_callsign,_grpType,_requestType] call TOG_fnc_jtac_ifalive;
if (!_isAlive) exitWith {};

{
	deleteVehicle (vehicle _x);
	deleteVehicle _x;
} forEach units _grp;

//Usuwanie z tablic
TOG_jtac_Requested_arr = TOG_jtac_Requested_arr - [_callsign];
{
	if (_x select 0 == _callsign) then {TOG_jtac_All_Groups_arr = TOG_jtac_All_Groups_arr - [_x];};
} forEach TOG_jtac_All_Groups_arr;

{
	if (_x select 0 == _callsign) then {
		TOG_jtac_AbortCodes_arr = TOG_jtac_AbortCodes_arr - [_x];
	};
} forEach TOG_jtac_AbortCodes_arr;

{
	if (_x select 0 == _callsign) then {
		TOG_jtac_Aborted_arr = TOG_jtac_Aborted_arr - [_x];
	};
} forEach TOG_jtac_Aborted_arr;

publicVariable "TOG_jtac_All_Groups_arr";
publicVariable "TOG_jtac_Requested_arr";
publicVariable "TOG_jtac_AbortCodes_arr";
publicVariable "TOG_jtac_Aborted_arr";

true
