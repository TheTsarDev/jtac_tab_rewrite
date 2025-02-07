//////////////////////////////
//      JTAC TAB RW         //
//       by Tsardev         //
//     version 1.5.3        //
//////////////////////////////

/*
    JTAC Respawn Handler
    - Ensures JTAC functions persist after player respawn.
    - Automatically restores UAV Terminal if needed.
    - Re-initializes the JTAC tablet ONLY if the player was a JTAC before death.
*/

["playerRespawn", {
    params ["_newUnit", "_oldUnit"];

    // Check if the player was assigned JTAC through the module
    private _isJTAC = _oldUnit getVariable ["TOG_isJTAC", false];

    // If they were NOT JTAC before, do nothing
    if (!_isJTAC) exitWith {
        diag_log format ["[JTAC] Player %1 respawned but was NOT a JTAC before death. No reinitialization performed.", name _newUnit];
    };

    // Restore JTAC status for the new unit
    _newUnit setVariable ["TOG_isJTAC", true, true];

    // Ensure the new player unit still has a UAV Terminal
    if (!("B_UavTerminal" in items _newUnit)) then {
        _newUnit addItem "B_UavTerminal";
    };

    // Reinitialize JTAC functionalities
    [_newUnit] call TOG_fnc_jtac_tablet_start;

    // Debug message for logs
    diag_log format ["[JTAC] Player %1 respawned and JTAC system reinitialized.", name _newUnit];

}] call BIS_fnc_addRespawnHandler;
