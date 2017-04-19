local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("RestrictDatafile");
COMMAND.text = "<string Name> [string Reason]";
COMMAND.tip = "Make someone their datafile (un)restricted.";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

function COMMAND:OnRun(player, arguments)
    local target = Clockwork.player:FindByID(arguments[1]);
    local text = table.concat(arguments, " ", 2);

    if (!text or text == "") then
    	text = nil;
    end;

    if (target) then
    	if (cwDatafile:ReturnPermission(player) >= DATAFILE_PERMISSION_FULL) then
    		if (text) then
	        	cwDatafile:SetRestricted(true, text, target, player);

	        	Clockwork.player:Notify(player, target:Name() .. "'s file has been restricted.");
    		else
	        	cwDatafile:SetRestricted(false, "", target, player);

	        	Clockwork.player:Notify(player, target:Name() .. "'s file has been unrestricted.");
    		end;
	    else
	    	Clockwork.player:Notify(player, "You do not have access to this command.");
	    end;
    else
        Clockwork.player:Notify(player, "You have entered an invalid character.");
    end;
end;

COMMAND:Register();
