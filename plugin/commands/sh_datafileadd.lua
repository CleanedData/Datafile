local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("DatafileAdd");
COMMAND.text = "<string Name> <string Category> <int Points> [string Entry]";
COMMAND.tip = "View the datafile of someone.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 4;

function COMMAND:OnRun(player, arguments)
    --if (Schema:PlayerIsCombine(player)) then
        local target = Clockwork.player:FindByID(arguments[1], " ");
        local category = arguments[2];
        local points = tonumber(arguments[3]);
        local entry = arguments[4];

        if (target) then
            if (category) then
                if (points) then
                    if (entry) then
                        PLUGIN:AddEntry(target, category, entry, points, player);
                    else
                        Clockwork.player:Notify(player, "This is not a valid entry.");
                    end;
                else
                    Clockwork.player:Notify(player, "This is not a valid amount of points.");
                end;
            else
                Clockwork.player:Notify(player, "This is not a valid category.");
            end;
        else
            Clockwork.player:Notify(player, "You have entered an invalid character.");
        end;
    --else
        --Clockwork.player:Notify(player, "You are not authorized to use datafile.");
    --end;
end;

COMMAND:Register();
