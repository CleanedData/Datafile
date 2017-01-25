local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

// All the categories possible.
PLUGIN.Categories = {
	"med",      // Medical note.
	"union",    // Union (CWU, WI, UP) type note.
	"civil",    // Civil Protection/CTA type note.
};

// Permissions for the numerous factions.
PLUGIN.Permissions = {
	elevated = {
		"Overwatch",
	},
	full = {
		"Combine Transhuman Arm",
		"Overwatch Transhuman Arm",
		"Administrator",
		"Civil Administration Board",
		"Metropolice Force",
	},
	medium = {
		"Server Administration",
	},
	minor = {
		"Civil Worker's Union",
		"Willard Industries",
		"Unity Party",
		"Citizen",
	},
};

// Factions that do not get access to the datafile & factions that do not get a datafile.
PLUGIN.RestrictedFactions = {
	"Alien Grunt",
	"Bird",
	"Houndeye",
	"Vortigaunt",
	"Zombie",
	"Houndeye"
};

PLUGIN.CivilStatus = {
	"Anti-Citizen",
	"Citizen",
	"Brown",
	"Red",
	"Blue",
	"Green",
	"White",
	"Gold",
	"Platinum",
};
