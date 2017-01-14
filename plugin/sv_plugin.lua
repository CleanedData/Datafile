local PLUGIN = PLUGIN;

Clockwork.config:Add("mysql_datafile_table", "datafile", nil, nil, true, true, true);

// Update the player their datafile.
function PLUGIN:UpdateDatafile(player, GenericData, Datafile)
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
        queryObj:SetValue("_Datafile", Clockwork.json:Encode(Datafile));
    queryObj:Push();
end;

function PLUGIN:ReturnGenericData(player)
    -- return _GenericData in table format, no JSON


end;

function PLUGIN:ReturnDatafile(player)
    -- return _Datafile in table format, no JSON
end;

function PLUGIN:AddEntry(category, text, date, points, player, poster)
    -- add a new entry to the _Datafile
    --Clockwork.kernel:PrintLog(LOGTYPE_MINOR, poster:Name() .. " has added an entry to " .. player:Name() .. "'s datafile with category: " .. category);

end;

function PLUGIN:SetCivilStatus(player, poster, civilStatus)
    -- set the player their civil status
    --Clockwork.kernel:PrintLog(LOGTYPE_MINOR, poster:Name() .. " has changed " .. player:Name() .. "'s Civil Status to: " .. civilStatus);

end;

function PLUGIN:ScrubDatafile(player)
    -- scrub datafile
end;

function PLUGIN:EditEntry(player, entry)
    -- edit an entry
end;

function PLUGIN:UpdateLastSeen(player, seeer)
    -- update the last seen (seeer = see-er);
end;

function PLUGIN:SetBOL(bBOL, text)
    if (bBOL) then
        -- add the BOL with the text
    else
        -- remove the BOL, set text to ""
    end;
end;

function PLUGIN:SetRestricted(bRestricted, text)
    if (bRestricted) then
        -- make the file restricted with the text
    else
        -- make the file unrestricted, set text to ""
    end;
end;

function PLUGIN:ReturnBOL(player)
    if (bHasBOL) then
        return true, BOLText;
    else
        return false
    end;
end;

function PLUGIN:IsRestricted(player)
    return bIsRestricted;
end;

// If the player is apart of any of the factions within PLUGIN.RestrictedFactions, return true.
function PLUGIN:IsRestrictedFaction(player)
    if (table:HasValue(PLUGIN.RestrictedFactions, player:GetFaction())) then
        return true;
    else
        return false;
    end;
end;
