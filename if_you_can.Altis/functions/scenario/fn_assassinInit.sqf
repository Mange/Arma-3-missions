allUnits select { side _x == west } apply {
  [_x] spawn {
    private _unit = _this select 0;

    // Wait until the game has begun before adding the poisoning actions so
    // players have been assigned to all units and the unit name will be
    // properly reflected in the action menu.
    waitUntil { time > 2 };

    _unit addAction [
      format ["<t color='#00ff00'>Poison %1</t>", name _unit], // Text
      {
        [_this select 0] call IYC_fnc_poisonWithCooldown;
      }, // Code
      [], // Arguments to code
      10, // Priority
      true, // Show text on screen
      true, // Hide action menu when used
      "compass", // Enable using keybind
      "_this distance _target < poisonDistance" // Condition
    ];
  };
};
