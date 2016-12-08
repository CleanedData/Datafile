local PLUGIN = PLUGIN;

local PANEL = {}

function PANEL:Init()
    self:SetSize(700, 400);
    self:Center();

    self:MakePopup();
end;

function PANEL:Populate(target, dfTarget)
    self:SetTitle(target:Nick() .. "'s Datafile");

    self.List = vgui.Create("DListView", self);
    self.List:Dock(FILL);
    self.List:SetMultiSelect(false);
    self.List:AddColumn("Date");
    self.List:AddColumn("Category");
    self.List:AddColumn("Text");
    self.List:AddColumn("Points");
    self.List:AddColumn("Author");

    for k, v in pairs(dfTarget.datafile) do
        local line = self.List:AddLine(dfTarget.datafile[k].date, dfTarget.datafile[k].category, dfTarget.datafile[k].text, dfTarget.datafile[k].points, dfTarget.datafile[k].originalposter);

        /*
        function line:Paint(w, h)
            if (line:IsHovered()) then
                if (dfTarget.datafile[k].category == "note") then
                    surface.SetDrawColor(27, 72, 232, 50);
                    surface.DrawRect(0, 0, w, h);
                elseif (dfTarget.datafile[k].category == "civil") then
                    surface.SetDrawColor(232, 72, 27, 50);
                    surface.DrawRect(0, 0, w, h);
                elseif (dfTarget.datafile[k].category == "medical") then
                    surface.SetDrawColor(27, 190, 72, 50);
                    surface.DrawRect(0, 0, w, h);
                end;
            else
                if (dfTarget.datafile[k].category == "note") then
                    surface.SetDrawColor(27, 72, 232, 150);
                    surface.DrawRect(0, 0, w, h);
                elseif (dfTarget.datafile[k].category == "civil") then
                    surface.SetDrawColor(232, 72, 27, 150);
                    surface.DrawRect(0, 0, w, h);
                elseif (dfTarget.datafile[k].category == "medical") then
                    surface.SetDrawColor(27, 190, 72, 150);
                    surface.DrawRect(0, 0, w, h);
                end;
            end;
        end;*/
    end;

    self.BottomPanel = vgui.Create("DPanel", self);
    self.BottomPanel:Dock(BOTTOM);

    self.Delete = vgui.Create("DButton", self.BottomPanel)
    self.Delete:Dock(FILL);
    self.Delete:SetText("Delete Entry");
    self.Delete:DockMargin(0, 5, 0, 0);
    self.Delete.DoClick = function()
        local key = self.List:GetSelectedLine();

        if (key == nil) then
            return false
        else
            local key = self.List:GetSelectedLine();
            local date = self.List:GetLine(self.List:GetSelectedLine()):GetValue(1);
            local text = self.List:GetLine(self.List:GetSelectedLine()):GetValue(3);

            PLUGIN:RemoveEntry(target, key, date, text);
            self.List:RemoveLine(key);
        end;
    end;
end;

vgui.Register("dfDataManagement", PANEL, "DFrame");
