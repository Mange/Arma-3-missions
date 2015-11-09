tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

if (isServer) then {
    [] call BVC_fnc_scenarioInit;

    // Let the cops loose when money disappears
    // TODO: Switch to activate on a trigger instead.
    [] spawn {
        // entities does not work for this one
        // cashTotal = count entities "CUP_item_Money";
        cashTotal = count allMissionObjects "CUP_item_Money";
        waitUntil { sleep 9; count allMissionObjects "CUP_item_Money" < cashTotal };
        hint "policeChase = true";
        policeChase = true;
    };
};
