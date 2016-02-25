params ["_unit", "_poisoner", "_succeeded", "_delay"];

sleep _delay;

if (_succeeded) then {
  _unit setDamage (getDammage _unit) + poisonDamage;
};

[_unit, _poisoner, _succeeded] remoteExec ["IYC_fnc_broadcastPoisoning", 0];
