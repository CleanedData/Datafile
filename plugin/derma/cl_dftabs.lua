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
