//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_CAS_changeMrkDir

if (isNil "TOG_jtac_CAS_mrkIp") exitWith {};
_display = uiNamespace getVariable "TOG_jtac_cas_dlg";
_headingList = _display displayCtrl 10013;
_selectedHeading = lbCurSel _headingList;
_headingVal = _headingList lbValue _selectedHeading;

_dir = switch (_headingVal) do {
	case 0: {0};
	case 1: {45};
	case 2: {90};
	case 3: {135};
	case 4: {180};
	case 5: {225};
	case 6: {270};
	case 7: {315};
	default {0};
};

TOG_jtac_CAS_mrkIp setMarkerDirLocal _dir;
TOG_jtac_CAS_Heading = _dir;

true
