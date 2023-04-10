local dc = DarkCache
dc.CCacheItem = {}
dc.CCacheItem.__index = dc.CCacheItem
local s = dc.CCacheItem

dc.fetch_enums = {
	results = {
		NONE = "none",
		SUCCESSFUL = "success",
		FAILED = "failed"
	},
	reasons = {
		NONE = "none",
		NO_PROMISE = "no_promise",
		CONNECTION_TIMEOUT = "connection_timeout",
		FAILED_BEFORE_RESPONSE = "failed_before_response"
	}
}

s.new = function(key, _fetch_cb, _response_cb, refresh_on_expiry)
	local self = {}
	setmetatable(self, s)

	self.data = nil
	self.expired_at_time = -1
	self.expires_at_time = math.huge
	self.fetch_cb = _fetch_cb or function() end
	self.fetch_param = {}
	self.response_cb = _response_cb or function() end
	self.key = key
	self.refresh_on_expiry = refresh_on_expiry
	self.needs_refresh = true

	self.last_fetch = {
		time = -1,
		result = dc.fetch_enums.results.NONE,
		reason = dc.fetch_enums.reasons.NONE
	}

	dc.rt:dev_echo("New cache item: " .. key)
	return self
end

s.try_get_data = function(self)
	if self.fetching then
		dc.rt:dev_echo(self.key .. " already fetching.")
		return { status = "already_fetching" }
	end

	-- Since we're trying to *get* the data right now and it's expired, we have
	-- no choice but to immediately fetch.
	if self:is_expired() then
		dc.rt:dev_echo(self.key .. " expired & data needed. Triggering refresh.")
		self:refresh()
		return self.data
	end

	dc.rt:dev_echo(self.key .. " hit.")
	return self.data
end

s.is_expired = function(self)
	return dc.server_time > self.expires_at_time
end

s.expire = function(self)
	self.expired_at_time = dc.server_time
	self.expires_at_time = -1
	self.needs_refresh = self.refresh_on_expiry
end

s.fetch = function(self)
	dc.rt:dev_echo(self.key .. " fetching...")

	self.last_fetch.time = dc.server_time
	self.last_fetch.result = dc.fetch_enums.results.FAILED
	self.last_fetch.reason = dc.fetch_enums.reasons.FAILED_BEFORE_RESPONSE

	self.fetching = true
	local response = self:fetch_cb()
	self.fetching = false

	if response then
		if response.is_promise then
			self.last_fetch.result = dc.fetch_enums.results.SUCCESSFUL
			self.last_fetch.reason = dc.fetch_enums.reasons.NONE

			return response:next(function(data)
				self:response_cb(data)
				return data
			end)
		end

		self.last_fetch.result = dc.fetch_enums.results.SUCCESSFUL
		self.last_fetch.reason = dc.fetch_enums.reasons.NONE
		return response
	end

	-- Fetch failed for whatever reason. Set as expired but without auto-refresh.
	self:expire()
	self.refresh_on_expiry = false
	return nil
end

s.has_data = function(self)
	for _, _ in pairs(self.data or {}) do
		return true
	end

	return false
end

-- Fetches and stores fresh data. Should be called by CCache as part of 
-- endpoint-call staggering code.
s.refresh = function(self)
	self.needs_refresh = false
	self.data = self:fetch()

	if self.expires_at_time == -1 then
		self.expires_at_time = math.huge
	end
end

s.update = function(self)
	if not self.needs_refresh and
			self.refresh_on_expiry and
			self:is_expired() and
			self.last_fetch.result ~= dc.fetch_enums.results.FAILED then
		self.needs_refresh = true
	end
end
