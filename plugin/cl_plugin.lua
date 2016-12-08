local PLUGIN = PLUGIN;

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

function PLUGIN:RefreshDataFile(target, file)
    local datafile = vgui.Create("dfMain");
    datafile:Populate(target, file);
end;

function PLUGIN:AddEntry(target, category, text, points)
    Clockwork.datastream:Start("AddEntry", {target, category, text, points});
end;

function PLUGIN:AddBOL(target, text)
    Clockwork.datastream:Start("AddBOL", {target, text});
end;

function PLUGIN:RemoveBOL(target)
    Clockwork.datastream:Start("RemoveBOL", target);
end;


function PLUGIN:ChangeCivilStatus(target, civilStatus)
    Clockwork.datastream:Start("UpdateCivilStatus", {target, civilStatus});
end;

Clockwork.datastream:Hook("RefreshDataFile", function(data)
    local target = data[1];
    local file = data[2];

    PLUGIN:RefreshDataFile(data, file);
end);

function PLUGIN:RemoveEntry(target, key, date, text)
    Clockwork.datastream:Start("RemoveEntry", {target, key, date, text})
end;
