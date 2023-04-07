local dc = DarkCache

dc.settings = {}
dc.settings.cache = {}
dc.settings.cache_key_groups = {
	armoury_caching = { "credits_store" },
	melk_caching = { "marks_store", "marks_store_temporary" },
	contracts_caching = { "contracts_list" },
	mission_board_caching = { "mission_board" },
	premium_store_caching = {
		"premium_store_account_update",
		"premium_store_featured",
		"premium_store_skins_veteran",
		"premium_store_skins_zealot",
		"premium_store_skins_psyker",
		"premium_store_skins_ogryn",
		"hard_currency_store"
	}
}

dc.settings.build_cache = function()
	local cache = dc.settings.cache
	cache.armoury_caching = dc.mod:get("armoury_caching")
	cache.melk_caching = dc.mod:get("melk_caching")
	cache.contracts_caching = dc.mod:get("contracts_caching")
	cache.mission_board_caching = dc.mod:get("mission_board_caching")
	cache.premium_store_caching = dc.mod:get("premium_store_caching")
	cache.hub_caching = dc.mod:get("hub_caching")
end

dc.settings.announce = function(setting_id)
	local loc_name = dc.mod:localize(setting_id)
	local value = dc.settings.cache[setting_id]

	if not loc_name or value == nil then
		return
	end

	local str = loc_name .. " " ..
		(value and
			dc.mod:localize("enabled") or
			dc.mod:localize("disabled")
		) .. "."

	str = str .. " " .. (dc.settings.get_explanation_text(setting_id, value))
	dc.mod:echo(str)
end

dc.settings.get_explanation_text = function(setting_id, value)
	local text = nil

	if setting_id == "premium_store_caching" then
		text = value and dc.mod:localize("loc_premium_store_caching_enabled")
	elseif setting_id == "hub_caching" then
		text = value and dc.mod:localize("loc_hub_caching_enabled") or
			dc.mod:localize("loc_hub_caching_disabled")
	end

	return text or ""
end

dc.settings.is_cache_key_enabled = function(key)
	for setting_name, group in pairs(dc.key_setting_map) do
		for _, cache_key in ipairs(group) do
			if cache_key == key then
				return dc.settings.cache[setting_name]
			end
		end
	end

	return false
end

dc.settings.update_chat_command_availability = function()
	(dc.settings.cache.dev_mode and
		dc.mod.enable_all_commands or
		dc.mod.disable_all_commands)(dc.mod)
end
