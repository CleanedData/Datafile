local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("Datafile");
COMMAND.text = "<string Name>";
COMMAND.tip = "View the datafile of someone.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(table.concat(arguments, " "));

    if (target) then
        if (PLUGIN:IsRestrictedFaction(target)) then
            Clockwork.player:Notify(player, "This datafile does not exist.");
        else
            PLUGIN:HandleDatafile(player, target)
        end;
    else
        Clockwork.player:Notify(player, "This datafile does not exist.");
    end;
end;

COMMAND:Register();
