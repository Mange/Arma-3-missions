// Configure TFAR
tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

fnc_selectMagazine = {
	_magazines = _this select 0;
	_index = _this select 1;

	_magazine = _magazines select _index;

	// Some magazines have 5 shots, others have 200. Try to adjust the amount of magazines added in the
	// box depending on the size of the magazine.
	_ammoCount = getNumber (configfile / "CfgMagazines" / _magazine / "count");
	_magazineCount = 5;
	if (_ammoCount < 50) then { _magazineCount = 7; };
	if (_ammoCount < 30) then { _magazineCount = 20; };

	[_magazine, _magazineCount]
};

_itemsToRemove = [
	"NVGoggles", "NVGoggles_INDEP", "NVGoggles_OPFOR", "NVGoggles_mas_h",
	"Laserdesignator", "Rangefinder"
];

_magazinesToRemove = [
	"B_IR_Grenade",	"O_IR_Grenade"
];

_attachmentsToRemove = [
	"acc_pointer_IR", "acc_mas_pointer_IR_b",

	// Some units have a flashlight in their inventory. Remove it and re-add it through
	// _attachmentsToAdd later.
	"acc_flashlight",

	// Silencers
	"muzzle_mas_snds_Mc", "muzzle_mas_snds_L", "muzzle_snds_H_MG",
	"muzzle_mas_snds_MP7", "muzzle_mas_snds_SVc", "muzzle_mas_snds_SM"
];

_itemsToAdd = [
];

_attachmentsToAdd = [
	"acc_flashlight"
];

_magnifyingOpticsAllowed = "MagnifyingOpticsAllowed" call BIS_fnc_getParamValue;

if (_magnifyingOpticsAllowed == 0) then {
	_attachmentsToAdd = _attachmentsToAdd + [
		"optic_Holosight"
	];
};

{
    _unit = _x;

    { _unit unlinkItem _x; } foreach (_itemsToRemove);
    { _unit removeItem _x; } foreach (_itemsToRemove);
    { _unit removeMagazines _x; } foreach (_magazinesToRemove);

    { _unit removePrimaryWeaponItem _x; } foreach (_attachmentsToRemove);
    // In case there are some of them inside the inventory too
    { _unit unlinkItem _x; } foreach (_attachmentsToRemove);
    { _unit removeItem _x; } foreach (_attachmentsToRemove);

    { _unit addItem _x; _unit assignItem _x; } foreach (_itemsToAdd);

	// Add attachments.
	// Some units might have one in the backpack already, so remove it first.
    { _unit unlinkItem _x; } foreach (_attachmentsToAdd);
    { _unit removePrimaryWeaponItem _x; } foreach (_attachmentsToAdd);
    { _unit addPrimaryWeaponItem _x; } foreach (_attachmentsToAdd);

    // Replace 1Rnd GL shells with 3Rnd
    if ("1Rnd_HE_Grenade_shell" in magazines _unit) then {
    	_unit removeMagazines "1Rnd_HE_Grenade_shell";
    	_unit addMagazines ["3Rnd_HE_Grenade_shell", 3];
    };

} foreach (allUnits);

// Setup supply boxes
if (isServer) then {
	// playableUnits is empty in single player (for example, editor preview.)
	_playableUnits = playableUnits;
	if (count _playableUnits == 0) then {
		_playableUnits = units group player;
	};

	/* Figure ammo that each playable unit needs. */
	_extraMagazines = [];
	{
		_magazines = getArray (configFile / "CfgWeapons" / (primaryWeapon _x) / "magazines");

		if (count _magazines > 0) then {
			_extraMagazines = _extraMagazines + [
				[_magazines, 0] call fnc_selectMagazine
			];
		};

		if (count _magazines > 1) then {
			_extraMagazines = _extraMagazines + [
				[_magazines, 1] call fnc_selectMagazine
			];
		};
	} foreach (_playableUnits);


	{
		_box = _x;
		clearWeaponCargoGlobal _box;
		clearMagazineCargoGlobal _box;
		clearItemCargoGlobal _box;
		clearBackpackCargoGlobal _box;

		_box addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", 5];
		_box addItemCargoGlobal ["FirstAidKit", 5];

		_box addMagazineCargoGlobal ["HandGrenade", 8];
		_box addMagazineCargoGlobal ["SmokeShellRed", 2];

		_box addMagazineCargoGlobal ["3Rnd_UGL_FlareGreen_F", 3];
		_box addMagazineCargoGlobal ["3Rnd_UGL_FlareRed_F", 3];
		_box addMagazineCargoGlobal ["3Rnd_UGL_FlareWhite_F", 3];
		_box addMagazineCargoGlobal ["3Rnd_UGL_FlareYellow_F", 3];

		_box addWeaponCargoGlobal ["launch_RPG32_F", 2];
		_box addMagazineCargoGlobal ["RPG32_HE_F", 2];
		_box addMagazineCargoGlobal ["RPG32_F", 3];

		_box addWeaponCargoGlobal ["launch_B_Titan_F", 1];
		_box addMagazineCargoGlobal ["Titan_AA", 3];

		_box addBackpackCargoGlobal ["B_HMG_01_high_weapon_F", 1];
		_box addBackpackCargoGlobal ["B_HMG_01_support_high_F", 1];

		if (_magnifyingOpticsAllowed == 0) then {
			_box addItemCargoGlobal ["optic_Aco", 5];
		};

		{
			_box addMagazineCargoGlobal [_x select 0, _x select 1];
		} foreach _extraMagazines;

	} foreach ([supply1, supply2]);
};