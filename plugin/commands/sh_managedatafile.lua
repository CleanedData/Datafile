local cw, cwDatafile = cw, cwDatafile

local COMMAND = cw.command:New("ManageDatafile")
COMMAND.text = "#datafile_command_managedatafile_syntax"
COMMAND.tip = "#datafile_command_managedatafile_tip"
COMMAND.flags = CMD_DEFAULT
COMMAND.arguments = 1

function COMMAND:OnRun(player, arguments)
    local target = _player.Find(table.concat(arguments, " "))

    if (target) then
        netstream.Start(player, "CreateManagementPanel", {target, cwDatafile:ReturnDatafile(target)})
    else
        cw.player:Notify(player, L"#datafile_command_managedatafile_err")
    end
end

COMMAND:Register()