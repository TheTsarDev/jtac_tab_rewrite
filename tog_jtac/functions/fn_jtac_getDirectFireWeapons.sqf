//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

// Returns [[weapon, mode], ...] for DIRECT gun runs on fixed-wing aircraft
params ["_plane", ["_planeClass", "", [""]]];

if (_planeClass == "") then { _planeClass = typeOf _plane; };

private _candidates = +weapons _plane;
private _cfg = configFile >> "CfgVehicles" >> _planeClass;

if (isClass _cfg) then {
	{
		if !(_x in _candidates) then { _candidates pushBack _x; };
	} forEach getArray (_cfg >> "weapons");

	{
		{
			if !(_x in _candidates) then { _candidates pushBack _x; };
		} forEach getArray (_x >> "weapons");
	} forEach ("true" configClasses (_cfg >> "Turrets"));
};

private _directTypes = ["machinegun", "cannon", "gun"];
private _excludeTypes = [
	"binocular", "rangefinder", "nvgholder", "unknown",
	"missilelauncher", "rocketlauncher", "mortar", "shotgun", "submachinegun",
	"mask", "vest", "backpack", "uniform", "headgear", "goggles"
];
private _result = [];

{
	private _weapon = _x;
	if (_weapon == "") then {} else {
		private _itemType = toLower ((_weapon call BIS_fnc_itemType) select 1);
		private _isDirect = _itemType in _directTypes;

		if (!_isDirect && {!(_itemType in _excludeTypes)}) then {
			private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
			if (isClass _weaponCfg) then {
				private _magList = getArray (_weaponCfg >> "magazines");
				if (count _magList > 0) then {
					private _magCfg = configFile >> "CfgMagazines" >> (_magList select 0);
					if (isText (_magCfg >> "ammo")) then {
						private _ammoCfg = configFile >> "CfgAmmo" >> getText (_magCfg >> "ammo");
						if (isClass _ammoCfg) then {
							private _sim = toLower getText (_ammoCfg >> "simulation");
							if (_sim in ["shotbullet", "shotshell"]) then {
								_isDirect = true;
							};
						};
					};
				};
			};
		};

		if (_isDirect) then {
			private _modes = getArray (configFile >> "CfgWeapons" >> _weapon >> "modes");
			if (count _modes > 0) then {
				private _mode = _modes select 0;
				if (_mode == "this") then { _mode = _weapon; };
				_result pushBack [_weapon, _mode];
			};
		};
	};
} forEach _candidates;

private _seen = [];
private _final = [];
{
	if !((_x select 0) in _seen) then {
		_seen pushBack (_x select 0);
		_final pushBack _x;
	};
} forEach _result;

_final
