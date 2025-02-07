//////////////////////////////
//      JTAC TAB RW         //
//       by Tsardev         //
//     version 1.5.3        //
//////////////////////////////

_grp = (_this select 3) select 0;
					_markType = (_this select 3) select 1;
					_primaryTarget = (_this select 3) select 2;
					_alterTgt = (_this select 3) select 4;
					_laser = nearestObjects [getPos _alterTgt, ["LaserTarget"], 1500];
					_tgt = _laser select 0;
					_planeClass = (_this select 3) select 5;
					if (count _laser < 0) then {
						_markType = 0;
						_tgt = _alterTgt;
					};
					_ammo = (_this select 3) select 3; // 0 - AT ; 1 - AP ; 2 - Cannon
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
							 hint format["AT left:%1",heliMaxAt];
							 if(heliMaxAt < 1) then {[addATMissile] call CBA_fnc_removePlayerAction;};
							} else {
							 _apLeft = _unitToFire getVariable ["maxAp",0]; _apLeft = _apLeft -1; _unitToFire setVariable ["maxAp",_apLeft,false];
							  heliMaxAp = heliMaxAp -1;
							 hint format["AP left:%1",heliMaxAp];
							  if(heliMaxAp < 1) then {[addAPMissile] call CBA_fnc_removePlayerAction;};
							};

							[_unitToFire,_tgt,200,_missile,_markType,"APKWS",_alterTgt] spawn TOG_fnc_jtac_CAS_launchGuided;

						} else {
							if (_ammo == 0) then { [addATMissile] call CBA_fnc_removePlayerAction; } else {[addAPMissile] call CBA_fnc_removePlayerAction;};
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