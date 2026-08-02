//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

// Remove JTAC scroll-wheel actions by category and optional key
if (!hasInterface) exitWith {false};

params [["_category", "all", [""]], ["_key", "", [""]]];

private _store = missionNamespace getVariable ["TOG_jtac_clientActionStore", []];
private _newStore = [];

{
	_x params ["_cat", "_actions"];
	private _remaining = [];

	{
		_x params ["_actionKey", "_actionId"];
		private _remove = (_category == "all") || {_cat == _category && {_key == "" || _actionKey == _key}};
		if (_remove) then {
			[_actionId] call CBA_fnc_removePlayerAction;
		} else {
			_remaining pushBack _x;
		};
	} forEach _actions;

	if (count _remaining > 0) then {
		_newStore pushBack [_cat, _remaining];
	};
} forEach _store;

missionNamespace setVariable ["TOG_jtac_clientActionStore", _newStore];

true
