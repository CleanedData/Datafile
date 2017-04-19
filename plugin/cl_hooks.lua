local PLUGIN = PLUGIN;

-- Open the datafile, start the population functions. Restricted: means it is limited.
Clockwork.datastream:Hook("CreateRestrictedDatafile", function(data)
	local target = data[1];
	local GenericData = data[2]
	local datafile = data[3];

	PLUGIN.cwDatafile = vgui.Create("cwRestrictedDatafile");
	PLUGIN.cwDatafile:PopulateDatafile(target, datafile);
	PLUGIN.cwDatafile:PopulateGenericData(target, datafile, GenericData);
end);

-- Create the full datafile.
Clockwork.datastream:Hook("CreateFullDatafile", function(data)
	local target = data[1];
	local GenericData = data[2]
	local datafile = data[3];
	
	PLUGIN.cwDatafile = vgui.Create("cwFullDatafile");
	PLUGIN.cwDatafile:PopulateDatafile(target, datafile);
	PLUGIN.cwDatafile:PopulateGenericData(target, datafile, GenericData);
end);

-- Management panel, for removing entries.
Clockwork.datastream:Hook("CreateFullDatafile", function(data)
	local target = data[1];
	local datafile = data[2];
	
	PLUGIN.cwManagefile = vgui.Create("cwDfManageFile");
	PLUGIN.cwManagefile:PopulateEntries(target, datafile);
end);