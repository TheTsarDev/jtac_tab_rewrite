//////////////////////////////
//      JTAC TAB RW         //
//       by Tsardev         //
//     version 1.5.3        //
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

/* SCRIPT VERSION */
//_units = [heliArr, planeArr, transArr];
//_respawn = 5;
//TOG_jtac_sunrise = 5;
//TOG_jtac_sunset = 0;

/* END SCRIPT VERSION */

// Rejestracja zmiennych
if (TOG_jtac_sunset == 0) then {TOG_jtac_sunset = 24;};
_date = date;
_h = _date select 3;

if (_h > TOG_jtac_sunrise && _h < TOG_jtac_sunset) then { TOG_jtac_daytime = 1; } else { TOG_jtac_daytime = 2; }; //1 - day 2 - night
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

if (isNil "actionAdd") then {actionAdd = true;};

//Dodawanie akcji
if (!isServer && (player != player)) then { waitUntil {player == player}; waitUntil {time > 10}; };
waitUntil {count _units > 0};
TOG_jtac_operator = player;

if (actionAdd) then {
	_actionJTAC = [["<t color='#c48214'>JTAC Tablet</t>",{call TOG_fnc_jtac_tablet_start;},[],0,false,true,"","((vehicle player) == _this) && ({_x in (assignedItems player)}count ['B_UavTerminal','O_UavTerminal','I_UavTerminal'] > 0)"]] call CBA_fnc_addPlayerAction;
	actionAdd = false;
};

// Ensure all players assigned JTAC roles through the module are tracked
if (isServer) then {
    {
        if (_x getVariable ["TOG_isJTAC", false]) then {
            _x setVariable ["TOG_isJTAC", true, true];
        };
    } forEach allPlayers;
};

//Kończenie
TOG_jtac_enable = true;

// Debug message to confirm initialization
diag_log "[JTAC] Initialization completed. All assigned JTACs tracked.";

true
