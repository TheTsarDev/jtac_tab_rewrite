//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

private [
	"_plane", "_primaryTarget", "_alterTgt", "_defaultTargetPos", "_secondaryTarget",
	"_tgt", "_speed", "_markType", "_seconds", "_ammo", "_bomb", "_boom",
	"_travelTime", "_relDirHor", "_relDirVer", "_velocityX", "_velocityY", "_velocityZ",
	"_velocityForCheck", "_startBomb", "_gravity", "_tgtPosASL", "_bombPosASL"
];

_plane = _this select 0;
_primaryTarget = _this select 1;
_speed = _this select 2;
_ammo = _this select 3;
_markType = _this select 4;
_boom = _this select 5;
_alterTgt = _this select 6;

_seconds = 20;
_gravity = 9.81;

// Resolve primary target — laser object or fallback
if (isNull _primaryTarget) then {
	_laser = nearestObjects [getPosATL _alterTgt, ["LaserTarget"], 1500];
	if (count _laser > 0) then {
		_primaryTarget = _laser select 0;
	} else {
		_primaryTarget = _alterTgt;
	};
};

// Fallback marker for when laser/sp smoke is lost mid-flight (no random offset for laser)
if (_markType == 1) then {
	_defaultTargetPos = ASLtoAGL getPosASL _primaryTarget;
} else {
	_defaultTargetPos = [
		(getPosATL _primaryTarget select 0) + (random 20) - 10,
		(getPosATL _primaryTarget select 1) + (random 20) - 10,
		0
	];
};

_secondaryTarget = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
_secondaryTarget setPosATL _defaultTargetPos;
hideObjectGlobal _secondaryTarget;

_tgt = _primaryTarget;

_planeVeh = vehicle _plane;
_bombPos = getPosATL _planeVeh;
_bombPos set [2, (_bombPos select 2) - 2];

_startBomb = createAgent ["Logic", _bombPos, [], 0, "CAN_COLLIDE"];
_bomb = _ammo createVehicle _bombPos;
_bomb setPosATL _bombPos;

// Track live target position each guidance tick
_flyAmmo = {
	_tgtPosASL = if (_markType == 1) then {
		if (!isNull _primaryTarget) then {
			getPosASL _primaryTarget
		} else {
			private _lasers = nearestObjects [ASLtoAGL getPosASL _bomb, ["LaserTarget"], 1500];
			if (count _lasers > 0) then {
				_primaryTarget = _lasers select 0;
				_tgt = _primaryTarget;
				getPosASL _primaryTarget
			} else {
				getPosASL _secondaryTarget
			};
		};
	} else {
		if (!isNull _tgt && {alive _tgt}) then {
			getPosASL _tgt
		} else {
			getPosASL _secondaryTarget
		};
	};

	_bombPosASL = getPosASL _bomb;

	if (_bomb distance2D _tgtPosASL > (_speed / 20)) then {
		_travelTime = (_bombPosASL distance _tgtPosASL) / _speed max 0.1;
		_relDirHor = [_bomb, _tgtPosASL] call BIS_fnc_dirTo;
		_bomb setDir _relDirHor;

		_relDirVer = asin (((_bombPosASL select 2) - (_tgtPosASL select 2)) / (_bombPosASL distance _tgtPosASL) max 0.1);
		[_bomb, _relDirVer * -1, 0] call BIS_fnc_setPitchBank;

		_velocityX = ((_tgtPosASL select 0) - (_bombPosASL select 0)) / _travelTime;
		_velocityY = ((_tgtPosASL select 1) - (_bombPosASL select 1)) / _travelTime;
		// Gravity compensation so bomb doesn't fall short of laser spot
		_velocityZ = ((_tgtPosASL select 2) - (_bombPosASL select 2)) / _travelTime + (0.5 * _gravity * _travelTime);
	};

	[_velocityX, _velocityY, _velocityZ]
};

_velocityX = 0;
_velocityY = 0;
_velocityZ = 0;

call _flyAmmo;

if (_boom == "BOMB" || _boom == "MISSILE") then {
	while {alive _bomb} do {
		_velocityForCheck = call _flyAmmo;
		if ({typeName _x == "SCALAR"} count _velocityForCheck == 3) then {
			_bomb setVelocity _velocityForCheck;
		};
		sleep (1 / _seconds);
	};
} else {
	if (_boom == "CARPET") then {
		sleep 0.02;
		_bomb2 = _ammo createVehicle _bombPos;
		_bomb2 setPosATL _bombPos;
		sleep 0.02;
		_bomb3 = _ammo createVehicle _bombPos;
		_bomb3 setPosATL _bombPos;

		while {alive _bomb && {_bomb distance2D _tgtPosASL > 50}} do {
			_velocityForCheck = call _flyAmmo;
			if ({typeName _x == "SCALAR"} count _velocityForCheck == 3) then {
				_bomb setVelocity _velocityForCheck;
				_bomb2 setVelocity [(_velocityForCheck select 0) - 20, (_velocityForCheck select 1) - 20, _velocityForCheck select 2];
				_bomb3 setVelocity [(_velocityForCheck select 0) + 20, (_velocityForCheck select 1) + 20, _velocityForCheck select 2];
			};
			sleep (1 / _seconds);
		};

		{
			private _pos = getPos _x;
			"SmallSecondary" createVehicle _pos;
			for "_i" from 0 to 24 do {
				private _nade = "Sh_120mm_HE_Tracer_Red" createVehicle _pos;
				_nade setVelocity [-50 + (random 100), -50 + (random 100), -50];
				sleep 0.02;
			};
		} forEach [_bomb, _bomb2, _bomb3];
	};
};

deleteVehicle _startBomb;
deleteVehicle _secondaryTarget;

true
