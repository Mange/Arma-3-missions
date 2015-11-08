private ["_unit", "_preset"];
_unit = param [0];
_preset = param [1, 0, [0]];

if (_preset < 0) then {
    _preset = 0;
};

if (_preset > 2) then {
    _preset = _preset % 3;
};

// Clear out the unit
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

// Gear
switch(_preset) do {
    case (0): {
        _unit forceAddUniform "TRYK_U_denim_hood_blk";
        _unit addVest "V_BandollierB_blk";
        _unit addBackpack "B_AssaultPack_blk";
        _unit addGoggles "G_Balaclava_blk";
    };

    case (1): {
        _unit forceAddUniform "TRYK_shirts_BLK_PAD_RED2";
        _unit addVest "V_BandollierB_blk";
        _unit addBackpack "B_AssaultPack_blk";
        _unit addGoggles "MEC_shemag_black";
    };

    case (2): {
        _unit forceAddUniform "TRYK_U_B_PCUGs_OD";
        _unit addVest "V_BandollierB_blk";
        _unit addBackpack "TRYK_B_tube_blk";
        _unit addGoggles "G_Balaclava_oli";
    };
};

// Items
_unit linkItem "ItemRadio";
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit addItemToUniform "ACE_EarPlugs";
for "_i" from 1 to 2 do {_unit addItemToUniform "FirstAidKit";};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
for "_i" from 1 to 2 do {_unit addItemToVest "ACE_M84";};

// Weapon and ammo
switch(_preset) do {
    case (0): {
        _unit addWeapon "RH_tec9";
        for "_i" from 1 to 6 do {_unit addItemToVest "RH_32Rnd_9x19_tec";};
    };

    case(1): {
        _unit addWeapon "RH_kimber_nw";
        for "_i" from 1 to 5 do {_unit addItemToVest "RH_7Rnd_45cal_m1911";};
        for "_i" from 1 to 3 do {_unit addItemToBackpack "RH_7Rnd_45cal_m1911";};
    };

    case (2): {
        _unit addWeapon "RH_m9";
        for "_i" from 1 to 6 do {_unit addItemToVest "RH_15Rnd_9x19_M9";};
        for "_i" from 1 to 3 do {_unit addItemToUniform "RH_15Rnd_9x19_M9";};
    };
};
