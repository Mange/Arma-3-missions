# Arma 3 missions

Missions I work on for Arma 3.

## Missions

Here's a short summary of the different missions.

### Baron von Cash

**Type:** Cooperative (2-4 players)

Perform an armed robbery and escape with the money.

**Interesting parts:**
* Enemies chasing you when you are discovered. They will never give up and they are ruthless.
* All units have custom load outs.
* Police cars.
* Very hard difficulty.
* Mission-specific library functions.

### CQBuilding 1

**Type:** Training

CQB practice in two killhouses (from `@mbg_killhouses_a3`). Full virtual armory to try out your loadouts.

Initial mission where I started on my CQB framework.

**TODO:** Port to new HEHU_CQB version.

### CQBuilding 2

**Type:** Training

CQB practice in a large maze (from `@mbg_killhouses_a3`). Full virtual armory to try out your loadouts.

Initial mission where I started on my CQB framework.

**TODO:** Port to new HEHU_CQB version.

### Drip Drop

**Type:** Invasion

CSAT invades a few areas of Altis using helicopter transport/CAS. Don't take too long as darkness is approaching. Uses EOS for enemy placement.

**Interesting parts:**
* Rearming script.
* Properly formatted EOS config.

### Home-wreckers

CQB in a medium-sized town. Random enemy patrols, and two cars driving around. Players start at random, but fixed, spawn points with no radios. They need to find each other and clear out the town.

**Interesting parts:**
* Random "spawns" from a list of spawn points.
* Weapons and equipment tied to the location.
* No radios for the players, so they need to rely on fuzzy GPS tracking to find each other.

### ...if you can

A recreation of the *Kill the Traitor* community mission. One soldier locked inside a room full of civilians. Some of the civilians are the other players. In the middle of the room, there is a gun. It's up to the players to try to kill the soldier, and the solider's job is to find the players among the civilians.

**Still a work in progress.**

**Interesting parts:**
* Randomized faces and voices of players.
* Care is taken to make sure everything is randomized and anonymized.
* Everything kept vanilla. No mods required.

### Knock, Knock

**Type:** Last Breath

The original HEHU Last Breath. Stay alive in the cold Finnish winter night as the enemies storm from every direction.

**Interesting parts:**
* Unscripted waves.
* Conditional to remove magnifying optics.

**TODO:** Port to newest version of Arma / HEHU modset.

### Look out

**Type:** Last Breath

Defend a worthless island to your last breath.

**TODO:** Make it less hard now that firing from vehicles came. You die too fast.

### Misty ###

**Type:** Coop

It looks like a normal invasion mission where you are about to clear out an airport, but you are oh so wrong.

**Interesting parts:**
* Almost no scripting.
* Uses sound and environment effects for story/twist.

### UPS Man

**Type:** Coop

Escort a pilot to an airfield, steal an airplane and a truck and take out enemies in a village together.

**Interesting parts:**
* Time skip script.
* Rearming script.

### Mike X-Ray

**Type:** Coop

Two groups move through the woods to destroy to AA turrets.

**Interesting parts:**
* Randomized patrols using editor.
* Arrow pointing to one extra ammo box if the first one is destroyed and AA turrents are still there.

### Martyr

**Type:** PvP

Terrorists vs PMC battle in a town. Terrorist(s) are very, very outnumbered but have access to mines and other explosives.

**Interesting parts:**
* Countdown until mission start.
* Different endings depending on side.
* Strategic map for choosing insertion.
* Parameter for map/GPS settings.
* Custom loadouts for every unit.

### Camel Kick

**Type:** Coop

Destroy a NATO convoy passing through Fallujah and escape.

**Interesting parts:**
* Completely custom ammo box.
* `addAction` to trigger convoy.

### Chemical Waste

**Type:** Coop

Clear out a factory of enemies.

**Interesting parts:**
* Uses `@hehu_mf`; built in an hour
