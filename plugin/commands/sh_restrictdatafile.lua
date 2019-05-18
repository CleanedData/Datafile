local cw, cwDatafile = cw, cwDatafile

local COMMAND = cw.command:New("RestrictDatafile")
COMMAND.text = "#datafile_command_restrictdatafile_syntax"
COMMAND.tip = "#datafile_command_restrictdatafile_tip"
COMMAND.arguments = 1
COMMAND.optionalArguments = 1

function COMMAND:OnRun(player, arguments)
    local target = _player.Find(arguments[1])
    local text = table.concat(arguments, " ", 2)

    if (!text or text == "") then
    	text = nil
    end

    if (target) then
    	if (cwDatafile:ReturnPermission(player) >= DATAFILE_PERMISSION_FULL) then
    		if (text) then
	        	cwDatafile:SetRestricted(true, text, target, player)
				local langrestricted = true

	        	cw.player:Notify(player, L("#datafile_command_restrictdatafile_notify", target:Name(), (langrestricted and L"#datafile_restricted" or L"#datafile_unrestricted")))
    		else
	        	cwDatafile:SetRestricted(false, "", target, player)
				local langrestricted = false

	        	cw.player:Notify(player, L("#datafile_command_restrictdatafile_notify", target:Name(), (langrestricted and L"#datafile_restricted" or L"#datafile_unrestricted")))
    		end
	    else
	    	cw.player:Notify(player, L"#datafile_command_restrictdatafile_err1")
	    end
    else
        cw.player:Notify(player, L"#datafile_command_restrictdatafile_err2")
    end
end

COMMAND:Register()