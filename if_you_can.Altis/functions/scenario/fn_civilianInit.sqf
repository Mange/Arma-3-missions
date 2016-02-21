params ["_unit"];

_unit call IYC_fnc_setRandomPosition;
_unit call IYC_fnc_randomLoadout;

_unit addMagazines [weaponAmmo, 1];
