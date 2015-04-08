// Configure TFAR
tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

rushProtectionTime = ["SetupTime", 180] call BIS_fnc_getParamValue;
actualTime = 0;

// Handle victory conditions.
[] spawn {
	if (!hasInterface) exitWith {};

	while { true } do {
		sleep 4;

		if ({side _x == east && alive _x} count allUnits == 0) exitWith {
            [["WestWon", true, true], "BIS_fnc_endMission", west] call BIS_fnc_MP;
			[["loser", true, true], "BIS_fnc_endMission", east] call BIS_fnc_MP;
		};

		if ({side _x == west && alive _x} count allUnits == 0) exitWith {
            [["EastWon", true, true], "BIS_fnc_endMission", east] call BIS_fnc_MP;
			[["loser", true, true], "BIS_fnc_endMission", west] call BIS_fnc_MP;
		};
	};
};

// Display countdown until mission start.
[] spawn {
	private ["_timeLeft", "_countdownText"];
	if (!hasInterface) exitWith {};

	if (side player == west) then {
		_countdownText = "Mission starts in %1";
	} else {
		_countdownText = "Hurry! The americans will move in %1";
	};

	while { actualTime < rushProtectionTime } do {
		actualTime = if (ismultiplayer) then {servertime} else {time};
		_timeLeft = (rushProtectionTime - actualTime);
		if (_timeLeft < 0) then { _timeLeft = 0; };

		hintSilent format[_countdownText, ([_timeLeft, "M:SS"] call CBA_fnc_formatElapsedTime)];
		sleep 0.5;
	};

	if (side player == west) then {
		hint "Mission is a go!";
	} else {
		hint "The americans are moving! Prepare for battle.";
	};
};