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

rearmVehicle = {
    _vehicle = _this select 0;
    _type = typeOf _vehicle;
    _magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

    _current = 0;

    _vehicle setVehicleAmmoDef 1;

    hint "Refueling... Stand by.";
    while { _current < 1 } do {
        _vehicle setFuel _current;
        _current = _current + 0.01;
        if (_current >= 1) then { _current = 1; }; // Just in case of float-like errors
        sleep 0.1;
    };

    hint "Repearing... Stand by.";
    _current = damage _vehicle;
    while { _current > 0 } do {
        _vehicle setDamage _current;
        _current = _current - 0.1;
        if (_current <= 0) then { _current = 0; }; // Just in case of float-like errors
        sleep 1;
    };

    if (count _magazines > 0) then {
        { _vehicle removeMagazines _x; } forEach _magazines;
        {
            _name = getText (configFile >> "CfgMagazines" >> _x >> "displayName");
            if (_name == "") then {
                _name = getText (configFile >> "CfgMagazines" >> _x >> "displayNameShort");
            };
            if (_name == "") then {
                _name = _x;
            };

            hint format ["Reloading %1... Stand by.", _name];
            sleep 4;
            if (!alive _vehicle) exitWith {};
            _vehicle addMagazine _x;
        } forEach _magazines;
    };

    hint "You are good to go!";
};