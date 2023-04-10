-- # RedTools v2

RedTools = RedTools or {}
RedTools.__index = RedTools
local s = RedTools

-- Instantiates RedTools for a given mod, which is important for contextualising
-- logging output and maybe other things later.
-- # mod_name: Name of mod that can be passed to DMF's get_mod function.
s.new = function(mod_name)
	local self = {}
	setmetatable(self, s)
	self.mod = get_mod(mod_name)
	Mods.file.dofile(mod_name .. "/scripts/mods/" .. mod_name .. "/redtools/utils")
	return self
end

local internal_echo = function(self, msg)
	self.mod:echo(msg)
	print(msg)
end

local internal_echo_table = function(self, tbl)
	local count = s.len(tbl)
	local i = 1
	local str = "{ "

	for k, v in pairs(tbl) do
		str = str .. tostring(k) .. " = " .. tostring(v)
		if i ~= count then str = str .. ", " end
		i = i + 1
	end

	str = str .. " }"
	internal_echo(self, str)
end

local internal_echo_error = function(self, msg)
	self.mod:error(msg)
	print("Error: " .. msg)
end

function s:dev_mode()
	return self.mod and self.mod:get("dev_mode")
end

function s:dev_echo(o)
	if not self:dev_mode() then return end
	local type_str = type(o)

	if type_str == "string" then
		internal_echo(self, o)
	elseif type_str == "number" then
		internal_echo(self, tostring(o))
	elseif type_str == "table" then
		internal_echo_table(self, o)
	elseif o == nil then
		internal_echo(self, "nil")
	end
end

function s:dev_notify(msg)
	if not self:dev_mode() then return end
	self.mod:notify(msg)
end

function s:dev_error(msg)
	if not self:dev_mode() then return end
	internal_echo_error(self, msg)
end
