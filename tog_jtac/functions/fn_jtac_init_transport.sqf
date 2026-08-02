//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_init_transport

if (isServer) then {
	waitUntil { sleep 0.1; TOG_jtac_enable && !TOG_jtac_Trans_Heli_arr_busy };
	TOG_jtac_Trans_Heli_arr_busy = true;
};
/* MODULE VERSION */
_logic = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_callsign = (_logic getVariable "callsign");
_vehicleClass = (_logic getVariable "vehicleClass");
_custom = false;
if (_vehicleClass == "custom") then { _vehicleClass = (_logic getVariable "vehicleClassCustom");  _custom = true;};
_escortVehicleClass = (_logic getVariable "vehicleClassE");
if (_escortVehicleClass == "custom") then { _escortVehicleClass = (_logic getVariable "vehicleClassCustomE");};
_maxTransNumber = (_logic getVariable "maxTransNumber");
_thisModulePosition = getPos _logic;
_thisModule = _logic;
_typeTrans = 2; //2-Plane
/* END MODULE VERSION*/


/* SCRIPT VERSION
_logic = transArr;
_callsign = "Transpot Callsign";
_vehicleClass = "B_Heli_Transport_01_F";
_custom = false;
if (_vehicleClass == "custom") then { _vehicleClass = (_logic getVariable "vehicleClassCustom");  _custom = true;};
_escortVehicleClass = "B_Heli_Attack_01_F";
if (_escortVehicleClass == "custom") then { _escortVehicleClass = (_logic getVariable "vehicleClassCustomE");};
_maxTransNumber = 10;
_thisModulePosition = getPos _logic;
_thisModule = _logic;
_typeTrans = 2; //2-heli
END SCRIPT VERSION */

if (isServer) then {
//Tworzenie tablicy
	_thisModuleArr = [_typeTrans,_callsign, _vehicleClass, _maxTransNumber, _thisModulePosition, _thisModule,_escortVehicleClass,[],_custom];
	TOG_jtac_Trans_Heli_arr = TOG_jtac_Trans_Heli_arr + [_thisModuleArr];
	publicVariable "TOG_jtac_Trans_Heli_arr";
	TOG_jtac_Trans_Heli_arr_busy = false;
};

if (_maxTransNumber > 0) then {
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