local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("datafile", function(data)
    local target = data[1];
    local file = data[2];

    local datafile = vgui.Create("dfMain");
    datafile:Populate(target, file);
end);

Clockwork.datastream:Hook("managedatafile", function(data)
    local target = data[1];
    local file = data[2];

    local dataManagement = vgui.Create("dfDataManagement");
    dataManagement:Populate(target, file);
end);
