local dc = DarkCache
dc.CCache = {}
dc.CCache.__index = dc.CCache

dc.CCache.new = function()
	local self = {}
	setmetatable(self, dc.CCache)
	self.items = {}
	return self
end

dc.CCache.add = function(self, item)
	self.items[#self.items + 1] = item
end

dc.CCache.update = function(self)
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

dc.CCache.get = function(self, key)
	for _, v in pairs(self.items) do
		if v.key == key then
			return v
		end
	end

	return nil
end

dc.CCache.clear = function(self)
	self.items = {}
end

dc.CCache.has = function(self, key)
	for i = 1, #self.items do
		if self.items[i].key == key then
			return true
		end
	end

	return false
end

dc.CCache.is_empty = function(self)
	return not self.items or #self.items == 0
end

dc.CCache.remove = function(self, key)
	for i, v in ipairs(self.items) do
		if v.key == key then
			table.remove(self.items, i)
			return
		end
	end
end
