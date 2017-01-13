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
    if ((!bHasDatafile || bHasDatafile == nil) && PLUGIN:IsRestrictedFaction(player)) then
        PLUGIN:CreateDatafile(player);
    end;
end;
