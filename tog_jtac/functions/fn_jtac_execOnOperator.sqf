//////////////////////////////
//	Advanced JTAC module	//
//		bys SUSHI			//
//	all rights reserverd	//
//		www.armatog.com		//
//////////////////////////////

// Run a registered function on the JTAC operator's machine (local call on host, remoteExec on dedicated)
params ["_functionName", "_args"];

private _operator = TOG_jtac_operator;
if (isNull _operator) exitWith {false};

if (local _operator) then {
	_args call (missionNamespace getVariable [_functionName, {}]);
} else {
	_args remoteExec [_functionName, _operator];
};

true
