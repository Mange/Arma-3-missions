{
	alive _x &&
	!(fleeing _x) &&
	// Note: A getFriend B does not have to equal B getFriend A.
	// For example: West could be friendly to all civilians, while the civilians
	// hate and avoid West. We want to know how many enemies exist in relation to
	// the PLAYER here, so we need to have the player on the left-hand side.
	((side player) getFriend (side _x)) < 0.6
} count allUnits