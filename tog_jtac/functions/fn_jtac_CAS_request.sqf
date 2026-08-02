//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_CAS_request
if (isNil "TOG_jtac_CAS_callsign" || isNil "TOG_jtac_CAS_type" || isNil "TOG_jtac_CAS_vehNum" || isNil "TOG_jtac_CAS_markType" || isNil "TOG_jtac_CAS_mrkTgt" || isNil "TOG_jtac_CAS_mrkIp" || isNil "TOG_jtac_CAS_ammoType" ) exitWith {hint (localize "STR_INFO_NODATA");};
if ((TOG_jtac_CAS_callsign in TOG_jtac_Requested_arr) || TOG_jtac_CAS_busy) exitWith {hint (localize "STR_INFO_BUSY");};
if (TOG_jtac_CAS_type == 2 && TOG_jtac_CAS_ammoType == 0 && TOG_jtac_CAS_markType != 1) exitWith {hint (localize "STR_INFO_MUSTBELASER");};
TOG_jtac_CAS_busy = true;
publicVariable "TOG_jtac_CAS_busy";


//zmienne

_display = uiNamespace getVariable "TOG_jtac_cas_dlg";
_elev = _display displayCtrl 1009;
_elevVal = ctrlText _elev;
_elevVal = parseNumber _elevVal;
_abortCode =_display displayCtrl 200004;
_abortCodeVal = ctrlText _abortCode;
_len = count (toArray _abortCodeVal);
_finalArr = [];
_arr = [];
_maxCasNumber = 0;
_canSpawn = false;

//ustalanie tablicy
switch (TOG_jtac_CAS_type) do {
	case 1: {
		_arr = TOG_jtac_CAS_Plane_arr;
	};
	case 2: {
		_arr = TOG_jtac_CAS_Heli_arr;
	};
};

//wybieranie tablicy
{
	_callsign = _x select 1;
	if (_callsign == TOG_jtac_CAS_callsign) then {
		_maxCasNumber = _x select 3;
		if (_maxCasNumber >= TOG_jtac_CAS_vehNum) then {
			_newMaxCasNumber = _maxCasNumber - TOG_jtac_CAS_vehNum;
			_x set [3, _newMaxCasNumber];
			_finalArr = _x;
			_canSpawn = true;
		} else {
			hint (localize "STR_INFO_MAXCAS_REACHED");
		};
	};
} foreach _arr;

//upublicznianie tablicy
if (TOG_jtac_CAS_type == 1) then {publicVariable "TOG_jtac_CAS_Plane_arr";} else {
	if (TOG_jtac_CAS_type == 2) then {publicVariable "TOG_jtac_CAS_Heli_arr";};
};

if (_canSpawn) then {
	_mrkTgtPos = getMarkerPos TOG_jtac_CAS_mrkTgt;
	_mrkIpPos = getMarkerPos TOG_jtac_CAS_mrkIp;
	//dodawanie do tablicy requested
	TOG_jtac_Requested_arr = TOG_jtac_Requested_arr +[TOG_jtac_CAS_callsign];
	publicVariable "TOG_jtac_Requested_arr";

	//dodawanie do tablicy abort code
	if (_len > 0) then {
		_arr = [TOG_jtac_CAS_callsign, _abortCodeVal];
		TOG_jtac_AbortCodes_arr = TOG_jtac_AbortCodes_arr + [_arr];
		publicVariable "TOG_jtac_AbortCodes_arr";
	};

	//Tworzenie
	_spawnArgs = [_finalArr,TOG_jtac_CAS_vehNum,TOG_jtac_CAS_markType,TOG_jtac_CAS_mrkTgt,TOG_jtac_CAS_mrkIp,TOG_jtac_CAS_ammoType, TOG_jtac_CAS_Heading,_elevVal, player, _mrkTgtPos, _mrkIpPos];
	if (isDedicated) then {
		_spawnArgs remoteExec ["TOG_fnc_jtac_CAS_spawnPlane", 2];
	} else {
		_spawnArgs spawn TOG_fnc_jtac_CAS_spawnPlane;
	};
	hint (localize "STR_INFO_REQESTSEND");
};

//koniec
TOG_jtac_CAS_busy = false;
publicVariable "TOG_jtac_CAS_busy";

true
