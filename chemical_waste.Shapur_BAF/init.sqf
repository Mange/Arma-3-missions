// Configure TFAR
tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

{
	_x addPrimaryWeaponItem "optic_Holosight";
} foreach (
   	// playable is empty in SP; switchable is empty in MP (when no
   	// AI available; but I disable AI.)
	playableUnits + switchableUnits
);
