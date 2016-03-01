// Track players
// Civilians can see all other civilians, and dead player markers.
// Nato can only see dead player's markers.

waitUntil { time > 0 };

trackedPlayers = [];
trackedDead = [];

// TODO: Params for this.
// Assassins have markers on: All players, Assassins (default), Peacekeepers, None
// Peacekeepers have markers on: Soldiers, None (default)

if (side group player == civilian) then {
  if (isMultiplayer) then {
    trackedPlayers = allPlayers select { _x != player && side group _x == civilian };
  } else {
    trackedPlayers = (allUnits select [0, 5]) select { _x != player };
  };
};

allPlayers apply {
  _x addEventHandler ["Killed", {
    params ["_victim"];

    private _index = trackedPlayers find _victim;
    if (_index >= 0) then {
      trackedPlayers deleteAt _index;
    };

    trackedDead pushBack _victim;
  }];
};

["IYC_player_3dicons", "onEachFrame", {
  trackedPlayers apply {
    // Unit, icon, color, position, text, arrows
    [
      _x,
      nil, // TODO: Choose an icon
      nil,
      (getPosATLVisual _x) vectorAdd ([0, 0, 2]) // 2 meters above feet (0.2 meters above head when standing)
    ] call IYC_fnc_drawIcon;
  };

  trackedDead apply {
    // Unit, icon, color, position, text, arrows
    [
      _x,
      nil, // TODO: Choose an icon
      [1, 0, 0, 1],
      _x modelToWorld (_x selectionPosition "head_hit")
    ] call IYC_fnc_drawIcon;
  };
}] call BIS_fnc_addStackedEventHandler;
