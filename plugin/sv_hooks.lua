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

    PLUGIN:LoadDatafile(player);
end;

function PLUGIN:LoadDatafile(player)
    local schemaFolder = Clockwork.kernel:GetSchemaFolder();
    local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
    local character = player:GetCharacter();

    local queryObj = Clockwork.database:Select(datafileTable);
        queryObj:AddWhere("_CharacterID = ?", character.characterID);
        queryObj:AddWhere("_SteamID = ?", player:SteamID());
        queryObj:AddWhere("_Schema = ?", schemaFolder);
        queryObj:SetCallback(function(result)
            if (!IsValid(player)) then return; end;

            if (Clockwork.database:IsResult(result)) then
                PrintTable(result)
                character.file = {
                    GenericData = Clockwork.json:Decode(result[1]._GenericData);
                    Datafile = Clockwork.json:Decode(result[1]._Datafile);
                };
            end;
        end);

    queryObj:Pull();
end;

// Create a datafile for the player.
function PLUGIN:CreateDatafile(player)
    if (player) then
        local schemaFolder = Clockwork.kernel:GetSchemaFolder();
        local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
        local character = player:GetCharacter();
        local steamID = player:SteamID();
        local defaultGenericData = {
            bol = {false, ""},
            restricted = {false, ""},
            civilStatus = "Citizen",
            lastSeen = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
        };

        local defaultDatafile = {
            [1] = {
                category = "union", // med, union, civil
                text = "INITIATED INTO WORKFORCE.",
                date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
                points = "0",
                poster = {"Overwatch", "BOT"},
            },
        };

        // Set all the values.
        local queryObj = Clockwork.database:Insert(datafileTable);
            queryObj:SetValue("_CharacterID", character.characterID);
            queryObj:SetValue("_CharacterName", character.name);
            queryObj:SetValue("_SteamID", steamID);
            queryObj:SetValue("_Schema", schemaFolder);
            queryObj:SetValue("_GenericData", Clockwork.json:Encode(defaultGenericData));
            queryObj:SetValue("_Datafile", Clockwork.json:Encode(defaultDatafile));
        queryObj:Push();

        // Change the hasDatafile bool to true to indicate the player has a datafile now.
        player:SetCharacterData("hasDatafile", true);
    end;
end;

// Returns true if the player has a datafile.
function PLUGIN:HasDatafile(player)
    return player:GetCharacterData("hasDatafile");
end;

function PLUGIN:HandleDatafile(player, target)
    local playerValue = PLUGIN:ReturnPermission(player);
    local targetValue = PLUGIN:ReturnPermission(target);
    local bTargetIsRestricted, restrictedText = PLUGIN:IsRestricted(player);

    print(playerValue, targetValue)

    if (playerValue >= targetValue) then
        -- allow
        Clockwork.player:Notify(player, "Yes.");

    elseif (playerValue < targetValue) then
        -- don't allow
        Clockwork.player:Notify(player, "You are not authorized to access this datafile.");

    elseif (bTargetIsRestricted && playerValue < 3) then
        -- don't allow
        Clockwork.player:Notify(player, "This datafile has been restricted; access denied. REASON: " + restrictedText);
    end;
end;
