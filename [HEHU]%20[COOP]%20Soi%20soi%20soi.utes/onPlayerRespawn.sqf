_player = _this select 0;
_pos = getPosATL _player;

_player setPosATL [
	(_pos select 0),
	(_pos select 1),
	(_pos select 2) + 16
];