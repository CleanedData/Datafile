local PLUGIN = PLUGIN;

// Create the table for the datafile.
function PLUGIN:ClockworkDatabaseConnected()
	local CREATE_DATAFILE_TABLE = [[
	CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_datafile_table"):Get()..[[` (
	`_Key` smallint(11) unsigned NOT NULL AUTO_INCREMENT,
	`_CharacterID` varchar(50) NOT NULL,
	`_CharacterName` varchar(150) NOT NULL,
	`_SteamID` varchar(60) NOT NULL,
	`_Schema` text NOT NULL,
	`_GenericData` text NOT NULL,
	`_Datafile` text NOT NULL,
	PRIMARY KEY (`_Key`),
	KEY `_CharacterName` (`_CharacterName`),
	KEY `_SteamID` (`_SteamID`))
	]];

	Clockwork.database:Query(string.gsub(CREATE_DATAFILE_TABLE, "%s", " "), nil, nil, true);
end;

// Check if the player has a datafile or not. If not, create one.
function PLUGIN:PostPlayerSpawn(player)
	local bHasDatafile = PLUGIN:HasDatafile(player);

	// Nil because the bHasDatafile is not in every player their character data.
	if ((!bHasDatafile || bHasDatafile == nil) && !PLUGIN:IsRestrictedFaction(player)) then
		PLUGIN:CreateDatafile(player);
	end;

	PLUGIN:LoadDatafile(player);
end;

function PLUGIN:LoadDatafile(player)
	local schemaFolder = Clockwork.kernel:GetSchemaFolder();
	local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
	local character = player:GetCharacter();

	local queryObj = Clockwork.database:Select(datafileTable);
		queryObj:AddWhere("_CharacterID = ?", character.characterID);
		queryObj:AddWhere("_SteamID = ?", player:SteamID());
		queryObj:AddWhere("_Schema = ?", schemaFolder);
		queryObj:SetCallback(function(result)
			if (!IsValid(player)) then return; end;

			if (Clockwork.database:IsResult(result)) then
				character.file = {
					GenericData = Clockwork.json:Decode(result[1]._GenericData);
					Datafile = Clockwork.json:Decode(result[1]._Datafile);
				};

				--PLUGIN:RefreshEditors(player);
			end;
		end);

	queryObj:Pull();
end;

// Create a datafile for the player.
function PLUGIN:CreateDatafile(player)
	if (player) then
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
		local character = player:GetCharacter();
		local steamID = player:SteamID();

		// Set all the values.
		local queryObj = Clockwork.database:Insert(datafileTable);
			queryObj:SetValue("_CharacterID", character.characterID);
			queryObj:SetValue("_CharacterName", character.name);
			queryObj:SetValue("_SteamID", steamID);
			queryObj:SetValue("_Schema", schemaFolder);
			queryObj:SetValue("_GenericData", Clockwork.json:Encode(PLUGIN.Default.GenericData));
			queryObj:SetValue("_Datafile", Clockwork.json:Encode(PLUGIN.Default.civilianDatafile));
		queryObj:Push();

		// Change the hasDatafile bool to true to indicate the player has a datafile now.
		player:SetCharacterData("hasDatafile", true);
	end;
end;

// Returns true if the player has a datafile.
function PLUGIN:HasDatafile(player)
	return player:GetCharacterData("hasDatafile");
end;

// Datafile handler. Decides what to do when a player types /Datafile John Doe.
function PLUGIN:HandleDatafile(player, target)
	local playerValue = PLUGIN:ReturnPermission(player);
	local targetValue = PLUGIN:ReturnPermission(target);
	local bTargetIsRestricted, restrictedText = PLUGIN:IsRestricted(player);

	if (playerValue >= targetValue) then
		-- allow
		local GenericData = PLUGIN:ReturnGenericData(target);
		local datafile = PLUGIN:ReturnDatafile(target);

		if (playerValue == 1) then
			if (bTargetIsRestricted) then
				Clockwork.player:Notify(player, "This datafile has been restricted; access denied. REASON: " .. restrictedText);
				
				return false
			end;

			-- allow but strip Civil records, don't show BOL buttons, don't show stuff like that yes
			for k, v in pairs(datafile) do
				if (v.category == "civil") then
					table.remove(datafile, k);
				end;
			end;

			Clockwork.datastream:Start(player, "createRestrictedDatafile", {target, GenericData, datafile});

			--PLUGIN:AddEditing(player, target);
		else
			Clockwork.datastream:Start(player, "createFullDatafile", {target, GenericData, datafile});
			
			--PLUGIN:AddEditing(player, target);
		end;
	elseif (playerValue < targetValue) then
		-- don't allow
		Clockwork.player:Notify(player, "You are not authorized to access this datafile.");
	end;
end;

// Datastream
Clockwork.datastream:Hook("updateLastSeen", function(player, data)
	local target = data[1];

	PLUGIN:UpdateLastSeen(target);
end);

Clockwork.datastream:Hook("updateCivilStatus", function(player, data)
	local target = data[1];
	local civilStatus = data[2];

	PLUGIN:SetCivilStatus(target, player, civilStatus);
end);

Clockwork.datastream:Hook("addEntry", function(player, data)
	local target = data[1];
	local category = data[2];
	local text = data[3];
	local points = data[4];

	PLUGIN:AddEntry(category, text, points, target, player, false);
end);

Clockwork.datastream:Hook("setBOL", function(player, data)
	local target = data[1];
	local bHasBOL = PLUGIN:ReturnBOL(player);

	if (bHasBOL) then
		PLUGIN:SetBOL(false, "", target, player);
	else 
		PLUGIN:SetBOL(true, "", target, player);
	end;
end);

Clockwork.datastream:Hook("requestPoints", function(player, data)
	local target = data[1];

	if (PLUGIN:ReturnPermission(player) == 1 && (PLUGIN:ReturnPermission(target) == 0 || PLUGIN:ReturnPermission(target) == 1)) then
		print(PLUGIN:ReturnPoints(target));
		Clockwork.datastream:Start(player, "sendPoints", {PLUGIN:ReturnPoints(target)});
	end;
end);

Clockwork.datastream:Hook("removeLine", function(player, data)
	local target = data[1];
	local key = data[2];
	local date = data[3];
	local category = data[4];
	local text = data[5];

	PLUGIN:RemoveEntry(target, key, date, category, text);
end);

// File refresh.
/*
Clockwork.datastream:Hook("stopEditing", function(player, data)
	local target = data[1];

	PLUGIN:RemoveEditing(player, target);
end);*/