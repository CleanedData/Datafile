local PLUGIN = PLUGIN;

function PLUGIN:RemoveEntry(target, key, date, category, text)
	Clockwork.datastream:Start("removeLine", {target, key, date, category, text});
end;

function PLUGIN:UpdateCivilStatus(target, tier)
	Clockwork.datastream:Start("updateCivilStatus", {target, tier});
end;