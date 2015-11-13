/*
Start scenario. (Executed on server.)

    1. Initialize mission state
    2. Initialize loadouts
    3. Hide police units and police cars
    4. Wait for policeChase to change to true and show the police again.
*/

/* Mission state */
policeChase = false; // Flip to true when the police should come
guardChase = false; // Flip to true when the guards should start to chase you.

private ["_policeObjects", "_robbers"];
_policeObjects = [];

// Initialize loadouts and hide police
{
    switch (side _x) do {
        case (Blufor): {
            _x call BVC_fnc_initPolice;
            [_x, true] call BVC_fnc_globalHideUnit;
            _policeObjects pushBack _x;
        };
        case (Independent): {
            _x call BVC_fnc_initGuard;
        };
        // Robbers are initialized in the mission file
    };
} forEach allUnits;

// Initialize and hide police cars
{
    _x call BVC_fnc_initPoliceCar;
    [_x, true] call BVC_fnc_globalHideUnit;
    _policeObjects pushBack _x;
} forEach entities "C_Offroad_01_F";

// Initialize chaser routine for all the robbers
_robbers = (units (group (allPlayers select 0)));
[_robbers] call BVC_fnc_chaseInit;

// Guards should chase robbers when guardChase is switched over.
[] spawn {
    waitUntil { sleep 2; guardChase };

    {
        // TODO: Use allGroups?
        // Only execute on leaders so the same group isn't added multiple times...
        if (side _x == independent && leader _x == _x) then {
            // TODO: Destroy existing waypoints in case of patrols.
            [group _x] call BVC_fnc_addChasers;
        };
    } forEach allUnits;
};

// Restore police when policeChase is switched over.
[_policeObjects, _robbers] spawn {
    private ["_policeObjects", "_robbers"];
    _policeObjects = param [0];
    _robbers = param [1];

    waitUntil { sleep 2.1; policeChase };

    {
        private "_unit";
        _unit = _x;

        [_unit, false] call BVC_fnc_globalHideUnit;
        // When unit is restored from enableSimulation false, it needs a nudge to understand its
        // surroundings or the AI might not react to anything or do anything.
        // In addition, police dispatch should make all robbers known to the police unit.
        { _unit reveal [_x, 4]; } forEach (_unit nearEntities 50);
        { _unit reveal [_x, 2]; } forEach _robbers;
    } forEach _policeObjects;

    // Let them enter their cars, then tell the ones in a car to chase the robbers.
    sleep 30;
    {
        // Object should be a person, it should be inside a vehicle and it should be the leader of
        // the group (so the group isn't added multiple times)
        if (_x isKindOf "Man" && vehicle _x != _x && leader _x == _x) then {
            [group _x] call BVC_fnc_addChasers;
        };
    } forEach _policeObjects;
};
