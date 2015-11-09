/*
Inits the "chase" system.

It keeps a list of units that should be chased, the currently targeted unit and the groups that
should do the chasing. Add units to either list at runtime to add more parts to the system.
If target list gets empty, the system will stop and need to be initialized again.
*/

// Don't allow more than one loop to run at once. If the variables are set to true, we have a loop
// already.
if (!isNil "chaseInitialized") then {
    if (chaseInitalized) exitWith { };
};

chaseInitialized = true;
chaseTargets = param [0, [], [[]]];
chaseGroups = param [1, [], [[]]];

[] spawn {
    private ["_debug", "_debugMarker", "_loop", "_currentLocation"];
    waitUntil { time > 1 };

    _debug = !isMultiplayer;
    _debugMarker = "chaseDebugMarker";

    if (count chaseTargets == 0) then {
        waitUntil { sleep 1; count chaseTargets > 0 }
    };

    // Create debug marker
    if (_debug) then {
        createMarker [_debugMarker, [0, 0]];
        _debugMarker setMarkerType "o_unknown";
        _debugMarker setMarkerColor "ColorRed";
    };

    _loop = true;
    while {_loop} do {
        chaseTargets = chaseTargets call CBA_fnc_getAlive;
        if (count chaseTargets > 0) then {
            // Determine the location to chase currently
            _currentPosition = getPos (chaseTargets select 0);

            // Update debug marker
            if (_debug) then {
                _debugMarker setMarkerPos _currentPosition;
                _debugMarker setMarkerText (str (count chaseGroups));
            };

            {
                private ["_chaser"];
                _chaser = _x;

                // Make all chasers know about all targets
                {
                    _chaser reveal [_x, 4];
                } forEach chaseTargets;

                [_x, _currentPosition] call BVC_fnc_keepChasing;

                sleep 0.2;
            } forEach chaseGroups;

            sleep 5;
        } else {
            _loop = false;
        }
    };

    if (_debug) then {
        deleteMarker _debugMarker;
    };
    chaseInitialized = false;
};
