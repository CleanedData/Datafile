local PLUGIN = PLUGIN;

PLUGIN:SetGlobalAlias("cwDatafile");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

// All the categories possible. Yes, the names are quite annoying.
PLUGIN.Categories = {
	"med",      // Medical note.
	"union",    // Union (CWU, WI, UP) type note.
	"civil",    // Civil Protection/CTA type note.
};

DATAFILE_PERMISSION_NONE = 0;
DATAFILE_PERMISSION_MINOR = 1;
DATAFILE_PERMISSION_MEDIUM = 2;
DATAFILE_PERMISSION_FULL = 3;
DATAFILE_PERMISSION_ELEVATED = 4;

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
		"Civil Protection",
	},
	medium = {
		"Server Administration",
	},
	minor = {
		"Civil Worker's Union",
		"Willard Industries",
		"Unity Party",
	},
	none = {
		"Citizen",
	},
};

// All the civil statuses. Just for verification purposes.
PLUGIN.CivilStatus = {
	"Anti-Citizen",
	"Citizen",
	"Black",
	"Brown",
	"Red",
	"Blue",
	"Green",
	"White",
	"Gold",
	"Platinum",
};

PLUGIN.Default = {
	GenericData = {
        bol = {false, ""},
        restricted = {false, ""},
        civilStatus = "Citizen",
        lastSeen = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
        points = 0,
        sc = 0,
	},
	civilianDatafile = {
        [1] = {
           	category = "union", // med, union, civil
            text = "TRANSFERRED TO DISTRICT WORKFORCE.",
            date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
            points = "0",
            poster = {"Overwatch", "BOT"},
        },
	},
	combineDatafile = {
        [1] = {
           	category = "union", // med, union, civil
            text = "INSTATED AS CIVIL PROTECTOR.",
            date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
            points = "0",
            poster = {"Overwatch", "BOT"},
        },
	},
};
