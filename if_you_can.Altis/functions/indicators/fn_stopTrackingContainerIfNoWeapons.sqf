params ["_container"];

if (count weaponCargo _container == 0) then {
  _container call IYC_fnc_stopTrackingContainer;
};
