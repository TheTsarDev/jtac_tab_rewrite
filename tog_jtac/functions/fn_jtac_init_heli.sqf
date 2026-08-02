//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_init_heli

if (isServer) then {
	waitUntil { sleep 0.1; !isNil "TOG_jtac_enable" };
	waitUntil { sleep 0.1; TOG_jtac_enable && !TOG_jtac_CAS_Heli_arr_busy };
	TOG_jtac_CAS_Heli_arr_busy = true;
};

/* MODULE VERSION */
_logic = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_callsign = (_logic getVariable "callsign");
_vehicleClass = (_logic getVariable "vehicleClass");
_custom = false;
if (_vehicleClass == "custom") then { _vehicleClass = (_logic getVariable "vehicleClassCustom");  _custom = true;};
_maxCasNumber = (_logic getVariable "maxCasNumber");
_maxAt = (_logic getVariable "maxAt");
_maxAp = (_logic getVariable "maxAp");
_maxPassNumber = (_logic getVariable "maxPassNum");
_thisModulePosition = getPos _logic;
_thisModule = _logic;
_typeCas = 2; //1-Plane, 2-Heli
 /* END MODULE VERSION*/

 /* SCRIPT VERSION
_logic = heliArr;
_callsign = "Callsign Heli";
_vehicleClass = "B_Heli_Attack_01_F";
_custom = false;
if (_vehicleClass == "custom") then { _vehicleClass = (_logic getVariable "vehicleClassCustom");  _custom = true;};
_maxCasNumber = 10;
_maxPassNumber = 2;
_maxAt = 2;
_maxAp = 4;
_thisModulePosition = getPos _logic;
_thisModule = _logic;
_typeCas = 2; //1-Plane, 2-Heli
END SCRIPT VERSION */

_maxPassNumber = _maxPassNumber -1;
if (isServer) then {
	//Tworzenie tablicy
	_thisModuleArr = [_typeCas,_callsign,_vehicleClass,_maxCasNumber,_thisModulePosition,_thisModule,_maxPassNumber,_maxAt,_maxAp,_custom];
	TOG_jtac_CAS_Heli_arr = TOG_jtac_CAS_Heli_arr + [_thisModuleArr];
	publicVariable "TOG_jtac_CAS_Heli_arr";
	TOG_jtac_CAS_Heli_arr_busy = false;
};

if (_maxCasNumber > 0) then {
	//Tworzenie markera
	_airport = "Airport";
	_mrk_ico = "mil_box";
	_mrk_color = "ColorBlack";
	_mrk_txt =  format ["Airport %1",_callsign];
	_mrk = createMarker [_mrk_txt, _thisModulePosition];
	_mrk setMarkerType _mrk_ico;
	_mrk setMarkerColor _mrk_color;
	_mrk setMarkerText _mrk_txt;
};

true





