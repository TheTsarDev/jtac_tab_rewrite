//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

private ["_pos","_planePos","_vectorDir","_velocity","_vectorUp","_fire","_fireNull","_time","_offset","_isAborted","_posASL","_terrainH","_minAGL","_dir","_dis","_alt","_pitch","_speed","_duration","_approachTimeout"];

_pilot = _this select 0;
_plane = vehicle _pilot;
_tgt = _this select 1;
_mrkTgt = _this select 2;
_mrkIp = _this select 3;
_planeClass = _this select 4;
_alterTgt = _this select 5;
_vehCallsign = _this select 6;

{_x allowDamage false} forEach [_pilot, _plane];

if (isNull _tgt) then {
	_laser = nearestObjects [getPos _alterTgt, ["LaserTarget"], 1500];
	if (count _laser > 0) then {
		_tgt = _laser select 0;
	} else {
		_tgt = _alterTgt;
	};
};

_planeCfg = configFile >> "CfgVehicles" >> _planeClass;
if !(isClass _planeCfg) exitWith {
	["Vehicle class '%1' not found", _planeClass] call BIS_fnc_error;
	leader (group _pilot) setVariable ["casDirect", false, false];
	false
};

_weaponTypes = ["machinegun","missilelauncher"];
_weapons = [];
{
	if (toLower ((_x call BIS_fnc_itemType) select 1) in _weaponTypes) then {
		_modes = getArray (configFile >> "CfgWeapons" >> _x >> "modes");
		if (count _modes > 0) then {
			_mode = _modes select 0;
			if (_mode == "this") then { _mode = _x; };
			_weapons pushBack [_x, _mode];
		};
	};
} forEach getArray (_planeCfg >> "weapons");

if (count _weapons == 0) exitWith {
	["No weapon of type 'MachineGun' found on '%1'", _planeClass] call BIS_fnc_error;
	leader (group _pilot) setVariable ["casDirect", false, false];
	false
};

_posASL = getPosASL _tgt;
_terrainH = getTerrainHeightASL _posASL;
_minAGL = 150;
_dir = ((getMarkerPos _mrkTgt select 0) - (getMarkerPos _mrkIp select 0)) atan2 ((getMarkerPos _mrkTgt select 1) - (getMarkerPos _mrkIp select 1));
_dis = [getMarkerPos _mrkTgt, getMarkerPos _mrkIp] call BIS_fnc_distance2D;
_dis = _dis max 500;
_alt = (_dis * 0.15) max _minAGL;
_alt = _alt min 800;
_speed = 400 / 3.6;
_duration = ([0, 0] distance [_dis, _alt]) / _speed max 5;

_pos = +_posASL;
_planePos = [_pos, _dis, _dir + 180] call BIS_fnc_relPos;
_planePos set [2, (_pos select 2) + _alt];

_plane flyInHeight _alt;
_plane move _planePos;

_approachTimeout = time + 120;
waitUntil {
	sleep 0.2;
	([_plane, _planePos] call BIS_fnc_distance2D < 400)
	|| (time > _approachTimeout)
	|| !(alive _plane)
};

if !(alive _plane) exitWith {
	leader (group _pilot) setVariable ["casDirect", false, false];
	false
};

_plane setPosASL _planePos;
_plane move ([_pos, _dis, _dir] call BIS_fnc_relPos);
_plane disableAI "MOVE";
_plane disableAI "TARGET";
_plane disableAI "AUTOTARGET";
_plane setCombatMode "BLUE";

_vectorDir = [_planePos, _pos] call BIS_fnc_vectorFromXtoY;
_velocity = [_vectorDir, _speed] call BIS_fnc_vectorMultiply;
_plane setVectorDir _vectorDir;
[_plane, -90 + atan (_dis / _alt), 0] call BIS_fnc_setPitchBank;
_vectorUp = vectorUp _plane;

{
	if !(toLower ((_x call BIS_fnc_itemType) select 1) in (_weaponTypes + ["countermeasureslauncher"])) then {
		_plane removeWeapon _x;
	};
} forEach weapons _plane;

_fire = [] spawn { waitUntil {false}; };
_fireNull = true;
_time = time;
_offset = if ({_x == "missilelauncher"} count _weaponTypes > 0) then {20} else {0};
_isAborted = [_vehCallsign] call TOG_fnc_jtac_Abort_check;

if (_isAborted) exitWith {
	leader (group _pilot) setVariable ["casDirect", false, false];
	_plane enableAI "MOVE";
	{_x allowDamage true} forEach [_pilot, _plane];
};

waitUntil {
	_fireProgress = _plane getVariable ["fireProgress", 0];

	if ((getPosASL _tgt distance _posASL > 1) && _fireProgress == 0) then {
		_posASL = getPosASL _tgt;
		_pos = +_posASL;
		_planePos = [_pos, _dis, _dir + 180] call BIS_fnc_relPos;
		_planePos set [2, (_pos select 2) + _alt];
		_vectorDir = [_planePos, _pos] call BIS_fnc_vectorFromXtoY;
		_velocity = [_vectorDir, _speed] call BIS_fnc_vectorMultiply;
		_plane setVectorDir _vectorDir;
		_vectorUp = vectorUp _plane;
		_plane move ([_pos, _dis, _dir] call BIS_fnc_relPos);
	};

	// Keep minimum altitude above terrain during the pass
	private _planeASL = getPosASL _plane;
	if ((_planeASL select 2) - (getTerrainHeightASL _planeASL) < _minAGL) then {
		_planeASL set [2, (getTerrainHeightASL _planeASL) + _minAGL];
		_plane setPosASL _planeASL;
	};

	_plane setVelocityTransformation [
		_planePos,
		[_pos select 0, _pos select 1, (_pos select 2) + _offset + _fireProgress * 12],
		_velocity, _velocity,
		_vectorDir, _vectorDir,
		_vectorUp, _vectorUp,
		((time - _time) / _duration) min 1
	];
	_plane setVelocity velocity _plane;

	_isAborted = [_vehCallsign] call TOG_fnc_jtac_Abort_check;
	if (_isAborted) exitWith { true; };

	if ((getPosASL _plane) distance _pos < 1000 && _fireNull) then {
		_fireNull = false;
		terminate _fire;
		_fire = [_plane, _weapons] spawn {
			params ["_plane", "_weapons"];
			private _planeDriver = driver _plane;
			private _duration = 3;
			private _endTime = time + _duration;
			waitUntil {
				{ _planeDriver forceWeaponFire _x; } forEach _weapons;
				_plane setVariable ["fireProgress", (1 - ((_endTime - time) / _duration)) max 0 min 1];
				sleep 0.1;
				time > _endTime || isNull _plane
			};
			sleep 1;
		};
	};

	sleep 0.01;
	scriptDone _fire || isNull _tgt || isNull _plane || (time - _time > _duration + 10)
};

if (_isAborted) exitWith {
	leader (group _pilot) setVariable ["casDirect", false, false];
	_plane enableAI "MOVE";
	{_x allowDamage true} forEach [_pilot, _plane];
};

_plane setVelocity [0, 0, 20];
_plane flyInHeight (_alt + 200);

waitUntil {
	sleep 0.2;
	(getPosATL _plane) select 2 > _alt || !(alive _plane)
};

_plane enableAI "MOVE";
_plane setVehicleAmmo 1;
{_x allowDamage true} forEach [_pilot, _plane];
leader (group _pilot) setVariable ["casDirect", false, false];

true
