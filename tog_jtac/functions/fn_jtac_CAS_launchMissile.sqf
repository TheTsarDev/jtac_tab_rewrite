//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

// CBA action on client forwards to server; server receives args array directly via remoteExec
if (!isServer) exitWith {
	(_this select 3) remoteExec ["TOG_fnc_jtac_CAS_launchMissile", 2];
};

private _args = _this;
if (count _this >= 4 && {typeName (_this select 3) == "ARRAY"}) then {
	_args = _this select 3;
};

_grp = _args select 0;
_markType = _args select 1;
_primaryTarget = _args select 2;
_alterTgt = _args select 4;
_laser = nearestObjects [getPos _alterTgt, ["LaserTarget"], 1500];
if (count _laser < 1) then {
	_markType = 0;
	_tgt = _alterTgt;
} else {
	_tgt = _laser select 0;
};
_ammo = _args select 3; // 0 - AT ; 1 - AP ; 2 - Cannon
_missile = "";
_unitToFire = objNull;
_atLeft = 0;
_apLeft = 0;
_cannLeft = 0;
switch (_ammo) do {
	case 0: {_missile = "M_Titan_AT";};
	case 1: {_missile = "M_Titan_AP";};
};

if (_ammo == 1 || _ammo == 0 ) then {
	if (_ammo == 0) then {
		{
			_count = (vehicle _x) getVariable ["maxAt",0];
			if (_count > 0) exitWith {
				_unitToFire = (vehicle _x);
			};
		} foreach units _grp;
	} else {
		{
			_count = (vehicle _x) getVariable ["maxAp",0];
			if (_count > 0) exitWith {
				_unitToFire = (vehicle _x);
			};
		} foreach units _grp;
	};

	if (!isNull _unitToFire ) then {
		if (_ammo == 0) then {
			_atLeft = _unitToFire getVariable ["maxAt",0]; _atLeft = _atLeft -1; _unitToFire setVariable["maxAt",_atLeft,false];
			heliMaxAt = heliMaxAt -1;
			[format["AT left:%1", heliMaxAt]] remoteExec ["hint", TOG_jtac_operator];
			if (heliMaxAt < 1) then {
				["TOG_fnc_jtac_client_removeActions", ["heliMissile", "AT"]] call TOG_fnc_jtac_execOnOperator;
			};
		} else {
			_apLeft = _unitToFire getVariable ["maxAp",0]; _apLeft = _apLeft -1; _unitToFire setVariable ["maxAp",_apLeft,false];
			heliMaxAp = heliMaxAp -1;
			[format["AP left:%1", heliMaxAp]] remoteExec ["hint", TOG_jtac_operator];
			if (heliMaxAp < 1) then {
				["TOG_fnc_jtac_client_removeActions", ["heliMissile", "AP"]] call TOG_fnc_jtac_execOnOperator;
			};
		};

		[_unitToFire,_tgt,200,_missile,_markType,"MISSILE",_alterTgt] spawn TOG_fnc_jtac_CAS_launchGuided;
	} else {
		if (_ammo == 0) then {
			["TOG_fnc_jtac_client_removeActions", ["heliMissile", "AT"]] call TOG_fnc_jtac_execOnOperator;
		} else {
			["TOG_fnc_jtac_client_removeActions", ["heliMissile", "AP"]] call TOG_fnc_jtac_execOnOperator;
		};
	};
} else {
	{
		_count = (vehicle _x) getVariable ["maxCann",0];
		if (_count > 0) exitWith {
			_unitToFire = (vehicle _x);
		};
	} foreach units _grp;
	// CANNON - TO DO
};
