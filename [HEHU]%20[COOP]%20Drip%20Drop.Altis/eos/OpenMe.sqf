EOS_Spawn = compile preprocessfilelinenumbers "eos\core\eos_launch.sqf";Bastion_Spawn=compile preprocessfilelinenumbers "eos\core\b_launch.sqf";null=[] execVM "eos\core\spawn_fnc.sqf";onplayerConnected {[] execVM "eos\Functions\EOS_Markers.sqf";};
/* EOS 1.98 by BangaBob
GROUP SIZES
 0 = 1
 1 = 2,4
 2 = 4,8
 3 = 8,12
 4 = 12,16
 5 = 16,20

EXAMPLE CALL - EOS
 null = [["MARKERNAME","MARKERNAME2"],[2,1,70],[0,1],[1,2,30],[2,60],[2],[1,0,10],[1,0,250,WEST]] call EOS_Spawn;
 null=[["M1","M2","M3"],[HOUSE GROUPS,SIZE OF GROUPS,PROBABILITY],[PATROL GROUPS,SIZE OF GROUPS,PROBABILITY],[LIGHT VEHICLES,SIZE OF CARGO,PROBABILITY],[ARMOURED VEHICLES,PROBABILITY], [STATIC VEHICLES,PROBABILITY],[HELICOPTERS,SIZE OF HELICOPTER CARGO,PROBABILITY],[FACTION,MARKERTYPE,DISTANCE,SIDE,HEIGHTLIMIT,DEBUG]] call EOS_Spawn;

EXAMPLE CALL - BASTION
 null = [["BAS_zone_1"],[3,1],[2,1],[2],[0,0],[0,0,EAST,false,false],[10,2,120,TRUE,TRUE]] call Bastion_Spawn;
 null=[["M1","M2","M3"],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES],[HELICOPTERS,SIZE OF HELICOPTER CARGO],[FACTION,MARKERTYPE,SIDE,HEIGHTLIMIT,DEBUG],[INITIAL PAUSE, NUMBER OF WAVES, DELAY BETWEEN WAVES, INTEGRATE EOS, SHOW HINTS]] call Bastion_Spawn;
*/

_debugMode = !isMultiplayer;

VictoryColor="ColorOPFOR";	// Colour of marker after completion
hostileColor="ColorBLUFOR";	// Default colour when enemies active
bastionColor="colorOrange";	// Colour for bastion marker
EOS_DAMAGE_MULTIPLIER=1;	// 1 is default
EOS_KILLCOUNTER=_debugMode;		// Counts killed units

/*
EOS group sizes:
	0 = 1
	1 = 2-4
	2 = 4-8
	3 = 8-12
	4 = 12-16
	5 = 16-20
Factions:
	0 = CSAT
	1 = NATO
	2 = AAF
	3 = Civilian
	4 = FIA

Markers:
	eos_1 = Solar plant
	eos_2 = Storage area
	eos_3 = Northern field
	eos_4 = Military base
	eos_5 = Factory
*/
null = [
	["eos_1","eos_3"],  // Markers
	[0,0],              // House patrol groups [groups, group size, probability]
	[4,2,75],           // Patrolling infantry [groups, group size, probability]
	[1,2,50],           // Motorized infantry [groups, cargo group size, probability]
	[0],                // Armored vehicles [count, probability]
	[2,50],             // Static weapons [?]
	[0,0],              // Helicopters [groups, cargo group size, probability]
	[4,0,500,WEST,false,_debugMode] // [Faction, Marker type, Spawn distance, Side, Height limit, Debug mode]
] call EOS_Spawn;
null = [
	["eos_3"],          // Markers
	[0,0],              // House patrol groups [groups, group size, probability]
	[3,2,60],           // Patrolling infantry [groups, group size, probability]
	[1,2,50],           // Motorized infantry [groups, cargo group size, probability]
	[0],                // Armored vehicles [count, probability]
	[1,50],             // Static weapons [?]
	[1,3],              // Helicopters [groups, cargo group size, probability]
	[1,0,500,WEST,false,_debugMode] // [Faction, Marker type, Spawn distance, Side, Height limit, Debug mode]
] call EOS_Spawn;
null = [
	["eos_2"],          // Markers
	[2,1],              // House patrol groups [groups, group size, probability]
	[3,3,75],           // Patrolling infantry [groups, group size, probability]
	[0,0],              // Motorized infantry [groups, cargo group size, probability]
	[0],                // Armored vehicles [count, probability]
	[0,0],              // Static weapons [?]
	[0,0],              // Helicopters [groups, cargo group size, probability]
	[1,0,500,WEST,false,_debugMode] // [Faction, Marker type, Spawn distance, Side, Height limit, Debug mode]
] call EOS_Spawn;
null = [
	["eos_4"],          // Markers
	[4,1,75],           // House patrol groups [groups, group size, probability]
	[2,1,50],           // Patrolling infantry [groups, group size, probability]
	[0,0],              // Motorized infantry [groups, cargo group size, probability]
	[1,60],             // Armored vehicles [count, probability]
	[0,0],              // Static weapons [?]
	[0,0],              // Helicopters [groups, cargo group size, probability]
	[1,0,500,WEST,false,_debugMode] // [Faction, Marker type, Spawn distance, Side, Height limit, Debug mode]
] call EOS_Spawn;
null = [
	["eos_5"],          // Markers
	[4,1,60],           // House patrol groups [groups, group size, probability]
	[2,1,75],           // Patrolling infantry [groups, group size, probability]
	[1,2,30],           // Motorized infantry [groups, cargo group size, probability]
	[1,50],             // Armored vehicles [count, probability]
	[2,30],             // Static weapons [?]
	[0,0],              // Helicopters [groups, cargo group size, probability]
	[1,0,500,WEST,false,_debugMode] // [Faction, Marker type, Spawn distance, Side, Height limit, Debug mode]
] call EOS_Spawn;
