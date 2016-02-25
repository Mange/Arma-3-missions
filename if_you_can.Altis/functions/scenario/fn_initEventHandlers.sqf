// Never allow a player to get negative rating. First of all, the whole level is
// about "team killing", so don't punish for it. Secondly, and this one is the
// most important one, is that you shouldn't become an ENEMY for doing too much
// team killing because the civilian NPCs will stop following waypoints and just
// keep facing you.
player addEventHandler ["HandleRating", {
  private _rating = _this select 1;
  if (_rating < 0) then {
    0
  } else {
    _rating
  };
}];
