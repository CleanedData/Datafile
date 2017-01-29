local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("RestrictDatafile");
COMMAND.text = "<string Name> <string Reason>";
COMMAND.tip = "Make someone their datafile (un)restricted.";
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(table.concat(arguments, " "));

    if (target ) then
    	if (PLUGIN:ReturnPermission(player) >= 3) then
	    	if (PLUGIN:IsRestricted(player)) then
	        	PLUGIN:SetRestricted(false, "", target, player);

	        	Clockwork.player:Notify(player, target:Name() .. "'s file has been unrestricted.");
	    	else
	        	PLUGIN:SetRestricted(true, "test lol", target, player);

	        	Clockwork.player:Notify(player, target:Name() .. "'s file has been restricted.");
	    	end;
	    else
	    	Clockwork.player:Notify(player, "You do not have access to this command.");
	    end;
    else
        Clockwork.player:Notify(player, "You have entered an invalid character.");
    end;
end;

COMMAND:Register();