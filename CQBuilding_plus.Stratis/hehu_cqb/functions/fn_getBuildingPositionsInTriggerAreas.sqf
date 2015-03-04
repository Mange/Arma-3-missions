private ["_positions", "_triggers", "_buildingsInTrigger"];
_triggers = _this;
_positions = [];

{
	_buildingsInTrigger = [_x] call HEHU_CQB_fnc_getBuildingsInTriggerArea;
	{
		_positions = _positions + (_x call HEHU_CQB_fnc_getAllBuildingPositions);
	} foreach _buildingsInTrigger;
} foreach (_triggers);

_positions