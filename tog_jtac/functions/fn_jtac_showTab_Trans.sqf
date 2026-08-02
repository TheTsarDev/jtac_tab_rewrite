//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_showTab_Trans

disableSerialization;
private ["_TOG_jtac_show_dlg","_display","_i","_type","_picture"];

_TOG_jtac_show_dlg = createDialog "TOG_jtac_trans_dlg";
_display = uiNamespace getVariable "TOG_jtac_trans_dlg";

TOG_jtac_Trans_selectPos = 0; //0- PU, 1- DEST
TOG_jtac_Trans_vehNum = 1;
TOG_jtac_Trans_sequrity = 0; //0 -safe , 1-Possibly, 2-Eenemy, 3-escort
TOG_jtac_Trans_markType = 0; //0 - none, 1 - dym
TOG_jtac_Trans_mrkPick = nil;
TOG_jtac_Trans_mrkDest = nil;

//Sprawdzanie czy noc
_date = date;
_h = _date select 3;

if (_h > TOG_jtac_sunrise && _h < TOG_jtac_sunset) then { TOG_jtac_daytime = 1; } else { TOG_jtac_daytime = 2; }; //1 - day 2 - night

//callsign
_i = 0;
{
	{
		if (_x select 3 > 0) then {
			_type = _x select 2;
			_picture = getText (configFile >> "cfgVehicles" >> _type >> "picture");

			lbAdd[1004,( _x select 1)];
			lbSetValue[1004,_i,(_x select 0)];
			lbSetPicture[1004,_i,_picture];
			_i = _i + 1;
		};
	} foreach _x;
} foreach [TOG_jtac_Trans_Heli_arr];

//security of pickup
_i = 0;
{
	lbAdd[1008,_x];
	lbSetValue[1008,_i,_i];
	_i = _i + 1;
} forEach [(localize "STR_TRANS_SEQ_N"),(localize "STR_TRANS_SEQ_P"),(localize "STR_TRANS_SEQ_E"),(localize "STR_TRANS_SEQ_X")];

//Marker
_markersArr = [(localize "STR_NONE"),(localize "STR_SMOKE")];
if (TOG_jtac_daytime == 2) then {
	_markersArr = [(localize "STR_NONE"),(localize "STR_LIGHTSTICK")];
};
_i = 0;
{
	lbAdd[1010,_x];
	lbSetValue[1010,_i,_i];
	_i = _i + 1;
} forEach _markersArr;

//Ustawianie pierwszych wartosci
{lbSetCurSel[_x,0]} foreach [1003,1004,1008,1010];

[_display] call TOG_fnc_jtac_Trans_onMapClick;