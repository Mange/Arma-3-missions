// Pick a random position and add a waypoint there.
private ["_unit", "_startingPosition", "_destination_1", "_destination_2", "_wp"];
_unit = _this select 0;
_startingPosition = _this select 1;
_destination_1 = (_this select 2) call BIS_fnc_selectRandom;
_destination_2 = (_this select 2) call BIS_fnc_selectRandom;

_wp = (group _unit) addWaypoint [_destination_1, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "LIMITED";

((group _unit) addWaypoint [_destination_2, 0]) setWaypointType "MOVE";
((group _unit) addWaypoint [_startingPosition, 0]) setWaypointType "CYCLE";