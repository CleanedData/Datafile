local PLUGIN = PLUGIN;

// FUNCTIONS

-- Called when a player spawns, sets their datafile table up (dfMain).
function PLUGIN:PostPlayerSpawn(player)
    if (player:GetCharacterData("dfMain") == nil && !table:HasValue(PLUGIN.NoDatafile, player:GetFaction())) then
        local dfPlayer = {
            bol = {false, ""},
            civilStatus = "Citizen",
            cid = math.random(0, 99999),
            lastSeen = {"", ""},
            datafile = {},
        };

        player:SetCharacterData("dfMain", dfPlayer);

        /*
            Darafile design:

            dfPlayer.datafile[k] = {
                category = "", -- note, civil, Medical
                text = "",
                date = "",
                points = "",
                originalposter = "",
            };
        */
    end;
end;

-- Adds an entry to a player their datafile.
function PLUGIN:AddEntry(target, category, text, points, author)
    local dfPlayer = target:GetCharacterData("dfMain");
    local count = table.Count(dfPlayer.datafile) + 1;

    dfPlayer.datafile[count] = {
        category = category,
        text = text,
        date = os.date("%d/%m/%Y - %H:%M:%S", os.time()),
        points = points,
        originalposter = author:Nick(),
    };

    target:SetCharacterData("dfMain", dfPlayer);
end;

-- Removes an entry from a player, check if several entries match to ensure it's the correct key.
function PLUGIN:RemoveEntry(target, key, date, text)
    local dfPlayer = target:GetCharacterData("dfMain")

    if (dfPlayer.datafile[key].date == date && dfPlayer.datafile[key].text == text) then
        table.remove(dfPlayer.datafile, key);
        target:SetCharacterData("dfMain", dfPlayer);
    end;
end;

-- Updates a player their Civil Status, also adds an entry.
function PLUGIN:UpdateCivilStatus(target, civilStatus, author)
    local dfPlayer = target:GetCharacterData("dfMain");
    dfPlayer.civilStatus = civilStatus;

    target:SetCharacterData("dfMain", dfPlayer);

    PLUGIN:AddEntry(target, "note", author:Nick() .. " has set " .. target:Nick() .. "'s Civil Status to " .. civilStatus .. ".", 0, author)
end;

-- Updates the time a player has been last seen.
function PLUGIN:UpdateLastSeen(target, player)
    local dfPlayer = target:GetCharacterData("dfMain");
    dfPlayer.lastSeen = {
        player:Nick(),
        os.date("%d/%m/%Y - %H:%M:%S", os.time()),
    };

    target:SetCharacterData("dfMain", dfPlayer);
end;

-- Add a BOL, insert a note.
function PLUGIN:AddBOL(target, text, author)
    local dfPlayer = target:GetCharacterData("dfMain");
    dfPlayer.bol = {
        true,
        text,
    };

    target:SetCharacterData("dfMain", dfPlayer);

    PLUGIN:AddEntry(target, "note", auhtor:Nick() .. " has put a BOL on " .. target:Nick() .. ".", 0, author)
end;

-- Remove a BOL, insert a note.
function PLUGIN:RemoveBOL(target, author)
    local dfPlayer = target:GetCharacterData("dfMain");
    dfPlayer.bol = {
        false,
        "",
    };

    target:SetCharacterData("dfMain", dfPlayer);

    PLUGIN:AddEntry(target, "note", author:Nick() .. " has removed a BOL from " .. target:Nick() .. ".", 0, author)
end;

-- Scrub a player their entire datafile.
function PLUGIN:ScrubDatafile(target)
    local dfPlayer = {
        bol = {false, ""},
        civilStatus = "Citizen",
        tier = "None",
        cid = math.random(0, 99999),
        lastSeen = {"", ""},
        datafile = {},
    };

    player:SetCharacterData("dfMain", dfPlayer);
end;

// DATASTREAM

Clockwork.datastream:Hook("AddEntry", function(player, data)
    local target = data[1];
    local category = data[2];
    local text = data[3];
    local points = data[4];

    PLUGIN:AddEntry(target, category, text, points, player);
end)

Clockwork.datastream:Hook("UpdateCivilStatus", function(player, data)
    local target = data[1];
    local civilStatus = data[2];

    PLUGIN:UpdateCivilStatus(target, civilStatus, player);
end);

Clockwork.datastream:Hook("AcknowledgeExistence", function(player, data)
    local target = data;

    PLUGIN:UpdateLastSeen(target, player)
end);

Clockwork.datastream:Hook("RemoveEntry", function(player, data)
    local target = data[1];
    local key = data[2];
    local date = data[3];
    local text = data[4];

    PLUGIN:RemoveEntry(target, key, date, text);
end);

Clockwork.datastream:Hook("AddBOL", function(player, data)
    local target = data[1];
    local text = data[2];

    PLUGIN:AddBOL(target, text, player);
end);

Clockwork.datastream:Hook("RemoveBOL", function(player, data)
    local target = data;

    PLUGIN:RemoveBOL(target, player);
end);
