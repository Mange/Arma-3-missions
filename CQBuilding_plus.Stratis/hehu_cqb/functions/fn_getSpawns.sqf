private ["_logics", "_spawns"];

_logics = _this select 0;

_spawns = [];
{
	_spawns = _spawns + (_x call HEHU_CQB_fnc_getSpawnsInLogic)
} foreach _logics;

[_spawns] call CBA_fnc_shuffle
