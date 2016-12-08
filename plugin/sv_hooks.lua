local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("AddEntry", function(player, data)
    local target = data[1];
    local category = data[2];
    local text = data[3];
    local points = data[4];

    local dfPlayer = target:GetCharacterData("dfMain");
    local count = table.Count(dfPlayer.datafile) + 1;

    dfPlayer.datafile[count] = {
        category = category,
        text = text,
        date = os.date("%d/%m/%Y - %H:%M:%S", os.time()),
        points = points,
        originalposter = player:Nick(),
    };

    target:SetCharacterData("dfMain", dfPlayer);

    Clockwork.datastream:Start("RefreshDataFile", {target, dfPlayer});
end)

Clockwork.datastream:Hook("UpdateCivilStatus", function(player, data)
    local target = data[1];
    local civilStatus = data[2];

    local dfPlayer = target:GetCharacterData("dfMain");
    local count = table.Count(dfPlayer.datafile) + 1;

    dfPlayer.civilStatus = civilStatus;

    dfPlayer.datafile[count] = {
        category = "note",
        text = player:Nick() .. " has set " .. target:Nick() .. "'s Civil Status to " .. civilStatus .. ".",
        date = os.date("%d/%m/%Y - %H:%M:%S", os.time()),
        points = "0",
        originalposter = player:Nick(),
    };

    target:SetCharacterData("dfMain", dfPlayer);
end);


Clockwork.datastream:Hook("AcknowledgeExistence", function(player, data)
    local target = data;
    local dfPlayer = target:GetCharacterData("dfMain");
    dfPlayer.lastSeen = {
        player:Nick(),
        os.date("%d/%m/%Y - %H:%M:%S", os.time()),
    };

    target:SetCharacterData("dfMain", dfPlayer);
end);

Clockwork.datastream:Hook("RemoveEntry", function(player, data)
    local target = data[1];
    local key = data[2];
    local date = data[3];
    local text = data[4];

    local dfPlayer = target:GetCharacterData("dfMain")

    if (dfPlayer.datafile[key].date == date && dfPlayer.datafile[key].text == text) then
        table.remove(dfPlayer.datafile, key);
        target:SetCharacterData("dfMain", dfPlayer);
    end;
end);

Clockwork.datastream:Hook("AddBOL", function(player, data)
    local target = data[1];
    local text = data[2];

    local dfPlayer = target:GetCharacterData("dfMain");
    local count = table.Count(dfPlayer.datafile) + 1;

    dfPlayer.bol = {
        true,
        text,
    };

    dfPlayer.datafile[count] = {
        category = "note",
        text = player:Nick() .. " has put a BOL on " .. target:Nick() .. ".",
        date = os.date("%d/%m/%Y - %H:%M:%S", os.time()),
        points = "0",
        originalposter = player:Nick(),
    };

    target:SetCharacterData("dfMain", dfPlayer);
end);

Clockwork.datastream:Hook("RemoveBOL", function(player, data)
    local target = data;

    local dfPlayer = target:GetCharacterData("dfMain");
    local count = table.Count(dfPlayer.datafile) + 1;

    dfPlayer.bol = {
        false,
        "",
    };

    dfPlayer.datafile[count] = {
        category = "note",
        text = player:Nick() .. " has removed a BOL from " .. target:Nick() .. ".",
        date = os.date("%d/%m/%Y - %H:%M:%S", os.time()),
        points = "0",
        originalposter = player:Nick(),
    };

    target:SetCharacterData("dfMain", dfPlayer);
end);

function PLUGIN:PostPlayerSpawn(player)
    if (player:GetCharacterData("dfMain") == nil) then
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
