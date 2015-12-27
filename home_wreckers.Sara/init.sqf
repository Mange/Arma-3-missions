tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = false;
tf_same_sw_frequencies_for_side = false;
tf_same_lr_frequencies_for_side = true;

// Random spawn point placement
if (isServer) then {
    private ["_positions", "_heights", "_players"];

    _spawns = [
        // Marker name, spawn height, primary weapon, primary weapon ammo, ammo count, primary scope
        ["spawn1", 0, "RH_hk416_des",     "RH_30Rnd_556x45_M855A1",  6, "optic_Holosight"],
        ["spawn2", 0, "hlc_rifle_falosw", "hlc_20Rnd_762x51_B_fal",  6, "RH_compm4s"],
        ["spawn3", 4, "RH_m16a4_des",     "RH_30Rnd_556x45_M855A1",  6, "RH_t1_tan"],
        ["spawn4", 5, "CUP_arifle_AK47",  "CUP_30Rnd_762x39_AK47_M", 6, "CUP_optic_Kobra"],
        ["spawn5", 2, "RH_hk416_des",     "RH_30Rnd_556x45_M855A1",  6, "optic_Holosight"],
        ["spawn6", 0, "CUP_arifle_AK47",  "CUP_30Rnd_762x39_AK47_M", 6, "CUP_optic_Kobra"]
    ];

    _players = [];
    {
        if (side _x == independent) then {
            _players pushBack _x;
        };
    } forEach allUnits;

    {
        private [
            "_unit", "_index", "_spawn",
            "_position", "_height",
            "_primaryWeapon", "_primaryAmmo", "_primaryAmmoCount",
            "_scope"
        ];
        _unit = _x;
        _index = [0, (count _spawns) - 1] call BIS_fnc_randomInt;
        _spawn = (_spawns deleteAt _index);

        _position         = getMarkerPos (_spawn param [0]);
        _height           = _spawn param [1];
        _primaryWeapon    = _spawn param [2];
        _primaryAmmo      = _spawn param [3];
        _primaryAmmoCount = _spawn param [4];
        _scope            = _spawn param [5];

        _position set [2, _height];

        [
            _unit, _position,
            _primaryWeapon, _primaryAmmo, _primaryAmmoCount,
            _scope
        ] remoteExec ["HW_fnc_initPlayer", _unit];
    } forEach _players;
};

// We want to remove the radio of all AIs, but they spawn at runtime so we wait a long time
// before we start to clean them up.
[] spawn {
    sleep 20;
    {
        _x unassignItem "ItemRadio";
        _x removeItem "ItemRadio";
    } forEach allUnits;
};
