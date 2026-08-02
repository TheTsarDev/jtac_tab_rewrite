//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_CAS_callsign

params [["_delMark", false, [true]]];

_display = uiNamespace getVariable "TOG_jtac_cas_dlg";
if (isNull _display) exitWith {false};

_callSignList = _display displayCtrl 1004;
_size = lbSize _callSignList;
_selectedCallSign = lbCurSel _callSignList;
_callsign = _callSignList lbText _selectedCallSign;
_casType = _callSignList lbValue _selectedCallSign;

TOG_jtac_CAS_type = _casType;
TOG_jtac_CAS_callsign = _callsign;

if (_delMark) then {
	for [{_i = 0},{_size > _i},{_i = _i + 1}] do {
		_callsign = _callSignList lbText _i;
		if (_callsign in TOG_jtac_Requested_arr) then {} else {
			{
				_mrk_name = _callsign + _x;
				_distMrkName = _mrk_name + "dist";
				deleteMarker _mrk_name;
				deleteMarker _distMrkName;
			} foreach ["TGT","IP","FRIENDS"];
		};
	};
};

_ammoPlane = _display displayCtrl 1011;
_ammoHeli = _display displayCtrl 1013;
if (_casType == 1) then {_ammoHeli ctrlShow false; _ammoPlane ctrlShow true; };
if (_casType == 2) then {_ammoHeli ctrlShow true; _ammoPlane ctrlShow false; };

true
