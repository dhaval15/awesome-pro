local helpers = require("modular.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")

-- COMMAND widget

-- modular.widget.command

local function factory(args)
    args           = args or {}
    local command  = { widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 5
    local cmd      = args.command
		local bg       = args.bg or "#000000"
		local fg       = args.fg or "#FFFFFF"
		local margins  = args.margins or 2
		local padding  = args.padding or 8
		local prev_value = nil
		local font     = "Icons 10"
    local settings = function(value) 
			command.widget:set_markup(string.format("<span font='%s'>%s</span>", font, value))
		end

    local container = {
			{
				{
					command,
					left    = padding,
					right   = padding,
					widget  = wibox.container.margin()
				},
				bg     = bg .. "CC",
				fg     = fg,
				widget = wibox.container.background()
			},
			margins = margins,
			widget  = wibox.container.margin()
		}

    function container.update()
        helpers.async(cmd, function(value)
            if prev_value ~= value then
                widget = command.widget
                settings(value)
                prev_value = value
            end
        end)
    end

		--container.update()
    helpers.newtimer(cmd, timeout, container.update)
		return container
end

return factory
