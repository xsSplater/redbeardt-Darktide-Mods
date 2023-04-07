DarkCache.dev = {}
local ns = DarkCache.dev -- Namespace
local mod = get_mod("darkcache")

ns.echo = function(o)
	if mod:get("dev_mode") then
		if type(o) == "string" then
			mod:echo(o)
			print(o)
		elseif type(o) == "number" then
			mod:echo(tostring(o))
			print(tostring(o))
		elseif type(o) == "table" then
			ns.echo_table(o)
		elseif o == nil then
			mod:echo("nil")
			print("nil")
		end
	end
end

ns.notify = function(msg)
	if mod:get("dev_mode") then
		mod:notify(msg)
	end
end

ns.error = function(msg)
	if mod:get("dev_mode") then
		mod:error("Error: " .. msg)
		print("Error: " .. msg)
	end
end

ns.warning = function(msg)
	mod:echo("Warning: " .. msg)
	print("Warning: " .. msg)
end

ns.len = function(tbl)
	local count = 0

	for _, _ in pairs(tbl) do
		count = count + 1
	end

	return count
end

ns.echo_table = function(tbl)
	local count = ns.len(tbl)
	local i = 1
	local str = "{ "

	for k, v in pairs(tbl) do
		str = str .. tostring(k) .. " = " .. tostring(v)
		if i ~= count then str = str .. ", " end
		i = i + 1
	end

	str = str .. " }"
	ns.echo(str)
	print(str)
end
