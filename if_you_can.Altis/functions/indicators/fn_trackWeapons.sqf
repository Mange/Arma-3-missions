// Track all known positions of a weapon to pick up.

// Start out with the starting container.
// This variable will be kept in sync for all machines using event handlers
// (see IYC_fnc_initEventHandlers)
if (isNil "weaponContainers") then {
  weaponContainers = [weapon1];
};

waitUntil { time > 0 };

// Draw icons on all weapon container's positions
if (hasInterface) then {
  ["IYC_weapon_3dicons", "onEachFrame", {
    // Nato does not get to see any markers. They still get this onEachFrame,
    // however as I want to support team switch in the editor.
    if (side group player == west) exitWith {};

    weaponContainers apply {
      if (_x != player) then {
        private _icon = "\A3\ui_f\data\gui\cfg\hints\rifles_ca.paa";
        private _position = getPosATLVisual _x;

        if (_x isKindOf "Man") then {
          _icon = "\A3\ui_f\data\map\markers\military\warning_CA.paa";
          _position = _x modelToWorld (_x selectionPosition "RightHand"),
        };

        // Unit, icon, color, position, arrows
        [_x, _icon, [1, 0.1, 0.1, 1], _position] call IYC_fnc_drawIcon;
      };
    };
  }] call BIS_fnc_addStackedEventHandler;
};
