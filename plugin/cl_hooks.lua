local PLUGIN = PLUGIN;

-- Open the minor datafile panel and populate it.
Clockwork.datastream:Hook("minorDatafile", function(data)
    local target = data[1];
    local file = data[2];

    local datafile = vgui.Create("dfMinorMain");
    datafile:Populate(target, file);
end);

-- Open the medium datafile panel and populate it.
Clockwork.datastream:Hook("mediumDatafile", function(data)
    local target = data[1];
    local file = data[2];

    local datafile = vgui.Create("dfMediumMain");
    datafile:Populate(target, file);
end);

-- Open the full datafile panel and populate it.
Clockwork.datastream:Hook("fullDatafile", function(data)
    local target = data[1];
    local file = data[2];

    local datafile = vgui.Create("dfFullMain");
    datafile:Populate(target, file);
end);

-- Open the Data Management panel and populate it.
Clockwork.datastream:Hook("managedatafile", function(data)
    local target = data[1];
    local file = data[2];

    local dataManagement = vgui.Create("dfDataManagement");
    dataManagement:Populate(target, file);
end);
