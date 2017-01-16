local PLUGIN = PLUGIN;

Clockwork.config:Add("mysql_datafile_table", "datafile", nil, nil, true, true, true);

// Update the player their datafile.
function PLUGIN:UpdateDatafile(player, GenericData, datafile)
    /* Datafile structure:
        table to JSON encoded with CW function:
        _GenericData = {
            bol = {false, ""},
            restricted = {false, ""},
            civilStatus = "";
            lastSeen = "";
        };
        _Datafile = {
            entries[k] = {
                category = "", // med, union, civil
                text = "",
                date = "",
                points = "",
                poster = {charName, steamID},
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
        queryObj:SetValue("_GenericData", Clockwork.json:Encode(GenericData));
        queryObj:SetValue("_Datafile", Clockwork.json:Encode(datafile));
    queryObj:Push();

    PLUGIN:LoadDatafile();
end;

// Add a new entry. bCommand is used to prevent logging when /AddEntry is used.
function PLUGIN:AddEntry(category, text, points, player, poster, bCommand)
    --Clockwork.kernel:PrintLog(LOGTYPE_MINOR, poster:Name() .. " has added an entry to " .. player:Name() .. "'s datafile with category: " .. category);
    if (!table.HasValue(PLUGIN.Categories, category)) then return; end;
    if (PLUGIN:ReturnPermission(poster) <= 1 && category == "civil") then return; end;

    local GenericData = PLUGIN:ReturnGenericData(player);
    local datafile = PLUGIN:ReturnDatafile(player);
    local tableSize = PLUGIN:ReturnDatafileSize();

    currentDatafile[tableSize + 1] = {
        category = category,
        text = text,
        date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
        points = points,
        poster = {
            charName = poster:GetCharacter().name,
            steamID = poster:SteamID(),
        },
    };

    PLUGIN:UpdateDatafile(player, GenericData, datafile);
end;

// Set a player their Civil Status.
function PLUGIN:SetCivilStatus(player, poster, civilStatus)
    --Clockwork.kernel:PrintLog(LOGTYPE_MINOR, poster:Name() .. " has changed " .. player:Name() .. "'s Civil Status to: " .. civilStatus);
    if (!table.HasValue(PLUGIN.CivilStatus, civilStatus)) then return; end;
    if (PLUGIN:ReturnPermission(poster) <= 1) then return; end;

    local GenericData = PLUGIN:ReturnGenericData(player);
    local datafile = PLUGIN:ReturnDatafile(player);
    GenericData.civilStatus = civilStatus;

    PLUGIN:AddEntry("union", poster:GetCharacter().name .. " has changed " .. player:GetCharacter().name .. "'s Civil Status to: " .. civilStatus, 0, player, poster);
    PLUGIN:UpdateDatafile(player, GenericData, datafile);
end;

// Scrub a player their datafile.
function PLUGIN:ScrubDatafile(player)
    -- scrub datafile
    -- DROP TABLE datafile ayy lmao
end;

// Edit an entry.
function PLUGIN:EditEntry(player, entry)
    -- edit an entry
end;

// Update the time a player has last been seen.
function PLUGIN:UpdateLastSeen(player, seeer)
    local GenericData = PLUGIN:ReturnGenericData(player);
    local datafile = PLUGIN:ReturnDatafile(player);
    GenericData.lastSeen = os.date("%H:%M:%S - %d/%m/%Y", os.time());

    PLUGIN:UpdateDatafile(player, GenericData, datafile);
end;

// Enable or disable a BOL on the player.
function PLUGIN:SetBOL(bBOL, text, player, poster)
    if (PLUGIN:ReturnPermission(poster) <= 1) then return; end;

    local GenericData = PLUGIN:ReturnGenericData(player);
    local datafile = PLUGIN:ReturnDatafile(player);

    if (bBOL) then
        -- add the BOL with the text
        GenericData.bol[1] = true;
        GenericData.bol[2] = text;

        PLUGIN:AddEntry("union", poster:GetCharacter().name .. " has put a bol on " .. player:GetCharacter().name, 0, player, poster);

    else
        GenericData.bol[1] = false;
        GenericData.bol[2] = "";

        PLUGIN:AddEntry("union", poster:GetCharacter().name .. " has removed a bol on " .. player:GetCharacter().name, 0, player, poster);
    end;

    PLUGIN:UpdateDatafile(player, GenericData, datafile);
end;

// Make the file of a player restricted or not.
function PLUGIN:SetRestricted(bRestricted, text, player, poster)
    if (PLUGIN:ReturnPermission(poster) <= 3) then return; end;

    local GenericData = PLUGIN:ReturnGenericData(player);
    local datafile = PLUGIN:ReturnDatafile(player);

    if (bRestricted) then
        -- make the file restricted with the text
        GenericData.restricted[1] = true;
        GenericData.restricted[2] = text;

        PLUGIN:AddEntry("civil", poster:GetCharacter().name .. " has made " .. player:GetCharacter().name .. "'s file restricted.", 0, player, poster);
    else
        -- make the file unrestricted, set text to ""
        GenericData.restricted[1] = false;
        GenericData.restricted[2] = "";

        PLUGIN:AddEntry("civil", poster:GetCharacter().name .. " has removed the restriction on " .. player:GetCharacter().name .. "'s file.", 0, player, poster);
    end;

    PLUGIN:UpdateDatafile(player, GenericData, datafile);
end;

function PLUGIN:ReturnPoints(player)
    local datafile = PLUGIN:ReturnDatafile(player);
    local points = 0;

    for k, v in pairs(datafile) do
        points = points + tonumber(v.points);
    end;
end;

// Return _GenericData in normal table format.
function PLUGIN:ReturnGenericData(player)
    return player:GetCharacter().file.GenericData;
end;

// Return _Datafile in normal table format.
function PLUGIN:ReturnDatafile(player)
    return player:GetCharacter().file.Datafile;
end;

// Return the size of _Datafile. Used to calculate what key the next entry should be.
function PLUGIN:ReturnDatafileSize(player)
    return #player:GetCharacter().file.Datafile;
end;

// Return the BOL of a player.
function PLUGIN:ReturnBOL(player)
    local GenericData = PLUGIN:ReturnGenericData();
    local bHasBOL = GenericData.bol[1];
    local BOLText = GenericData.bol[2];

    if (bHasBOL) then
        return true, BOLText;
    else
        return false, "";
    end;
end;

// Return the permission of a player. The higher, the more privileges.
function PLUGIN:ReturnPermission(player)
    local faction = player:GetFaction();
    local permission;

    for k, v in pairs(PLUGIN.Permissions) do
        for l, q in pairs(PLUGIN.Permissions[k]) do
            if (faction == q) then
                permission = k;

                if (permission == "elevated") then
                    return 4;

                elseif (permission == "full") then
                    return 3;

                elseif (permission == "medium") then
                    return 2;

                elseif (permission == "minor") then
                    return 1;

                elseif (permission == "none") then
                    return 0;
                end;
            end;
        end;
    end;
end;

// Returns if the player their file is restricted or not, and the text if it is.
function PLUGIN:IsRestricted(player)
    local GenericData = PLUGIN:ReturnGenericData(player);
    local bIsRestricted = GenericData.restricted[1];
    local restrictedText = GenericData.restricted[2];

    return bIsRestricted, restrictedText;
end;

// If the player is apart of any of the factions within PLUGIN.RestrictedFactions, return true.
function PLUGIN:IsRestrictedFaction(player)
    if (table:HasValue(PLUGIN.RestrictedFactions, player:GetFaction())) then
        return true;
    else
        return false;
    end;
end;
