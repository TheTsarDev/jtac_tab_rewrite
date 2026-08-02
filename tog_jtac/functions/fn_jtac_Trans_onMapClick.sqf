//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

["TOG_jtac_Trans_mapClick", "onMapSingleClick", {

		_debug = false;

		[false] call TOG_fnc_jtac_Trans_callsign;

		_callsign = TOG_jtac_Trans_callsign;
		_maxDist = 100;
		if (isNil "TOG_jtac_Trans_mrkPick") then {TOG_jtac_Trans_mrkPick = nil;};
		if (isNil "TOG_jtac_Trans_mrkDest") then {TOG_jtac_Trans_mrkDest = nil;};

		_mrk_ico = "EMPTY";
		_mrk_color = "EMPTY";
		_mrk_name = "EMPTY";
		_mrk_str = "EMPTY";
		switch (TOG_jtac_Trans_selectPos) do {
			case 0: {
				_mrk_ico = "mil_pickup";
				_mrk_color = "ColorGreen";
				_mrk_name = _callsign + "PICK";
				_mrk_str = (localize "STR_PICK_TRANS");
			};
			case 1: {
				_mrk_ico = "mil_end";
				_mrk_color = "ColorBlack";
				_mrk_name= _callsign + "DEST";
				_mrk_str = (localize "STR_DEST_TRANS");
			};
		};
		// TO DO inne Markery

		if (_debug) then {
			hint format["MRK Ico: %1 \nMRK Color: %2 \nMrk Name: %3 \nSelectPos: %4 \nMapPos %5 \nCallsign: %6, \nSelected: %7 \nDisplay: %8", _mrk_ico, _mrk_color, _mrk_name, TOG_jtac_Trans_selectPos, _pos, _callsign, _selectedCallSign, _callSignList];
		};
		deleteMarkerLocal _mrk_name;
		_mrkTxtString = format ["%1 / %2",_mrk_str, _callsign];
		_mrk = createMarkerLocal [_mrk_name, _pos];
		_mrk setMarkerTypeLocal _mrk_ico;
		_mrk setMarkerColorLocal _mrk_color;
		_mrk setMarkerTextLocal _mrkTxtString;

		switch (TOG_jtac_Trans_selectPos) do {
			case 0: {
				TOG_jtac_Trans_mrkPick = _mrk;
				_distMrkName = _mrk_name + "dist";
				deleteMarkerLocal _distMrkName;
				_distMrk = createMarkerLocal [_distMrkName, _pos];
				_distMrk setMarkerShapeLocal "ELLIPSE";
				_distMrk setMarkerSizeLocal[_maxDist, _maxDist];
				_distMrk setMarkerColorLocal "ColorBlack";
				_distMrk setMarkerBrushLocal "Border";

			};
			case 1: {
				TOG_jtac_Trans_mrkDest = _mrk;
			};
		};

		if ((!isNil "TOG_jtac_Trans_mrkPick") && (!isNil "TOG_jtac_Trans_mrkDest")) then {
			_distance = (getMarkerPos TOG_jtac_Trans_mrkPick) distance (getMarkerPos TOG_jtac_Trans_mrkDest);


			if (_distance < _maxDist) then {
				hint (localize "STR_INFO_LOWDISTANCE");
				deleteMarkerLocal TOG_jtac_Trans_mrkDest;
				TOG_jtac_Trans_mrkDest = nil;
			};
		};

	}] call BIS_fnc_addStackedEventHandler;