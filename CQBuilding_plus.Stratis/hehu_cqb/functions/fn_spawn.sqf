private ["_spawns", "_numberOfEnemies", "_enemyPatrols", "_enemyAlertness", "_spawn", "_position", "_soldierType", "_patrolPositions"];

_spawns = _this select 0;
_numberOfEnemies = _this select 1;
_enemyPatrols = _this select 2;
_enemyAlertness = _this select 3;

if (count _spawns < _numberOfEnemies) then {
	_numberOfEnemies = count _spawns;
};

for "_i" from 0 to (_numberOfEnemies - 1) do {
	_spawn = _spawns select _i;

    _position = _spawn select 0;
    _soldierType = _spawn select 1;
    _patrolPositions = _spawn select 2;

    _unit = [_soldierType, _position] call HEHU_CQB_fnc_spawnUnit;
    _unit setCombatMode _enemyCombatMode;

    if (_i < _enemyPatrols) then {
    	[_unit, _position, _patrolPositions] call HEHU_CQB_fnc_setupPatrol;
    };

    sleep 0.1;
};