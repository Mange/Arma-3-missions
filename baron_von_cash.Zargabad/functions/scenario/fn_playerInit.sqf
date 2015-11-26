private ["_robbers", "_cars", "_driver", "_carIndex", "_robbersPerCar"];

_robbers = units player;
_cars = [car1, car2];

// Distribute robbers evenly among the cars
if (count _robbers < 4) then {
    _robbersPerCar = (count _robbers);
} else {
    _robbersPerCar = ceil ((count _robbers) / (count _cars));
};

_carIndex = 0;
for "_i" from 0 to ((count _robbers) - 1) do {
    private ["_robber", "_car"];
    _robber = (_robbers select _i);
    _car = (_cars select _carIndex);

    if (local _robber) then {
        // First robber for this car should be the driver
        if (_i % _robbersPerCar == 0) then {
            _robber moveInDriver _car;
        } else {
            _robber moveInCargo _car;
        };
    };

    if (_i % _robbersPerCar == _robbersPerCar-1) then {
        _carIndex = _carIndex + 1;
    };
};

if (_carIndex == 0) then {
    // Robbers fit in a single car. Delete the other one.
    deleteVehicle car2;
};
