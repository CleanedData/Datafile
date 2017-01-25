local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("createRestrictedDatafile", function(data)
	local target = data[1];
	local GenericData = data[2]
	local datafile = data[3];

	local cwDatafile = vgui.Create("cwRestrictedDatafile");
	cwDatafile:PopulateDatafile(target, datafile);
	cwDatafile:PopulateGenericData(target, datafile, GenericData);
end);

Clockwork.datastream:Hook("createFullDatafile", function(data)
	local target = data[1];
	local GenericData = data[2]
	local datafile = data[3];
	
	local cwDatafile = vgui.Create("cwFullDatafile");
	cwDatafile:PopulateDatafile(target, datafile);
	cwDatafile:PopulateGenericData(target, datafile, GenericData);
end);
