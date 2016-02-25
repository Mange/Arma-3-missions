/*
Always run this function on the client of the unit.
*/

// Keep screen dark in the beginning so AI players can adjust their positions
// properly without giving players away (as they would not be moving).
// Also allows players to rotate a bit in the beginning to orient themselves.
[] spawn {
  titleText ["Find and kill the hidden players", "BLACK IN", 500];
  sleep 6;
  titleText ["Find and kill the hidden players", "BLACK IN", 1];
};
