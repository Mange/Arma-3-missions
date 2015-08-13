tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

convoyGroup = group car1;

ambushReady = false;
convoyEntered = false;
convoyLeft = false;
convoyAlive = true;
playersEscaped = false;

fillAmmoBox = {
	clearMagazineCargoGlobal _this;
	clearWeaponCargoGlobal _this;
	clearItemCargoGlobal _this;

	// Medical gear
	_this addItemCargoGlobal ["ACE_fieldDressing", 22];
	_this addItemCargoGlobal ["ACE_epinephrine", 1];
	_this addItemCargoGlobal ["ACE_morphine", 8];

	// Weapons and ammo
	_this addItemCargoGlobal ["hlc_rifle_ak74_dirty", 5];
	_this addItemCargoGlobal ["hlc_30Rnd_545x39_B_AK", 39];

	_this addItemCargoGlobal ["hlc_rifle_rpk", 2];
	_this addItemCargoGlobal ["hlc_75Rnd_762x39_m_rpk", 6];

	_this addItemCargoGlobal ["CUP_srifle_SVD", 1];
	_this addItemCargoGlobal ["CUP_10Rnd_762x54_SVD_M", 4];
	_this addItemCargoGlobal ["CUP_optic_PSO_1", 1];

	_this addItemCargoGlobal ["hlc_rifle_saiga12k", 2];
	_this addItemCargoGlobal ["hlc_10rnd_12g_buck_S12", 8];
	_this addItemCargoGlobal ["hlc_10rnd_12g_slug_S12", 5];

	_this addItemCargoGlobal ["CUP_launch_RPG7V", 2];
	_this addItemCargoGlobal ["CUP_PG7V_M", 6];

	// Grenades, smoke, etc.
	_this addItemCargoGlobal ["ACE_HandFlare_Red", 3];
	_this addItemCargoGlobal ["MiniGrenade", 6];
	_this addItemCargoGlobal ["SmokeShell", 4];

	// IEDs
	_this addItemCargoGlobal ["ACE_DeadManSwitch", 2];
	_this addItemCargoGlobal ["ACE_Cellphone", 2];
	_this addItemCargoGlobal ["IEDUrbanBig_Remote_Mag", 1];
	_this addItemCargoGlobal ["IEDUrbanSmall_Remote_Mag", 3];
	_this addItemCargoGlobal ["DemoCharge_Remote_Mag", 2];

	// Misc
	_this addItemCargoGlobal ["ACE_Tripod", 1];
	_this addBackpackCargoGlobal ["B_AssaultPack_blk", 3];
};

ammobox call fillAmmoBox;

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

showReady = {
	player removeAction readyAction;
    [] spawn {
        titleText ["", "BLACK"];
        sleep 2;

        skiptime 1.5;

        titleText ["", "BLACK IN", 2];
        [
            ["90 MINUTES LATER ...","<t align = 'center' shadow = '1' size = '1.0'>%1</t><br/>"]

        ] call Bis_printText;
    };
};

readyAction = player addAction [
	"<t color='#FF0000'>Wait</t>",
	{
		ambushReady = true;
		publicVariable "ambushReady";
		call showReady;
	},
	[], // Arguments
	-1, // Priority
	false // Don't show in the middle of the screen
];

"ambushReady" addPublicVariableEventHandler {
	if (_this select 1) then {
		call showReady;
	};
};

if (hasInterface) then {
	0 spawn {
		titleText ["", "BLACK"];
		sleep 1;
		titleText ["", "BLACK IN", 2];
		[
			parseText format
			[
				"<t align='right' size='1.2'>"
					+ "<t font='PuristaBold' size='1.6'>Fallujah</t><br/>"
					+ "early morning of january 11, 2010</t>"
			],
			[
				safezoneX + 0.4 * safezoneW,
				safezoneY + 0.4 * safezoneH,
				safezoneW * 0.4,
				safezoneH * 0.2
			],
			[9, 3] // 9x3 grid
			// no duration given, so default of 5 seconds.
		] spawn BIS_fnc_textTiles;
	};
};
