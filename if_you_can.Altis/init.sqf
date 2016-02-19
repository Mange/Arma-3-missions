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

{
    private ["_unit", "_direction"];
    _unit = _x;

    if (local _unit) then {
        _direction = random 360;
        _unit setDir _direction;
        _unit setFormDir _direction;

        if (side _unit == civilian && _unit isKindOf "Man") then {
            _unit setPos ([playArea] call BIS_fnc_randomPosTrigger);

            _unit setFace (faces call BIS_fnc_selectRandom);
            _unit setSpeaker (speakers call BIS_fnc_selectRandom);
            _unit addMagazines ["30Rnd_9x21_Mag", 1];
        };

        if (!isPlayer _unit) then {
          private ["_totalWps", "_wpIndex", "_wpPos", "_wp"];
          _totalWps = [2, 7] call BIS_fnc_randomInt;
          for "_wpIndex" from 0 to _totalWps-1 do {
            if (random 1 < 0.7) then {
              _wpPos = [playArea] call BIS_fnc_randomPosTrigger;
            } else {
              _wpPos = [closeToGun] call BIS_fnc_randomPosTrigger;
            };
            _wp = (group _unit) addWaypoint [_wpPos, 1];
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
            switch ([1, 6] call BIS_fnc_randomInt) do {
              case (1): {
                // No timeout.
              };
              case (2): {
                _wp setWaypointTimeout [30, 50, 70];
              };
              default {
                _wp setWaypointTimeout [5, 10, 20];
              };
            };
          };
          _wp = (group _unit) addWaypoint [getPos _unit, 0];
          _wp setWaypointType "CYCLE";
        };
    };
} forEach allUnits;

if (hasInterface) then {
  waitUntil { time > 5 };

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
      _natoWinCondition = { count allDead > 1 && (allDead select 0) != soldier1 };
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
