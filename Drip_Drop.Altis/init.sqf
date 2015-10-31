// Configure TFAR
tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

nameOfMagazine = {
    _name = getText (configFile >> "CfgMagazines" >> _this >> "displayName");
    if (_name == "") then {
        _name = getText (configFile >> "CfgMagazines" >> _this >> "displayNameShort");
    };
    if (_name == "") then { _name = _this; };
    _name;
};

fnc_playerHintStateDisplay = {
    private ["_players", "_message"];
    _players = _this select 0;
    _message = _this select 1;
    {
        if (!isNull _x && {local _x}) then {
            hint _message;
        };
    } foreach _players;
};

playersHintState = [];
"playersHintState" addPublicVariableEventHandler { (_this select 1) call fnc_playerHintStateDisplay; };

showHintToPlayers = {
    private ["_players", "_message"];
    _players = _this select 0;
    _message = _this select 1;

    hint str _this;

    playersHintState = [_players, _message];
    publicVariable "playersHintState";
    // public variable event handler will not execute on the machine that changed the variable, so run it
    // manually as well.
    playersHintState call fnc_playerHintStateDisplay;
};

rearmVehicle = {
    private ["_vehicle", "_type", "_magazines", "_current"];
    _vehicle = _this select 0;
    _type = typeOf _vehicle;
    _magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");
    _current = 0;

    _vehicle setVehicleAmmoDef 1;

    // No fuel means forced engine off, and we cannot do lift-off until we've completed. >:)
    _vehicle setFuel 0;

    [(crew _vehicle), "Repearing... Stand by."] call showHintToPlayers;
    _current = damage _vehicle;
    while { _current > 0 } do {
        _vehicle setDamage _current;
        _current = _current - 0.1;
        if (_current <= 0) then { _current = 0; }; // Just in case of float-like errors
        sleep 1.2;
    };

    if (count _magazines > 0) then {
        {
            [(crew _vehicle), format ["Rearming %1... Stand by.", (_x call nameOfMagazine)]] call showHintToPlayers;
            _vehicle removeMagazines _x;
            sleep 4;
            _vehicle addMagazine _x;
        } forEach _magazines;
    };

    [(crew _vehicle), "Refueling... Stand by."] call showHintToPlayers;
    while { _current < 1 } do {
        _vehicle setFuel _current;
        _current = _current + 0.01;
        if (_current >= 1) then { _current = 1; }; // Just in case of float-like errors
        sleep 0.1;
    };

    [(crew _vehicle), "You are good to go!"] call showHintToPlayers;
};

// Set up ammoboxes
_enableVirtualArsenal = ["VirtualArsenal", 1] call BIS_fnc_getParamValue;
if (_enableVirtualArsenal == 1) then {
    // Remove normal ammo boxes
    { deleteVehicle _x } foreach [
        vanilla_ab1,
        vanilla_ab2,
        vanilla_ab3,
        vanilla_ab4,
        vanilla_ab5,
        vanilla_ab6,
        vanilla_ab7,
        vanilla_ab8
    ];
    {
        ["AmmoboxInit",[_x, true]] spawn BIS_fnc_arsenal;
    } foreach [ab1, ab2, ab3, ab4];
} else {
    // Delete big ammo box
    deleteVehicle ab4;
};

//EOS SYSTEM
[]execVM "eos\OpenMe.sqf";