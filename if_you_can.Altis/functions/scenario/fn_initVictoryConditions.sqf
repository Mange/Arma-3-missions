[] spawn {
  private ["_loop", "_civilians", "_soldiers", "_natoWinCondition", "_civilianWinCondition"];
  _loop = true;
  _civilians = [];
  _soldiers = [];

  waitUntil { time > 10 };

  private _players = (call BIS_fnc_listPlayers);
  if (!isMultiplayer) then {
    _players = switchableUnits;
  };

  _players apply {
    if (side group _x == west) then {
      _soldiers pushBack _x;
    } else {
      _civilians pushBack _x;
    };
  };

  _natoWinCondition = { ({alive _x} count _civilians) < 1 };
  _civilianWinCondition = { ({alive _x} count _soldiers) < 1 };

  while { _loop } do {
    if ([] call _civilianWinCondition) then {
      if (side group player == west) then {
        ["loser", false, true] call BIS_fnc_endMission;
      } else {
        ["end2", true, true] call BIS_fnc_endMission;
      };
      _loop = false;
    } else {
      if ([] call _natoWinCondition) then {
        if (side group player == west) then {
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
