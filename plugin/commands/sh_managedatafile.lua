local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("ManageDatafile");
COMMAND.text = "<string Name>";
COMMAND.tip = "Manage someone their datafile. Ability to remove entries.";
COMMAND.access = "s";
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(table.concat(arguments, " "));

    if (target) then
        Clockwork.datastream:Start(player, "managedatafile", {target, target:GetCharacterData("dfMain")});
    else
        Clockwork.player:Notify(player, "You have entered an invalid character.");
    end;
end;

COMMAND:Register();
