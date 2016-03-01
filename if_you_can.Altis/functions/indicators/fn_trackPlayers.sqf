// Track players
// Civilians can see all other civilians, and dead player markers.
// Nato can only see dead player's markers.

waitUntil { time > 0 };

trackedPlayers = [];
trackedDead = [];

// TODO: Params for this.
// Assassins have markers on: All players, Assassins (default), Peacekeepers, None
// Peacekeepers have markers on: Soldiers, None (default)

if (side group player == civilian) then {
  if (isMultiplayer) then {
    trackedPlayers = (call BIS_fnc_listPlayers) select { _x != player && side group _x == civilian };
  } else {
    trackedPlayers = (allUnits select [0, 5]) select { _x != player };
  };
};

["IYC_player_3dicons", "onEachFrame", {
  trackedPlayers apply {
    // Unit, icon, color, position, text, arrows
    [
      _x,
      "\A3\ui_f\data\map\markers\military\box_CA.paa",
      nil,
      (getPosATLVisual _x) vectorAdd ([0, 0, 2]), // 2 meters above feet (0.2 meters above head when standing)
      "", // Don't show player names for alive players
      (side group player == civilian) // NATO gets no arrows
    ] call IYC_fnc_drawIcon;
  };

  trackedDead apply {
    // Unit, icon, color, position, text, arrows
    [
      _x,
      "\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa",
      [1, 0, 0, 1],
      _x modelToWorld (_x selectionPosition "head_hit"),
      nil,
      (side group player == civilian) // NATO gets no arrows
    ] call IYC_fnc_drawIcon;
  };
}] call BIS_fnc_addStackedEventHandler;
