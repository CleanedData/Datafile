--[[
    Same as dfCivilEntry, except that it's just for the notes and medical categories.
]]--

local PLUGIN = PLUGIN;

local PANEL = {}

function PANEL:Init()
    self:SetSize(300, 200);
    self:Center();
    self:MakePopup();

    self:SetTitle("Add Entry");
end;

function PANEL:Populate(target, category)
    self.TextEntry = vgui.Create("DTextEntry", self);
    self.TextEntry:SetMultiline(true);
    self.TextEntry:Dock(FILL);
    self.TextEntry:DockMargin(0, 0, 0, 5);

    self.Button = vgui.Create("DButton", self);
    self.Button:Dock(BOTTOM);
    self.Button:SetText("Add Entry");
    self.Button.DoClick = function()
        PLUGIN:AddEntry(target, category, self.TextEntry:GetValue(), 0);

        self:Close();
    end;
end;

vgui.Register("dfEntry", PANEL, "DFrame");
