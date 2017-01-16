local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("createCivilDatafile", function(data)
    local target = data[1];
    local datafile = data[2];

    local datafile = vgui.Create("civilDatafile");
    datafile:Populate(target, GenericData, datafile);
end);

Clockwork.datastream:Hook("createUnionDatafile", function(data)
    local target = data[1];
    local datafile = data[2];

    local datafile = vgui.Create("unionDatafile");
    datafile:Populate(target, GenericData, datafile);
end);
