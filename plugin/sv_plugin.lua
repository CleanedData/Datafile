Datafile = {};

local PLUGIN = PLUGIN;

function Datafile:ReturnPoints(target)
    local dfPlayer = target:GetCharacterData("dfMain");
    local totalPoints = 0;

    for k, v in pairs(dfPlayer.datafile) do
        totalPoints = totalPoints + tonumber(v.points);
    end;

    return totalPoints;
end;

function Datafile:ReturnCivilStatus(target)
    local dfPlayer = target:GetCharacterData("dfMain");

    return dfPlayer.civilStatus;
end;

function Datafile:IsBOL(target)
    --return BOL;
end;
