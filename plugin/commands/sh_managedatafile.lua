local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("ManageDatafile");
COMMAND.text = "<string Name>";
COMMAND.tip = "Manage the datafile of someone.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(table.concat(arguments, " "));

    if (target) then
        Clockwork.datastream:Start(player, "CreateManagementPanel", {target, cwDatafile:ReturnDatafile(target)});
    else
        Clockwork.player:Notify(player, "This datafile does not exist.");
    end;
end;

COMMAND:Register();
