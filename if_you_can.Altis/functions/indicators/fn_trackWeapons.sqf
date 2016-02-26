// Track all known positions of a weapon to pick up.

// Start out with the starting container.
// TODO: Don't reset if already defined (JIP)
weaponContainers = [weapon1];

fn_isAWeapon = {
  private _class = _this;
  _class isKindOf ["Rifle", configFile >> "cfgWeapons"] || _class isKindOf ["Pistol", configFile >> "cfgWeapons"];
};

fn_addContainer = {
  private _container = _this;
  weaponContainers pushBackUnique _container;
  publicVariable "weaponContainers";
};

fn_removeContainerIfNoMoreWeapons = {
  private _container = _this;
  // Only remove container when it no longer contains any weapons.
  if (count weaponCargo _container == 0) then {
    _container call fn_removeContainer;
  };
};

fn_removeContainer = {
  private _container = _this;
  private _index = weaponContainers find _container;
  // Check if it's even in the container list in the first place.
  if (_index >= 0) then {
    weaponContainers deleteAt _index;
    publicVariable "weaponContainers";
  };
};

waitUntil { time > 0 };

// Temp hack for editor:
// weaponContainers append (allUnits select { side group _x == west });

// Set up EH only on local entities; then broadcast changes to weaponContainers
// when it is changed. This should save a lot of combined processing.
allUnits select { local _x } apply {
  private _unit = _x;

  // If unit picks up a gun
  _unit addEventHandler ["Take", {
    params ["_taker", "_box", "_item"];

    if (_item call fn_isAWeapon) then {
      _box call fn_removeContainerIfNoMoreWeapons;
      _taker call fn_addContainer;
    };
  }];

  // If unit drops a gun
  _unit addEventHandler ["Put", {
    params ["_putter", "_box", "_item"];

    if (_item call fn_isAWeapon) then {
      _putter call fn_removeContainerIfNoMoreWeapons;
      _box call fn_addContainer;
    };
  }];

  // If unit dies
  _unit addEventHandler ["Killed", {
    params ["_victim"];
    _victim call fn_removeContainer;
  }];
};

// Draw icons on all weapon container's positions
if (hasInterface) then {
  ["IYC_3dicons", "onEachFrame", {
    // Nato does not get to see any markers. They still get this onEachFrame,
    // however as I want to support team switch in the editor.
    if (side group player == west) exitWith {};

    weaponContainers apply {
      private _icon = "\A3\ui_f\data\gui\cfg\hints\rifles_ca.paa";
      private _position = getPosATLVisual _x;
      private _color = [1, 0.1, 0.1, 1];
      private _distance = player distance _x;

      if (_x != player && _distance > 0) then {
        if (_x isKindOf "Man") then {
          _icon = "\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa";
          _position = _x modelToWorld (_x selectionPosition "RightHand");
        };

        // Make the icon smaller the further away you are, but lengthen the factor
        // by only looking at 20% of the distance so it doesn't shrink too fast.
        private _scale = 1 / (_distance * 0.2);
        if (_scale > 2) then { _scale = 2; };
        if (_scale < 0.3) then { _scale = 0.3; };

        // Make it a bit more transparent when near
        // http://www.wolframalpha.com/input/?i=plot+f(x)%3D(ln(x)%2B2)%2F4,+0%3Cx%3C7
        if (_distance < 7) then {
          private _opacity = ((ln _distance) + 2) / 4;
          _color set [3, (_opacity max 0.1) min 1.0];
        };

        drawIcon3D [
          _icon, _color, _position,
          1 * _scale, 1 * _scale, // Width, height
          0, // Angle
          "", // Optional text
          0, // Optional shadow
          0, // Optional text size
          "", // Optional font
          "", // Optional text alignment
          true // Optional show side arrows?
        ];
      };
    };
  }] call BIS_fnc_addStackedEventHandler;
};