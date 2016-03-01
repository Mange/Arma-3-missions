params ["_unit"];

private _actionId = _unit getVariable "IYC_poisonActionId";
if (!isNil "_actionId") then {
  _unit removeAction _actionId;
  _unit setVariable ["IYC_poisonActionId", nil, false];
};
