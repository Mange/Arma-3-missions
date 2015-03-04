private ["_totalEnemies"];

while {true} do {
	_totalEnemies = [] call HEHU_CQB_fnc_aliveEnemies;
	if (_totalEnemies == 0) then {
		hintSilent parseText "<t color='#ff0000'>NO</t> ENEMY UNITS LEFT";
	} else {
		if (_totalEnemies == 1) then {
			hintSilent parseText "ONLY <t color='#ff0000'>1</t> ENEMY UNIT LEFT";
		} else {
			hintSilent parseText format["THERE ARE <t color='#ff0000'>%1</t> ENEMY UNITS LEFT TO KILL", _totalEnemies];
		};
	};

	sleep 2;
};
