tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

robberGroup = (group player);
policeChase = false; // Triggered when money is taken

globalHideUnit = {
    params ["_unit", "_hide"];
	_unit hideObjectGlobal _hide;
    _unit enableSimulationGlobal !_hide;
};

policeUnits = [];
{
    if (side _x == blufor) then {
        policeUnits pushBack _x;
    }
} forEach (allUnits);
{ policeUnits pushBack _x; } forEach entities "C_Offroad_01_F";

if (isServer) then {
    {
        [_x, true] call globalHideUnit;
    } forEach policeUnits;

    [] spawn {
        waitUntil { sleep 2; policeChase };
        {
            [_x, false] call globalHideUnit;
        } forEach policeUnits;
    };
};

{
    if (local _x) then {
        switch (side _x) do {
            case (Blufor): {
                _x call bvc_fnc_initPolice;
            };
            case (Independent): {
                _x call bvc_fnc_initGuard;
            };
            // Robbers are initialized in the mission file
        };
    };
} forEach allUnits;

{
    _x call bvc_fnc_initPoliceCar;
} forEach entities "C_Offroad_01_F";

selectFirstAlive = {
    private ["_selected"];
    _selected = (_this select 0);

    {
        if (!alive _selected) then {
            _selected = _x;
        };
    } forEach _this;

    _selected;
};

chaseRobbers = {
    params ["_groups", "_robbers"];
    /*
    Set up a waypoint for each _groups.

    In each iteration:
        - Determine if current target is dead, then swith to the next Robber
        - Get position of the Robber
        - Go through each group and move their waypoints.
    */

    private ["_target", "_currentPosition"];

    // Initial state; target first alive robber
    _target = _robbers call selectFirstAlive;
    _currentPosition = getPos _target;

    // Run as long as we have any living robbers
    while {{ alive _x } count _robbers > 0} do {
        // Target is dead; select a new one
        if (!alive _target) then {
            // Stop if all robbers are dead.
            if (count _robbers == 0) exitWith { };
            _target = _robbers call selectFirstAlive;
            if (!alive _target) exitWith { };
        };

        // Update position
        _currentPosition = getPos _target;
        {
            private ["_group", "_wp"];
            _group = _x;
            // Move (or create) the current waypoint to the new position
            _wp = currentWaypoint _group;
            // All waypoints are completed, or there are none.
            if (_wp == 0 || count (waypoints _group) == _wp) then {
                _wp = _group addWaypoint [_currentPosition, _wp + 1];
            } else {
                // Convert waypoint index into full waypoint format
                _wp = [_group, _wp];
            };

            _wp setWaypointPosition [_currentPosition, 20];
            _wp setWaypointType "DESTROY";
            _wp setWaypointSpeed "FULL";
            _wp setWaypointBehaviour "COMBAT";
            sleep 0.2;
        } forEach _groups;

        sleep 3;
    };
};

allGroupsInSide = {
    private ["_groups"];
    _groups = [];

    {
        if (side _x == _this) then {
            _groups pushBack _x;
        };
    } forEach allGroups;

    _groups
};

// Let the cops loose when money disappears
if (isServer) then {
    [] spawn {
        // entities does not work for this one
        // cashTotal = count entities "CUP_item_Money";
        cashTotal = count allMissionObjects "CUP_item_Money";

        waitUntil { sleep 9; count allMissionObjects "CUP_item_Money" < cashTotal };

        policeChase = true;

        // Let everyone get into their cars
        sleep 30;
        [
            [(group officer1), (group officer2), (group officer3)],
            units robberGroup
        ] spawn chaseRobbers;
    };
};
