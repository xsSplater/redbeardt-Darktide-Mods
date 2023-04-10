local dc = DarkCache

local expiry_from_rot_end = function(cache_item, data)
	if not (data and data.current_rotation_end) then return end
	cache_item.expires_at_time = tonumber(data.current_rotation_end)
end

dc.init_cache_armoury = function(cache)
	local store = RedTools.Utils.nil_check(Managers, "data_service", "store")

	if not store then
		return dc.rt:dev_error("Managers.data_service.store missing.")
	end

	if store.get_credits_store then
		cache:add(dc.CCacheItem.new("credits_store",
			function()
				return store:get_credits_store()
			end,
			expiry_from_rot_end, true))
	end

	if store.get_credits_cosmetics_store then
		cache:add(dc.CCacheItem.new("credits_cosmetics_store",
			function()
				return store:get_credits_cosmetics_store()
			end,
			nil, true))
	end

	if store.get_credits_weapon_cosmetics_store then
		cache:add(dc.CCacheItem.new("credits_weapon_cosmetics_store",
			function()
				return store:get_credits_weapon_cosmetics_store()
			end,
			nil, true))
	end
end

dc.init_cache_melk = function(cache)
	local store = RedTools.Utils.nil_check(Managers, "data_service", "store")

	if not store then
		return dc.rt:dev_error("Managers.data_service.store missing.")
	end

	if store.get_marks_store_temporary then
		cache:add(dc.CCacheItem.new("marks_store_temporary",
			function()
				return store:get_marks_store_temporary()
			end,
			expiry_from_rot_end, true))
	end

	if store.get_marks_store then
		cache:add(dc.CCacheItem.new("marks_store",
			function()
				return store:get_marks_store()
			end,
			expiry_from_rot_end, true))
	end
end

dc.init_cache_contracts = function(cache)
	local contracts = RedTools.Utils.nil_check(Managers, "backend", "interfaces", "contracts")

	if not contracts then
		return dc.rt:dev_error("Managers.backend.interfaces.contracts missing.")
	end

	if contracts.get_current_contract then
		cache:add(dc.CCacheItem.new("contracts_list",
			function()
				return contracts:get_current_contract(dc.get_current_char_id())
			end, nil, false))
	end
end

dc.init_cache_mission_board = function(cache)
	local mission_board = RedTools.Utils.nil_check(Managers, "data_service", "mission_board")

	if not mission_board then
		return dc.rt:dev_error("Managers.data_service.mission_board missing.")
	end

	cache:add(dc.CCacheItem.new("mission_board",
		function()
			return mission_board:fetch(nil, 1)
		end,
		function(cache_item, data)
			if data and data.expiry_game_time then
				cache_item.expires_at_time = Managers.backend:get_server_time(
					data.expiry_game_time)
				return
			end

			cache_item.expires_at_time = math.huge
		end, true))
end

dc.init_cache_premium = function(cache)
	local store = RedTools.Utils.nil_check(Managers, "data_service", "store")

	if not store then
		return dc.rt:dev_error("Managers.data_service.store missing.")
	end

	cache:add(dc.CCacheItem.new("premium_store_account_update",
		function()
			return dc.premium_store_fetch_wrap()
		end), nil, false)

	cache:add(dc.CCacheItem.new("premium_store_featured",
		function()
			return store:get_premium_store("premium_store_featured")
		end), nil, false)

	cache:add(dc.CCacheItem.new("premium_store_skins_veteran",
		function()
			return store:get_premium_store("premium_store_skins_veteran")
		end), nil, false)

	cache:add(dc.CCacheItem.new("premium_store_skins_zealot",
		function()
			return store:get_premium_store("premium_store_skins_zealot")
		end), nil, false)

	cache:add(dc.CCacheItem.new("premium_store_skins_psyker",
		function()
			return store:get_premium_store("premium_store_skins_psyker")
		end), nil, false)

	cache:add(dc.CCacheItem.new("premium_store_skins_ogryn",
		function()
			return store:get_premium_store("premium_store_skins_ogryn")
		end), nil, false)

	cache:add(dc.CCacheItem.new("hard_currency_store",
		function()
			return store:get_premium_store("hard_currency_store")
		end), nil, false)
end
