local PLUGIN = PLUGIN;

--PLUGIN.UsingDatafile = {};

Clockwork.config:Add("mysql_datafile_table", "datafile", nil, nil, true, true, true);

// Update the player their datafile.
function PLUGIN:UpdateDatafile(player, GenericData, datafile)
    /* Datafile structure:
        table to JSON encoded with CW function:
        _GenericData = {
            bol = {false, ""},
            restricted = {false, ""},
            civilStatus = "",
            lastSeen = "",
            points = 0,
            sc = 0,
        };
        _Datafile = {
            entries[k] = {
                category = "", // med, union, civil
                hidden = boolean,
                text = "",
                date = "",
                points = "",
                poster = {charName, steamID, color},
            },
        };
    */

    local schemaFolder = Clockwork.kernel:GetSchemaFolder();
    local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
    local character = player:GetCharacter();

    local queryObj = Clockwork.database:Update(datafileTable);
        queryObj:AddWhere("_CharacterID = ?", character.characterID);
        queryObj:AddWhere("_SteamID = ?", player:SteamID());
        queryObj:AddWhere("_Schema = ?", schemaFolder);
        queryObj:SetValue("_CharacterName", character.name);
        queryObj:SetValue("_GenericData", Clockwork.json:Encode(GenericData));
        queryObj:SetValue("_Datafile", Clockwork.json:Encode(datafile));
    queryObj:Push();

    PLUGIN:LoadDatafile(player);
end;

// Add a new entry. bCommand is used to prevent logging when /AddEntry is used.
function PLUGIN:AddEntry(category, text, points, player, poster, bCommand)
    if (!table.HasValue(PLUGIN.Categories, category)) then return; end;
    if ((PLUGIN:ReturnPermission(poster) <= 1 && category == "civil") || PLUGIN:ReturnPermission(poster) == 0) then return; end;
    
    Clockwork.kernel:PrintLog(LOGTYPE_MINOR, poster:Name() .. " has added an entry to " .. player:Name() .. "'s datafile with category: " .. category);

    local GenericData = PLUGIN:ReturnGenericData(player);
    local datafile = PLUGIN:ReturnDatafile(player);
    local tableSize = PLUGIN:ReturnDatafileSize(player);

    if (Schema:PlayerIsCombine(player)) then
        GenericData.sc = GenericData.sc + points;
    else
        GenericData.points = GenericData.points + points;
    end;

    datafile[tableSize + 1] = {
        category = category,
        hidden = false,
        text = text,
        date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
        points = points,
        poster = {
            poster:GetCharacter().name,
            poster:SteamID(),
            team.GetColor(poster:Team()),
        },
    };

    PLUGIN:UpdateDatafile(player, GenericData, datafile);
end;

/*
function PLUGIN:AddDatafileUser(user, target)
    local tableSize = #PLUGIN.UsingDatafile;

    PLUGIN.UsingDatafile[tableSize + 1] = {user, target};
end;
*/

// Set a player their Civil Status.
function PLUGIN:SetCivilStatus(player, poster, civilStatus)
    Clockwork.kernel:PrintLog(LOGTYPE_MINOR, poster:Name() .. " has changed " .. player:Name() .. "'s Civil Status to: " .. civilStatus);
    
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
    PLUGIN:UpdateDatafile(player, PLUGIN.Default.GenericData, PLUGIN.Default.civilianDatafile);
end;

// Edit an entry.
function PLUGIN:EditEntry(player, entry)
    -- edit an entry
end;

// Update the time a player has last been seen.
function PLUGIN:UpdateLastSeen(player)
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

// File refresh. Deprecated for now.
/*
function PLUGIN:AddEditing(editor, target)
    table.insert(PLUGIN.UsingDatafile, {editor, target});
end;

function PLUGIN:RemoveEditing(editor, target)
    for k, v in pairs(PLUGIN.UsingDatafile) do
        if (editor == v[1] && target == v[2]) then
            table.remove(PLUGIN.UsingDatafile, v[k]);
        end;
    end;
end;

// Basically: check if anyone is editing the datafile of a person right now, and if someone is found, refresh the panel of the person who has it opened.
function PLUGIN:RefreshEditors(target)
    for k, v in pairs(PLUGIN.UsingDatafile) do
        if (v[2] == target) then
            PLUGIN:RefreshFile(v[1], v[2]);
        end;
    end;
end;

function PLUGIN:RefreshFile(editor, target)
    Clockwork.datastream:Start(editor, "closeDatafile");
    PLUGIN:HandleDatafile(editor, target);
end;
*/

function PLUGIN:ReturnPoints(player)
    local GenericData = PLUGIN:ReturnGenericData(player);

    if (Schema:PlayerIsCombine(player)) then
        return GenericData.sc;
    else
        return GenericData.points;
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
    return #(player:GetCharacter().file.Datafile);
end;

// Return the BOL of a player.
function PLUGIN:ReturnBOL(player)
    local GenericData = PLUGIN:ReturnGenericData(player);
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
