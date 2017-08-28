-- default keybinding: n
-- add the following to your input.conf to change the default keybinding:
-- keyname script_binding auto_load_delogo
local utils = require 'mp.utils'
function load_delogo_fn()
    mp.osd_message("Search logo")
    subl = "~/.config/mpv/bin/delogo"
    t = {}
    t.args = {subl,mp.get_property("path")}
    res = utils.subprocess(t)
    mp.osd_message(res.stdout)
    mp.command("vf add @%s:lavfi=" .. res.stdout)
    mp.osd_message("No Logo")
end

mp.add_key_binding("n", "auto_load_delogo", load_delogo_fn)
