params ["_unit"];
private ["_totalWps", "_wpIndex", "_wpPos", "_wp"];

_totalWps = [2, 7] call BIS_fnc_randomInt;

_wp = (group _unit) addWaypoint [getPos _unit, 0];
_wp setWaypointTimeout [5, 50, 120];
_wp setWaypointCompletionRadius 5;
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

for "_wpIndex" from 0 to _totalWps-1 do {
  if (random 1 < 0.7) then {
  _wpPos = [playArea] call BIS_fnc_randomPosTrigger;
  } else {
    _wpPos = [closeToGun] call BIS_fnc_randomPosTrigger;
  };

  _wp = (group _unit) addWaypoint [_wpPos, 0];
  _wp setWaypointBehaviour "SAFE";
  _wp setWaypointSpeed "LIMITED";
  _wp setWaypointCompletionRadius 1;

  switch ([1, 6] call BIS_fnc_randomInt) do {
    case (1): {
      // No timeout.
    };
    case (2): {
      _wp setWaypointTimeout [5, 20, 50];
    };
    default {
      _wp setWaypointTimeout [30, 70, 120];
    };
  };

_wp = (group _unit) addWaypoint [getPos _unit, 0];
_wp setWaypointType "CYCLE";
