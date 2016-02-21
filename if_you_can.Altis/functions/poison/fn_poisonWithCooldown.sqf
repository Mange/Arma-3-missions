params ["_target"];
private _timeLeft = (lastPoisonTry + poisonCooldownSeconds) - time;

if (_timeLeft <= 0) then {
  [_target] call IYC_fnc_poisonTarget;
} else {
  hint format ["You need to wait %1 more seconds before you can poison again!", round _timeLeft];
};
