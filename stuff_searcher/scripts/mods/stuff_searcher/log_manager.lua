LogManager = {
	mod = nil,
	prefix = ""
}

function LogManager:new(mod, prefix)
	self.mod = mod
	self.prefix = prefix
	return self
end

function LogManager:echo(text)
	self.mod:echo(self.prefix .. text)
end

function LogManager:error(text)
	self.mod:error(self.prefix .. text)
end

function LogManager:warning(text)
	self.mod:warning(self.prefix .. text)
end

function LogManager:debug(text)
	self.mod:debug(self.prefix .. text)
end
