DarkCache = DarkCache or {}
local dc = DarkCache
dc.mod = get_mod("darkcache")

-- linter shut up please
Promise = Promise or {}
Mods = Mods or {}
Managers = Managers or {}

dc.update_interval = 1 -- seconds
dc.update_delta = 0
dc.storeview_account_items = {}
dc.main_time = 0
dc.server_time = 0
dc.agnostic_cache = nil
dc.char_caches = {}
dc.mod_path = "darkcache/scripts/mods/darkcache/"
dc.ext_mod_path = "./../mods/darkcache/scripts/mods/darkcache/"

Mods.file.dofile(dc.mod_path .. "redtools/main")
dc.rt = RedTools.new("darkcache")

Mods.file.dofile(dc.mod_path .. "settings_manager")
Mods.file.dofile(dc.mod_path .. "ccache_item")
Mods.file.dofile(dc.mod_path .. "ccache")
Mods.file.dofile(dc.mod_path .. "cache_inits")
Mods.file.dofile(dc.mod_path .. "hooks")
-- Mods.file.dofile(mod_path .. "item_icon_caching") -- Problematic
Mods.file.dofile(dc.mod_path .. "hub_caching")
Mods.file.dofile(dc.mod_path .. "mod_events")
Mods.file.dofile(dc.mod_path .. "commands")

dc.update_caches = function()
	if dc.agnostic_cache then dc.agnostic_cache:update() end

	-- Only update current character's cache.
	local cache = dc.get_current_char_cache()
	if cache then cache:update() end
	dc.refresh_happened = false
end

dc.get_current_char_id = function()
	return dc.current_char_id
end

dc.get_current_char_cache = function()
	local char_id = dc.get_current_char_id()
	if not char_id then return nil end
	return dc.char_caches[char_id]
end

dc.build_agnostic_cache = function(force)
	if not force and dc.agnostic_cache then
		dc.rt:dev_echo("Agnostic cache already exists. Build skipped.")
		return
	end

	local cache = dc.CCache.new()

	if cache then
		if dc.settings_manager.cache["mission_board_caching"] then
			dc.init_cache_mission_board(cache)
		end

		if dc.settings_manager.cache["premium_store_caching"] then
			dc.init_cache_premium(cache)
		end
	end

	dc.agnostic_cache = cache
end

dc.build_char_cache = function(char_id)
	if not char_id then
		char_id = dc.get_current_char_id()
	end

	if not char_id then
		dc.rt:dev_echo("Couldn't create char cache. No character id.")
		return
	end

	-- See if a cache already exists for this char and it needs rebuilding.
	local extant = dc.char_caches[char_id]

	if extant and not extant.dirty then
		dc.rt:dev_echo("Clean cache already exists for char " .. char_id .. ". Build skipped.")
		return
	end

	local cache = dc.CCache.new()

	if cache then
		if dc.settings_manager.cache["armoury_caching"] then
			dc.init_cache_armoury(cache)
		end

		if dc.settings_manager.cache["melk_caching"] then
			dc.init_cache_melk(cache)
		end

		if dc.settings_manager.cache["contracts_caching"] then
			dc.init_cache_contracts(cache)
		end
	end

	dc.char_caches = dc.char_caches or {}
	dc.char_caches[char_id] = cache
end
