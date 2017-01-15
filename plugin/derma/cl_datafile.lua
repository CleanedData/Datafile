local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

// Main datafile panel.
local PANEL = {};

function PANEL:Init()
    self:SetSize(700, 530);
    self:Center();
    self:MakePopup();
end;

function PANEL:Populate()
    // Population function. Create all the components based upon the stripped datafile.
end;

vgui.Register("datafile", PANEL, "DFrame");
