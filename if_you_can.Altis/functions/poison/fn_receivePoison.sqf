params ["_unit", "_poisoner", "_succeeded", "_delay"];

sleep _delay;
if (_succeeded) then {
  _unit setDamage (getDammage _unit) + poisonDamage;
  hint parseText format ["<t color='#ff0000'>%1 poisoned you.</t>", name _poisoner];
} else {
  hint parseText format ["<t color='#3333ff'>%1 tried to poison you.</t>", name _poisoner];
};
