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


isHit = false;
notHit = false;
nextPass = false;

_confirmHit = {isHit = true;};
_requestPass = {_val = (_this select 3) select 0; if(_val) then {nextPass = true;} else {notHit = true;}; };

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
				//TALK
				leader _grp sideChat format["%1 %4. %5",groupId (group player),(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_CONFIRM_HIT'),(localize 'STR_RADIO_OVER')];

				_actionText = "<t color='#c48214'>" + (localize "STR_CONFIRM_HITNOT") + "</t>";
				_actionVal = false;
				if (_maxPassNumber > 0) then {_actionText = "<t color='#c48214'>" + (localize "STR_CONFIRM_HITNOT") + "/" + (localize "STR_REQUEST_PASS") + "</t>"; _actionVal = true;};
				_addConfirmHit = [[(localize "STR_CONFIRM_HIT"),_confirmHit,[true]]] call CBA_fnc_addPlayerAction;
				_addRequestPass = [[_actionText,_requestPass,[_actionVal]]] call CBA_fnc_addPlayerAction;


				//czekaj...
				waitUntil {
					_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;
					sleep 0.2;

					isHit || nextPass || notHit || time > _timeToWait || !_isAlive || (!alive TOG_jtac_operator) || (!isPlayer TOG_jtac_operator)
				};

				//usun akcje
				{
					[_x] call CBA_fnc_removePlayerAction;
				} foreach [_addConfirmHit,_addRequestPass];

				//nastepny przelot?
				if (nextPass && _isAlive) then {
					//TALK
					leader _grp sideChat format["%3 %4. %5",groupId (group player),(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_MAKING_PASS'),(localize 'STR_RADIO_OVER')];
					nextPass = false;

					waitUntil {([leader _grp, getMarkerPos _mrkTgt] call BIS_fnc_distance2D > 300) || ({alive _X} count (units _grp) < 1)};

					false

				} else {
					if (notHit) then {leader _grp sideChat format["%1 %4. %5",groupId (group player),(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_NO_FUEL'),(localize 'STR_RADIO_OVER')];};
					isHit = false;
					notHit = false;

					true

				};

} else {
	true
};