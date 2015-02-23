class NumberOfEnemies {
	title = "Number of enemies";
	texts[] = {"7", "10", "15", "20", "30", "40"};
	values[] = {7, 10, 15, 20, 30, 40};
	default = 20;
};

class EnemyAlertness {
	title = "Enemy alertness";
	texts[] = {"Stand still", "Respond to threats", "Some will look for you", "Most will look for you", "All will look for you"};
	values[] = {0, 1, 2, 3, 4};
	default = 0;
};

#include "\a3\functions_f\Params\paramWeather.hpp"
#include "\a3\functions_f\Params\paramDaytimePeriod.hpp"
