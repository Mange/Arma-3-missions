tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = false;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

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

poisonCooldownSeconds = 30;
lastPoisonTry = 0;

fn_tryPoison = {
  params ["_target"];
  private ["_timeLeft"];

  _timeLeft = (lastPoisonTry + poisonCooldownSeconds) - time;
  if (_timeLeft <= 0) then {
    [_target] call fn_poisonApply;
  } else {
    hint format ["You need to wait %1 more seconds before you can poison again!", round _timeLeft];
  };
};

fn_poisonApply = {
  private ["_succeeded"];
  params ["_target"];
  lastPoisonTry = time;
  hintSilent format ["Stand close to %1 to poison them!", name _target];

  sleep 2;
  _succeeded = (player distance _target <= 2);

  if (_succeeded) then {
    hint parseText format ["<t color='#ff0000'>You have poisoned %1!</t>", name _target];
  } else {
    hint parseText "<t color='#3333ff'>Poisoning failed!</t>";
  };
  [_target, player, _succeeded] remoteExec ["fn_poison", _target];
};

fn_poison = {
  params ["_unit", "_poisoner", "_succeeded"];

  sleep random [2, 5, 10];
  if (_succeeded) then {
    _unit setDamage (getDammage _unit) + 0.25; // TODO: Param for poison strength
    hint parseText format ["<t color='#ff0000'>%1 poisoned you.</t>", name _poisoner];
  } else {
    hint parseText format ["<t color='#3333ff'>%1 tried to poison you.</t>", name _poisoner];
  };
};

{
    private ["_unit", "_direction"];
    _unit = _x;

    if (local _unit) then {
        _direction = random 360;
        _unit setDir _direction;
        _unit setFormDir _direction;

        if (side _unit == civilian && _unit isKindOf "Man") then {
            _unit setPos ([playArea] call BIS_fnc_randomPosTrigger);
            _unit addUniform (civilianUniforms call BIS_fnc_selectRandom);
            _unit addMagazines ["30Rnd_9x21_Mag", 1];

            [
              _unit,
              (faces call BIS_fnc_selectRandom),
              (speakers call BIS_fnc_selectRandom)
            ] remoteExec ["BIS_fnc_setIdentity", 0, true];
        };

        if (!isPlayer _unit) then {
          private ["_totalWps", "_wpIndex", "_wpPos", "_wp"];

          _wp = (group _unit) addWaypoint [getPos _unit, 0];
          _wp setWaypointTimeout [5, 50, 120];
          _wp setWaypointCompletionRadius 5;
          _wp setWaypointBehaviour "SAFE";
          _wp setWaypointSpeed "LIMITED";

          _totalWps = [2, 7] call BIS_fnc_randomInt;
          for "_wpIndex" from 0 to _totalWps-1 do {
            if (random 1 < 0.7) then {
              _wpPos = [playArea] call BIS_fnc_randomPosTrigger;
            } else {
              _wpPos = [closeToGun] call BIS_fnc_randomPosTrigger;
            };
            _wp = (group _unit) addWaypoint [_wpPos, 0];
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
            _wp setWaypointCompletionRadius 1;
            switch ([1, 6] call BIS_fnc_randomInt) do {
              case (1): {
                // No timeout.
              };
              case (2): {
                _wp setWaypointTimeout [5, 20, 50];
              };
              default {
                _wp setWaypointTimeout [30, 70, 120];
              };
            };
          };
          _wp = (group _unit) addWaypoint [getPos _unit, 0];
          _wp setWaypointType "CYCLE";
        };
    };
} forEach allUnits;

if (hasInterface) then {
  if (side player == west) then {
    titleText ["Find and kill the hidden players", "BLACK IN", 100];
    sleep 5;
    titleText ["Find and kill the hidden players", "BLACK IN", 1];
  };

  if (side player == civilian) then {
    soldier1 addAction [
      "<t color='#00ff00'>Poison soldier</t>", // Text
      {
        [soldier1] call fn_tryPoison;
      }, // Code
      [], // Arguments to code
      10, // Priority
      true, // Show text on screen
      true, // Hide action menu when used
      "compass", // Enable using keybind
      "player distance soldier1 < 2"
    ];
  };

  waitUntil { time > 10 };
  [] spawn {
    private ["_loop", "_civilians", "_soldiers", "_natoWinCondition", "_civilianWinCondition"];
    _loop = true;
    _civilians = [];
    _soldiers = [];

    {
      if (side _x == west) then {
        _soldiers pushBack _x;
      } else {
        _civilians pushBack _x;
      };
    } forEach allPlayers;

    // Real conditions
    if (isMultiplayer) then {
      _natoWinCondition = { ({alive _x} count _civilians) < 1 };
      _civilianWinCondition = { ({alive _x} count _soldiers) < 1 };
    } else {
      // For editor preview
      _natoWinCondition = { count allDead >= 2 && (allDead select 0) != soldier1 };
      _civilianWinCondition = { count allDead > 0 && (allDead select 0) == soldier1 };
    };

    while { _loop } do {
      if ([] call _civilianWinCondition) then {
        if (side player == west) then {
          ["loser", false, true] call BIS_fnc_endMission;
        } else {
          ["end2", true, true] call BIS_fnc_endMission;
        };
        _loop = false;
      } else {
        if ([] call _natoWinCondition) then {
          if (side player == west) then {
            ["end1", true, true] call BIS_fnc_endMission;
          } else {
            ["loser", false, true] call BIS_fnc_endMission;
          };
          _loop = false;
        };
      };
      sleep 2;
    };
  };
};
