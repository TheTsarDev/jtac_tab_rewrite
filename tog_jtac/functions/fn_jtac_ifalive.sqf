//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

_grp = _this select 0;
_callsign = _this select 1;
_grpType = _this select 2;
_requestType = _this select 3;
_alive = {alive _X} count (units _grp);
_arr = [];
_mrkArr = [];
if (_grpType == 1) then {
	_mrkArr = ["TGT","IP","FRIENDS"];
	switch (_requestType) do {
		case 1:{
			_arr = TOG_jtac_CAS_Plane_arr;
		};
		case 2: {
			_arr = TOG_jtac_CAS_Heli_arr;
		};
	};
} else {
	_mrkArr = ["PICK","DEST"];
	_arr = TOG_jtac_Trans_Heli_arr;
};


// USUWANIE
if (_alive > 0) then {
	true
} else {
	//TALK
	leader _grp sideChat format["%1 %2 %3 %4 [...]",groupId (group player),(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_TAKINGFIRE')];
	{
		_mrk_name = _callsign + _x;
		_distMrkName = _mrk_name + "dist";
		deleteMarker _mrk_name;
		deleteMarker _distMrkName;
	} foreach _mrkArr;

		{
			if (_x select 1 == _callsign) then {
				_arr = _arr - [_x];
				if (_grpType == 1) then {
					if (_requestType == 1) then {
						TOG_jtac_CAS_Plane_arr = _arr;
						publicVariable "TOG_jtac_CAS_Plane_arr";
					} else {
						if (_requestType == 2) then {
							TOG_jtac_CAS_Heli_arr = _arr;
							publicVariable "TOG_jtac_CAS_Heli_arr";
						};
					};
				} else {
					TOG_jtac_Trans_Heli_arr = _arr;
					publicVariable "TOG_jtac_Trans_Heli_arr";
				};

			TOG_jtac_Requested_arr = TOG_jtac_Requested_arr -[_callsign];
			{
				if (_x select 0 == _callsign) then {TOG_jtac_All_Groups_arr = TOG_jtac_All_Groups_arr - [_x];};
			} foreach TOG_jtac_All_Groups_arr;

			if (TOG_jtac_respawn_enable > 0) then {
				[_x,_grpType,_requestType] spawn {
					_delArr = _this select 0;
					_grpType = _this select 1;
					_requestType = _this select 2;
					sleep TOG_jtac_respawn_enable;

					if (_grpType == 1) then {
						if (_requestType == 1) then {
							TOG_jtac_CAS_Plane_arr = TOG_jtac_CAS_Plane_arr + [_delArr];
							publicVariable "TOG_jtac_CAS_Plane_arr";
						} else {
							TOG_jtac_CAS_Heli_arr = TOG_jtac_CAS_Heli_arr + [_delArr];
							publicVariable "TOG_jtac_CAS_Heli_arr";
						};
					} else {
						TOG_jtac_Trans_Heli_arr = TOG_jtac_Trans_Heli_arr + [_delArr];
						publicVariable "TOG_jtac_Trans_Heli_arr";
					};

					true
				};
			};
		};
	} forEach _arr;

	{
		if (_x select 0 == _callsign) then {
			TOG_jtac_AbortCodes_arr = TOG_jtac_AbortCodes_arr - [_x];
			publicVariable "TOG_jtac_AbortCodes_arr";
		};
	} foreach TOG_jtac_AbortCodes_arr;

	publicVariable "TOG_jtac_All_Groups_arr";
	publicVariable "TOG_jtac_AbortCodes_arr";
	publicVariable "TOG_jtac_Requested_arr";
	hint format["%1 is destroyed",_callsign];

	false

};