local PLUGIN = PLUGIN;

-- Create the table for the datafile.
function cwDatafile:ClockworkDatabaseConnected()
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

	mysql:RawQuery(string.gsub(CREATE_DATAFILE_TABLE, "%s", " "));
end;

-- Check if the player has a datafile or not. If not, create one.
function cwDatafile:PostPlayerSpawn(player)
	local bHasDatafile = self:HasDatafile(player);

	-- Nil because the bHasDatafile is not in every player their character data.
	if ((!bHasDatafile or bHasDatafile == nil) and self:IsRestrictedFaction(player)) then
		self:CreateDatafile(player);
	end;

	-- load the datafile again with the new changes.
	self:LoadDatafile(player);
end;

-- Function to load the datafile on the player's character. Used after updating something in the MySQL.
function cwDatafile:LoadDatafile(player)
	if (IsValid(player)) then
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
		local character = player:GetCharacter();

		local queryObj = mysql:Select(datafileTable);
			queryObj:Where("_CharacterID", character.characterID);
			queryObj:Where("_SteamID", player:SteamID());
			queryObj:Where("_Schema", schemaFolder);
			queryObj:Callback(function(result, status, lastID)
				if (!IsValid(player)) then return; end;

				if (mysql:IsResult(result)) then
					player.cwDatafile = {
						GenericData = Clockwork.json:Decode(result[1]._GenericData);
						Datafile = Clockwork.json:Decode(result[1]._Datafile);
					};
				end;
			end);
		queryObj:ExecutePool(Clockwork.pool);
	end;
end;

-- Create a datafile for the player.
function cwDatafile:CreateDatafile(player)
	if (IsValid(player)) then
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
		local character = player:GetCharacter();
		local steamID = player:SteamID();

		-- Set all the values.
		local insertObj = mysql:Insert(datafileTable);
			insertObj:Insert("_CharacterID", character.characterID);
			insertObj:Insert("_CharacterName", character.name);
			insertObj:Insert("_SteamID", steamID);
			insertObj:Insert("_Schema", schemaFolder);
			insertObj:Insert("_GenericData", Clockwork.json:Encode(PLUGIN.Default.GenericData));
			insertObj:Insert("_Datafile", Clockwork.json:Encode(PLUGIN.Default.civilianDatafile));
		insertObj:ExecutePool(Clockwork.pool);

		-- Change the hasDatafile bool to true to indicate the player has a datafile now.
		player:SetCharacterData("HasDatafile", true);
	end;
end;

-- Returns true if the player has a datafile.
function cwDatafile:HasDatafile(player)
	return player:GetCharacterData("HasDatafile");
end;

-- Datafile handler. Decides what to do when a player types /Datafile John Doe.
function cwDatafile:HandleDatafile(player, target)
	local playerValue = self:ReturnPermission(player);
	local targetValue = self:ReturnPermission(target);
	local bTargetIsRestricted, restrictedText = self:IsRestricted(player);

	if (playerValue >= targetValue) then
		if (playerValue == DATAFILE_PERMISSION_NONE) then
			Clockwork.player:Notify(player, "You are not authorized to access this datafile.");

			return false;
		end;

		local GenericData = self:ReturnGenericData(target);
		local datafile = self:ReturnDatafile(target);

		if (playerValue == DATAFILE_PERMISSION_MINOR) then
			if (bTargetIsRestricted) then
				Clockwork.player:Notify(player, "This datafile has been restricted; access denied. REASON: " .. restrictedText);

				return false;
			end;

			for k, v in pairs(datafile) do
				if (v.category == "civil") then
					table.remove(datafile, k);
				end;
			end;

			Clockwork.datastream:Start(player, "CreateRestrictedDatafile", {target, GenericData, datafile});
		else
			Clockwork.datastream:Start(player, "CreateFullDatafile", {target, GenericData, datafile});
		end;

	elseif (playerValue < targetValue) then
		Clockwork.player:Notify(player, "You are not authorized to access this datafile.");

		return false;
	end;
end;

-- Datastream

-- Update the last seen.
Clockwork.datastream:Hook("UpdateLastSeen", function(player, data)
	local target = data[1];

	cwDatafile:UpdateLastSeen(target);
end);

-- Update the civil status.
Clockwork.datastream:Hook("UpdateCivilStatus", function(player, data)
	local target = data[1];
	local civilStatus = data[2];

	cwDatafile:SetCivilStatus(target, player, civilStatus);
end);

-- Add a new entry.
Clockwork.datastream:Hook("AddDatafileEntry", function(player, data)
	local target = data[1];
	local category = data[2];
	local text = data[3];
	local points = data[4];

	cwDatafile:AddEntry(category, text, points, target, player, false);
end);

-- Add/remove a BOL.
Clockwork.datastream:Hook("SetBOL", function(player, data)
	local target = data[1];
	local bHasBOL = cwDatafile:ReturnBOL(player);

	if (bHasBOL) then
		cwDatafile:SetBOL(false, "", target, player);
	else
		cwDatafile:SetBOL(true, "", target, player);
	end;
end);

-- Send the points of the player back to the user.
Clockwork.datastream:Hook("RequestPoints", function(player, data)
	local target = data[1];

	if (cwDatafile:ReturnPermission(player) == DATAFILE_PERMISSION_MINOR and (cwDatafile:ReturnPermission(target) == DATAFILE_PERMISSION_NONE or cwDatafile:ReturnPermission(target) == DATAFILE_PERMISSION_MINOR)) then
		Clockwork.datastream:Start(player, "SendPoints", {cwDatafile:ReturnPoints(target)});
	end;
end);

-- Remove a line from someone their datafile.
Clockwork.datastream:Hook("RemoveDatafileLine", function(player, data)
	local target = data[1];
	local key = data[2];
	local date = data[3];
	local category = data[4];
	local text = data[5];

	cwDatafile:RemoveEntry(player, target, key, date, category, text);
end);

-- Refresh the active datafile panel of a player.
Clockwork.datastream:Hook("RefreshDatafile", function(player, data)
	local target = data[1];

	cwDatafile:HandleDatafile(player, target);
end);
