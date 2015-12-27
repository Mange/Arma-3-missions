tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = false;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

faces = [
    "AfricanHead_01",
    "AfricanHead_02",
    "AfricanHead_03",
    "AsianHead_A3_01",
    "AsianHead_A3_02",
    "AsianHead_A3_03",
    "GreekHead_A3_01",
    "GreekHead_A3_02",
    "GreekHead_A3_03",
    "GreekHead_A3_04",
    "GreekHead_A3_05",
    "GreekHead_A3_06",
    "GreekHead_A3_07",
    "GreekHead_A3_08",
    "GreekHead_A3_09",
    "PersianHead_A3_01",
    "PersianHead_A3_02",
    "PersianHead_A3_03",
    "NATOHead_01",
    "WhiteHead_02",
    "WhiteHead_03 ",
    "WhiteHead_04",
    "WhiteHead_05",
    "WhiteHead_06",
    "WhiteHead_07",
    "WhiteHead_08",
    "WhiteHead_09",
    "WhiteHead_10",
    "WhiteHead_11",
    "WhiteHead_12",
    "WhiteHead_13",
    "WhiteHead_14",
    "WhiteHead_15"
];

speakers = [
    "Male01ENG",
    "Male01ENGB",
    "Male01GRE",
    "Male01PER",
    "Male02ENG",
    "Male02ENGB",
    "Male02GRE",
    "Male02PER",
    "Male03ENG",
    "Male03ENGB",
    "Male03GRE",
    "Male03PER",
    "Male04ENG",
    "Male04ENGB",
    "Male04GRE",
    "Male05ENG",
    "Male06ENG",
    "Male07ENG",
    "Male08ENG",
    "Male09ENG"
];

{
    private ["_unit", "_direction"];
    _unit = _x;

    if (local _unit) then {
        _direction = random 360;
        _unit setDir _direction;
        _unit setFormDir _direction;

        if (side _unit == civilian && _unit isKindOf "Man") then {
            _unit setPos ([playArea] call BIS_fnc_randomPosTrigger);

            _unit setFace (faces call BIS_fnc_selectRandom);
            _unit setSpeaker (speakers call BIS_fnc_selectRandom);
            _unit addMagazines ["30Rnd_9x21_Mag", 1];
        };
    };
} forEach allUnits;

[] call {
    private "_holder";

    _holder = createVehicle ["groundweaponHolder", getPos playArea, [], 0, "CAN_COLLIDE"];
    _holder addweaponcargo ["hgun_PDW2000_F", 1];
};
