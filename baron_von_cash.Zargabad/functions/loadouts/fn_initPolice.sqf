private "_unit";
_unit = param [0];

// Clear out the unit
removeAllWeapons _this;
removeAllItems _this;
removeAllAssignedItems _this;
removeUniform _this;
removeVest _this;
removeBackpack _this;
removeHeadgear _this;
removeGoggles _this;

// Gear
_this forceAddUniform "TRYK_U_B_BLK";
_this addVest "TRYK_V_tacv1_P_BK";
_this addHeadgear "TRYK_H_PASGT_BLK";

// Items
for "_i" from 1 to 2 do {_this addItemToUniform "ACE_CableTie";};
_this addItemToUniform "ACE_EarPlugs";
for "_i" from 1 to 2 do {_this addItemToVest "ACE_M84";};
_this addItemToVest "ACE_HandFlare_Red";
for "_i" from 1 to 2 do {_this addItemToVest "Chemlight_green";};
_this addItemToVest "SmokeShell";

// Weapon and ammo
_this addWeapon "CUP_smg_EVO";
_this addPrimaryWeaponItem "acc_flashlight";
for "_i" from 1 to 6 do {_this addItemToVest "CUP_30Rnd_9x19_EVO";};

_unit addWeapon "RH_g17";
for "_i" from 1 to 3 do {_unit addItemToUniform "RH_17Rnd_9x19_g17";};
