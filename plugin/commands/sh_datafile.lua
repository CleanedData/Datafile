local cw, cwDatafile = cw, cwDatafile

local COMMAND = cw.command:New("Datafile")
COMMAND.text = "#datafile_command_datafile_syntax"
COMMAND.tip = "#datafile_command_datafile_tip"
COMMAND.flags = CMD_DEFAULT
COMMAND.arguments = 1

function COMMAND:OnRun(player, arguments)
    local target = _player.Find(table.concat(arguments, " "))

    if (target) then
        if (cwDatafile:IsRestrictedFaction(target)) then
            cw.player:Notify(player, L"#datafile_command_datafile_err")
        else
            cwDatafile:HandleDatafile(player, target)
        end
    else
        cw.player:Notify(player, L"#datafile_command_datafile_err")
    end
end

COMMAND:Register()
