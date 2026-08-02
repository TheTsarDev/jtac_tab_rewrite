//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_Search_Mark
private ["_markType","_callsign","_mrkTgt","_grp","_searchDist","_lasers","_laser","_tgt","_timeToWait","_isAborted","_smokeConfirmed"];
_markType = _this select 0;
_callsign = _this select 1;
_mrkTgt = _this select 2;
_grp = _this select 3;
_grpType = _this select 4;
_searchDist = 50;
_mrkCenter = if (typeName _mrkTgt == "ARRAY") then {_mrkTgt} else {getMarkerPos _mrkTgt};
_lasers = [];
_tgt = objNull;
_timeToWait = time + 180;
_isAborted = false;
_smokeConfirmed = objNull;
if (_grpType == 2) then {_searchDist = 300;};

private _smokeY = "SmokeShellYellow";
private _smokeG = "SmokeShellGreen";
private _smokeR = "SmokeShellRed";
private _smokeP = "SmokeShellPurple";
private _smokeO = "SmokeShellOrange";
private _smokeB = "SmokeShellBlue";

private _smokeYgl = "G_40mm_SmokeYellow";
private _smokeGgl = "G_40mm_SmokeGreen";
private _smokeRgl = "G_40mm_SmokeRed";
private _smokePgl = "G_40mm_SmokePurple";
private _smokeOgl = "G_40mm_SmokeOrange";
private _smokeBgl = "G_40mm_SmokeBlue";

private _item = (localize "STR_SMOKE");

_countShells = 0;
if (TOG_jtac_daytime == 2 && _markType == 2) then {
	_smokeY = "Chemlight_yellow";
	_smokeG = "Chemlight_green";
	_smokeR = "Chemlight_red";
	_smokeP = "";
	_smokeO = "";
	_smokeB = "Chemlight_blue";

	_smokeYgl = _smokeY;
	_smokeGgl = _smokeG;
	_smokeRgl = _smokeR;
	_smokePgl = _smokeP;
	_smokeOgl = _smokeO;
	_smokeBgl = _smokeB;

	_item = (localize "STR_LIGHTSTICK");
};

if (TOG_jtac_daytime == 2 && _markType == 3) then {
	_smokeY = "F_40mm_Yellow";
	_smokeG = "F_40mm_Green";
	_smokeR = "F_40mm_Red";
	_smokeP = "";
	_smokeO = "";
	_smokeB = "";

	_smokeYgl = _smokeY;
	_smokeGgl = _smokeG;
	_smokeRgl = _smokeR;
	_smokePgl = _smokeP;
	_smokeOgl = _smokeO;
	_smokeBgl = _smokeB;
	_searchDist = 500;
	_item = (localize "STR_FLARE");
};

_fnc_offerSmokeAction = {
	params ["_colorKey", "_shell", "_label", "_itemName"];
	private _varName = format ["TOG_jtac_smokeOffer_%1", _colorKey];
	if (leader _grp getVariable [_varName, false]) exitWith {};
	leader _grp setVariable [_varName, true, true];
	private _actionText = format [
		"<t color='#c48214'>%1 - %2 %3</t>",
		localize "STR_SMOKE_CONFIRM",
		_label,
		_itemName
	];
	["TOG_fnc_jtac_client_addSmokeAction", [_shell, _grp, _actionText, _colorKey]] call TOG_fnc_jtac_execOnOperator;
};

////////////////////Start szukania
//////Laser
if (_markType == 1) then {
	waitUntil {
		_lasers = nearestObjects [_mrkCenter, ["LaserTarget"], 1500];
		_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
		if (count _lasers > 0) then {_tgt = _lasers select 0;};
		sleep 0.2;
		!isNull _tgt || _isAborted || {alive _x} count (units _grp) < 1 || time > _timeToWait
	};

} else {
//////DYM

	_countSmoke = {
		private _center = _mrkCenter;
		private _allSmokes = nearestObjects [_center, ["SmokeShell", "SmokeShellVehicle", "G_40mm_Smoke", "Chemlight_yellow", "Chemlight_green", "Chemlight_red", "Chemlight_blue", "F_40mm_Yellow", "F_40mm_Green", "F_40mm_Red"], _searchDist];
		private _smokeYellow = 0;
		private _smokeGreen = 0;
		private _smokeRed = 0;
		private _smokePurple = 0;
		private _smokeOrange = 0;
		private _smokeBlue = 0;

		{
			private _type = typeOf _x;
			if (_type == _smokeY || _type == _smokeYgl || _type isKindOf "SmokeShellYellow") then {
				_smokeYellow = _smokeYellow + 1;
			} else {
				if (_type == _smokeG || _type == _smokeGgl || _type isKindOf "SmokeShellGreen") then {
					_smokeGreen = _smokeGreen + 1;
				} else {
					if (_type == _smokeR || _type == _smokeRgl || _type isKindOf "SmokeShellRed") then {
						_smokeRed = _smokeRed + 1;
					} else {
						if (_smokeP != "" && {_type == _smokeP || _type == _smokePgl || _type isKindOf "SmokeShellPurple"}) then {
							_smokePurple = _smokePurple + 1;
						} else {
							if (_smokeO != "" && {_type == _smokeO || _type == _smokeOgl || _type isKindOf "SmokeShellOrange"}) then {
								_smokeOrange = _smokeOrange + 1;
							} else {
								if (_type == _smokeB || _type == _smokeBgl || _type isKindOf "SmokeShellBlue") then {
									_smokeBlue = _smokeBlue + 1;
								};
							};
						};
					};
				};
			};
		} forEach _allSmokes;

		private _smokeShells = _smokeYellow + _smokeGreen + _smokeRed + _smokePurple + _smokeOrange + _smokeBlue;
		[_smokeShells,_smokeYellow,_smokeGreen,_smokeRed,_smokePurple,_smokeOrange,_smokeBlue]
	};

	waitUntil {
		_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
		_takeSmoke = call _countSmoke;
		_smokeShells = _takeSmoke select 0;
		if (_smokeShells > 0) then {
			_smokeYellow = _takeSmoke select 1;
			_smokeGreen = _takeSmoke select 2;
			_smokeRed = _takeSmoke select 3;
			_smokePurple = _takeSmoke select 4;
			_smokeOrange = _takeSmoke select 5;
			_smokeBlue = _takeSmoke select 6;

			if (_smokeYellow > _countShells) then {
				private _shell = nearestObject [_mrkCenter, _smokeY];
				if (isNull _shell) then {_shell = nearestObject [_mrkCenter, _smokeYgl];};
				["Y", _shell, localize "STR_SMOKE_YELLOW", _item] call _fnc_offerSmokeAction;
			};
			if (_smokeGreen > _countShells) then {
				private _shell = nearestObject [_mrkCenter, _smokeG];
				if (isNull _shell) then {_shell = nearestObject [_mrkCenter, _smokeGgl];};
				["G", _shell, localize "STR_SMOKE_GREEN", _item] call _fnc_offerSmokeAction;
			};
			if (_smokeRed > _countShells) then {
				private _shell = nearestObject [_mrkCenter, _smokeR];
				if (isNull _shell) then {_shell = nearestObject [_mrkCenter, _smokeRgl];};
				["R", _shell, localize "STR_SMOKE_RED", _item] call _fnc_offerSmokeAction;
			};
			if (_smokePurple > _countShells) then {
				private _shell = nearestObject [_mrkCenter, _smokeP];
				if (isNull _shell) then {_shell = nearestObject [_mrkCenter, _smokePgl];};
				["P", _shell, localize "STR_SMOKE_PURPLE", _item] call _fnc_offerSmokeAction;
			};
			if (_smokeOrange > _countShells) then {
				private _shell = nearestObject [_mrkCenter, _smokeO];
				if (isNull _shell) then {_shell = nearestObject [_mrkCenter, _smokeOgl];};
				["O", _shell, localize "STR_SMOKE_ORANGE", _item] call _fnc_offerSmokeAction;
			};
			if (_smokeBlue > _countShells) then {
				private _shell = nearestObject [_mrkCenter, _smokeB];
				if (isNull _shell) then {_shell = nearestObject [_mrkCenter, _smokeBgl];};
				["B", _shell, localize "STR_SMOKE_BLUE", _item] call _fnc_offerSmokeAction;
			};
		};

		_smokeConfirmed = leader _grp getVariable ["confrimsmoke", objNull];
		if (!isNull _smokeConfirmed) then {
			["TOG_fnc_jtac_client_removeActions", ["smoke"]] call TOG_fnc_jtac_execOnOperator;
			_tgt = _smokeConfirmed;
		};
		sleep 0.2;
		!isNull _tgt || _isAborted || {alive _x} count (units _grp) < 1 || time > _timeToWait
	};

};

//Koniec sprawdzania
[_tgt,_isAborted];
