local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("ScrubDatafile");
COMMAND.text = "<string Name>";
COMMAND.tip = "Scrub someone their datafile.";
COMMAND.access = "s";
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(table.concat(arguments, " "));
  
    if (target) then
        PLUGIN:ScrubDatafile(target);
    else
        Clockwork.player:Notify(player, "You have entered an invalid character.");
    end;
end;

COMMAND:Register();