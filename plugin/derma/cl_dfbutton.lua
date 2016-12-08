local PLUGIN = PLUGIN;

local PANEL = {}

function PANEL:Init()
	self:Dock(BOTTOM);

	self.MainButton = vgui.Create("DImageButton", self);
	self.MainButton:SetImage("icon16/add.png");
	self.MainButton:SetSize(16, 16);
	self.MainButton:SetPos(300-16, 5);
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
			local bolEntry = vgui.Create("dfBolEntry");
			bolEntry:Populate(target);
        end):SetImage("icon16/add.png");

        self.BOL:AddOption("Remove BOL", function()
			PLUGIN:RemoveBOL(target)
        end):SetImage("icon16/delete.png");

        self.Menu:AddSpacer();

        self.Tier = self.Menu:AddSubMenu("Set Status");

        self.Tier:AddOption("Anti-Citizen", function()
			PLUGIN:UpdateCivilStatus(target, "Anti-Citizen");
        end):SetImage("icon16/box.png");

        self.Tier:AddSpacer();

        self.Tier:AddOption("Citizen", function()
			PLUGIN:UpdateCivilStatus(target, "Citizen");

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
