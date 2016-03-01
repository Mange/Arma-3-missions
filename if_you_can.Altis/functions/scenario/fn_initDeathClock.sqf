if (isServer) then {
  [] spawn {
    waitUntil { time > 0 };

    private _npcs = (
      allUnits select { !isPlayer _x && side group _x == civilian }
    ) - switchableUnits;

    while { count _npcs > 0 } do {
      sleep deathClockInterval;
      private _index = floor random (count _npcs);
      private _target = _npcs select _index;

      _npcs deleteAt _index;

      // If we do setDamage 1, the character will end up really bloody. By just
      // damaging a specific part of the unit, we'll only get blood on that part
      // so the body looks a lot more intact.
      // Index 2 is "HitHead" in this case.
      private _hitPointIndexes = (getAllHitPointsDamage _target) select 0;
      private _hitIndex = (_hitPointIndexes find "HitHead");

      // Just in case Arma changes in the future and no "HitHead" exists
      // anymore.
      if (_hitIndex < 0) then { _hitIndex = 0 };
      _target setHitIndex [_hitIndex, 1];
    };
  };
};
