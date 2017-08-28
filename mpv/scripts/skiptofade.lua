-- betterchapters.lua
-- seeks forward until a black screen appears.
-- default keybinding: b
-- Keybind names: skip_scene
script_name = mp.get_script_name()
detect_label = string.format("%s-detect", script_name)
detecting = false
threshold = 0.9
detection_span = 0.05
negation = false
normal_speed = 1
seek_position = 0.0

function toggle_detect()
	if (detecting) then
		stop()
	else
		detecting = not detecting
		normal_speed = mp.get_property_native("speed")
		mp.set_property("speed", 100)
		detect()
	end
end

-- from https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autocrop.lua
function del_filter_if_present(label)
    -- necessary because mp.command('vf del @label:filter') raises an
    -- error if the filter doesn't exist
    local vfs = mp.get_property_native("vf")
    for i,vf in pairs(vfs) do
        if vf["label"] == label then
            table.remove(vfs, i)
            mp.set_property_native("vf", vfs)
            return true
        end
    end
    return false
end

function toggle_negation()
	del_filter_if_present(detect_label)
	if (negation) then
		del_filter_if_present("negate")
		negation = false
	else
		mp.command('vf add @negate:lavfi=graph="negate=1"')
		negation = true
	end
end

function detect()
  if (detecting) then
		toggle_negation()
    mp.command(
      string.format(
        'vf add @%s:lavfi=graph="blackdetect=d=%s:pic_th=%s"',
        detect_label, detection_span, threshold)
    )
    mp.add_timeout(detection_span, seek)
  end
end

function seek()
	local res = mp.get_property_native(string.format("vf-metadata/%s", detect_label))
	if (res["lavfi.black_start"]) then
    seek_position = res["lavfi.black_start"]
		stop()
	else 
		detect()
	end
end

function stop()
	del_filter_if_present("negate")
	del_filter_if_present(detect_label)
	detecting = false
	negation = false
	mp.set_property("speed", 1)

  -- fix audio video desynchronisation
	mp.commandv("seek", seek_position, "absolute", "exact")
end

mp.add_key_binding("ctrl+n", "skip_scene", toggle_detect)
