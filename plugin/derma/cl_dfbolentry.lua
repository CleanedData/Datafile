--[[
	BOL entry frame.
]]--

local PLUGIN = PLUGIN;

local PANEL = {}

function PANEL:Init()
    self:SetSize(300, 200);
    self:Center();
    self:MakePopup();

    self:SetTitle("Add BOL");
end;

function PANEL:Populate(target)
    self.TextEntry = vgui.Create("DTextEntry", self);
    self.TextEntry:SetMultiline(true);
    self.TextEntry:Dock(FILL);
    self.TextEntry:DockMargin(0, 0, 0, 5);

    self.Button = vgui.Create("DButton", self);
    self.Button:Dock(BOTTOM);
    self.Button:SetText("Add BOL");
    self.Button.DoClick = function()
        PLUGIN:AddBOL(target, self.TextEntry:GetValue());

        self:Close();
    end;
end;

vgui.Register("dfBolEntry", PANEL, "DFrame");
