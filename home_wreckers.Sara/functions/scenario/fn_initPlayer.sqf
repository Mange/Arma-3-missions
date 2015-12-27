params [
    "_unit", "_position",
    "_primaryWeapon", "_primaryAmmo", "_primaryAmmoCount",
    "_scope"
];

waitUntil {!isNull player && player == player};

// In case we teleport into stuff
_unit allowDamage false;

_unit setPos _position;

_unit unassignItem "ItemRadio";
_unit removeItem "ItemRadio";

_unit removeMagazines "CUP_30Rnd_762x39_AK47_M";
_unit addItemToUniform _primaryAmmo;
for "_i" from 1 to (_primaryAmmoCount - 1) do {_unit addItemToVest _primaryAmmo;};

_unit addWeapon _primaryWeapon;
_unit addPrimaryWeaponItem _scope;

// Restore mortality
_unit spawn { sleep 2; _this allowDamage true; }
