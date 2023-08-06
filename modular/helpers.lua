local spawn  = require("awful.spawn")
local timer  = require("gears.timer")
local helpers = {}

helpers.timer_table = {}

function helpers.newtimer(name, timeout, fun, nostart, stoppable)
    if not name or #name == 0 then return end
    name = (stoppable and name) or timeout
    if not helpers.timer_table[name] then
        helpers.timer_table[name] = timer({ timeout = timeout })
        helpers.timer_table[name]:start()
    end
    helpers.timer_table[name]:connect_signal("timeout", fun)
    if not nostart then
        helpers.timer_table[name]:emit_signal("timeout")
    end
    return stoppable and helpers.timer_table[name]
end

function helpers.async(cmd, callback)
    return spawn.easy_async(cmd,
    function (stdout, _, _, exit_code)
        callback(stdout, exit_code)
    end)
end


return helpers
