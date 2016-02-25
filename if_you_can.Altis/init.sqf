tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = false;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

lastPoisonTry = 0; // Point in time where the civilian tried to poison the last time.
poisonCooldownSeconds = 30; // Number of seconds that need to pass after last try in order to be able to poison again.
poisonDistance = 2.2; // Distance that poison can be given.
poisonDamage = 0.25; // TODO: Parameter for this
poisonApplicationTime = 1; // Seconds to apply poison for it to succeed.

weaponAmmo = "30Rnd_9x21_Mag"; // Ammo that works with the weapon on the ground

call IYC_fnc_scenarioInit;
