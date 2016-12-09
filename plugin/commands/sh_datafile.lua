local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("Datafile");
COMMAND.text = "<string Name>";
COMMAND.tip = "View the datafile of someone.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
    if (Datafile:CanUseDatafile(player)) then
        local target = Clockwork.player:FindByID(table.concat(arguments, " "));

        if (Datafile:CanUseDatafileRestricted(player) && Schema:PlayerIsCombine(target)) then
            Clockwork.player:Notify(player, "You are not authorized to see restricted datafiles.");
        else
            if (target) then
                /*if (Datafile:CanUseDatafileRestricted(player)) then
                    local dfPlayer = target:GetCharacterData("dfMain");

                    for k, v in pairs(dfPlayer.datafile) do
                        if (dfPlayer.datafile[k].category == "civil") then
                            table.remove(dfPlayer.datafile, k);
                        end;
                    end;

                    Clockwork.datastream:Start(player, "datafile", {target, dfPlayer});
                end;*/

                Clockwork.datastream:Start(player, "datafile", {target, target:GetCharacterData("dfMain")});
            else
                Clockwork.player:Notify(player, "You have entered an invalid character.");
            end;
        end;
    else
        Clockwork.player:Notify(player, "You are not authorized to use datafile.");
    end;
end;

COMMAND:Register();
