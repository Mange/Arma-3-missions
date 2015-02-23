private ["_trigger", "_radius"];
_trigger = _this select 0;
_radius = (triggerArea _trigger) select 0;
nearestObjects [_trigger, ["House"], _radius];