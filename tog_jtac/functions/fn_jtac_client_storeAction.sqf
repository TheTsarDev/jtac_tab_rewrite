//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

// Track scroll-wheel action IDs on the JTAC client (category + optional key)
if (!hasInterface) exitWith {false};

params ["_category", "_actionId", ["_key", "", [""]]];

private _store = missionNamespace getVariable ["TOG_jtac_clientActionStore", []];
private _idx = _store findIf {(_x select 0) == _category};

if (_idx < 0) then {
	_store pushBack [_category, []];
	_idx = (count _store) - 1;
};

(_store select _idx) select 1 pushBack [_key, _actionId];
missionNamespace setVariable ["TOG_jtac_clientActionStore", _store];

true
