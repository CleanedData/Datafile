local PLUGIN = PLUGIN;

-- Open the datafile panel and populate it.
Clockwork.datastream:Hook("datafile", function(data)
    local target = data[1];
    local file = data[2];

    local datafile = vgui.Create("dfMain");
    datafile:Populate(target, file);
end);

-- Open the Data Management panel and populate it.
Clockwork.datastream:Hook("managedatafile", function(data)
    local target = data[1];
    local file = data[2];

    local dataManagement = vgui.Create("dfDataManagement");
    dataManagement:Populate(target, file);
end);
