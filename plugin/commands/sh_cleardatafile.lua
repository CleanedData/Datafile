local cw, cwDatafile = cw, cwDatafile

local COMMAND = cw.command:New("ClearDatafile")
COMMAND.text = "#datafile_command_cleardatafile_syntax"
COMMAND.tip = "#datafile_command_cleardatafile_tip"
COMMAND.access = "s"
COMMAND.arguments = 1

function COMMAND:OnRun(player, arguments)
    local target = _player.Find((table.concat(arguments, " ")))

    if (target) then
        cwDatafile:ClearDatafile(target)
    else
        cw.player:Notify(player, L"#datafile_command_cleardatafile_err1")
    end
end

COMMAND:Register();

