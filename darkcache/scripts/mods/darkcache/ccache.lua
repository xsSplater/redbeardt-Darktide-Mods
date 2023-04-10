local dc = DarkCache
dc.CCache = {}
dc.CCache.__index = dc.CCache
local s = dc.CCache

s.new = function()
	local self = {}
	setmetatable(self, s)
	self.items = {}
	return self
end

s.add = function(self, item)
	self.items[#self.items + 1] = item
end

s.update = function(self)
	for i = 1, #self.items do
		self.items[i]:update()
	end

	-- Used to ensure that several caches don't do refreshes simultaneously.
	if dc.refresh_happened then
		return
	end

	for i = 1, #self.items do
		if self.items[i].needs_refresh then
			dc.refresh_happened = true
			self.items[i]:refresh()
			break -- Do one fetch per update at most.
		end
	end
end

s.get = function(self, key)
	for _, v in pairs(self.items) do
		if v.key == key then
			return v
		end
	end

	return nil
end

s.clear = function(self)
	self.items = {}
end

s.has = function(self, key)
	for i = 1, #self.items do
		if self.items[i].key == key then
			return true
		end
	end

	return false
end

s.is_empty = function(self)
	return not self.items or #self.items == 0
end

s.remove = function(self, key)
	for i, v in ipairs(self.items) do
		if v.key == key then
			table.remove(self.items, i)
			return
		end
	end
end
