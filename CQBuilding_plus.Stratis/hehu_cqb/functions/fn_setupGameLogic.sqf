private ["_logic", "_triggers", "_soldierTypes", "_positions", "_numberOfEnemies", "_enemyPatrols", "_enemyCombatMode"];


_logic = _this select 0;
// TODO: Make optional
_numberOfEnemies = _this select 1;
_enemyPatrols = _this select 2;
_enemyCombatMode = _this select 3;

_soldierTypes = [_logic] call HEHU_CQB_fnc_inferEnemyUnits;

_triggers = [];
{
	if (_x isKindOf "EmptyDetector") then {
		_triggers = _triggers + [_x];
	};
} foreach (synchronizedObjects _logic);


//
// Read all positions
//
_positions = (
	[
		_triggers call HEHU_CQB_fnc_getBuildingPositionsInTriggerAreas
	] call CBA_fnc_shuffle
);

// Just in case the building don't have that many enemies.
if (_numberOfEnemies > (count _positions)) then {
	_numberOfEnemies = (count _positions);
};

//
// Spawn units
//
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