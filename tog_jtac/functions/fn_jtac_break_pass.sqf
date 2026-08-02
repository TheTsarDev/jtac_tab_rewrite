//////////////////////////////

//	Advanced JTAC module	//

//		bys SUSHI			//

//	all rights reserverd	//

//		www.armatog.com		//

//////////////////////////////





_grp = _this select 0;

_callsign = _this select 1;

_grpType = _this select 2;

_typeCas = _this select 3;

_maxPassNumber = _this select 4;

_mrkIpPos = _this select 5;

_mrkTgt = _this select 6;



_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;

_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;



if (_isAlive && !_isAborted) then {



	_grp setVariable ["TOG_jtac_passState", "", true];



	//// Dodanie WP

	_wp = _grp addWaypoint [_mrkIpPos,0];

	_wp setWaypointType "MOVE";

	_wp setWaypointCompletionRadius 800;

	_wp setWaypointSpeed "FULL";

	_wp setWaypointFormation "WEDGE";

	_wp setWaypointBehaviour "CARELESS";

	_wp setWaypointCombatMode "BLUE";



	_timeToWait = time + 180;

	sleep 5;

	leader _grp sideChat format["%1 %4. %5",[] call TOG_fnc_jtac_operatorGroupId,(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_CONFIRM_HIT'),(localize 'STR_RADIO_OVER')];



	_actionText = "<t color='#c48214'>" + (localize "STR_CONFIRM_HITNOT") + "</t>";

	_actionVal = false;

	if (_maxPassNumber > 0) then {

		_actionText = "<t color='#c48214'>" + (localize "STR_CONFIRM_HITNOT") + "/" + (localize "STR_REQUEST_PASS") + "</t>";

		_actionVal = true;

	};



	["TOG_fnc_jtac_client_addBreakPassActions", [_grp, _actionText, _actionVal]] call TOG_fnc_jtac_execOnOperator;



	//czekaj...

	waitUntil {

		_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;

		sleep 0.2;



		private _passState = _grp getVariable ["TOG_jtac_passState", ""];

		_passState in ["hit", "nextPass", "notHit"]

		|| time > _timeToWait

		|| !_isAlive

		|| (!isNull TOG_jtac_operator && {(!alive TOG_jtac_operator) || (!isPlayer TOG_jtac_operator)})

	};



	["TOG_fnc_jtac_client_removeActions", ["breakPass"]] call TOG_fnc_jtac_execOnOperator;



	private _passState = _grp getVariable ["TOG_jtac_passState", ""];



	//nastepny przelot?

	if (_passState == "nextPass" && _isAlive) then {

		leader _grp sideChat format["%3 %4. %5",[] call TOG_fnc_jtac_operatorGroupId,(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_MAKING_PASS'),(localize 'STR_RADIO_OVER')];



		private _mrkTgtPos = if (typeName _mrkTgt == "ARRAY") then {_mrkTgt} else {getMarkerPos _mrkTgt};



		waitUntil {

			sleep 0.2;

			([leader _grp, _mrkTgtPos] call BIS_fnc_distance2D > 300) || ({alive _X} count (units _grp) < 1)

		};



		false



	} else {

		if (_passState == "notHit") then {

			leader _grp sideChat format["%1 %4. %5",[] call TOG_fnc_jtac_operatorGroupId,(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_NO_FUEL'),(localize 'STR_RADIO_OVER')];

		};



		true

	};



} else {

	true

};

