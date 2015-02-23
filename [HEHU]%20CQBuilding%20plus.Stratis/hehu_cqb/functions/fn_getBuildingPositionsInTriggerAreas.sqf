private ["_positions", "_triggers"];
_triggers = _this;
_positions = [];

{
	_positions = _positions + (_x call HEHU_CQB_fnc_getAllBuildingPositions);
} foreach (_triggers call HEHU_CQB_fnc_getBuildingsInTriggerArea);

_positions