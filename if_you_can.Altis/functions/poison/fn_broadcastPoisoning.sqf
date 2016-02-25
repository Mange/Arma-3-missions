params ["_target", "_poisoner", "_succeeded"];

private ["_targetName"];
if (player == _target) then {
  _targetName = "you";
} else {
  _targetName = name _target;
};

if (player == _poisoner) then {
  if (_succeeded) then {
    hint parseText format ["<t color='#ff0000'>%1 feels the poison now.</t>", _targetName];
  };
} else {
  if (_succeeded) then {
    hint parseText format ["<t color='#ff0000'>%1 poisoned %2.</t>", name _poisoner, _targetName];
  } else {
    hint parseText format ["<t color='#3333ff'>%1 tried to poison %2.</t>", name _poisoner, _targetName];
  };
};
