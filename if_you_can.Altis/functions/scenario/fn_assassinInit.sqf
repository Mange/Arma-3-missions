[] spawn {
  // Wait until the game has begun before adding the poisoning actions so
  // players have been assigned to all units and the unit name will be
  // properly reflected in the action menu.
  waitUntil { time > 2 };

  allUnits select { side group _x == west && alive _x } apply {
    _x call IYC_fnc_addPoisonAction;
  };
};
