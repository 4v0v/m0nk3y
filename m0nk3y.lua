table.insert(package.loaders, 2, function(name)
	local name = name:gsub("%.", "/") .. ".lua"
    local file = love.filesystem.read(name)
    if not file then return nil end

    local var = "([%w%.:_%[%]'\"]+)"
	for i, v in ipairs({
		{ pattern = var .. "%s*%+=" , replacement = "%1 = %1 + "},
            	{ pattern = var .. "%s*%-=" , replacement = "%1 = %1 - "},
            	{ pattern = var .. "%s*%*=" , replacement = "%1 = %1 * "},
            	{ pattern = var .. "%s*/="  , replacement = "%1 = %1 / "},
            	{ pattern = var .. "%s*^="  , replacement = "%1 = %1 ^ "},
            	{ pattern = var .. "%s*%%=" , replacement = "%1 = %1 %% "},
            	{ pattern = var .. "%s*%..=", replacement = "%1 = %1 .. "},
            	{ pattern = var .. "%+%+"   , replacement = "%1 = %1 + 1"},
            	{ pattern = "&&"            , replacement = " and "},
	 	{ pattern = "||"            , replacement = " or "},
		{ pattern = "!="            , replacement = "~="},
		{ pattern = "!"             , replacement = " not "},
		{ pattern = "([%s,={%(])fn%(" , replacement = "%1function("},
    		{ pattern = "for%spairs%("  , replacement = "for key, value in pairs("},
    		{ pattern = "for%sipairs%(" , replacement = "for index, value in ipairs("},
        }) do 
		file = file:gsub(v.pattern, v.replacement) 
	end
	return assert(loadstring(file, name))
end)
