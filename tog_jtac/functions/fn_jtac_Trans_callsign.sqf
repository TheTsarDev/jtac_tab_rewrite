//////////////////////////////
//      JTAC TAB RW         //
//       by Tsardev         //
//     version 1.5.3        //
//////////////////////////////

	//fn_jtac_TRANS_callsign

	_display = uiNamespace getVariable "TOG_jtac_Trans_dlg";
	_callSignList = _display displayCtrl 1004;
	_size = lbSize _callSignList;
	_selectedCallSign = lbCurSel _callSignList;
	_callsign = _callSignList lbText _selectedCallSign;
	_transType = _callSignList lbValue _selectedCallSign;
	_delMark = _this select 0;

	if (typeName _delMark != "BOOL" || isNil "_delMark") then {_delMark = false;};
	TOG_jtac_Trans_type = _transType;
	TOG_jtac_Trans_callsign = _callsign;
	if (_delMark) then {
		for [{_i = 0},{_size > _i},{_i = _i + 1}] do {
			_callsign = _callSignList lbText _i;
			if (_callsign in TOG_jtac_Trans_requested) then {} else {
				{
					_mrk_name = _callsign + _x;
					_distMrkName = _mrk_name + "dist";
					deleteMarker _mrk_name;
					deleteMarker _distMrkName;
				} foreach ["PICK","DEST"];
			};
		};
	};