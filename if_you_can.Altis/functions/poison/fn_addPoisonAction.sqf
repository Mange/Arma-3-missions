params ["_unit"];

private _actionId = _unit addAction [
  format ["<t color='#00ff00'><img image='\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa'/> Poison %1</t>", name _unit], // Text
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

_unit setVariable ["IYC_poisonActionId", _actionId, false];
