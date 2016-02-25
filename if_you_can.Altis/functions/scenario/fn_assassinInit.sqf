// TODO: Make this work without a hardcoded soldier name.

soldier1 addAction [
  "<t color='#00ff00'>Poison soldier</t>", // Text
  {
    [soldier1] call IYC_fnc_poisonWithCooldown;
  }, // Code
  [], // Arguments to code
  10, // Priority
  true, // Show text on screen
  true, // Hide action menu when used
  "compass", // Enable using keybind
  "player distance soldier1 < poisonDistance" // Condition
];
