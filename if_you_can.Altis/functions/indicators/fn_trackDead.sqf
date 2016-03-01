params ["_unit"];

private _index = trackedPlayers find _victim;
if (_index >= 0) then {
  trackedPlayers deleteAt _index;
};

trackedDead pushBack _victim;
