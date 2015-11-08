private "_unit";
_unit = param [0];

// Clear out the unit
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

// Gear
_unit forceAddUniform "TRYK_U_B_BLTAN_T";
_unit addVest "TRYK_V_tacSVD_BK";
_unit addHeadgear "TRYK_H_headsetcap_blk_Glasses";

// Items
_unit addItemToUniform "ACE_EarPlugs";
_unit addItemToUniform "ACE_CableTie";
_unit addItemToUniform "FirstAidKit";
// No map or compass as guards don't normally have them IRL.
// _unit linkItem "ItemMap";
// _unit linkItem "ItemCompass";
_unit linkItem "ItemWatch";
_unit linkItem "ItemRadio";

// Weapon and ammo
_unit addWeapon "hlc_rifle_M4";
_unit addPrimaryWeaponItem "CUP_acc_Flashlight";
for "_i" from 1 to 4 do {_unit addItemToVest "hlc_30rnd_556x45_EPR";};

_unit addWeapon "RH_g17";
for "_i" from 1 to 3 do {_unit addItemToUniform "RH_17Rnd_9x19_g17";};
