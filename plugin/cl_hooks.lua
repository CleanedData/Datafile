local PLUGIN = PLUGIN;

Clockwork.datastream:Hook("createRestrictedDatafile", function(data)
	local target = data[1];
	local GenericData = data[2]
	local datafile = data[3];

	PLUGIN.cwDatafile = vgui.Create("cwRestrictedDatafile");
	PLUGIN.cwDatafile:PopulateDatafile(target, datafile);
	PLUGIN.cwDatafile:PopulateGenericData(target, datafile, GenericData);
end);

Clockwork.datastream:Hook("createFullDatafile", function(data)
	local target = data[1];
	local GenericData = data[2]
	local datafile = data[3];
	
	PLUGIN.cwDatafile = vgui.Create("cwFullDatafile");
	PLUGIN.cwDatafile:PopulateDatafile(target, datafile);
	PLUGIN.cwDatafile:PopulateGenericData(target, datafile, GenericData);
end);

Clockwork.datastream:Hook("createManagementPanel", function(data)
	local target = data[1];
	local datafile = data[2];
	
	PLUGIN.cwManagefile = vgui.Create("cwDfManageFile");
	PLUGIN.cwManagefile:PopulateEntries(target, datafile);
end);

// File refresh.
/*
Clockwork.datastream:Hook("closeDatafile", function(data)
	PLUGIN.cwDatafile:Close();
	PLUGIN.cwDatafile = nil;
end);*/