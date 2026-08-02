//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

if (!hasInterface) exitWith {false};

params [["_unit", player, [objNull]]];

if (isNull _unit) exitWith {false};
if (_unit getVariable ["TOG_jtac_actionAdded", false]) exitWith {false};

private _actionId = [[
	"<t color='#c48214'>JTAC Tablet</t>",
	{ call TOG_fnc_jtac_tablet_start; },
	[],
	0,
	false,
	true,
	"",
	"((vehicle player) == _this) && ({_x in (assignedItems player)}count ['B_UavTerminal','O_UavTerminal','I_UavTerminal'] > 0)"]
] call CBA_fnc_addPlayerAction;

_unit setVariable ["TOG_jtac_actionAdded", true, false];
_unit setVariable ["TOG_jtac_tabletActionId", _actionId, false];

true
