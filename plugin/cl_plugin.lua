local PLUGIN = PLUGIN;

-- Create the 2 necessary fonts for the main datafile panel.
surface.CreateFont("BigDermaRoboto", {
    font = "Roboto",
    size = 17,
    weight = 500,
    antialias = true,
})

surface.CreateFont("SmallDermaRoboto", {
    font = "Roboto",
    size = 15,
    weight = 450,
    antialias = true,
})

-- Refresh the datafile. Doesn't work right now.
function PLUGIN:RefreshDataFile(target, file)
    local datafile = vgui.Create("dfMain");
    datafile:Populate(target, file);
end;

-- Start a datastream to add a new entry.
function PLUGIN:AddEntry(target, category, text, points)
    Clockwork.datastream:Start("AddEntry", {target, category, text, points});
end;

-- Start a datastream to remove an entry.
function PLUGIN:RemoveEntry(target, key, date, text)
    Clockwork.datastream:Start("RemoveEntry", {target, key, date, text})
end;

-- Start a datastream to add a BOL.
function PLUGIN:AddBOL(target, text)
    Clockwork.datastream:Start("AddBOL", {target, text});
end;

-- Start a datastream to remove a BOL.
function PLUGIN:RemoveBOL(target)
    Clockwork.datastream:Start("RemoveBOL", target);
end;

-- Start a datastream to change the Civil Status of a player.
function PLUGIN:ChangeCivilStatus(target, civilStatus)
    Clockwork.datastream:Start("UpdateCivilStatus", {target, civilStatus});
end;

Clockwork.datastream:Hook("RefreshDataFile", function(data)
    local target = data[1];
    local file = data[2];

    PLUGIN:RefreshDataFile(data, file);
end);
