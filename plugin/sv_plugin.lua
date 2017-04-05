local PLUGIN = PLUGIN;

Clockwork.config:Add("mysql_datafile_table", "datafile", nil, nil, true, true, true);

// Update the player their datafile.
function cwDatafile:UpdateDatafile(player, GenericData, datafile)
	/* Datafile structure:
		table to JSON encoded with CW function:
		_GenericData = {
			bol = {false, ""},
			restricted = {false, ""},
			civilStatus = "",
			lastSeen = "",
			points = 0,
			sc = 0,
		};
		_Datafile = {
			entries[k] = {
				category = "", // med, union, civil
				hidden = boolean,
				text = "",
				date = "",
				points = "",
				poster = {charName, steamID, color},
			},
		};
	*/

	if (player:IsValid()) then
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
		local character = player:GetCharacter();

		// Update all the values of a player.
		local queryObj = Clockwork.database:Update(datafileTable);
			queryObj:AddWhere("_CharacterID = ?", character.characterID);
			queryObj:AddWhere("_SteamID = ?", player:SteamID());
			queryObj:AddWhere("_Schema = ?", schemaFolder);
			queryObj:SetValue("_CharacterName", character.name);
			queryObj:SetValue("_GenericData", Clockwork.json:Encode(GenericData));
			queryObj:SetValue("_Datafile", Clockwork.json:Encode(datafile));
		queryObj:Push();

		cwDatafile:LoadDatafile(player);
	end;
end;

// Add a new entry. bCommand is used to prevent logging when /AddEntry is used.
function cwDatafile:AddEntry(category, text, points, player, poster, bCommand)
	if (!table.HasValue(PLUGIN.Categories, category)) then return false end;
	if ((cwDatafile:ReturnPermission(poster) <= 1 && category == "civil") || cwDatafile:ReturnPermission(poster) == 0) then return; end;

	Clockwork.kernel:PrintLog(LOGTYPE_MINOR, poster:Name() .. " has added an entry to " .. player:Name() .. "'s datafile with category: " .. category);

	local GenericData = cwDatafile:ReturnGenericData(player);
	local datafile = cwDatafile:ReturnDatafile(player);
	local tableSize = cwDatafile:ReturnDatafileSize(player);

	// If the player isCombine, add SC instead.
	if (Schema:PlayerIsCombine(player)) then
		GenericData.sc = GenericData.sc + points;
	else
		GenericData.points = GenericData.points + points;
	end;

	// Add a new entry with all the following values.
	datafile[tableSize + 1] = {
		category = category,
		hidden = false,
		text = text,
		date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
		points = points,
		poster = {
			poster:GetCharacter().name,
			poster:SteamID(),
			team.GetColor(poster:Team()),
		},
	};

	// Update the player their file with the new entry and possible points addition.
	cwDatafile:UpdateDatafile(player, GenericData, datafile);
end;

// Set a player their Civil Status.
function cwDatafile:SetCivilStatus(player, poster, civilStatus)
	if (!table.HasValue(PLUGIN.CivilStatus, civilStatus)) then return; end;
	if (cwDatafile:ReturnPermission(poster) < 1) then return; end;

	local GenericData = cwDatafile:ReturnGenericData(player);
	local datafile = cwDatafile:ReturnDatafile(player);
	GenericData.civilStatus = civilStatus;

	Clockwork.kernel:PrintLog(LOGTYPE_MINOR, poster:Name() .. " has changed " .. player:Name() .. "'s Civil Status to: " .. civilStatus);

	cwDatafile:AddEntry("union", poster:GetCharacter().name .. " has changed " .. player:GetCharacter().name .. "'s Civil Status to: " .. civilStatus, 0, player, poster);
	cwDatafile:UpdateDatafile(player, GenericData, datafile);
end;

// Scrub a player their datafile.
function cwDatafile:ScrubDatafile(player)
	cwDatafile:UpdateDatafile(player, PLUGIN.Default.GenericData, PLUGIN.Default.civilianDatafile);
end;

// Update the time a player has last been seen.
function cwDatafile:UpdateLastSeen(player)
	local GenericData = cwDatafile:ReturnGenericData(player);
	local datafile = cwDatafile:ReturnDatafile(player);
	GenericData.lastSeen = os.date("%H:%M:%S - %d/%m/%Y", os.time());

	cwDatafile:UpdateDatafile(player, GenericData, datafile);
end;

// Enable or disable a BOL on the player.
function cwDatafile:SetBOL(bBOL, text, player, poster)
	if (cwDatafile:ReturnPermission(poster) <= 1) then return; end;

	local GenericData = cwDatafile:ReturnGenericData(player);
	local datafile = cwDatafile:ReturnDatafile(player);

	if (bBOL) then
		-- add the BOL with the text
		GenericData.bol[1] = true;
		GenericData.bol[2] = text;

		cwDatafile:AddEntry("union", poster:GetCharacter().name .. " has put a bol on " .. player:GetCharacter().name, 0, player, poster);

	else
		-- remove the BOL, get rid of the text
		GenericData.bol[1] = false;
		GenericData.bol[2] = "";

		cwDatafile:AddEntry("union", poster:GetCharacter().name .. " has removed a bol on " .. player:GetCharacter().name, 0, player, poster);
	end;

	cwDatafile:UpdateDatafile(player, GenericData, datafile);
end;

// Make the file of a player restricted or not.
function cwDatafile:SetRestricted(bRestricted, text, player, poster)
	local GenericData = cwDatafile:ReturnGenericData(player);
	local datafile = cwDatafile:ReturnDatafile(player);

	if (bRestricted) then
		-- make the file restricted with the text
		GenericData.restricted[1] = true;
		GenericData.restricted[2] = text;

		cwDatafile:AddEntry("civil", poster:GetCharacter().name .. " has made " .. player:GetCharacter().name .. "'s file restricted.", 0, player, poster);
	else
		-- make the file unrestricted, set text to ""
		GenericData.restricted[1] = false;
		GenericData.restricted[2] = "";

		cwDatafile:AddEntry("civil", poster:GetCharacter().name .. " has removed the restriction on " .. player:GetCharacter().name .. "'s file.", 0, player, poster);
	end;

	cwDatafile:UpdateDatafile(player, GenericData, datafile);
end;

// Remove an entry by checking for the key & validating it is the entry.
function cwDatafile:RemoveEntry(player, target, key, date, category, text)
	local GenericData = cwDatafile:ReturnGenericData(target);
	local datafile = cwDatafile:ReturnDatafile(target);

	if (datafile[key].date == date && datafile[key].category == category && datafile[key].text == text) then
		table.remove(datafile, key);

		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name() .. " has removed an entry of " .. target:Name() .. "'s datafile with category: " .. category);
		cwDatafile:UpdateDatafile(target, GenericData, datafile);
	end;
end;

// Return the amount of points someone has.
function cwDatafile:ReturnPoints(player)
	local GenericData = cwDatafile:ReturnGenericData(player);

	if (Schema:PlayerIsCombine(player)) then
		return GenericData.sc;
	else
		return GenericData.points;
	end;
end;

function cwDatafile:ReturnCivilStatus(player)
	local GenericData = cwDatafile:ReturnGenericData(player);

	return GenericData.civilStatus;
end;

// Return _GenericData in normal table format.
function cwDatafile:ReturnGenericData(player)
	return player:GetCharacter().file.GenericData;
end;

// Return _Datafile in normal table format.
function cwDatafile:ReturnDatafile(player)
	return player:GetCharacter().file.Datafile;
end;

// Return the size of _Datafile. Used to calculate what key the next entry should be.
function cwDatafile:ReturnDatafileSize(player)
	return #(player:GetCharacter().file.Datafile);
end;

// Return the BOL of a player.
function cwDatafile:ReturnBOL(player)
	local GenericData = cwDatafile:ReturnGenericData(player);
	local bHasBOL = GenericData.bol[1];
	local BOLText = GenericData.bol[2];

	if (bHasBOL) then
		return true, BOLText;
	else
		return false, "";
	end;
end;

// Return the permission of a player. The higher, the more privileges.
function cwDatafile:ReturnPermission(player)
	local faction = player:GetFaction();
	local permission;

	for k, v in pairs(PLUGIN.Permissions) do
		for l, q in pairs(PLUGIN.Permissions[k]) do
			if (faction == q) then
				permission = k;

				if (permission == "elevated") then
					permission = nil;

					return 4;

				elseif (permission == "full") then
					permission = nil;

					return 3;

				elseif (permission == "medium") then
					permission = nil;

					return 2;

				elseif (permission == "minor") then
					permission = nil;

					return 1;

				elseif (permission == "none") then
					permission = nil;

					return 0;
				end;
			end;
		end;
	end;

	if (permission == nil) then
		return 0;
	end;
end;

// Returns if the player their file is restricted or not, and the text if it is.
function cwDatafile:IsRestricted(player)
	local GenericData = cwDatafile:ReturnGenericData(player);
	local bIsRestricted = GenericData.restricted[1];
	local restrictedText = GenericData.restricted[2];

	return bIsRestricted, restrictedText;
end;

// If the player is apart of any of the factions within PLUGIN.RestrictedFactions, return true.
function cwDatafile:IsRestrictedFaction(player)
	if (table:HasValue(PLUGIN.RestrictedFactions, player:GetFaction())) then
		return true;
	else
		return false;
	end;
end;
