allUnits select { side _x == west } apply {
  _x addAction [
    format ["<t color='#00ff00'>Poison %1</t>", str _x], // Text
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
