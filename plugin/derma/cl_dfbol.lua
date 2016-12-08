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
