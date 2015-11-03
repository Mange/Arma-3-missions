tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

policeChase = false; // Triggered when money is taken

// TODO: Add randomization
initPolice = {
    removeAllWeapons _this;
    removeAllItems _this;
    removeAllAssignedItems _this;
    removeUniform _this;
    removeVest _this;
    removeBackpack _this;
    removeHeadgear _this;
    removeGoggles _this;

    _this forceAddUniform "TRYK_U_B_BLK";
    for "_i" from 1 to 2 do {_this addItemToUniform "ACE_CableTie";};
    _this addItemToUniform "ACE_EarPlugs";
    _this addVest "TRYK_V_tacv1_P_BK";
    for "_i" from 1 to 6 do {_this addItemToVest "CUP_30Rnd_9x19_EVO";};
    for "_i" from 1 to 2 do {_this addItemToVest "ACE_M84";};
    _this addItemToVest "ACE_HandFlare_Red";
    for "_i" from 1 to 2 do {_this addItemToVest "Chemlight_green";};
    _this addItemToVest "SmokeShell";
    _this addHeadgear "TRYK_H_PASGT_BLK";

    _this addWeapon "CUP_smg_EVO";
    _this addPrimaryWeaponItem "acc_flashlight";
};

initGuard = {
    removeAllWeapons _this;
    removeAllItems _this;
    removeAllAssignedItems _this;
    removeUniform _this;
    removeVest _this;
    removeBackpack _this;
    removeHeadgear _this;
    removeGoggles _this;

    _this forceAddUniform "TRYK_U_B_BLTAN_T";
    for "_i" from 1 to 3 do {_this addItemToUniform "RH_17Rnd_9x19_g17";};
    _this addItemToUniform "hlc_30rnd_556x45_EPR";
    _this addVest "TRYK_V_tacSVD_BK";
    _this addItemToVest "ACE_EarPlugs";
    _this addItemToVest "ACE_CableTie";
    for "_i" from 1 to 3 do {_this addItemToVest "ACE_fieldDressing";};
    _this addItemToVest "ACE_morphine";
    for "_i" from 1 to 3 do {_this addItemToVest "hlc_30rnd_556x45_EPR";};
    _this addHeadgear "TRYK_H_headsetcap_blk_Glasses";

    _this addWeapon "hlc_rifle_M4";
    _this addPrimaryWeaponItem "CUP_acc_Flashlight";
    _this addWeapon "RH_g17";

    _this linkItem "ItemMap";
    _this linkItem "ItemCompass";
    _this linkItem "ItemWatch";
    _this linkItem "ItemRadio";
};

{
    if (local _x) then {
        switch (side _x) do {
            case (Blufor): {
                _x call initPolice;
            };
            case (Independent): {
                _x call initGuard;
            };
            // Robbers are initialized in the mission
        };
    };
} forEach allUnits;

initPoliceCar = {
    if (local _this) then {
        [
        	_this,
        	["blue",1],
        	[
        		"hidePolice", 0,
        		"BeaconsStart", 1,
        		"HideBumper2", 0,
        		"Proxy", 0,
        		"Destruct", 0
        	]
        ] call BIS_fnc_initVehicle;
    };
};

{
    _x call initPoliceCar;
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
            units (group (player))
        ] spawn chaseRobbers;
    };
};
