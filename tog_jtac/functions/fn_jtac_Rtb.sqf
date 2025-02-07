//////////////////////////////
//      JTAC TAB RW         //
//       by Tsardev         //
//     version 1.5.3        //
//////////////////////////////

/*
    Input parameters:
    _this = [_grp, _callsign, _grpType, _requestType, _pos]
      _grp         : The group (of units) representing the helicopter/transport.
      _callsign    : The callsign used for radio messages and tracking.
      _grpType     : Type identifier (1 = CAS, else transport).
      _requestType : Differentiates between fixed-wing or rotary-wing (used only if _grpType==1).
      _pos         : The RTB waypoint position (vector3).
*/

params ["_grp", "_callsign", "_grpType", "_requestType", "_pos"];

// Count alive units in the group
private _alive = {alive _x} count (units _grp);

// Setup marker arrays for cleanup and internal tracking
private _arr    = [];
private _mrkArr = [];
if (_grpType == 1) then {
    _mrkArr = ["TGT", "IP", "FRIENDS"];
    switch (_requestType) do {
        case 1: { _arr = TOG_jtac_CAS_Plane_arr; };
        case 2: { _arr = TOG_jtac_CAS_Heli_arr; };
    };
} else {
    _mrkArr = ["PICK", "DEST"];
    _arr    = TOG_jtac_Trans_Heli_arr;
};

// Announce RTB via side chat
if (!isNil "_callsign") then {
    leader _grp sideChat format ["%1 %2 %3 %4. %5", groupId (group player), (localize "STR_RADIO_THISIS"), _callsign, (localize "STR_RADIO_RTB"), (localize "STR_RADIO_OUT")];
};

// Remove any existing waypoints from the group
while { (count (waypoints _grp)) > 0 } do {
    deleteWaypoint ((waypoints _grp) select 0);
};

// Enable AI movement for all group units and their vehicles
{
    _x enableAi "MOVE";
    (vehicle _x) enableAi "MOVE";
} forEach units _grp;

// Set group behavior for RTB
_grp setBehaviour "CARELESS";
_grp setCombatMode "BLUE";

// Create a new RTB waypoint at the specified position
private _wp = _grp addWaypoint [_pos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 500;
_wp setWaypointSpeed "FULL";
_wp setWaypointFormation "WEDGE";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointCombatMode "BLUE";

// Remove any markers associated with this callsign
{
    private _mrk_name    = _callsign + _x;
    private _distMrkName = _mrk_name + "dist";
    deleteMarker _mrk_name;
    deleteMarker _distMrkName;
} forEach _mrkArr;

// Wait until the group leader is within 300m (2D distance) of the RTB waypoint,
// or until the group is effectively destroyed.
waitUntil { ([leader _grp, waypointPosition _wp] call BIS_fnc_distance2D < 300) || (({alive _x} count (units _grp)) < 1) };

// Verify the group is still alive using your custom function.
private _isAlive = [_grp, _callsign, _grpType, _requestType] call TOG_fnc_jtac_ifalive;
if (!_isAlive) exitWith {};

// Retrieve the helicopter object (assumed to be the vehicle of the group leader)
private _heli = vehicle leader _grp;

// **Ensure Safe Landing Before Despawn**
private _helipad = createVehicle ["Land_HelipadEmpty_F", _pos, [], 0, "NONE"];
_helipad setPos _pos;

// Force helicopters to land
if (_heli isKindOf "Helicopter") then {
    _heli land "GET IN";
};

// Wait until all helicopters are on the ground
private _landed = false;
for "_i" from 0 to 10 do {
    sleep 2;
    if ((getPosATL _heli select 2) < 2) exitWith { _landed = true; };
};

// **If landing fails, move helicopter 300m ahead and try again**
if (!_landed) then {
    private _heading    = getDir _heli;
    private _currentPos = getPos _heli;
    private _rad        = _heading * (pi / 180);
    private _newPos     = [
        (_currentPos select 0) + (300 * sin _rad),
        (_currentPos select 1) + (300 * cos _rad),
        _currentPos select 2
    ];

    _heli move _newPos;
    diag_log format ["[JTAC RTB] %1: Helicopter did not land at RTB point, moving extra 300m.", _callsign];

    // Wait again for landing
    sleep 10;
    if ((getPosATL _heli select 2) < 2) then { _landed = true; };
};

// **Ensure AI stops interfering before deletion**
{
    _x disableAI "MOVE";
    (vehicle _x) disableAI "MOVE";
} foreach units _grp;

// **Delete Helicopter & Units**
{
    deleteVehicle (vehicle _x);
    deleteVehicle _x;
} forEach units _grp;

// Remove temporary helipad
deleteVehicle _helipad;

// Remove this group's callsign from global tracking arrays

// Remove from Requested Array
TOG_jtac_Requested_arr = TOG_jtac_Requested_arr - [_callsign];

// Remove from All Groups Array
{
    if ((_x select 0) == _callsign) then {
        TOG_jtac_All_Groups_arr = TOG_jtac_All_Groups_arr - [_x];
    };
} forEach TOG_jtac_All_Groups_arr;

// Remove from Abort Codes Array
{
    if ((_x select 0) == _callsign) then {
        TOG_jtac_AbortCodes_arr = TOG_jtac_AbortCodes_arr - [_x];
        publicVariable "TOG_jtac_AbortCodes_arr";
    };
} forEach TOG_jtac_AbortCodes_arr;

// Mark as aborted and remove from Aborted Array
{
    if ((_x select 0) == _callsign) then {
        _isAborted = true;
        TOG_jtac_Aborted_arr = TOG_jtac_Aborted_arr - [_x];
    };
} forEach TOG_jtac_Aborted_arr;

// Publish updated arrays for synchronization in multiplayer
publicVariable "TOG_jtac_All_Groups_arr";
publicVariable "TOG_jtac_Requested_arr";
publicVariable "TOG_jtac_AbortCodes_arr";
publicVariable "TOG_jtac_Aborted_arr";
