private ["_loop", "_totalEnemies"];

_loop = true;
while {_loop} do {
	_totalEnemies = [] call HEHU_CQB_fnc_aliveEnemies;
	if (_totalEnemies == 1) then {
		hintSilent parseText "ONLY <t color='#ff0000'>1</t> ENEMY UNIT LEFT";
	} else {
		hintSilent parseText format["THERE ARE <t color='#ff0000'>%1</t> ENEMY UNITS LEFT TO KILL", _totalEnemies];
	};

	sleep 2;
	if (_totalEnemies == 0) then {
		//_loop = false;
	};
};
