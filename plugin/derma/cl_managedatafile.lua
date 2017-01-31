// Datafile management panel. Allows one to remove/edit entries.
local PANEL = {};

function PANEL:Init()	
    self:SetTitle("");
    
    self:SetSize(700, 400);
    self:Center();

    self:MakePopup();

    self.List = vgui.Create("DListView", self);
    self.List:Dock(FILL);
    self.List:AddColumn("key");
   	self.List:AddColumn("date");
	self.List:AddColumn("category");
	self.List:AddColumn("text");
	self.List:AddColumn("points");
	self.List:AddColumn("poster");
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(40, 40, 40, 150));
	surface.DrawRect(0, 0, w, h);

	surface.SetDrawColor(Color(255, 255, 255, 100));
	surface.DrawOutlinedRect(0, 0, w, h);
end;

function PANEL:PopulateEntries(target, datafile)
    self:SetTitle(target:Name() .. "'s datafile");

    for k, v in pairs(datafile) do
       	self.List:AddLine(
       		datafile[k].key,
       		datafile[k].date,
       		datafile[k].category,
       		datafile[k].text,
       		datafile[k].points,
       		datafile[k].poster[1]
       	);
    end;
end;

vgui.Register("cwDfManageFile", PANEL, "DFrame");

local target = Entity(1);
local datafile = {};

datafile[1] = {
	key = 1,
	category = "civil",
	hidden = false,
	text = "Just a test lads",
	date = "30/01/2017 - 12:34",
	points = 1,
	poster = {"James Whatever", "BOT"},
}

local test = vgui.Create("cwDfManageFile");
test:PopulateEntries(target, datafile);