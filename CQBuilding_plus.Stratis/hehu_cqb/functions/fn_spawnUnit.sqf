private ["_type", "_position", "_side", "_group", "_unit"];
_type = [_this, 0, "O_soldier_F", [""]] call BIS_fnc_param;
_position = [_this, 1, ObjNull, [[]], [2,3]] call BIS_fnc_param;

_side = [(configfile >> "CfgVehicles" >> _type), "side", 0] call BIS_fnc_returnConfigEntry;
_side = switch(_side) do {
	case 0: { east; };
	case 1: { west; };
	case 2: { independent; };
	case 3: { civilian; };
	default { east; };
};

_group = createGroup _side;
_unit = _group createUnit [_type, _position, [], 0, "CAN_COLLIDE"];

_unit setBehaviour "COMBAT";
_unit setUnitPos "UP";
_unit setDir random 360;

_unit;
