 //////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////


//fnc_jtac_Trans_request
if (isNil "TOG_jtac_Trans_callsign" || isNil "TOG_jtac_Trans_type" || isNil "TOG_jtac_Trans_vehNum" || isNil "TOG_jtac_Trans_markType" || isNil "TOG_jtac_Trans_mrkPick" || isNil "TOG_jtac_Trans_mrkDest" || isNil "TOG_jtac_Trans_sequrity") exitWith {hint (localize "STR_INFO_NODATA");};
if ((TOG_jtac_Trans_callsign in TOG_jtac_Requested_arr) || TOG_jtac_Trans_busy) exitWith {hint (localize "STR_INFO_BUSY");};
TOG_jtac_Trans_busy = true;
publicVariable "TOG_jtac_Trans_busy";

//zmienne
_display = uiNamespace getVariable "TOG_jtac_trans_dlg";
_abortCode =_display displayCtrl 200004;
_abortCodeVal = ctrlText _abortCode;
_len = count (toArray _abortCodeVal);
_finalArr = [];
_arr = [];
_maxTransNumber = 0;
_canSpawn = false;

//ustalanie tablicy
_arr = TOG_jtac_Trans_Heli_arr;

//wybieranie tablicy
{
	_callsign = _x select 1;
	if (_callsign == TOG_jtac_Trans_callsign) then {
		_maxTransNumber = _x select 3;
		if (_maxTransNumber >= TOG_jtac_Trans_vehNum) then {
			_newMaxTransNumber = _maxTransNumber - TOG_jtac_Trans_vehNum;
			_x set [3, _newMaxTransNumber];
			_finalArr = _x;
			_canSpawn = true;
		} else {
			hint (localize "STR_INFO_MAXCAS_REACHED");
		};
	};
} foreach _arr;

//upublicznianie tablicy
if (TOG_jtac_Trans_type == 1) then {} else {
	if (TOG_jtac_Trans_type == 2) then {publicVariable "TOG_jtac_Trans_Heli_arr";};
};

if (_canSpawn) then {
	_mrkPickPos = getMarkerPos TOG_jtac_Trans_mrkPick;
	_mrkDestPos = getMarkerPos TOG_jtac_Trans_mrkDest;
	//dodawanie do tablicy requested
	TOG_jtac_Requested_arr = TOG_jtac_Requested_arr +[TOG_jtac_Trans_callsign];
	publicVariable "TOG_jtac_Requested_arr";

	//dodawanie do tablicy abort code
	if (_len > 0) then {
		_arr = [TOG_jtac_Trans_callsign, _abortCodeVal];
		TOG_jtac_AbortCodes_arr = TOG_jtac_AbortCodes_arr + [_arr];
		publicVariable "TOG_jtac_AbortCodes_arr";
	};

	//Tworzenie
	_spawnArgs = [_finalArr,TOG_jtac_Trans_vehNum,TOG_jtac_Trans_markType,TOG_jtac_Trans_mrkPick,TOG_jtac_Trans_mrkDest,TOG_jtac_Trans_sequrity, player, _mrkPickPos, _mrkDestPos];
	if (isDedicated) then {
		_spawnArgs remoteExec ["TOG_fnc_jtac_Trans_spawnVeh", 2];
	} else {
		_spawnArgs spawn TOG_fnc_jtac_Trans_spawnVeh;
	};
	hint (localize "STR_INFO_REQESTSEND");
};

//koniec
TOG_jtac_Trans_busy = false;
publicVariable "TOG_jtac_Trans_busy";

true