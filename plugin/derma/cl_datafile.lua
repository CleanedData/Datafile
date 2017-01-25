/*local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

surface.CreateFont("MiddleLabels", {
    font = "DermaLarge",
    size = 21,
    weight = 0,
})

surface.CreateFont("TopBoldLabel", {
    font = "DermaLarge",
    size = 21,
    weight = 500,
    antialias = true,
})

surface.CreateFont("TopLabel", {
    font = "Helvetica",
    size = 23,
    weight = 0,
    antialias = true,
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
    self.TopPanel:SetTall(85)
    function self.TopPanel:Paint(w, h)
        surface.SetDrawColor(Color(40, 40, 40, 255));
        surface.DrawRect(0, 0, w, h)
    end;

    self.NameLabel = vgui.Create("DLabel", self.TopPanel);
    self.NameLabel:SetTextColor(Color(0, 0, 0, 255));
    self.NameLabel:SetText("");
    self.NameLabel:SetFont("DermaLarge")
    self.NameLabel:Dock(TOP);
    self.NameLabel:DockMargin(5, 5, 0, 0);
    self.NameLabel:SizeToContents();

    // cid, civil status, last seen, points

    self.LabelPanel = vgui.Create("DPanel", self);
    self.LabelPanel:Dock(TOP);
    self.LabelPanel:SetTall(35);
    self.LabelPanel:DockMargin(0, 3, 0, 0);
    function self.LabelPanel:Paint(w, h)
        surface.SetDrawColor(Color(40, 40, 40, 255));
        surface.DrawRect(0, 0, w, h)
    end;

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

    function self.FillPanel:Paint(w, h)
        surface.SetDrawColor(Color(40, 40, 40, 255));
        surface.DrawRect(0, 0, w, h);
    end;

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

    self.dBottomPanel = vgui.Create("DPanel", self);
    self.dBottomPanel:Dock(BOTTOM)
    self.dBottomPanel:SetTall(35);
    function self.dBottomPanel:Paint(w, h)
        surface.SetDrawColor(Color(40, 40, 40, 255));
        surface.DrawRect(0, 0, w, h);
    end;

    self.dLeftButton = vgui.Create("DButton", self.dBottomPanel);
    self.dLeftButton:SetText("UPDATE LAST SEEN")
    self.dLeftButton:SetTextColor(Color(180, 180, 180, 255))
    self.dLeftButton:Dock(LEFT);
    self.dLeftButton:SetWide(225);
    self.dLeftButton:DockMargin(5, 2.5, 5, 2.5);
    function self.dLeftButton:Paint(w, h)
        surface.SetDrawColor(Color(47, 47, 47, 255));
        surface.DrawRect(0, 0, w, h);
    end;

    self.dMiddleButton = vgui.Create("DButton", self.dBottomPanel);
    self.dMiddleButton:SetText("CHANGE CIVIL STATUS")
    self.dMiddleButton:SetTextColor(Color(180, 180, 180, 255))
    self.dMiddleButton:Dock(FILL);
    self.dMiddleButton:SetWide(225);
    self.dMiddleButton:DockMargin(5, 2.5, 5, 2.5);
    function self.dMiddleButton:Paint(w, h)
        surface.SetDrawColor(Color(47, 47, 47, 255));
        surface.DrawRect(0, 0, w, h);
    end;

    self.dRightButton = vgui.Create("DButton", self.dBottomPanel);
    self.dRightButton:SetText("ADD BOL")
    self.dRightButton:SetTextColor(Color(180, 180, 180, 255))
    self.dRightButton:Dock(RIGHT);
    self.dRightButton:SetWide(225);
    self.dRightButton:DockMargin(5, 2.5, 5, 2.5);
    function self.dRightButton:Paint(w, h)
        surface.SetDrawColor(Color(47, 47, 47, 255));
        surface.DrawRect(0, 0, w, h);
    end;

    self.uBottomPanel = vgui.Create("DPanel", self);
    self.uBottomPanel:Dock(BOTTOM)
    self.uBottomPanel:SetTall(35);
    function self.uBottomPanel:Paint(w, h)
        surface.SetDrawColor(Color(40, 40, 40, 255));
        surface.DrawRect(0, 0, w, h);
    end;

    self.uLeftButton = vgui.Create("DButton", self.uBottomPanel);
    self.uLeftButton:SetText("ADD NOTE")
    self.uLeftButton:SetTextColor(Color(180, 180, 180, 255))
    self.uLeftButton:Dock(LEFT);
    self.uLeftButton:SetWide(225);
    self.uLeftButton:DockMargin(5, 2.5, 5, 2.5);
    function self.uLeftButton:Paint(w, h)
        surface.SetDrawColor(Color(47, 47, 47, 255));
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(Color(41, 128, 185, 255));
        surface.DrawRect(0, h - 2, w, 2);
    end;

    self.uMiddleButton = vgui.Create("DButton", self.uBottomPanel);
    self.uMiddleButton:SetText("ADD CIVIL RECORD")
    self.uMiddleButton:SetTextColor(Color(180, 180, 180, 255))
    self.uMiddleButton:Dock(FILL);
    self.uMiddleButton:SetWide(225);
    self.uMiddleButton:DockMargin(5, 2.5, 5, 2.5);
    function self.uMiddleButton:Paint(w, h)
        surface.SetDrawColor(Color(47, 47, 47, 255));
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(Color(231, 76, 60, 255));
        surface.DrawRect(0, h - 2, w, 2);
    end;

    self.uRightButton = vgui.Create("DButton", self.uBottomPanel);
    self.uRightButton:SetText("ADD MEDICAL NOTE")
    self.uRightButton:SetTextColor(Color(180, 180, 180, 255))
    self.uRightButton:Dock(RIGHT);
    self.uRightButton:SetWide(225);
    self.uRightButton:DockMargin(5, 2.5, 5, 2.5);
    function self.uRightButton:Paint(w, h)
        surface.SetDrawColor(Color(47, 47, 47, 255));
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(Color(39, 174, 96, 255));
        surface.DrawRect(0, h - 2, w, 2);
    end;
end;

function PANEL:Populate(target, GenericData, datafile)
    // Population function. Create all the components based upon the stripped datafile.
    // 3 statuses; gray, yellow, red, blue;
    local bIsCombine = Schema:PlayerIsCombine(target);
    local bHasBOL = GenericData.bol[1];
    local bIsAntiCitizen;
    local civilStatus = GenericData.civilStatus;
    local totalPoints = 0;
    local lastSeen = GenericData.lastSeen;

    for k, v in pairs(datafile) do
        totalPoints = totalPoints + tonumber(v.points);
    end;

    if (GenericData.civilStatus == "Anti-Citizen") then
        bIsAntiCitizen = true;
    end;

    if (bHasBol) then
        self.Status = "yellow";
        self.dRightButton:SetText("REMOVE BOL");
    elseif (bIsAntiCitizen) then
        self.Status = "red";
    elseif (bIsCombine) then
        self.Status = "blue";
    end;

    self.NameLabel:SetText(target:Name());

    for k, v in pairs(datafile) do
        if (datafile[k].category == "civil") then
            local entry = vgui.Create("datafileEntry", self.MiddleScrollPanel);
            entry:SetEntryText(datafile[k].text, datafile[k].date, "~ " .. datafile[k].poster[1], tonumber(datafile[k].points), datafile[k].poster[3]);
            entry:SetEntryColor(datafile[k].poster[3]);

            function entry:Paint(w, h)
                surface.SetDrawColor(Color(47, 47, 47, 255));
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(datafile[k].poster[3]);
                surface.DrawRect(0, h - 2, w, 2);
            end;

        elseif (datafile[k].category == "med") then
            local entry = vgui.Create("datafileEntry", self.RightScrollPanel);
            entry:SetEntryText(datafile[k].text, datafile[k].date, "~ " .. datafile[k].poster[1], tonumber(datafile[k].points), datafile[k].poster[3])
            entry:SetEntryColor(datafile[k].poster[3]);

            function entry:Paint(w, h)
                surface.SetDrawColor(Color(47, 47, 47, 255));
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(datafile[k].poster[3]);
                surface.DrawRect(0, h - 2, w, 2);
            end;

        elseif (datafile[k].category == "union") then
            local entry = vgui.Create("datafileEntry", self.LeftScrollPanel);
            entry:SetEntryText(datafile[k].text, datafile[k].date, "~ " .. datafile[k].poster[1], tonumber(datafile[k].points), datafile[k].poster[3])
            entry:SetEntryColor(datafile[k].poster[3]);

            function entry:Paint(w, h)
                surface.SetDrawColor(Color(47, 47, 47, 255));
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(datafile[k].poster[3]);
                surface.DrawRect(0, h - 2, w, 2);
            end;
        end;
    end;

    local Header = vgui.Create("datafileInfoLabel", self.TopPanel);
    Header:SetInfoText("CIVIL STATUS", civilStatus, "CIVIL RECORD", totalPoints, "LAST SEEN", lastSeen)
end;

function PANEL:Paint(w, h)
    local sineToColor = math.abs(math.sin(RealTime() * 1.5) * 255);
    local color;

    if (self.Status == "yellow") then
        color = Color(sineToColor / 1.4, sineToColor / 1.4, 0, 180);

    elseif (self.Status == "red") then
        color = Color(sineToColor, 0, 0, 180);

    elseif (self.Status == "blue") then
        color = Color(0, 100, 150, 200)
    else
        color = Color(170, 170, 170, 200);
    end;

    surface.SetDrawColor(color);
    surface.DrawRect(0, 0, w, h);

    self.NameLabel:SetTextColor(color);

    surface.SetDrawColor(Color(255, 255, 255, 100));
    surface.DrawOutlinedRect(0, 0, w, h);
end;

vgui.Register("civilDatafile", PANEL, "DFrame");

local PANEL = {};

function PANEL:Init()
    self.color = Color(255, 255, 255, 255);
    self:Dock(TOP);
    self:SetTall(90);
    self:DockMargin(0, 5, 5, 0)

    self.Text = vgui.Create("DLabel", self);
    self.Text:SetTextColor(Color(220, 220, 220, 255))
    self.Text:SetText("");
    self.Text:SetWrap(true);
    self.Text:Dock(FILL);
    self.Text:DockMargin(5, 0, 0, 0);
    self.Text:SetContentAlignment(5);

    self.Date = vgui.Create("DLabel", self);
    self.Date:SetTextColor(Color(150, 150, 150));
    self.Date:SetText("");
    self.Date:SetWrap(true);
    self.Date:Dock(TOP);
    self.Date:DockMargin(5, 5, 0, 0);
    self.Date:SetContentAlignment(7);

    self.Poster = vgui.Create("DLabel", self);
    self.Poster:SetWrap(true);
    self.Poster:Dock(BOTTOM);
    self.Poster:DockMargin(5, 0, 0, 5);
    self.Poster:SetContentAlignment(1);

    self.Points = vgui.Create("DLabel", self.Date);
    self.Points:SetWrap(true);
    self.Points:SetWide(20)
    self.Points:Dock(RIGHT);
    self.Points:DockMargin(0, 0, 0, 0);
    self.Points:SetContentAlignment(9);
end;

function PANEL:SetEntryText(noteText, dateText, posterText, pointsText)
    self.Text:SetText(noteText);
    self.Date:SetText(dateText);
    self.Poster:SetText(posterText);
    self.Points:SetText(pointsText);

    if (pointsText < 0) then
        self.Points:SetTextColor(Color(255, 100, 100, 255))
    elseif (pointsText > 0) then
        self.Points:SetTextColor(Color(150, 255, 50, 255))
    else
        self.Points:SetTextColor(Color(220, 220, 220, 255))
    end;

    self:SetTall(60 + (string.len(self.Text:GetText()) / 28) * 9);
end;

function PANEL:SetEntryColor(posterColor, pointsColor)
    self.Poster:SetTextColor(posterColor);
end;


vgui.Register("datafileEntry", PANEL, "DPanel");


local PANEL = {};

function PANEL:Init()
    self:Dock(TOP);
    self:SetTall(50);


    self.LeftHeaderLabel = vgui.Create("DLabel", self);
    self.LeftHeaderLabel:SetContentAlignment(4)
    self.LeftHeaderLabel:SetTextColor(Color(0, 150, 150, 255));
    self.LeftHeaderLabel:SetFont("TopBoldLabel");
    self.LeftHeaderLabel:Dock(FILL);
    self.LeftHeaderLabel:DockMargin(5, 5, 0, 0);

    self.MiddleHeaderLabel = vgui.Create("DLabel", self);
    self.MiddleHeaderLabel:SetContentAlignment(5)
    self.MiddleHeaderLabel:SetTextColor(Color(231, 76, 60, 255));
    self.MiddleHeaderLabel:SetFont("TopBoldLabel");
    self.MiddleHeaderLabel:Dock(FILL);
    self.MiddleHeaderLabel:DockMargin(5, 5, 0, 0);

    self.RightHeaderLabel = vgui.Create("DLabel", self);
    self.RightHeaderLabel:SetContentAlignment(6)
    self.RightHeaderLabel:SetTextColor(Color(150, 150, 96, 255));
    self.RightHeaderLabel:SetFont("TopBoldLabel");
    self.RightHeaderLabel:Dock(FILL);
    self.RightHeaderLabel:DockMargin(0, 5, 5, 0);

    self.TextPanel = vgui.Create("DPanel", self);
    self.TextPanel:Dock(BOTTOM);
    self.TextPanel:SetTall(25)
    self.TextPanel.Paint = function() return false end;

    self.LeftTextLabel = vgui.Create("DLabel", self.TextPanel);
    self.LeftTextLabel:SetTextColor(Color(180, 180, 180, 255));
    self.LeftTextLabel:SetContentAlignment(4)
    self.LeftTextLabel:Dock(FILL);
    self.LeftTextLabel:DockMargin(5, 5, 5, 5);

    self.MiddleTextLabel = vgui.Create("DLabel", self.TextPanel);
    self.MiddleTextLabel:SetTextColor(Color(0, 0, 0, 255));
    self.MiddleTextLabel:SetContentAlignment(5)
    self.MiddleTextLabel:Dock(FILL);
    self.MiddleTextLabel:DockMargin(5, 5, 5, 5);

    self.RightTextLabel = vgui.Create("DLabel", self.TextPanel);
    self.RightTextLabel:SetTextColor(Color(180, 180, 180, 255));
    self.RightTextLabel:SetContentAlignment(6)
    self.RightTextLabel:Dock(FILL);
    self.RightTextLabel:DockMargin(5, 5, 5, 5);
end;

function PANEL:SetInfoText(leftTop, leftBottom, middleTop, middleBottom, rightTop, rightBottom, color)
    self.LeftHeaderLabel:SetText(leftTop);
    self.LeftTextLabel:SetText(leftBottom);

    self.MiddleHeaderLabel:SetText(middleTop);
    self.MiddleTextLabel:SetText(middleBottom);

    self.RightHeaderLabel:SetText(rightTop);
    self.RightTextLabel:SetText(rightBottom);

    if (tonumber(middleBottom) < 0) then
        self.MiddleTextLabel:SetTextColor(Color(200, 0, 0, 255));
    elseif (tonumber(middleBottom) > 0) then
        self.MiddleTextLabel:SetTextColor(Color(0, 150, 0, 255));
    else
        self.MiddleTextLabel:SetTextColor(Color(0, 0, 0, 255));
    end;
end;

function PANEL:Paint(w, h)
    surface.SetDrawColor(Color(180, 180, 180, 255));
    surface.DrawRect(0, 27, w, 1);
end;

vgui.Register("datafileInfoLabel", PANEL, "DPanel");

local target = Entity(1);
local GenericData = {
    bol = {false, ""},
    restricted = {false, ""},
    civilStatus = "Citizen";
    lastSeen = "16/01/2017 - 19:11:01";
};

local datafile = {};

datafile[1] = {
        category = "civil", // med, union, civil
        text = "helloooOOojfeoiazfmejazoizjeoi",
        date = "15/01/2017 - 21:20:15",
        points = "3",
        poster = {"Hey Man", "test", team.GetColor(Entity(1):Team())},
};

datafile[2] = {
        category = "med", // med, union, civil
        text = "mlk jlkdjlekj fmelzkfj azmlkfjzealfj ezalfkjeazlfj zeaflkejz amflza jlmk j",
        date = "15/01/2017 - 21:20:15",
        points = "65",
        poster = {"Hey Man", "test", team.GetColor(Entity(1):Team())},
};

datafile[3] = {
        category = "union", // med, union, civil
        text = "mlkj lkfjazi jioez jfazeoi ! ! ! ! !! !! ! pizza pug",
        date = "15/01/2017 - 21:20:15",
        points = "-50",
        poster = {"Hey Man", "test", team.GetColor(Entity(1):Team())},
};

datafile[4] = {
        category = "med", // med, union, civil
        text = "hello",
        date = "15/01/2017 - 21:20:15",
        points = "-6",
        poster = {"Hey Man", "test", team.GetColor(Entity(1):Team())},
};

datafile[5] = {
        category = "union", // med, union, civil
        text = "hello",
        date = "15/01/2017 - 21:20:15",
        points = "3",
        poster = {"CP:LOL", "test", Color(0, 150, 255)},
};

datafile[6] = {
        category = "union", // med, union, civil
        text = "hello",
        date = "15/01/2017 - 21:20:15",
        points = "3",
        poster = {"CP:LOL", "test", Color(0, 150, 255)},
};

datafile[7] = {
        category = "union", // med, union, civil
        text = "hello",
        date = "15/01/2017 - 21:20:15",
        points = "3",
        poster = {"CP:LOL", "test", Color(0, 150, 255)},
};

datafile[8] = {
        category = "union", // med, union, civil
        text = "hello",
        date = "15/01/2017 - 21:20:15",
        points = "3",
        poster = {"CP:LOL", "test", Color(0, 150, 255)},
};

datafile[9] = {
        category = "union", // med, union, civil
        text = "hello",
        date = "15/01/2017 - 21:20:15",
        points = "3",
        poster = {"CP:LOL", "test", Color(0, 150, 255)},
};

datafile[10] = {
        category = "union", // med, union, civil
        text = "hello",
        date = "15/01/2017 - 21:20:15",
        points = "3",
        poster = {"CP:LOL", "test", Color(0, 150, 255)},
};


local test = vgui.Create("civilDatafile");
test:Populate(target, GenericData, datafile)
*/