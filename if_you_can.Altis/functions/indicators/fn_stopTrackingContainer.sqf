params ["_container"];

private _index = weaponContainers find _container;
if (_index >= 0) then {
  weaponContainers deleteAt _index;
  publicVariable "weaponContainers";
};
