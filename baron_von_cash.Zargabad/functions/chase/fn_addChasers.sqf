/* Adds the given unit groups as chasers. */
if (isServer) then {
    chaseGroups append _this;
} else {
    _this remoteExec ["BVC_fnc_addChasers", 2]; // run on server
};
