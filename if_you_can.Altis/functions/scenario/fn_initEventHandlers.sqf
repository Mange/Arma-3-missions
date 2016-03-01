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

// Global events
addMissionEventHandler ["EntityKilled", {
  private _victim = _this select 0;
  private _killer = _this select 1;

  // Remove stuff that might have been used on the victim
  if (isPlayer _victim || !isMultiplayer) then {
    _victim call IYC_fnc_trackDead;
  };
  _victim call IYC_fnc_removePoisonAction;
  _victim call IYC_fnc_stopTrackingContainer;

  // Punish peace keepers that kill innocent civilians, and reward for killing
  // assassins.
  if (
    local _killer &&
    side group _killer == west &&
    side group _victim == civilian &&
    _killer != _victim
  ) then {
    if (isPlayer _victim) then {
      // Heal the peacekeeper!
      _killer setDamage 0;
    } else {
      // Hurt the peacekeeper.
      _killer setDamage ((getDammage _killer) + murderDamage);
    };
  };
}];

// Events for all units.
// "Take" and "Put" events run no matter where the unit was local, but we limit
// ourselves to registering them only on machines that have these units locally
// initially to make the logic easier.
allUnits select { local _x } apply {
  private _unit = _x;

  // If unit picks up a gun
  _unit addEventHandler ["Take", {
    params ["_taker", "_box", "_item"];

    if (_item call IYC_fnc_isAWeapon) then {
      _box call IYC_fnc_stopTrackingContainerIfNoWeapons;
      _taker call IYC_fnc_trackContainer;
    };
  }];

  // If unit drops a gun
  _unit addEventHandler ["Put", {
    params ["_putter", "_box", "_item"];

    if (_item call IYC_fnc_isAWeapon) then {
      _putter call IYC_fnc_stopTrackingContainerIfNoWeapons;
      _box call IYC_fnc_trackContainer;
    };
  }];
};

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
