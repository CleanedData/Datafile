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
	rightTop:SetRightText("");

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

--[[
	BOL panel. Shows the exclamation image and opens a new frame with the BOL text inside.
]]--

local PANEL = {}

function PANEL:Init()
    self:Dock(TOP);
end;

function PANEL:Populate(target, dfTarget)
    self.Button = vgui.Create("DImageButton", self);
    self.Button:SetPos(285, 5);
    self.Button:SetSize(16, 16);
    self.Button:SetImage("icon16/exclamation.png");
    self.Button.DoClick = function()
        self.BolFrame = vgui.Create("DFrame");
        self.BolFrame:SetTitle(target:Nick() .. "'s BOL'");
        self.BolFrame:SetSize(300, 150);
        self.BolFrame:Center();
        self.BolFrame:MakePopup();

        self.BolText = vgui.Create("RichText", self.BolFrame);
        self.BolText:Dock(FILL)

        self.BolText.PerformLayout = function()
    		self.BolText:SetFontInternal("DermaDefault");
    	end;

        self.BolText:InsertColorChange(50, 50, 50, 255);
        self.BolText:AppendText(dfTarget.bol[2]);
    end;
end;

function PANEL:Paint()
    return false;
end;

vgui.Register("dfBol", PANEL, "DPanel");


--[[
	Panel for the fancy top labels and its contents.
]]--

local PANEL = {};

function PANEL:Init()
	self:Dock(TOP);
	self:SetTall(100);

	self.LeftPanel = vgui.Create("DPanel", self);
	self.LeftPanel:Dock(LEFT);
	self.LeftPanel:SetTall(40);
	self.LeftPanel:SetWide(280);
	self.LeftPanel.Paint = function()
		return false;
	end;

	self.RightPanel = vgui.Create("DPanel", self);
	self.RightPanel:Dock(RIGHT);
	self.RightPanel:SetTall(40);
	self.RightPanel:SetWide(280);
	self.RightPanel.Paint = function()
		return false;
	end;
end;

function PANEL:Paint()
	return false;
end;

vgui.Register("dfGenericInfo", PANEL, "DPanel")

local PANEL = {};

function PANEL:Init()
	self:Dock(TOP);
	self:SetTall(45);

	self.GenericLabel = vgui.Create("DLabel", self);
	self.GenericLabel:Dock(TOP);
	self.GenericLabel:DockMargin(0, 5, 0, 5)
	self.GenericLabel:SetFont("SmallDermaRoboto");
	self.GenericLabel:SizeToContents();

	self.GenericPanel = vgui.Create("DPanel", self);
	self.GenericPanel:Dock(TOP);

	self.GenericLeft = vgui.Create("DLabel", self.GenericPanel);
	self.GenericLeft:Dock(FILL);
	self.GenericLeft:DockMargin(10, 0, 0, 5);
	self.GenericLeft:SizeToContents();
	self.GenericLeft:SetContentAlignment(4);

	self.GenericRight = vgui.Create("DLabel", self.GenericPanel);
	self.GenericRight:Dock(FILL);
	self.GenericRight:DockMargin(0, 0, 10, 5);
	self.GenericRight:SizeToContents();
	self.GenericRight:SetContentAlignment(6);
end;

function PANEL:SetGenericText(text)
	self.GenericLabel:SetText(text);
end;

function PANEL:SetLeftText(text)
	self.GenericLeft:SetText(text);
end;

function PANEL:SetRightText(text)
	self.GenericRight:SetText(text);
end;

function PANEL:SetLeftColor(color)
	self.GenericLeft:SetColor(color);
end;

function PANEL:SetRightColor(color)
	self.GenericRight:SetColor(color);
end;

function PANEL:Paint()
	return false;
end;

vgui.Register("dfGenericLabel", PANEL, "DPanel");

--[[
	It's like the Berlin wall, but then there would be 3. Allows for having 3 categories
	to have the dfActivityNote in. Categories are scroll panels.
]]--

-- This is for the labels on top of the new section.
local PANEL = {};

function PANEL:Init()
	self:Dock(TOP);
	self:SetTall(20);

	self.LeftLabel = vgui.Create("DLabel", self);
	self.LeftLabel:SetFont("BigDermaRoboto");
	self.LeftLabel:SetTextColor(Color(27, 72, 232));
	self.LeftLabel:SetText("Notes");
	self.LeftLabel:SizeToContents();
	self.LeftLabel:SetContentAlignment(4);
	self.LeftLabel:Dock(FILL);
	self.LeftLabel:DockMargin(0, 5, 0, 0);

	self.MiddleLabel = vgui.Create("DLabel", self);
	self.MiddleLabel:SetFont("BigDermaRoboto");
	self.MiddleLabel:SetTextColor(Color(232, 72, 27));
	self.MiddleLabel:SetText("Civil Record");
	self.MiddleLabel:SizeToContents();
	self.MiddleLabel:SetContentAlignment(5);
	self.MiddleLabel:Dock(FILL);
	self.MiddleLabel:DockMargin(0, 5, 0, 0);

	self.RightLabel = vgui.Create("DLabel", self);
	self.RightLabel:SetFont("BigDermaRoboto");
	self.RightLabel:SetTextColor(Color(27, 190, 72));
	self.RightLabel:SetText("Medical Record");
	self.RightLabel:SizeToContents();
	self.RightLabel:SetContentAlignment(6);
	self.RightLabel:Dock(FILL);
	self.RightLabel:DockMargin(0, 5, 0, 0);
end;

function PANEL:Paint(w, h)
	return false;
end;

vgui.Register("dfTopLabels", PANEL, "DPanel");

-- This is the actual separation with 3 DScrollPanels.
local PANEL = {};

function PANEL:Init()
	self:Dock(FILL);
	self:DockMargin(0, 5, 0, 0);

	self.LeftPanel = vgui.Create("DScrollPanel", self);
	self.LeftPanel:Dock(LEFT);
	self.LeftPanel:DockMargin(0, 0, 10, 0)
	self.LeftPanel:SetWide(190);

	self.MiddlePanel = vgui.Create("DScrollPanel", self);
	self.MiddlePanel:Dock(LEFT);
	self.MiddlePanel:DockMargin(5, 0, 5, 0)
	self.MiddlePanel:SetWide(190);

	self.RightPanel = vgui.Create("DScrollPanel", self);
	self.RightPanel:Dock(LEFT);
	self.RightPanel:DockMargin(10, 0, 0, 0)
	self.RightPanel:SetWide(190);
end;

function PANEL:Paint()
	return false;
end;

vgui.Register("dfCenterBars", PANEL, "DPanel");

--[[
	Handles the note of someone their datafile. RichText for the note text, DLabel for the date,
	DLabel for the author's nick, DLabel for a player their points.
]]--

local PANEL =  {};

function PANEL:Init()
	self:Dock(TOP);
	self:DockMargin(0, 0, 0, 5);
	self:SetTall(75);

	self.Date = vgui.Create("DLabel", self);
	self.Date:Dock(TOP);
	self.Date:SetContentAlignment(7);
	self.Date:SetWide(150);
	self.Date:SetTall(17);
	self.Date:DockMargin(5, 5, 0, 0);
	self.Date:SetFont("DermaDefaultBold");
	self.Date:SetTextColor(Color(48, 62, 171, 255))

	self.Note = vgui.Create("RichText", self);
	self.Note:Dock(FILL);
	self.Note:DockMargin(2, 0, 3, 0);
	self.Note:InsertColorChange(50, 50, 50, 255)
	self.Note.PerformLayout = function()
		self.Note:SetFontInternal("DermaDefault");
	end;

	self.Player = vgui.Create("DLabel", self);
	self.Player:SetFont("DermaDefaultBold");
	self.Player:SetTextColor(Color(160, 16, 17, 255));
	self.Player:SetContentAlignment(7);
	self.Player:SetWide(150);
	self.Player:Dock(BOTTOM);
	self.Player:DockMargin(5, 0, 0, 0);

	self.Points = vgui.Create("DLabel", self);
	self.Points:SetFont("DermaDefaultBold");
	self.Points:SetContentAlignment(6);
	self.Points:Dock(RIGHT);
	self.Points:SetWide(20)
	self.Points:SetWrap(true);
	self.Points:DockMargin(0, 0, 0, 0);
end;

// Bunch of functions to be able to edit the many elements of the dfActivityNote.
function PANEL:SetDateText(date)
	self.Date:SetText(date);
end;

function PANEL:SetDateColor(color)
	self.Date:SetTextColor(color);
end;

function PANEL:SetNoteText(text)
	self.Note:AppendText(text);
end;

function PANEL:SetNoteColor(...)
	self.Note:InsertColorChange(...);
end

function PANEL:SetPlayerText(text)
	self.Player:SetText(text);
end;

function PANEL:SetPlayerColor(color)
	self.Player:SetTextColor(color);
end

function PANEL:SetPointsText(int)
	self.Points:SetText(int);
end;

function PANEL:SetPointsColor(color)
	self.Points:SetTextColor(color);
end;

vgui.Register("dfActivityNote", PANEL, "DPanel");

--[[
	This is the button that appears at the bottom of one their datafile. Main functions are run from this.
]]--

local PLUGIN = PLUGIN;

local PANEL = {}

function PANEL:Init()
	self:Dock(BOTTOM);

	self.MainButton = vgui.Create("DImageButton", self);
	self.MainButton:SetImage("icon16/add.png");
	self.MainButton:SetSize(16, 16);
	self.MainButton:SetPos(284, 5);
end;


function PANEL:Populate(target)
    self.MainButton.DoClick = function()
        self.Menu = DermaMenu();

		self.Menu:AddOption("Add Note", function()
			self.AddEntry = vgui.Create("dfEntry");
			self.AddEntry:Populate(target, "note");
        end):SetImage("icon16/add.png")

		self.Menu:AddOption("Add Civil Record", function()
			self.AddEntry = vgui.Create("dfCivilEntry");
			self.AddEntry:Populate(target);
        end):SetImage("icon16/add.png");

        self.Menu:AddOption("Add Medical Record", function()
			self.AddEntry = vgui.Create("dfEntry");
			self.AddEntry:Populate(target, "medical");
        end):SetImage("icon16/add.png");

        self.Menu:AddSpacer();

        self.Menu:AddOption("Acknowledge Existence", function()
			Clockwork.datastream:Start("AcknowledgeExistence", target);
        end):SetImage("icon16/lightbulb.png");

        self.Menu:AddSpacer();

        self.BOL = self.Menu:AddSubMenu("BOL");

        self.BOL:AddOption("Add BOL", function()
			self.bolEntry = vgui.Create("dfBolEntry");
			self.bolEntry:Populate(target);
        end):SetImage("icon16/add.png");

        self.BOL:AddOption("Remove BOL", function()
			PLUGIN:RemoveBOL(target)
        end):SetImage("icon16/delete.png");

        self.Menu:AddSpacer();

        self.Tier = self.Menu:AddSubMenu("Set Status");

        self.Tier:AddOption("Anti-Citizen", function()
			PLUGIN:ChangeCivilStatus(target, "Anti-Citizen");

        end):SetImage("icon16/box.png");

        self.Tier:AddSpacer();

        self.Tier:AddOption("Citizen", function()
			PLUGIN:ChangeCivilStatus(target, "Citizen");

        end):SetImage("icon16/user.png");

        self.Tier:AddSpacer();

        self.Tier:AddOption("Black", function()
			PLUGIN:ChangeCivilStatus(target, "Black");

        end):SetImage("icon16/user_gray.png");

        self.Tier:AddOption("Brown", function()
			PLUGIN:ChangeCivilStatus(target, "Brown");

        end):SetImage("icon16/briefcase.png");

        self.Tier:AddOption("Red", function()
			PLUGIN:ChangeCivilStatus(target, "Red");

        end):SetImage("icon16/flag_red.png");

        self.Tier:AddOption("Blue", function()
			PLUGIN:ChangeCivilStatus(target, "Blue");

        end):SetImage("icon16/flag_blue.png");

        self.Tier:AddOption("Green", function()
			PLUGIN:ChangeCivilStatus(target, "Green");

        end):SetImage("icon16/flag_green.png");

        self.Tier:AddOption("White", function()
			PLUGIN:ChangeCivilStatus(target, "White");

        end):SetImage("icon16/award_star_silver_3.png");

        self.Tier:AddOption("Gold", function()
			PLUGIN:ChangeCivilStatus(target, "Gold");

        end):SetImage("icon16/award_star_gold_3.png");

        self.Tier:AddOption("Platinum", function()
			PLUGIN:ChangeCivilStatus(target, "Platinum");

        end):SetImage("icon16/shield.png");

        self.Menu:Open();
    end;
end;

function PANEL:Paint()
	return false;
end;

vgui.Register("dfButton", PANEL, "DPanel");
