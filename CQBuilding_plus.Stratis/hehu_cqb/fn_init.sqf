private ["_triggers", "_positions", "_numberOfEnemies", "_enemyAlertness", "_enemyCombatMode", "_enemyPatrols", "_soldierType", "_soldierTypes", "_unit", "_i", "_position"];

if (isServer) then {
	_logics = [_this, 0, [], [[]]] call BIS_fnc_param;

	//
	// Read mission parameters
	//
	_numberOfEnemies = ["NumberOfEnemies", 10] call BIS_fnc_getParamValue;

	_enemyAlertness = ["EnemyAlertness", 0] call BIS_fnc_getParamValue;

	_enemyCombatMode = "YELLOW";
	_enemyPatrols = 0;

	switch(_enemyAlertness) do {
		// Stand still
		case 0: { _enemyCombatMode = "YELLOW"; _enemyPatrols = 0; };
		// Respond to threats
		case 1: { _enemyCombatMode = "RED"; _enemyPatrols = 0; };
		// Some will look for you
		case 2: { _enemyCombatMode = "RED"; _enemyPatrols = _numberOfEnemies * 0.3; };
		// Most will look for you
		case 3: { _enemyCombatMode = "RED"; _enemyPatrols = _numberOfEnemies * 0.6; };
		// All will look for you
		case 4: { _enemyCombatMode = "RED"; _enemyPatrols = _numberOfEnemies; };
	};

	////////////////////////

	{
		// TODO: _numberOfEnemies should be divided amongst the logics
		[_x, _numberOfEnemies, _enemyPatrols, _enemyCombatMode] call HEHU_CQB_fnc_setupGameLogic;
	} forEach _logics;
};


//
// Mission logic loop
//

if (!isServer) then {
	// MP clients should wait on the server to complete all the unit spawning. 15 seconds
	// should be enough, even with high lag and a LOT of units.
	sleep 15;
};

[] spawn HEHU_CQB_fnc_targetCounter;

// Win the game when enemies are killed!
waitUntil { [] call HEHU_CQB_fnc_aliveEnemies == 0; };
sleep 0.5;
["END1", true, 7] call BIS_fnc_endMission;