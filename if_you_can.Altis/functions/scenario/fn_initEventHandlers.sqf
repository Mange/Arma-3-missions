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

// Easter egg. If a soldier picks up the gun, every civilian will get their own
// gun and the soldier will become an enemy of all of them.
if (side player == west) then {
  player addEventHandler ["Take", {
    private _soldier = _this select 0;
    private _item = _this select 2;
    if (_item == weaponClass) then {
      // All hell breaks loose
      allUnits select { side _x == civilian } apply {
        if (primaryWeapon _x == "") then {
          _x addWeaponGlobal weaponClass;
        };
      };

      _soldier addRating -10000;
    };
  }];
};
