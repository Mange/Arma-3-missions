[] spawn {
  private ["_loop", "_civilians", "_soldiers", "_natoWinCondition", "_civilianWinCondition"];
  _loop = true;
  _civilians = [];
  _soldiers = [];

  waitUntil { time > 10 };

  {
    if (side _x == west) then {
      _soldiers pushBack _x;
    } else {
      _civilians pushBack _x;
    };
  } forEach (call BIS_fnc_listPlayers);

  // Real conditions
  if (isMultiplayer) then {
    _natoWinCondition = { ({alive _x} count _civilians) < 1 };
    _civilianWinCondition = { ({alive _x} count _soldiers) < 1 };
  } else {
    // For editor preview
    _natoWinCondition = { count allDead >= 2 && side (allDead select 0) != west };
    _civilianWinCondition = { count allDead > 0 && side (allDead select 0) == west };
  };

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
