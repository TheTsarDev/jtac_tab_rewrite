//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_Abort_check

_callsign = _this select 0;
_isAborted = false;

{
	if (_x select 0 == _callsign) then {
		_isAborted = true;
		TOG_jtac_Aborted_arr = TOG_jtac_Aborted_arr - [_x];
		publicVariable "TOG_jtac_Aborted_arr";
	};
} foreach TOG_jtac_Aborted_arr;

if (!_isAborted) then {
	false
} else {
	{
		if (_x select 0 == _callsign) then {
			TOG_jtac_AbortCodes_arr = TOG_jtac_AbortCodes_arr - [_x];
			publicVariable "TOG_jtac_AbortCodes_arr";
		};
	} foreach TOG_jtac_AbortCodes_arr;

	hint format["%1 mission is aborted",_callsign];

	true
};