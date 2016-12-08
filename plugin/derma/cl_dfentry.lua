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
