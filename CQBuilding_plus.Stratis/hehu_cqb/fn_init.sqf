private ["_triggers", "_positions", "_numberOfEnemies", "_enemyAlertness", "_enemyCombatMode", "_enemyPatrols", "_soldierType", "_soldierTypes", "_unit", "_i", "_position"];

_logics = [_this, 0, [], [[]]] call BIS_fnc_param;
// TODO: Support more than one Game Logic.
_logic = _logics select 0;

_triggers = [];
{
	if (_x isKindOf "EmptyDetector") then {
		_triggers = _triggers + [_x];
	};
} foreach (synchronizedObjects _logic);


_soldierTypes = [] call HEHU_CQB_fnc_inferEnemyUnits;

//
// Read all positions
//
_positions = (
	[
		_triggers call HEHU_CQB_fnc_getBuildingPositionsInTriggerAreas
	] call CBA_fnc_shuffle
);

//
// Read mission parameters
//
// TODO: Get this working properly. Global unit limit.
_numberOfEnemies = ["NumberOfEnemies", 10] call BIS_fnc_getParamValue;

// Just in case the building don't have that many enemies.
if (_numberOfEnemies > (count _positions)) then {
	_numberOfEnemies = (count _positions);
};

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

//
// Spawn units
//

if (isServer) then {
	for "_i" from 0 to (_numberOfEnemies - 1) do {
	    _soldierType = _soldierTypes call BIS_fnc_selectRandom;
	    _position = _positions select _i;

	    _unit = [_soldierType, _position] call HEHU_CQB_fnc_spawnUnit;
	    _unit setCombatMode _enemyCombatMode;

	    if (_i < _enemyPatrols) then {
	    	[_unit, (_positions select _i), _positions] call HEHU_CQB_fnc_setupPatrol;
	    };

	    sleep 0.1;
	};
} else {
	// MP clients don't do the loop above and skip right to this point. We
	// should wait until the server is most likely completed.
	sleep 15;
};


//
// Mission logic loop
//
[] spawn HEHU_CQB_fnc_targetCounter;

// Win the game when enemies are killed!
waitUntil { [] call HEHU_CQB_fnc_aliveEnemies == 0; };
//["END1", true, 2] call BIS_fnc_endMission;