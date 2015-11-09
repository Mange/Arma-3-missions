private ["_group", "_targetPosition", "_group", "_wp"];

_group = param [0];
_targetPosition = param [1, [0, 0, 0], [[]], 3];

_wp = currentWaypoint _group;

// All waypoints are completed, or there are none.
if (_wp == 0 || count (waypoints _group) == _wp) then {
    _wp = _group addWaypoint [_targetPosition, _wp + 1];
} else {
    // Convert waypoint index into full waypoint format
    _wp = [_group, _wp];
};

_wp setWaypointPosition [_targetPosition, 0];
_wp setWaypointType "DESTROY";
_wp setWaypointSpeed "FULL";
_wp setWaypointBehaviour "COMBAT";
