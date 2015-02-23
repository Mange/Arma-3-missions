/*
TODO:
	* Add Victory trigger.
*/
// Configure TFAR
tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

_itemsToRemove = [
	"NVGoggles", "NVGoggles_INDEP", "NVGoggles_OPFOR",
	"Laserdesignator"
];

_magazinesToRemove = [
	"B_IR_Grenade",	"O_IR_Grenade"
];

_attachmentsToRemove = [
	"acc_pointer_IR", "acc_mas_pointer_IR"
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
    { _unit removeMagazines _x; } foreach (_magazinesToRemove);

    { _unit removePrimaryWeaponItem _x; } foreach (_attachmentsToRemove);
    // In case there are some of them inside the inventory too
    { _unit unlinkItem _x; } foreach (_attachmentsToRemove);

    { _unit addItem _x; _unit assignItem _x; } foreach (_itemsToAdd);

	// Add attachments.
	// Some units might have one in the backpack already, so remove it first.
    { _unit unlinkItem _x; } foreach (_attachmentsToAdd);
    { _unit removePrimaryWeaponItem _x; } foreach (_attachmentsToAdd);
    { _unit addPrimaryWeaponItem _x; } foreach (_attachmentsToAdd);

    // Replace Nightstalker with RCO
    if (
    	("optic_Nightstalker" in items _unit) ||
    	("optic_Nightstalker" in primaryWeaponItems _unit)
    ) then {
    	_unit unlinkItem "optic_Nightstalker";
    	_unit addPrimaryWeaponItem "optic_Hamr";
    };

    // Replace 1Rnd GL shells with 3Rnd
    if ("1Rnd_HE_Grenade_shell" in magazines _unit) then {
    	_unit removeMagazines "1Rnd_HE_Grenade_shell";
    	_unit addMagazines ["3Rnd_HE_Grenade_shell", 3];
    };

} foreach (allUnits);

// Setup supply boxes
{
	clearWeaponCargoGlobal _x;
	clearMagazineCargoGlobal _x;
	clearItemCargoGlobal _x;
	clearBackpackCargoGlobal _x;

	_x addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", 5];
	_x addItemCargoGlobal ["FirstAidKit", 5];

	_x addMagazineCargoGlobal ["HandGrenade", 8];
	_x addMagazineCargoGlobal ["SmokeShellRed", 2];

	_x addMagazineCargoGlobal ["3Rnd_UGL_FlareGreen_F", 3];
	_x addMagazineCargoGlobal ["3Rnd_UGL_FlareRed_F", 3];
	_x addMagazineCargoGlobal ["3Rnd_UGL_FlareWhite_F", 3];
	_x addMagazineCargoGlobal ["3Rnd_UGL_FlareYellow_F", 3];

	_x addWeaponCargoGlobal ["launch_RPG32_F", 2];
	_x addMagazineCargoGlobal ["RPG32_HE_F", 2];
	_x addMagazineCargoGlobal ["RPG32_F", 3];

	_x addWeaponCargoGlobal ["launch_B_Titan_F", 1];
	_x addMagazineCargoGlobal ["Titan_AA", 3];

	_x addMagazineCargoGlobal ["30Rnd_mas_556x45_Stanag", 30];
	_x addMagazineCargoGlobal ["30Rnd_mas_556x45_T_Stanag", 30];
	_x addMagazineCargoGlobal ["200Rnd_mas_556x45_Stanag", 10];
	_x addMagazineCargoGlobal ["200Rnd_mas_556x45_T_Stanag", 10];
	_x addMagazineCargoGlobal ["100Rnd_mas_762x51_Stanag", 10];
	_x addMagazineCargoGlobal ["100Rnd_mas_762x51_T_Stanag", 10];
	_x addMagazineCargoGlobal ["100Rnd_mas_762x39_mag", 10];
	_x addMagazineCargoGlobal ["100Rnd_mas_762x39_T_mag", 10];

	_x addBackpackCargoGlobal ["B_HMG_01_high_weapon_F", 1];
	_x addBackpackCargoGlobal ["B_HMG_01_support_high_F", 1];

	if (_magnifyingOpticsAllowed == 0) then {
		_x addItemCargoGlobal ["optic_Aco", 5];
	};

} foreach ([supply1, supply2]);

// Iterate over all ammoboxes
//{
//
//} foreach (allMissionObjects "ReammoBox_F");