// Configure TFAR
tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

{
	_x unassignItem "NVGoggles";
	_x removeItem "NVGoggles";

	_x removePrimaryWeaponItem "acc_pointer_IR";
	_x addPrimaryWeaponItem "acc_flashlight";
} foreach allUnits;

Bis_printText = {
    private["_blocks","_block","_blockCount","_blockNr","_blockArray","_blockText","_blockTextF","_blockTextF_","_blockFormat","_formats","_inputData","_processedTextF","_char","_cursorBlinks","_cursorInvis"];

    _blockCount = count _this;

    _invisCursor = "<t color ='#00000000' shadow = '0'>_</t>";

    //process the input data
    _blocks = [];
    _formats = [];

    {
        _inputData = _x;

        _block     = [_inputData, 0, "", [""]] call BIS_fnc_param;
        _format = [_inputData, 1, "<t align = 'center' shadow = '1' size = '0.7'>%1</t><br/>", [""]] call BIS_fnc_param;

        //convert strings into array of chars
        _blockArray = toArray _block;
        {_blockArray set [_forEachIndex, toString [_x]]} forEach _blockArray;

        _blocks  = _blocks + [_blockArray];
        _formats = _formats + [_format];
    }
    forEach _this;

    //do the printing
    _processedTextF  = "";

    {
        _blockArray  = _x;
        _blockNr      = _forEachIndex;
        _blockFormat = _formats select _blockNr;
        _blockText   = "";
        _blockTextF  = "";
        _blockTextF_ = "";

        {
            _char = _x;

            _blockText = _blockText + _char;

            _blockTextF  = format[_blockFormat, _blockText + _invisCursor];
            _blockTextF_ = format[_blockFormat, _blockText + "_"];

            //print the output
            [(_processedTextF + _blockTextF_), 0, 0.15, 5, 0, 0, 90] spawn BIS_fnc_dynamicText;
            playSound "click";
            sleep 0.08;
            [(_processedTextF + _blockTextF), 0, 0.15, 5, 0, 0, 90] spawn BIS_fnc_dynamicText;
            sleep 0.02;
        }
        forEach _blockArray;

        if (_blockNr + 1 < _blockCount) then
        {
            _cursorBlinks = 5;
        }
        else
        {
            _cursorBlinks = 15;
        };

        for "_i" from 1 to _cursorBlinks do
        {
            [_processedTextF + _blockTextF_, 0, 0.15, 5, 0, 0, 90] spawn BIS_fnc_dynamicText;
            sleep 0.08;
            [_processedTextF + _blockTextF, 0, 0.15, 5, 0, 0, 90] spawn BIS_fnc_dynamicText;
            sleep 0.02;
        };

        //store finished block
        _processedTextF  = _processedTextF + _blockTextF;
    }
    forEach _blocks;

    //clean the screen
    ["", 0, 0.15, 5, 0, 0, 90] spawn BIS_fnc_dynamicText;
};

teleportTruck = {
    [] spawn {
        titleText ["", "BLACK"];
        sleep 2;

        truck setPosATL (getMarkerPos "marker_fast_travel_destination");
        skiptime 1;

        titleText ["", "BLACK IN", 2];
        [
            ["NORTH OF FERUZ ABAD","<t align = 'center' shadow = '1' size = '0.7'>%1</t><br/>"],
            ["1 HOUR LATER ...","<t align = 'center' shadow = '1' size = '1.0'>%1</t><br/>"]

        ] call Bis_printText;
    };
};

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
