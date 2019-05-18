local PLUGIN = PLUGIN;

-- Create the table for the datafile.
function cwDatafile:DatabaseConnected()
	local CREATE_DATAFILE_TABLE = [[
	CREATE TABLE IF NOT EXISTS `]]..cw.config:Get("mysql_datafile_table"):Get()..[[` (
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
		local schemaFolder = cw.core:GetSchemaFolder();
		local datafileTable = cw.config:Get("mysql_datafile_table"):Get();
		local character = player:GetCharacter();

		local queryObj = mysql:Select(datafileTable);
			queryObj:Where("_CharacterID", character.characterID);
			queryObj:Where("_SteamID", player:SteamID());
			queryObj:Where("_Schema", schemaFolder);
			queryObj:Callback(function(result, status, lastID)
				if (!IsValid(player)) then return; end;

				if (mysql:IsResult(result)) then
					player.cwDatafile = {
						GenericData = cw.json:Decode(result[1]._GenericData);
						Datafile = cw.json:Decode(result[1]._Datafile);
					};
				end;
			end);
		queryObj:ExecutePool(cw.pool);
	end;
end;

-- Create a datafile for the player.
function cwDatafile:CreateDatafile(player)
	if (IsValid(player)) then
		local schemaFolder = cw.core:GetSchemaFolder();
		local datafileTable = cw.config:Get("mysql_datafile_table"):Get();
		local character = player:GetCharacter();
		local steamID = player:SteamID();

		local defaultDatafile = self.Default.CivilianData;

		if (Schema:PlayerIsCombine(player)) then
			defaultDatafile = self.Default.CombineData;
		end;

		-- Set all the values.
		local insertObj = mysql:Insert(datafileTable);
			insertObj:Insert("_CharacterID", character.characterID);
			insertObj:Insert("_CharacterName", character.name);
			insertObj:Insert("_SteamID", steamID);
			insertObj:Insert("_Schema", schemaFolder);
			insertObj:Insert("_GenericData", cw.json:Encode(PLUGIN.Default.GenericData));
			insertObj:Insert("_Datafile", cw.json:Encode(defaultDatafile));
			insertObj:Callback(function(result)
				cwDatafile:SetHasDatafile(player, true);
			end);
		insertObj:ExecutePool(cw.pool);
	end;
end;

-- Sets whether as character has a datafile.
function cwDatafile:SetHasDatafile(player, bhasDatafile)
	player:SetCharacterData("HasDatafile", bhasDatafile);
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
			cw.player:Notify(player, L"#datafile_handledatafile_err_1");

			return false;
		end;

		local GenericData = self:ReturnGenericData(target);
		local datafile = self:ReturnDatafile(target);

		if (playerValue == DATAFILE_PERMISSION_MINOR) then
			if (bTargetIsRestricted) then
				cw.player:Notify(player, L("#datafile_handledatafile_err_2", restrictedText));

				return false;
			end;

			for k, v in pairs(datafile) do
				if (v.category == "civil") then
					table.remove(datafile, k);
				end;
			end;

			netstream.Start(player, "CreateRestrictedDatafile", {target, GenericData, datafile});
		else
			netstream.Start(player, "CreateFullDatafile", {target, GenericData, datafile});
		end;

	elseif (playerValue < targetValue) then
		cw.player:Notify(player, "#datafile_handledatafile_err_3");

		return false;
	end;
end;

-- Netstream

-- Update the last seen.
netstream.Hook("UpdateLastSeen", function(player, data)
	local target = data[1];

	cwDatafile:UpdateLastSeen(target);
end);

-- Update the civil status.
netstream.Hook("UpdateCivilStatus", function(player, data)
	local target = data[1];
	local civilStatus = data[2];

	cwDatafile:SetCivilStatus(target, player, civilStatus);
end);

-- Add a new entry.
netstream.Hook("AddDatafileEntry", function(player, data)
	local target = data[1];
	local category = data[2];
	local text = data[3];
	local points = data[4];

	cwDatafile:AddEntry(category, text, points, target, player, false);
end);

-- Add/remove a BOL.
netstream.Hook("SetBOL", function(player, data)
	local target = data[1];
	local bHasBOL = cwDatafile:ReturnBOL(player);

	if (bHasBOL) then
		cwDatafile:SetBOL(false, "", target, player);
	else
		cwDatafile:SetBOL(true, "", target, player);
	end;
end);

-- Send the points of the player back to the user.
netstream.Hook("RequestPoints", function(player, data)
	local target = data[1];

	if (cwDatafile:ReturnPermission(player) == DATAFILE_PERMISSION_MINOR and (cwDatafile:ReturnPermission(target) == DATAFILE_PERMISSION_NONE or cwDatafile:ReturnPermission(target) == DATAFILE_PERMISSION_MINOR)) then
		netstream.Start(player, "SendPoints", {cwDatafile:ReturnPoints(target)});
	end;
end);

-- Remove a line from someone their datafile.
netstream.Hook("RemoveDatafileLine", function(player, data)
	local target = data[1];
	local key = data[2];
	local date = data[3];
	local category = data[4];
	local text = data[5];

	cwDatafile:RemoveEntry(player, target, key, date, category, text);
end);

-- Refresh the active datafile panel of a player.
netstream.Hook("RefreshDatafile", function(player, data)
	local target = data[1];

	cwDatafile:HandleDatafile(player, target);
end);
