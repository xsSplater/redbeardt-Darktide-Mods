local dc = DarkCache

dc.mod.update = function(dt)
	dc.update_delta = dc.update_delta + dt

	if dc.update_delta < dc.update_interval or RedTools.Utils.player_in_mission() then
		return
	end

	dc.main_time = Managers.time:time("main")
	dc.server_time = Managers.backend:get_server_time(dc.main_time)
	dc.update_delta = 0
	dc.update_caches()
end

dc.mod.on_game_state_changed = function(status, state_name)
	-- When entering mission, expire contracts list. When entering hub, refresh
	-- contracts list data.
	if status == "enter" and state_name == "GameplayStateRun" then

		local cache = dc.get_current_char_cache()
		if not cache then return end
		local contracts_item = cache:get("contracts_list")

		if contracts_item then
			if RedTools.Utils.player_in_mission() then
				contracts_item:expire()
			elseif RedTools.Utils.player_in_hub() then
				contracts_item:try_get_data()
			end
		end
	end
end

dc.mod.on_setting_changed = function(setting_id)
	dc.settings_manager.cache[setting_id] = dc.mod:get(setting_id)

	if setting_id == "dev_mode" then
		dc.settings_manager.update_chat_command_availability()
	elseif setting_id == "armoury_caching" or
			setting_id == "melk_caching" or
			setting_id == "contracts_caching" then
		-- Flag all char caches as dirty so that this setting change can cause
		-- a rebuild of other (non-current) char's caches if any of those chars
		-- become current again.
		for _, cache in pairs(dc.char_caches) do
			cache.dirty = true
		end

		dc.build_char_cache()
	elseif setting_id == "mission_board_caching" or
			setting_id == "premium_store_caching" then
		dc.build_agnostic_cache(true)
	elseif setting_id == "hub_caching" then
		dc.update_hub_caching_hooks()
	end

	dc.settings_manager.announce(setting_id)
end

dc.mod.on_enabled = function(initial_call)
	if initial_call then
		dc.preload_hub()
	end
end
