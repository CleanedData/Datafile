--[[
    Initialize a global variable Datafile and put some functions in it.
    And create some generic PLUGIN functions.
]]--

Datafile = {};

local PLUGIN = PLUGIN;

PLUGIN.Permissions = {
    full = {
        "Combine Transhuman Arm",
        "Civil Administration Board",
        "Overwatch",
    },
    medium = {
        "Civil Protection",
        "Server Administration"
    },
    minor = {
        "Civil Worker's Union",
        "Willard Industries",
        "Unity Party",
    }
}

PLUGIN.NoDatafile = {
    "Alien Grunt",
    "Bird",
    "Houndeye",
    "Vortigaunt",
    "Zombie",
    "Houndeye"
};

-- Returns an int, the total points of a player.
function Datafile:ReturnPoints(target)
    local dfPlayer = target:GetCharacterData("dfMain");
    local totalPoints = 0;

    for k, v in pairs(dfPlayer.datafile) do
        totalPoints = totalPoints + tonumber(v.points);
    end;

    return totalPoints;
end;

--[[ Returns a string, the Civil Status of a player. These can be:
    Anti-Citizen, Citizen, Black, Brown, Red, Blue, Green, White,
    Gold, and Platinum.
]]--
function Datafile:ReturnCivilStatus(target)
    local dfPlayer = target:GetCharacterData("dfMain");

    return dfPlayer.civilStatus;
end;

-- Returns a boolean, whether the player has a BOL or not.
function Datafile:IsBOL(target)
    local dfPlayer = target:GetCharacterData("dfMain");

    return dfPlayer.bol[1];
end;

-- Returns a boolean, whether the player is an Anti-Citizen or not.
function Datafile:IsAntiCitizen(target)
    local dfPlayer = target:GetCharacterData("dfMain");

    return (dfPlayer.civilStatus == "Anti-Citizen");
end;

function PLUGIN:DecideDatafile(player, target)
    local playerValue, playerVersion = PLUGIN:ReturnPlayerValue(player);
    local targetValue, targetVersion = PLUGIN:ReturnPlayerValue(target);

    if (playerValue < targetValue) then
        Clockwork.player:Notify(player, "You are not allowed to access this datafile.");

    elseif (playerValue > targetValue) then
        Clockwork.datastream:Start(player, playerVersion + "Datafile", {target, target:GetCharacterData("dfMain")});

    elseif (playerValue == targetValue) then
        Clockwork.datastream:Start(player, playerVersion + "Datafile", {target, target:GetCharacterData("dfMain")});
    end;
end;

function PLUGIN:ReturnPlayerValue(player)
    local playerFaction = player:GetFaction()

    if (table.HasValue(PLUGIN.Permissions.minor, playerFaction)) then
        return 1, "minor";

    elseif (table.HasValue(PLUGIN.Permissions.medium, playerFaction)) then
        return 2, "medium";

    elseif (table.HasValue(PLUGIN.Permissions.full, playerFaction))
        return 3, "full";
    end;
end;

-- Send the minor datafile to the target.
function PLUGIN:SendMinorDatafile(target)

end;

-- Send the medium datafile to the target.
function PLUGIN:SendMediumDatafile(target)

end;

-- Send the full datafile to the target.
function PLUGIN:SendFullDatafile(target)

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
