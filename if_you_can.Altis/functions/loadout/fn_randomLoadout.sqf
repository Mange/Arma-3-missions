params ["_unit"];

[
  _unit,
  (call IYC_fnc_randomFace),
  (call IYC_fnc_randomVoice)
] remoteExec ["BIS_fnc_setIdentity", 0, true];

_unit addUniform (call IYC_fnc_randomUniform);
