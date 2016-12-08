local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("Datafile");
COMMAND.text = "<string Name>";
COMMAND.tip = "View the datafile of someone.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
    --if (Schema:PlayerIsCombine(player)) then
        local target = Clockwork.player:FindByID(table.concat(arguments, " "));

        if (target) then
            Clockwork.datastream:Start(player, "datafile", {target, target:GetCharacterData("dfMain")});
        else
            Clockwork.player:Notify(player, "You have entered an invalid character.");
        end;
    --else
        --Clockwork.player:Notify(player, "You are not authorized to use datafile.");
    --end;
end;

COMMAND:Register();
