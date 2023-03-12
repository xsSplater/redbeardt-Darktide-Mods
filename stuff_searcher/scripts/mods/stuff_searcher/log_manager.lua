LogManager = {
	mod = nil
}

function LogManager:new(mod)
	self.mod = mod
	return self
end

function LogManager:echo(text)
	self.mod:echo(text or "nil")
end

function LogManager:error(text)
	self.mod:error(text or "nil")
end

function LogManager:warning(text)
	self.mod:warning(text or "nil")
end

function LogManager:debug(text)
	if not self.mod:get("debug_mode") then return end
	self.mod:echo(text or "nil")
end
