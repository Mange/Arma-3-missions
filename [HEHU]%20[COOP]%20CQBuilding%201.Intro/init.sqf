// Configure TFAR
tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

_soldierTypes = [
	"MEC_GME_Rifleman",

	"MEC_GME_Medic",
	"MEC_GME_Crewman",

	"MEC_GME_Marksman",

	"MEC_GME_AutomaticRifleman",
	"MEC_GME_Officer",
	"MEC_GME_GME_RPG7Soldier"
];

_soldierTypeWeights = [
	0.8,

	0.4,
	0.4,

	0.3,

	0.2,
	0.2,
	0.2
];

fn_getAllBuildingPositions = {
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
};

fn_spawnUnit = {
	private ["_type", "_position", "_group", "_unit"];
	_type = _this select 0;
	_position = _this select 1;

	_group = createGroup east;
	_unit = _group createUnit [_type, _position, [], 0, "CAN_COLLIDE"];

    _unit setBehaviour "COMBAT";
    _unit setUnitPos "UP";
    _unit setDir random 360;

    _unit;
};

// Pick a random position and add a waypoint there.
fn_setupPatrol = {
	private ["_unit", "_startingPosition", "_destination_1", "_destination_2", "_wp"];
	_unit = _this select 0;
	_startingPosition = _this select 1;
	_destination_1 = (_this select 2) call BIS_fnc_selectRandom;
	_destination_2 = (_this select 2) call BIS_fnc_selectRandom;

	_wp = (group _unit) addWaypoint [_destination_1, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";

	((group _unit) addWaypoint [_destination_2, 0]) setWaypointType "MOVE";
	((group _unit) addWaypoint [_startingPosition, 0]) setWaypointType "CYCLE";
};

fn_showPlayerOrder = {
	private ["_caller"];
	_caller = _this select 1;

	if (count playerOrder > 0) then {
		_caller globalChat format["%1 drew straws!", name _caller];
		for "_i" from 0 to (count playerOrder) - 1 do {
			_caller globalChat format["%1. %2", (_i + 1), (playerOrder select _i)];
		};
	} else {
		_caller globalChat "Does anyone have any sticks to draw from?";
	};
};

//
// Read all positions
//
_positions = (killhouse_1 call fn_getAllBuildingPositions);
_positions = ([_positions] call CBA_fnc_shuffle);


//
// Read mission parameters
//
_numberOfEnemies = ["NumberOfEnemies", 10] call BIS_fnc_getParamValue;

// Just in case the building don't have that many enemies.
if (_numberOfEnemies > (count _positions)) then {
	_numberOfEnemies = (count _positions);
};

_enemyAlertness = ["EnemyAlertness", 0] call BIS_fnc_getParamValue;

_enemyCombatMode = "YELLOW";
_enemyPatrols = 0;

switch(_enemyAlertness) do {
	// Stand still
	case 0: { _enemyCombatMode = "YELLOW"; _enemyPatrols = 0; };
	// Respond to threats
	case 1: { _enemyCombatMode = "RED"; _enemyPatrols = 0; };
	// Some will look for you
	case 2: { _enemyCombatMode = "RED"; _enemyPatrols = _numberOfEnemies * 0.3; };
	// Most will look for you
	case 3: { _enemyCombatMode = "RED"; _enemyPatrols = _numberOfEnemies * 0.6; };
	// All will look for you
	case 4: { _enemyCombatMode = "RED"; _enemyPatrols = _numberOfEnemies; };
};

//
// Make a randomized list of all players
// (Can be recalled in the mission in case players want to go in a random order.)
//
if (isNil "playerOrder") then {
	playerOrder = [];
};
if (isServer) then {
	{
		if (isPlayer _x) then {
			playerOrder = playerOrder + [name vehicle _x];
		};
	} foreach allUnits;

	playerOrder = ([playerOrder] call CBA_fnc_shuffle);
	publicVariable "playerOrder";
};
ammobox addAction ["Draw straws", fn_showPlayerOrder];

//
// Spawn units
//
if (isServer) then {
	for "_i" from 0 to _numberOfEnemies do {
	    _soldierType = [_soldierTypes, _soldierTypeWeights] call BIS_fnc_selectRandomWeighted;
	    _unit = [_soldierType, (_positions select _i)] call fn_spawnUnit;
	    _unit setCombatMode _enemyCombatMode;

	    if (_i < _enemyPatrols) then {
	    	[_unit, (_positions select _i), _positions] call fn_setupPatrol;
	    };
	};
} else {
	// MP clients don't do the loop above and skip right to this point. We
	// should wait until the server is most likely completed.
	sleep 15;
};


//
// Mission logic loop
//

_loop = true;
while {_loop} do {
	_totalEnemies = {side _x == EAST && alive _x && !(fleeing _x)} count allUnits;
	hintSilent parseText format["THERE ARE <t color='#ff0000'>%1</t> ENEMY UNITS LEFT TO KILL", _totalEnemies];
	sleep 2;
	if (_totalEnemies == 0) then {
		_loop = false;
	};
};

// Win the game!
["END1", true, 2] call BIS_fnc_endMission;