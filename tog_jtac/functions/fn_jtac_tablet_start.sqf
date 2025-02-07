//////////////////////////////
//      JTAC TAB RW         //
//       by Tsardev         //
//     version 1.5.3        //
//////////////////////////////

//TOG_jtac_tablet_start.sqf
disableSerialization;
private ["_casNumber","_transNumber"];

_casNumber = (count TOG_jtac_CAS_Plane_arr) + (count TOG_jtac_CAS_Heli_arr);
_transNumber = count TOG_jtac_Trans_Heli_arr;
if (_casNumber > 0) exitWith {
	call TOG_fnc_jtac_showTab_CAS;
};

if (_transNumber > 0) exitWith {
	call TOG_fnc_jtac_showTab_Trans;
};