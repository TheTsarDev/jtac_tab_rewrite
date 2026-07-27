//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_Trans_spawnVeh

////Zmienne
/*
*[_finalArr,TOG_jtac_Trans_vehNum,TOG_jtac_Trans_markType,TOG_jtac_Trans_mrkPick,TOG_jtac_Trans_mrkDest,TOG_jtac_Trans_sequrity]
*Heli: [_typeTrans,_callsign, _vehicleClass, _maxTransNumber, _thisModulePosition, _thisModule,_escortVehicleClass,[],_custom];
*/
_vehArr = _this select 0;

_typeCas = _vehArr select 0;
_callsign = _vehArr select 1;
_vehClass = _vehArr select 2;
_vehSpawnPos = _vehArr select 4;
_thisModule =  _vehArr select 5;
_escortVehicleClass = _vehArr select 6;
_custom = _vehArr select 8;

_vehNumber = _this select 1;
_markType = _this select 2;
if (_markType > 0) then {_markType =_markType +1;}; // wyrównanie z markerami CAS
_mrkPick = _this select 3;
_mrkDest = _this select 4;
_mrkPickPos = getMarkerPos _mrkPick;
_mrkDestPos = getMarkerPos _mrkDest;
_sequrity = _this select 5;

//uzupełnianie zmiennych
_spawnArr = [_vehClass,""];
_spawnArrE = [_escortVehicleClass,""];
_grpFlying = true;
_isAborted = false;
_isAlive = true;
_requestType = 2;
_grpType = _requestType;
_grp2 = nil;
_altid = 100;
_wpDist = 800;
_tgt = objNull;
_alterTgt = createAgent ["Logic", [(_mrkPickPos select 0) + (random 10), (_mrkPickPos select 1) + (random 10),  0], [] , 0 , "CAN_COLLIDE"];
_grpFlying = true;
_center = [];
_mrkTgt = _mrkPick;
_helipad = objNull;

switch (_sequrity) do {
		case 1: {_altid = 250;};
		case 2: {_altid = 500;};
		case 3: {_altid = 600;};
};


//////////////////////////////////////Tworzenie

_grp = [_vehSpawnPos, side TOG_jtac_operator,_spawnArr] call BIS_fnc_spawnGroup;
_grp setGroupId [_callsign];
_grp setBehaviour "CARELESS";
_grp setCombatMode "BLUE";

//dodanie do tablicy all groups
_arrAll = [_callsign,_grp,_grpType,_typeCas];
TOG_jtac_All_Groups_arr = TOG_jtac_All_Groups_arr + [_arrAll];
publicVariable "TOG_jtac_All_Groups_arr";

/////////Tworzenie eskorty
if (_sequrity == 3) then {
		_grp2 = [_vehSpawnPos, side TOG_jtac_operator,_spawnArrE,[[10,30],[40,20]]] call BIS_fnc_spawnGroup;
		_grp2 setBehaviour "CARELESS";
		_grp2 setCombatMode "BLUE";
		leader _grp setVariable ["TOG_jtac_escortGrp", _grp2, true];

		_wpE = _grp2 addWaypoint [_mrkPickPos,0];
		_wpE setWaypointType "SAD";
		_wpE setWaypointCompletionRadius 300;
		_wpE setWaypointSpeed "FULL";
		_wpE setWaypointFormation "COLUMN";


};

//// Dodanie WP
_wp = _grp addWaypoint [_mrkPickPos,0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 100;
_wp setWaypointSpeed "FULL";
_wp setWaypointFormation "WEDGE";

//Ustawianie swiateł
if (_sequrity > 0) then {
	{
		[_x] spawn {_plane = _this select 0; while {alive (vehicle _plane)} do {_plane action ["CollisionLightOff", (vehicle _plane)];};};
		_x allowfleeing 0;
	} foreach units _grp;
	/*{(vehicle _x) flyinheight _altid; } foreach units _grp;*/
	if (!isNil "_grp2") then {
		{
			[_x] spawn {_plane = _this select 0; while {alive (vehicle _plane)} do {_plane action ["CollisionLightOff", (vehicle _plane)];};};
			_x allowfleeing 0;
		} foreach units _grp2;
	};
};

//ustawianie drzwi
if (_sequrity < 2) then {[_vehClass, _grp, 1] spawn TOG_fnc_jtac_openDoor;};


//TALK
leader _grp sideChat format["%1 %2 %3 %4. %5",groupId (group player),(localize "STR_RADIO_THISIS"),_callsign,(localize 'STR_RADIO_OSCARMIKE'),(localize 'STR_RADIO_OUT')];



//////////////////////////////////////Lot do Pick
//Lot eskorty
if (!isNil "_grp2") then {
		[_grp2, _wpDist,_wp] spawn {
			_grp2 = _this select 0;
			_wpDist = _this select 1;
			_wp = _this select 2;
			waitUntil { [leader _grp2, waypointPosition _wp] call BIS_fnc_distance2D < _wpDist || {alive _X} count (units _grp2) < 1 };
			_grp2 setBehaviour "COMBAT";
			_grp2 setCombatMode "RED";
		};
};

//Lot transportu
while {_grpFlying && _isAlive && !_isAborted} do {
	_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
	_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;
	if ([leader _grp, waypointPosition _wp] call BIS_fnc_distance2D < _wpDist) then {
	_grpFlying = false;
	};
	sleep 0.2;
};

////////////////////////////////////Oczekiwanie na oznaczenie celu
_waitForMark = {
	if (_isAlive && !_isAborted) then {
		if (_markType > 0) then {
			//TALK
			leader _grp sideChat format["%3 %5. %6",groupId (group player),(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_ENTERING'),(localize 'STR_RADIO_MARK_LZ'),(localize 'STR_RADIO_OVER')];

			_targetMarked = [_markType,_callsign,_mrkTgt,_grp,_grpType] call TOG_fnc_jtac_Search_Mark; // czeka na oznaczenie i potwierdzenie
			_tgt = _targetMarked select 0;
			_isAborted = _targetMarked select 1;
		} else {
			_tgt = _alterTgt;
			_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
		};
	};

	[_tgt, _isAborted];
};

/////////////////////////////////////////ROZPOCZĘCIE LĄDOWANIA

if (!_isAborted && _isAlive ) then {
	//TALK
	leader _grp sideChat format["%1 %2 %3 %4. %5",groupId (group player),(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_ENTERING'),(localize 'STR_RADIO_OVER')];
	// DLA HELI
	if (_typeCas == 2) then {

		//CZEKANIE NA MARK
		_isMarked = [] call _waitForMark;
		_tgt = _isMarked select 0;
		_center = getPos _tgt;
		_isAborted = _isMarked select 1;
		_isAlive = [_grp,_callsign,_grpType,_typeCas] call TOG_fnc_jtac_ifalive;

		//ladowanie
		if (_isAlive && !_isAborted && !isNull _tgt) then {

			{
				_x allowDamage false; _x setDamage 0;
				(vehicle _x) allowDamage false; (vehicle _x) setDamage 0;
			} foreach units _grp;



			//szukaj pozycji
			_lz = [];
			_lz = _center isFlatEmpty [(sizeOf _vehClass) / 2, 50, 0.7, (sizeOf _vehClass), 0, false, _tgt];
			while {(count _lz) < 1} do {
				_lz = _center isFlatEmpty [(sizeOf _vehClass) / 2, 200, 1, (sizeOf _vehClass), 0, false, _tgt];
			};

			//TALK
			leader _grp sideChat format["%3 %4. %5",groupId (group player),(localize 'STR_RADIO_THISIS'),_callsign,(localize 'STR_RADIO_LANDING'),(localize 'STR_RADIO_OUT')];

			//tworzenie helipada
			_helipad = createVehicle ["Land_HelipadEmpty_F",_lz,[],0,"NONE"];
			_helipad setPos [_lz select 0, _lz select 1, 0];
			//ladowanie wlasciwe
			{ (vehicle _x) land "GET IN";
				//dodatkowe sprawdzanie pozycji
			waitUntil {
				_heli = (vehicle _x);
				_landStatus = landResult _heli;

				if (_landStatus == "NotFound") then {
					_heli move [(getPos _heli select 0) + (random 30), (getPos _heli select 1) + (random 30), getPos _heli select 2];
				};
				waitUntil {unitReady _heli};
				_heli land "GET IN";

				sleep 0.2;

				_landStatus == "Found"
			};


			} foreach units _grp;



			leader _grp setVariable ["waitForLoad", true, true];

			// czekaj az usiądzie
			waitUntil {(getPosAtl leader _grp) select 2 < 5};

			{
				(vehicle _x) flyinheight 0;
			} foreach units _grp;

			//otworz dzwi
			if (_sequrity > 1) then {[_vehClass, _grp, 1] spawn TOG_fnc_jtac_openDoor;};

			// GO action on JTAC operator client
			private _operator = TOG_jtac_operator;
			if (isNull _operator) then { _operator = 0; };
			[_grp] remoteExec ["TOG_fnc_jtac_Trans_vehGo", _operator, false];

		};
		//koniec ladowania

		// czekaj na sygnal GO (default false so we don't hang if landing was skipped)
		if (_isAlive && !_isAborted && !isNull _tgt) then {
			private _loadTimeout = time + 600;
			waitUntil {
				_isAborted = [_callsign] call TOG_fnc_jtac_Abort_check;
				sleep 0.2;
				_isAborted
				|| !(leader _grp getVariable ["waitForLoad", false])
				|| ({alive _x} count (units _grp) < 1)
				|| (time > _loadTimeout)
			};

			if (time > _loadTimeout && {leader _grp getVariable ["waitForLoad", true]}) then {
				hint format ["%1 departing — load timeout", _callsign];
				[_grp] call TOG_fnc_jtac_Trans_vehGoRemoveAction;
			};
		};

		// usun stary helipad
		if (!isNull _helipad) then { deleteVehicle _helipad; };

		{
			_x allowDamage true;
			(vehicle _x) allowDamage true;
			(vehicle _x) flyinheight _altid;
		} foreach units _grp;

		// ruszaj do DEST
		_wp = _grp addWaypoint [_mrkDestPos,0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 100;
		_wp setWaypointSpeed "FULL";
		_wp setWaypointFormation "WEDGE";

		//zamknij drzwi
		if (_sequrity > 1) then {[_vehClass, _grp, 0] spawn TOG_fnc_jtac_openDoor;};

		// jesli eskorta - ruszaj eskorte

		if (!isNil "_grp2") then {
			_grp2 setBehaviour "SAFE";
			_grp2 setCombatMode "YELLOW";
			_wpE = _grp2 addWaypoint [_mrkDestPos,0];
			_wpE setWaypointType "MOVE";
			_wpE setWaypointCompletionRadius 50;
			_wpE setWaypointSpeed "FULL";
			_wpE setWaypointFormation "COLUMN";
		};

		//czekaj na dotarcie
		waitUntil {[leader _grp, waypointPosition _wp] call BIS_fnc_distance2D < 350 || {alive _X} count (units _grp) < 1};

		//szukaj pozycji
		_center = waypointPosition _wp;
		_center = [_center select 0, _center select 1, 0];
		_lz = [];
		_max_distance = (sizeOf _vehClass);

		_lz = _center isFlatEmpty [(sizeOf _vehClass) / 2, 50, 0.7, (sizeOf _vehClass), 0, false, (vehicle leader _grp)];
		while {(count _lz) < 1} do {
			_lz = _center isFlatEmpty [(sizeOf _vehClass) / 2, 200, 1, (sizeOf _vehClass), 0, false, (vehicle leader _grp)];
		};


		//tworzenie helipada
		_helipad = createVehicle ["Land_HelipadEmpty_F",_lz,[],0,"NONE"];
		_helipad setPos _lz;

		//ladowanie wlasciwe
		{ (vehicle _x) land "GET IN";

			waitUntil {
				_heli = (vehicle _x);
				_landStatus = landResult _heli;

				if (_landStatus == "NotFound") then {
					_heli move [(getPos _heli select 0) + (random 30), (getPos _heli select 1) + (random 30), getPos _heli select 2];

				};
				waitUntil {unitReady _heli};
				_heli land "GET IN";

				sleep 0.2;

				_landStatus == "Found"
			};
		} foreach units _grp;


		// czekaj az usiądzie
		waitUntil {(getPosAtl leader _grp) select 2 < 5};
		{
				(vehicle _x) flyinheight 0;
		} foreach units _grp;

		//otworz dzwi
		if (_sequrity > 1) then {[_vehClass, _grp, 1] spawn TOG_fnc_jtac_openDoor;};

		//czekaj 40 sek at destination, then depart automatically
		_timeToWait = time + 40;
		waitUntil {
			time > _timeToWait
			|| ({alive _x} count (units _grp) < 1)
			|| ([_callsign] call TOG_fnc_jtac_Abort_check)
		};
		{
				(vehicle _x) flyinheight _altid;
		} foreach units _grp;


		// usun stary helipad
		deleteVehicle _helipad;
	};
};

if(!_isAlive) exitWith {hint format["%1 is destroyed",_callsign];};
sleep 6;
[_grp,_callsign,_grpType,_typeCas,_vehSpawnPos] spawn TOG_fnc_jtac_Rtb;
