/*
Scenario start
*/

call IYC_fnc_initLoadouts;

allUnits apply {
    private _unit = _x;

    if (local _unit) then {
        _unit call IYC_fnc_setRandomDirection;

        if (side _unit == civilian && _unit isKindOf "Man") then {
          _unit call IYC_fnc_civilianInit;
        };

        if (!isPlayer _unit) then {
          if (side _unit == west) then {
            // Non-player NATO soldiers should not be in the game. AIs cannot
            // play this role.
            if (isMultiplayer) then {
              deleteVehicle _unit;
            };
          } else {
            _unit call IYC_fnc_npcInit;
          };
        };
    };
};

if (hasInterface) then {
  // Wait for scenario to start, or the side will not be the actual side in the
  // editor preview.
  waitUntil { time > 0 };

  if (side player == west) then {
    call IYC_fnc_soldierInit;
  };

  if (side player == civilian) then {
    call IYC_fnc_assassinInit;
  };

  call IYC_fnc_initVictoryConditions;
  call IYC_fnc_initEventHandlers;

  call IYC_fnc_trackWeapons;
  call IYC_fnc_trackPlayers;
};

call IYC_fnc_initDeathClock;
