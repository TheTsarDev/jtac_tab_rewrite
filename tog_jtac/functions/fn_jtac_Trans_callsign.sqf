//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_TRANS_callsign

params [["_delMark", false, [true]]];

_display = uiNamespace getVariable "TOG_jtac_trans_dlg";
if (isNull _display) exitWith {false};

_callSignList = _display displayCtrl 1004;
_size = lbSize _callSignList;
_selectedCallSign = lbCurSel _callSignList;
_callsign = _callSignList lbText _selectedCallSign;
_transType = _callSignList lbValue _selectedCallSign;

TOG_jtac_Trans_type = _transType;
TOG_jtac_Trans_callsign = _callsign;

if (_delMark) then {
	for [{_i = 0},{_size > _i},{_i = _i + 1}] do {
		_callsign = _callSignList lbText _i;
		if (_callsign in TOG_jtac_Requested_arr) then {} else {
			{
				_mrk_name = _callsign + _x;
				_distMrkName = _mrk_name + "dist";
				deleteMarkerLocal _mrk_name;
				deleteMarkerLocal _distMrkName;
			} foreach ["PICK","DEST"];
		};
	};
};

true
