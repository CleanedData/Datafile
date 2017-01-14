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
        PLUGIN:HandleDatafile(player, target)
    end;
end;

COMMAND:Register();
