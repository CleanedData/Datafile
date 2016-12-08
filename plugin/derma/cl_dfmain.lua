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
