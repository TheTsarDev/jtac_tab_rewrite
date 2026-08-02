//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

// Safe air spawn position from module XY (modules do not need to sit on a vanilla airfield)
params ["_modulePos", "_vehClass", ["_custom", false, [false]]];

if (_custom) exitWith {[_modulePos select 0, _modulePos select 1, 3000]};

private _cfg = configFile >> "CfgVehicles" >> _vehClass;
private _isHeli = isClass _cfg && {_vehClass isKindOf "Helicopter" || _vehClass isKindOf "Helicopter_Base_F"};
private _minAGL = if (_isHeli) then {100} else {500};

private _xy = [_modulePos select 0, _modulePos select 1];
private _pads = nearestObjects [_modulePos, ["Land_HelipadEmpty_F", "Land_HelipadCircle_F", "Land_Taxiway_F", "Land_Runway_main_F"], 600];

if (count _pads > 0) then {
	private _padPos = getPosATL (_pads select 0);
	_xy = [_padPos select 0, _padPos select 1];
};

private _empty = [_xy select 0, _xy select 1, 0] findEmptyPosition [30, 50, _vehClass];
if (count _empty == 3) then {
	_xy = [_empty select 0, _empty select 1];
};

private _ground = getTerrainHeightASL [_xy select 0, _xy select 1, 0];
[_xy select 0, _xy select 1, _ground + _minAGL]
