local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

surface.CreateFont("MiddleLabels", {
    font = "DermaLarge",
    size = 20,
    weight = 0,
})

// Main datafile panel.
local PANEL = {};

function PANEL:Init()
    self:SetSize(700, 570);
    self:Center();
    self:MakePopup();
    self:SetTitle("");

    // Foundation type components.
    self.TopPanel = vgui.Create("DPanel", self);
    self.TopPanel:Dock(TOP);
    self.TopPanel:SetTall(125)

    self.LabelPanel = vgui.Create("DPanel", self);
    self.LabelPanel:Dock(TOP);
    self.LabelPanel:SetTall(35);
    self.LabelPanel:DockMargin(0, 3, 0, 3);

    self.LeftLabel = vgui.Create("DLabel", self.LabelPanel);
    self.LeftLabel:SetText("NOTES")
    self.LeftLabel:SetTextColor(Color(41, 128, 185));
    self.LeftLabel:SetFont("MiddleLabels")
    self.LeftLabel:Dock(FILL)
    self.LeftLabel:DockMargin(7, 0, 0, 0);
    self.LeftLabel:SetContentAlignment(4)

    self.MiddleLabel = vgui.Create("DLabel", self.LabelPanel);
    self.MiddleLabel:SetText("CIVIL RECORD")
    self.MiddleLabel:SetTextColor(Color(231, 76, 60));
    self.MiddleLabel:SetFont("MiddleLabels")
    self.MiddleLabel:Dock(FILL)
    self.MiddleLabel:SetContentAlignment(5)

    self.RightLabel = vgui.Create("DLabel", self.LabelPanel);
    self.RightLabel:SetText("MEDICAL NOTES")
    self.RightLabel:SetTextColor(Color(39, 174, 96));
    self.RightLabel:SetFont("MiddleLabels")
    self.RightLabel:Dock(FILL)
    self.RightLabel:SetContentAlignment(6)
    self.RightLabel:DockMargin(0, 0, 7, 0);

    self.FillPanel = vgui.Create("DPanel", self);
    self.FillPanel:Dock(FILL);

    self.NameLabel = vgui.Create("DLabel", self.TopPanel);
    self.NameLabel:SetTextColor(Color(0, 0, 0, 255));
    self.NameLabel:SetText("");
    self.NameLabel:SetFont("DermaLarge")
    self.NameLabel:Dock(TOP);
    self.NameLabel:DockMargin(5, 5, 0, 0);
    self.NameLabel:SizeToContents();

    self.LeftScrollPanel = vgui.Create("DScrollPanel", self.FillPanel);
    self.LeftScrollPanel:Dock(LEFT)
    self.LeftScrollPanel:SetWide(225);
    self.LeftScrollPanel:DockMargin(5, 0, 5, 0)

    self.MiddleScrollPanel = vgui.Create("DScrollPanel", self.FillPanel);
    self.MiddleScrollPanel:Dock(FILL)
    self.MiddleScrollPanel:SetWide(225);
    self.MiddleScrollPanel:DockMargin(5, 0, 5, 0)

    self.RightScrollPanel = vgui.Create("DScrollPanel", self.FillPanel);
    self.RightScrollPanel:Dock(RIGHT)
    self.RightScrollPanel:SetWide(225);
    self.RightScrollPanel:DockMargin(5, 0, 5, 0)

    for i=1, 20 do
        local test = vgui.Create("DPanel", self.LeftScrollPanel);
        test:SetTall(90)
        test:Dock(TOP);
        test:DockMargin(0, 5, 5, 0)
        function test:Paint(w, h)
            surface.SetDrawColor(Color(47, 47, 47, 255));
            surface.DrawRect(0, 0, w, h)
        end;

        local label = vgui.Create("DLabel", test);
        label:SetTextColor(Color(220, 220, 220, 255))
        label:SetFont("DermaDefault")
        label:SetText("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        label:Dock(FILL)
        label:SetContentAlignment(5);
        label:SetWrap(true)
        label:DockMargin(5, 0, 30, 5)

        local label = vgui.Create("DLabel", test);
        label:SetTextColor(Color(150, 150, 150, 255))
        label:SetFont("DermaDefault")
        label:SetText("~ James Whatever")
        label:Dock(FILL)
        label:SetContentAlignment(1);
        label:SetWrap(true)
        label:DockMargin(5, 0, 0, 5)

        local label = vgui.Create("DLabel", test);
        label:SetTextColor(Color(150, 150, 150, 255))
        label:SetFont("DermaDefault")
        label:SetText("16/01/2017 - 7:55:59")
        label:Dock(FILL)
        label:SetContentAlignment(7);
        label:SetWrap(true)
        label:DockMargin(5, 2.5, 0, 5)

        local test = vgui.Create("DPanel", self.MiddleScrollPanel);
        test:SetTall(60)
        test:Dock(TOP);

        local test = vgui.Create("DPanel", self.RightScrollPanel);
        test:SetTall(60)
        test:Dock(TOP);
    end;

    self.uBottomPanel = vgui.Create("DPanel", self);
    self.uBottomPanel:Dock(BOTTOM)
    self.uBottomPanel:SetTall(35);

    self.uLeftButton = vgui.Create("DButton", self.uBottomPanel);
    self.uLeftButton:SetText("ADD NOTE")
    self.uLeftButton:Dock(LEFT);
    self.uLeftButton:SetWide(225);
    self.uLeftButton:DockMargin(5, 2.5, 5, 2.5);

    self.uMiddleButton = vgui.Create("DButton", self.uBottomPanel);
    self.uMiddleButton:SetText("ADD CIVIL RECORD")
    self.uMiddleButton:Dock(FILL);
    self.uMiddleButton:SetWide(225);
    self.uMiddleButton:DockMargin(5, 2.5, 5, 2.5);

    self.uRightButton = vgui.Create("DButton", self.uBottomPanel);
    self.uRightButton:SetText("ADD MEDICAL NOTE")
    self.uRightButton:Dock(RIGHT);
    self.uRightButton:SetWide(225);
    self.uRightButton:DockMargin(5, 2.5, 5, 2.5);

    self.dBottomPanel = vgui.Create("DPanel", self);
    self.dBottomPanel:Dock(BOTTOM)
    self.dBottomPanel:SetTall(35);

    self.dLeftButton = vgui.Create("DButton", self.dBottomPanel);
    self.dLeftButton:SetText("UPDATE LAST SEEN")
    self.dLeftButton:Dock(LEFT);
    self.dLeftButton:SetWide(225);
    self.dLeftButton:DockMargin(5, 2.5, 5, 2.5);

    self.dMiddleButton = vgui.Create("DButton", self.dBottomPanel);
    self.dMiddleButton:SetText("CHANGE CIVIL STATUS")
    self.dMiddleButton:Dock(FILL);
    self.dMiddleButton:SetWide(225);
    self.dMiddleButton:DockMargin(5, 2.5, 5, 2.5);

    self.dRightButton = vgui.Create("DButton", self.dBottomPanel);
    self.dRightButton:SetText("ADD BOL")
    self.dRightButton:Dock(RIGHT);
    self.dRightButton:SetWide(225);
    self.dRightButton:DockMargin(5, 2.5, 5, 2.5);
end;

function PANEL:Populate(target, GenericData, datafile)
    // Population function. Create all the components based upon the stripped datafile.
    // 3 statuses; green, yellow, red;
    local bHasBOL = GenericData.bol[1];
    local bIsAntiCitizen;

    if (GenericData.civilStatus == "Anti-Citizen") then
        bIsAntiCitizen = true;
    end;

    if (bHasBol) then
        self.Status = "yellow";
        self.dRightButton:SetText("REMOVE BOL");
    elseif (bIsAntiCitizen) then
        self.Status = "red";
    end;

    self.Status = "yellow"

    self.NameLabel:SetText(target:Name());
end;

function PANEL:Paint(w, h)
    local sineToColor = math.abs(math.sin(RealTime() * 1.5) * 255);
    local color;

    if (self.Status == "yellow") then
        color = Color(sineToColor / 1.4, sineToColor / 1.4, 0, 180);

    elseif (self.Status == "red") then
        color = Color(sineToColor, 0, 0, 180);
    else
        color = Color(46, 204, 113, 200);
    end;

    surface.SetDrawColor(color);
    surface.DrawRect(0, 0, w, h);

    self.NameLabel:SetTextColor(color);

    surface.SetDrawColor(Color(255, 255, 255, 100));
    surface.DrawOutlinedRect(0, 0, w, h);
end;

vgui.Register("civilDatafile", PANEL, "DFrame");

local target = Entity(1);
local GenericData = {
    bol = {false, ""},
    restricted = {false, ""},
    civilStatus = "";
    lastSeen = "";
};

local datafile = {};

datafile[1] = {
        category = "civil", // med, union, civil
        text = "hello",
        date = "15/01/2017 - 21:20:15",
        points = "3",
        poster = {"Hey Man", "test"},
}

local test = vgui.Create("civilDatafile");
test:Populate(target, GenericData, datafile)
