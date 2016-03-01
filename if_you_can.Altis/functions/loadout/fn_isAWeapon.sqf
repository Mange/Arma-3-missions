params ["_class"];

_class isKindOf ["Rifle", configFile >> "cfgWeapons"] ||
  _class isKindOf ["Pistol", configFile >> "cfgWeapons"];
