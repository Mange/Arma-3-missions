// TODO: Replace this function with BIS_fnc_buildingPositions
private ["_i", "_loop", "_positions", "_next"];
_loop = true;
_i = 0;
_positions = [];
while {_loop} do {
	_next = _this buildingPos _i;
	if (((_next select 0) == 0) && ((_next select 1) == 0) && ((_next select 2) == 0)) then {
		_loop = false;
	} else {
		_positions = _positions + [_next];
		_i = _i + 1;
	};
};
_positions