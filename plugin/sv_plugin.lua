local PLUGIN = PLUGIN;

Clockwork.config:Add("mysql_datafile_table", "datafile", nil, nil, true, true, true);

PLUGIN.Types = {
    "med",      // Medical note.
    "union",    // Union (CWU, WI, UP) type note.
    "civil",    // Civil Protection/CTA type note.
};

PLUGIN.Permissions = {
    elevated = {
        "Overwatch",
    },
    full = {
        "Combine Transhuman Arm",
        "Civil Administration Board",
        "Civil Protection",
    },
    medium = {
        "Server Administration"
    },
    minor = {
        "Civil Worker's Union",
        "Willard Industries",
        "Unity Party",
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

// Create a datafile for the player.
function PLUGIN:CreateDatafile(player)
    local schemaFolder = Clockwork.kernel:GetSchemaFolder();
    local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
    local character = player:GetCharacter();
    local steamID = player:SteamID();

    // Set all the values.
    local queryObj = Clockwork.database:Insert(datafileTable);
        queryObj:SetValue("_CharacterID", character.characterID);
        queryObj:SetValue("_CharacterName", character.name);
        queryObj:SetValue("_SteamID", steamID);
        queryObj:SetValue("_Schema", schemaFolder);
        queryObj:SetValue("_Datafile", "this will hopefully be the datafile");
    queryObj:Push();

    // Change the hasDatafile bool to true to indicate the player has a datafile now.
    player:SetCharacterData("hasDatafile", true);
end;

// Returns true if the player has a datafile.
function PLUGIN:HasDatafile(player)
    local bHasDatafile = player:GetCharacterData("hasDatafile");

    return bHasDatafile;
end;

// Update the player their datafile.
function PLUGIN:UpdateDatafile(player, fileTable)
    /* Datafile structure:
        table to JSON encoded with CW function:
        datafile = {
            bol = {false, ""},
            civilStatus = "";
            lastSeen = "";
            entries = {
                entries[k] = {
                    type = "", // med, union, civil
                    text = "",
                    date = "",
                    points = "",
                    poster = "",
                },
            },
        };
    */

    local schemaFolder = Clockwork.kernel:GetSchemaFolder();
    local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
    local character = player:GetCharacter();

    local queryObj = Clockwork.database:Update(datafileTable);
        queryObj:AddWhere("_CharacterID = ?", character.id);
        queryObj:AddWhere("_SteamID = ?", player:SteamID());
        queryObj:AddWhere("_Schema = ?", schemaFolder);
        queryObj:SetValue("_CharacterName", character.name);
        queryObj:SetValue("_Datafile", Clockwork.json:Encode(fileTable));
    queryObj:Push();
end;

// If the player is apart of any of the factions within PLUGIN.RestrictedFactions, return true.
function PLUGIN:IsRestrictedFaction(player)
    if (table:HasValue(PLUGIN.RestrictedFactions, player:GetFaction())) then
        return true;
    else
        return false;
    end;
end;
