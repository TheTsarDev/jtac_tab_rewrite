//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

_display = uiNamespace getVariable "TOG_jtac_abort_dlg";
_callSignList = _display displayCtrl 1004;
_size = lbSize _callSignList;
_selectedCallSign = lbCurSel _callSignList;
_callsign = _callSignList lbText _selectedCallSign;

_abortCode =_display displayCtrl 200004;
_abortCodeVal = ctrlText _abortCode;
_abortCodeOrig = "";
if (count TOG_jtac_AbortCodes_arr < 1) exitWith {hint "Bad abort code"};
{

			if (_x select 0 == _callsign) then {
				_abortCodeOrig = _x select 1;
			};
} foreach TOG_jtac_AbortCodes_arr;

if (_abortCodeVal == _abortCodeOrig) then {
	TOG_jtac_Aborted_arr = TOG_jtac_Aborted_arr + [[_callsign, _abortCodeVal]];
	publicVariable "TOG_jtac_Aborted_arr";
	hint "Abort request send";
} else {hint "Bad abort code";};