_magazinesToRemove = [
	"Chemlight_blue", "Chemlight_green", "Chemlight_yellow", "Chemlight_red",
	"I_IR_Grenade", "B_IR_Grenade", "O_IR_Grenade"
];

{
	_unit = _x;
	{ _unit removeMagazines _x; } foreach _magazinesToRemove;
} foreach (allUnits);

// Setup supply boxes
{
	clearWeaponCargoGlobal _x;
	clearMagazineCargoGlobal _x;
	clearItemCargoGlobal _x;
	clearBackpackCargoGlobal _x;

	_x addItemCargoGlobal ["FirstAidKit", 5];
	_x addItemCargoGlobal ["optic_Holosight", 4];

	_x addMagazineCargoGlobal ["APERSBoundingMine_Range_Mag", 5];

	_x addWeaponCargoGlobal ["srifle_mas_m24_d_h", 1];
	_x addMagazineCargoGlobal ["5Rnd_mas_762x51_Stanag", 10];

	_x addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", 5];

	_x addMagazineCargoGlobal ["HandGrenade", 10];
	_x addMagazineCargoGlobal ["SmokeShellBlue", 2];
	_x addMagazineCargoGlobal ["SmokeShellOrange", 2];
	_x addMagazineCargoGlobal ["SmokeShellRed", 2];

	_x addWeaponCargoGlobal ["launch_B_Titan_F", 1];
	_x addMagazineCargoGlobal ["Titan_AA", 3];

	_x addMagazineCargoGlobal ["20Rnd_mas_762x51_Stanag", 80];
	_x addMagazineCargoGlobal ["20Rnd_mas_762x51_T_Stanag", 80];
	_x addMagazineCargoGlobal ["200Rnd_mas_556x45_Stanag", 20];
	_x addMagazineCargoGlobal ["200Rnd_mas_556x45_T_Stanag", 20];
	_x addMagazineCargoGlobal ["9Rnd_45ACP_Mag", 10];
} foreach ([supplies]);