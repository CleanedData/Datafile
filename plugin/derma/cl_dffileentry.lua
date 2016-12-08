local PLUGIN = PLUGIN;

local PANEL = {}

function PANEL:Init()
    self:SetSize(300, 200);
    self:Center();
    self:MakePopup();

    self:SetTitle("Add Record");
end;

function PANEL:Populate(target)
    self.TextEntry = vgui.Create("DTextEntry", self);
    self.TextEntry:SetMultiline(true);
    self.TextEntry:Dock(FILL);
    self.TextEntry:DockMargin(0, 0, 0, 5);

    self.Button = vgui.Create("DButton", self);
    self.Button:Dock(BOTTOM);
    self.Button:SetText("Add Entry");
    self.Button.DoClick = function()
        PLUGIN:AddEntry(target, "civil", self.TextEntry:GetValue(), self.NumberWang:GetValue());

        self:Close();
    end;

    self.NumberWang = vgui.Create("DNumberWang", self);
    self.NumberWang:Dock(BOTTOM);
    self.NumberWang:DockMargin(0, 0, 0, 5);

end;

vgui.Register("dfCivilEntry", PANEL, "DFrame");
