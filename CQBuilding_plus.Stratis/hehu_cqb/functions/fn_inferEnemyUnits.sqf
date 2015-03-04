/*
 * Infer enemy units.
 * Do this by looking for the "cqb_units" Game Logic, and the units synchronized to it.
 *
 * If Game Logic cannot be found, or if no units are synchronized to it, fall back to a simple default.
 *
 * Return type is an array of unit types to select from.
 */
private ["_default", "_gameLogic", "_units"];
_gameLogic = _this select 0;

_default = ["O_soldier_F"];
_units = [];

{
	if (_x isKindOf "Man") then {
		_units = _units + [typeOf _x];
		deleteVehicle _x;
	};
} foreach (synchronizedObjects _gameLogic);

if (count _units > 0) then { _units } else { _default }