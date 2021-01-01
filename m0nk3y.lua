local function parse(s)
	local str = s
	local integer    = "([%d]+)"
	local simple_var = "([%w_]+)"
	local var        = "([%w%.:_'\"%[%]]+)"
	local expression = "([%w%.:_'\"%[%]%(%)]+)"
	local wl         = "[%s]+"
	local _wl        = "[%s]-"

	local patterns = {
		{ patt = "%-%-[^\n]+"         , repl = ""},
		{ patt = "@"                  , repl = "self"},
		{ patt = var .. _wl .. "%+="  , repl = "%1 = %1 + "},
		{ patt = var .. _wl .. "%-="  , repl = "%1 = %1 - "},
		{ patt = var .. _wl .. "%*="  , repl = "%1 = %1 * "},
		{ patt = var .. _wl .. "/="   , repl = "%1 = %1 / "},
		{ patt = var .. _wl .. "^="   , repl = "%1 = %1 ^ "},
		{ patt = var .. _wl .. "%%="  , repl = "%1 = %1 %% "},
		{ patt = var .. _wl .. "%.%.=", repl = "%1 = %1 .. "},
		{ patt = var .. _wl .. "%+%+" , repl = "%1 = %1 + 1"},
		{ patt = "&&"                 , repl = " and "},
		{ patt = "||"                 , repl = " or "},
		{ patt = "!="                 , repl = " ~= "},
		{ patt = "!"                  , repl = " not "},
		{ patt = "fn%("               , repl = "function("},
		{ patt = "for" .. wl .. integer .. wl .. "do", repl = "for it = 1, %1 do"},
		{ patt = "for" .. wl .. expression .. wl .. "do", repl = "for key, it in pairs(%1) do"},
		{ patt = "for" .. wl .. simple_var .. wl .. "in" .. wl .. var .. wl .. "do", repl = "for key, %1 in pairs(%2) do"},
		{ patt = "for" .. wl .. simple_var .. "," .. _wl .. simple_var .. wl .. "in" .. wl .. var .. wl .. "do", repl = "for %1, %2 in pairs(%3) do"},
	}

	for i, v in ipairs(patterns) do str = str:gsub(v.patt, v.repl) end
	return str
end

table.insert(package.loaders, 2, function(name)
	local name        = name:gsub("%.", "/") .. ".lua"
	local file        = love.filesystem.read(name)
	local parsed_file = parse(file)

	return assert(loadstring(parsed_file))
end)
