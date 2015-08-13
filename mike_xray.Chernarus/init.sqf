// Configure TFAR
tf_no_auto_long_range_radio = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

TF_defaultWestPersonalRadio = "tf_anprc152";
TF_give_personal_radio_to_regular_soldier = false;
TF_defaultWestRiflemanRadio = "tf_rf7800str";
TF_give_microdagr_to_soldier = false;

// Remove radio unless team leader.
if (isServer) then {
    {
        // Remove radios from all enemies, and non-leaders of West
        if (side _x != west || leader _x != _x) then {
            systemChat "Removing radios!";
            _x unlinkItem "ItemRadio";
            _x removeItems "ItemRadio";
        };
    } forEach allUnits;
};