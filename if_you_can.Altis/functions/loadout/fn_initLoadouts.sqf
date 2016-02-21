/*
Init loadouts when used for the first time.
*/

faces = (
  "getNumber (_x >> 'disabled') == 0 && getText(_x >> 'DLC') == ''" configClasses (configFile >> "CfgFaces" >> "Man_A3")
) apply { configName _x } select { _x != "Custom" };

speakers = (
  "getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVoice")
) apply { configName _x } select { _x != "NoVoice" };

civilianUniforms = (
  // Select all available uniforms
  "((configName _x) isKindOf ['Uniform_Base', configFile >> 'CfgWeapons'])" configClasses (configFile >> "CfgWeapons")
) select {
  // ...that does not require a DLC
  getText (_x >> "DLC") == '' &&
    // ...and is available
    getNumber (_x >> "scope") > 0
} select {
  // In order to detect which uniforms are used by civilians, we need to access a config on
  // it and then cross-reference the side of the that config.
  private _uniformClass = getText (_x >> "ItemInfo" >> "uniformClass");
  private _sides = getArray (configFile >> "CfgVehicles" >> _uniformClass >> "modelSides");
  // _sides == [3]; 3 is civilians
  count _sides == 1 && 3 in _sides
} apply {
  configName _x
} select {
  // Filter out the VR characters
  _x find "VR" < 0
};
