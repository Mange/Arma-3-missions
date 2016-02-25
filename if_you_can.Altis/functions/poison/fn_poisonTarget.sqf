params ["_target"];

lastPoisonTry = time;

hintSilent format ["Stand close to %1 to poison them!", name _target];
sleep poisonApplicationTime;
private _succeeded = (player distance _target <= poisonDistance);
private _delay = random [2, 5, 10];

if (!alive player) then {
  _delay = 0;
  _succeeded = false;
};

if (_succeeded) then {
  hint parseText format ["<t color='#ff0000'>You have poisoned %1!</t>", name _target];
} else {
  hint parseText "<t color='#3333ff'>Poisoning failed!</t>";
};

[_target, player, _succeeded, _delay] remoteExec ["IYC_fnc_receivePoison", _target];
