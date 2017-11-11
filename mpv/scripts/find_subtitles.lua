require 'os'
require 'io'
require 'string'
mputils = require 'mp.utils'

lang1 = 'en'
lang2 = 'de'

-- "find_subtitles" tries to do two simple things:
-- 1. use python's subliminal for downloading subtitles
-- 2. load any subtitles found within movie folder
-- (this script binds letter "s")

-- helper function for capturing cli response
-- Reference: http://stackoverflow.com/questions/132397
function os.capture(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
return string.sub(s, 0, -2)
end

-- helper function for getting file (adress) info
-- (works regardless cwd path)
function fileadressinfo()
	local fpath = mp.get_property("path"," ")
	local dir = mputils.split_path(fpath)
	if dir == "." then
		dir = mp.get_property("working-directory")
	end
	return fpath,dir
end

function find_subtitles_alt()	
	find_subtitles(lang2)
end

function find_subtitles_def()	
	find_subtitles(lang1)
end

function find_subtitles(lang)	
	local fp,dr =  fileadressinfo()

	-- use subliminal to fetch english subtitles from all providers (change en to your preference if needed)
	mp.osd_message("Searching for subtitles (" .. lang .. ")..")
	local ss = os.capture("subliminal download --provider opensubtitles --provider podnapisi --provider thesubdb --provider tvsubtitles -l " .. lang .. " -v '" .. fp .. "'")
	-- you can also use this if you join addict7d (replace user and pass with yours; use no quotes just the strings)
	-- local ss = os.capture("subliminal --addic7ed user pass download --provider addic7ed --provider opensubtitles --provider podnapisi --provider thesubdb --provider tvsubtitles -l en -v '" .. fp .. "'")

	-- strip unnecessary info (as of subliminal version 1.0.1 the string matchings below are working ... dont know for how long though
	ss = string.gsub(ss,"(Collecting videos)",'')
	ss = string.gsub(ss,"(Downloading subtitles)",'')
	ss = string.gsub(ss,"(1 video collected / 0 video ignored / 0 error)",'.')
	ss = string.gsub(ss,"\n",'')	
	if string.match(ss,"0 video collected / 1 video ignored / 0 error") then
		ss = "Subtitle already in path.. "
	end	
	
	-- Possible messages to display: 
	-- "1 subtitle downloaded for <FILENAME>", if subliminal returned without errors 
	-- "Subtitle already in path..", if there are already subtitles in the folder
        --  <captured errors>, if something has gone wrong
	mp.osd_message(string.format(" %s",ss),4)	
	
	-- no matter what happened, try to load *.srt files (if any)    	
    	for filename in io.popen('ls -a "'..dr..'"'):lines() do    		
		if string.match(filename,"%.srt$") then


			--load file to mpv			
			mp.command("sub-add \"" .. mputils.join_path(dr, filename) .. "\" select subliminal " .. lang)
		end		
    	end
end

mp.add_key_binding("U", "subtitles", find_subtitles_def)
mp.add_key_binding("ctrl+u", "subtitlesalt", find_subtitles_alt)
mp.add_key_binding("ctrl+U", "subtitlesalt2", find_subtitles_alt)
