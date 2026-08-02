//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_init

/* MODULE VERSION */
private ["_logic","_units","_respawn","_actionJTAC"];
_logic = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_units = synchronizedObjects _logic;
_respawn = (_logic getVariable "TOG_jtac_Respawn");
TOG_jtac_sunrise = (_logic getVariable "jtacSunrise");
TOG_jtac_sunset = (_logic getVariable "jtacSunset");
/* END MODULE VERSION*/

// Rejestracja zmiennych
if (TOG_jtac_sunset == 0) then {TOG_jtac_sunset = 24;};
_date = date;
_h = _date select 3;

if (_h > TOG_jtac_sunrise && _h < TOG_jtac_sunset) then { TOG_jtac_daytime = 1; } else { TOG_jtac_daytime = 2; };
if (isNil "TOG_jtac_enable") then {TOG_jtac_enable = false;};
if (isNil "TOG_jtac_respawn_enable") then {TOG_jtac_respawn_enable = _respawn;};
if (isNil "TOG_jtac_CAS_Plane_arr") then {TOG_jtac_CAS_Plane_arr = [];};
if (isNil "TOG_jtac_CAS_Plane_arr_busy") then {TOG_jtac_CAS_Plane_arr_busy = false;};
if (isNil "TOG_jtac_CAS_Heli_arr") then {TOG_jtac_CAS_Heli_arr = [];};
if (isNil "TOG_jtac_CAS_Heli_arr_busy") then {TOG_jtac_CAS_Heli_arr_busy = false;};
if (isNil "TOG_jtac_Trans_Heli_arr") then {TOG_jtac_Trans_Heli_arr = [];};
if (isNil "TOG_jtac_Trans_Heli_arr_busy") then {TOG_jtac_Trans_Heli_arr_busy = false;};
if (isNil "TOG_jtac_Aborted_arr") then {TOG_jtac_Aborted_arr = [];};
if (isNil "TOG_jtac_AbortCodes_arr") then {TOG_jtac_AbortCodes_arr = [];};
if (isNil "TOG_jtac_Requested_arr") then {TOG_jtac_Requested_arr = [];};
if (isNil "TOG_jtac_All_Groups_arr") then {TOG_jtac_All_Groups_arr = [];};
if (isNil "TOG_jtac_CAS_Busy") then {TOG_jtac_CAS_Busy = false;};

if (hasInterface) then {
	if (!isServer && (player != player)) then {
		waitUntil { sleep 0.1; player == player };
		waitUntil { sleep 0.1; time > 10 };
	};
	waitUntil { sleep 0.1; count _units > 0 };

	if (player in _units) then {
		[player] call TOG_fnc_jtac_addTabletAction;
		TOG_jtac_operator = player;

		if (isNil {player getVariable "TOG_jtac_respawnEH"}) then {
			player addEventHandler ["Respawn", {
				params ["_unit", "_corpse"];
				_unit setVariable ["TOG_jtac_actionAdded", false, false];
				[_unit] call TOG_fnc_jtac_addTabletAction;
				TOG_jtac_operator = _unit;
			}];
			player setVariable ["TOG_jtac_respawnEH", true, false];
		};
	};
};

TOG_jtac_enable = true;
publicVariable "TOG_jtac_enable";

true
