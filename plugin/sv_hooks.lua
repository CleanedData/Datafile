local PLUGIN = PLUGIN;

// Create the table for the datafile.
function PLUGIN:ClockworkDatabaseConnected()
    local CREATE_DATAFILE_TABLE = [[
    CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_datafile_table"):Get()..[[` (
    `_Key` smallint(11) unsigned NOT NULL AUTO_INCREMENT,
    `_CharacterID` varchar(50) NOT NULL,
    `_CharacterName` varchar(150) NOT NULL,
    `_SteamID` varchar(60) NOT NULL,
    `_Schema` text NOT NULL,
    `_GenericData` text NOT NULL,
    `_Datafile` text NOT NULL,
    PRIMARY KEY (`_Key`),
    KEY `_CharacterName` (`_CharacterName`),
    KEY `_SteamID` (`_SteamID`))
    ]];

    Clockwork.database:Query(string.gsub(CREATE_DATAFILE_TABLE, "%s", " "), nil, nil, true);
end;

// Check if the player has a datafile or not. If not, create one.
function PLUGIN:PostPlayerSpawn(player)
    local bHasDatafile = PLUGIN:HasDatafile(player);

    // Nil because the bHasDatafile is not in every player their character data.
    if ((!bHasDatafile || bHasDatafile == nil) && !PLUGIN:IsRestrictedFaction(player)) then
        PLUGIN:CreateDatafile(player);
    end;
end;

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
        queryObj:SetValue("_GenericData", "");
        queryObj:SetValue("_Datafile", "");
    queryObj:Push();

    // Change the hasDatafile bool to true to indicate the player has a datafile now.
    player:SetCharacterData("hasDatafile", true);
end;

// Returns true if the player has a datafile.
function PLUGIN:HasDatafile(player)
    return player:GetCharacterData("hasDatafile");
end;

function PLUGIN:HandleDatafile(player, target)
    /*
    bunch of pseudo logic right here
    check if the player is authorized to use th other player their datafile
    check if the player can see restricted files
    stuff like that
    */

    local playerPermission, playerValue = PLUGIN:ReturnPermission(player);
    local targetPermission, targetValue = PLUGIN:ReturnPermission(target);

    if (playerValue >= targetValue) then
        -- allow

    elseif (playerValue < targetValue) then
        -- don't allow
        -- "you do not have permission to access this datafile"
    elseif (bTargetIsRestricted && playerValue < 3) then
        -- don't allow
        -- "this datafile is restricted; access is not granted"
    end;
end;
