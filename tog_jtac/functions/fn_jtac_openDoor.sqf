//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

//fn_jtac_openDoor
_class = _this select 0;
_grp = _this select 1;
_action = _this select 2;

_doors = switch (true) do {
	case (_class == "B_Heli_Transport_01_F"): {["door_R", "door_L"]};
	case (_class == "I_Heli_Transport_02_F"): {["door_back_R", "door_back_L"]};
	case (_class == "B_Heli_Transport_03_F"): {["door_1_1", "door_1_2"]};
	case (_class == "O_Heli_Light_02_F"): {["Cargo_door"]};
	case (_class == "O_Heli_Transport_04_F" || _class == "O_Heli_Transport_04_covered_F"): {["Door_rear"]};
	case (_class == "I_Heli_Transport_03_F"): {["Door_1_source", "Door_2_source"]};
	case (_class == "I_Heli_light_03_dynamicLoadout_F"): {["Door_L", "Door_R"]};
	default {[]};
};

if (count _doors == 0) then {
	private _cfg = configFile >> "CfgVehicles" >> _class;
	if (isClass _cfg) then {
		{
			private _name = configName _x;
			private _lower = toLower _name;
			if (_lower find "door" >= 0 || _lower find "cargo" >= 0) then {
				if !(_name in _doors) then {_doors pushBack _name;};
			};
		} forEach ("true" configClasses (_cfg >> "AnimationSources"));
	};
};

if (count _doors == 0) exitWith {false};

{
	private _veh = vehicle _x;
	{
		if (_x find "_source" >= 0) then {
			_veh animate [_x, if (_action) then {1} else {0}];
		} else {
			_veh animateDoor [_x, _action];
		};
	} forEach _doors;
} forEach units _grp;

true
