--[[
	Main Datafile frame. Everything is then parented onto this.
]]--

local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local PANEL = {};

function PANEL:Init()
	self:SetSize(600, 450);
	self:Center();
	self:MakePopup();
end;

-- Main population function. Gets the datafile and target, populates its children with all the data.
function PANEL:Populate(target, dfTarget)
	self:SetTitle(target:Nick() .. "'s Datafile");

	// Show the BOL button if the player has a BOL.
	if (dfTarget.bol[1] == true) then
		local BolButton = vgui.Create("dfBol", self);
		BolButton:Populate(target, dfTarget);
	end;

	local totalPoints = 0;

	// Count the total points a player has.
	for k, v in pairs(dfTarget.datafile) do
		totalPoints = totalPoints + tonumber(v.points);
	end;

	self.Generic = vgui.Create("dfGenericInfo", self);
    self.topLabels = vgui.Create("dfTopLabels", self);

	local leftTop = vgui.Create("dfGenericLabel", self.Generic.LeftPanel);
	leftTop:SetGenericText("NAME AND C.I.D");
	leftTop:SetLeftText(target:Nick());
	leftTop:SetRightText(dfTarget.cid);

	local leftBottom = vgui.Create("dfGenericLabel", self.Generic.LeftPanel);
	leftBottom:SetGenericText("FACTION AND STANDING");
    --leftBottom:SetLeftColor(team.GetColor(target:GetFaction()));
	leftBottom:SetLeftText(target:GetFaction());
	leftBottom:SetRightText(dfTarget.civilStatus);

	local rightTop = vgui.Create("dfGenericLabel", self.Generic.RightPanel);
	rightTop:SetGenericText("CIVIL RECORD");
	if (totalPoints > 0) then
		rightTop:SetLeftColor(Color(27, 190, 72))
	else
		rightTop:SetLeftColor(Color(190, 27, 72))
	end;
	rightTop:SetLeftText(totalPoints);

	local rightBottom = vgui.Create("dfGenericLabel", self.Generic.RightPanel);
	rightBottom:SetGenericText("LAST SEEN");
	rightBottom:SetLeftText(dfTarget.lastSeen[1]);
	rightBottom:SetRightText(dfTarget.lastSeen[2]);

    self.centerBars = vgui.Create("dfCenterBars", self);
    local mainbutton = vgui.Create("dfButton", self);
    mainbutton:Populate(target);

	// Loop through all the notes in someone their datafile, add a dfActivityNote for every note.
	for k, v in pairs(dfTarget.datafile) do
		if (dfTarget.datafile[k].category == "note") then
			local note = vgui.Create("dfActivityNote", self.centerBars.LeftPanel);
			note:SetDateText(dfTarget.datafile[k].date);
			note:SetNoteText(dfTarget.datafile[k].text);
			note:SetPlayerText(dfTarget.datafile[k].originalposter);
			note.Points:Remove();

		elseif (dfTarget.datafile[k].category == "civil") then
			local note = vgui.Create("dfActivityNote", self.centerBars.MiddlePanel);
			note:SetDateText(dfTarget.datafile[k].date);
			note:SetNoteText(dfTarget.datafile[k].text);
			note:SetPlayerText(dfTarget.datafile[k].originalposter);
            note:SetPointsText(dfTarget.datafile[k].points);
            if (tonumber(dfTarget.datafile[k].points) > 0) then
                note:SetPointsColor(Color(27, 190, 72));
            else
                note:SetPointsColor(Color(232, 72, 27));
            end;

		elseif (dfTarget.datafile[k].category == "medical") then
			local note = vgui.Create("dfActivityNote", self.centerBars.RightPanel);
			note:SetDateText(dfTarget.datafile[k].date);
			note:SetNoteText(dfTarget.datafile[k].text);
			note:SetPlayerText(dfTarget.datafile[k].originalposter);
			note.Points:Remove();
		end;
	end;
end;

vgui.Register("dfMain", PANEL, "DFrame");
