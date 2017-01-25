// Entry panel.
local PANEL = {};

function PANEL:Init()
	self:SetTitle("Add Entry");
	self:MakePopup();
	
	self:SetSize(400, 250);
	self:Center();

	self.Restricted = false;

	self.Entry = vgui.Create("cwDfDTextEntry", self);
	self.Entry:Dock(FILL);
	self.Entry:SetMultiline(true);
	self.Entry:DockMargin(0, 0, 0, 2.5);

	self.Submit = vgui.Create("cwDfButton", self);
	self.Submit:SetText("Submit")
	self.Submit:Dock(BOTTOM);
	self.Submit:DockMargin(0, 2.5, 0, 2.5);

	self.Number = vgui.Create("DNumberWang", self);
	self.Number:Dock(BOTTOM);
	self.Number:DockMargin(0, 2.5, 0, 2.5);
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(100, 100, 100, 100));
	surface.DrawOutlinedRect(0, 0, w, h);
end;

vgui.Register("cwDfCivilEntry", PANEL, "DFrame");

// Black/grey text entry.
local PANEL = {};

function PANEL:Paint(w, h)
	surface.SetDrawColor(47, 47, 47, 255);
	surface.DrawRect(0, 0, w, h);

	self:DrawTextEntryText(Color(240, 240, 240), Color(255, 100, 100), Color(255, 255, 255));
end;

vgui.Register("cwDfDTextEntry", PANEL, "DTextEntry");

local test = vgui.Create("cwDfCivilEntry");