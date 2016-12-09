--[[
    Initialize a global variable Datafile and put some functions in it.
]]--

Datafile = {};

local PLUGIN = PLUGIN;

PLUGIN.Factions = {
    "Civil Worker's Union",
    "Willard Industries",
    "Unity Party",
    "Citizen"
};

PLUGIN.NoDatafile = {
    "Vortigaunt",
    "Refugee",
    "Zombie"
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

-- Returns a boolean if the player can use the datafile.
function Datafile:CanUseDatafile(target)
    if (table.HasValue(PLUGIN.Factions, target:GetFaction() || Schema:PlayerIsCombine(target))) then
        return true;
    end;
end;

-- Returns a boolean if the player can use the datafile. (difference: this one is to check non combine)
function Datafile:CanUseDatafileRestricted(target)
    if (table.HasValue(PLUGIN.Factions, target:GetFaction())) then
        return true;
    end;
end;
