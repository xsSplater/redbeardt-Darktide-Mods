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

Mods.file.dofile("darkcache/scripts/mods/darkcache/utils")
Mods.file.dofile("darkcache/scripts/mods/darkcache/settings")
Mods.file.dofile("darkcache/scripts/mods/darkcache/dev")
Mods.file.dofile("darkcache/scripts/mods/darkcache/ccache_item")
Mods.file.dofile("darkcache/scripts/mods/darkcache/ccache")
Mods.file.dofile("darkcache/scripts/mods/darkcache/cache_inits")
Mods.file.dofile("darkcache/scripts/mods/darkcache/hooks")
-- Mods.file.dofile("darkcache/scripts/mods/darkcache/item_icon_caching")
Mods.file.dofile("darkcache/scripts/mods/darkcache/hub_caching")
Mods.file.dofile("darkcache/scripts/mods/darkcache/mod_events")
Mods.file.dofile("darkcache/scripts/mods/darkcache/commands")

dc.update_caches = function()
	if dc.agnostic_cache then dc.agnostic_cache:update() end

	-- Only update current character's cache.
	local cache = dc.get_current_char_cache()
	if cache then cache:update() end
	dc.refresh_happened = false
end

dc.get_current_char_cache = function()
	local char_id = dc.Utils.get_current_char_id()
	if not char_id then return end
	return dc.char_caches[char_id]
end

dc.build_agnostic_cache = function(force)
	if not force and dc.agnostic_cache then
		dc.dev.echo("Agnostic cache already exists. Build skipped.")
		return
	end

	local cache = dc.CCache.new()

	if cache then
		if dc.settings.cache["mission_board_caching"] then
			dc.init_cache_mission_board(cache)
		end

		if dc.settings.cache["premium_store_caching"] then
			dc.init_cache_premium(cache)
		end
	end

	dc.agnostic_cache = cache
end

dc.build_char_cache = function(char_id)
	if not char_id then
		char_id = dc.Utils.get_current_char_id()
	end

	if not char_id then
		dc.dev.echo("Couldn't create char cache. No character id.")
		return
	end

	-- See if a cache already exists for this char and it needs rebuilding.
	local extant = dc.char_caches[char_id]

	if extant and not extant.dirty then
		dc.dev.echo("Clean cache already exists for char " .. char_id .. ". Build skipped.")
		return
	end

	local cache = dc.CCache.new()

	if cache then
		if dc.settings.cache["armoury_caching"] then
			dc.init_cache_armoury(cache)
		end

		if dc.settings.cache["melk_caching"] then
			dc.init_cache_melk(cache)
		end

		if dc.settings.cache["contracts_caching"] then
			dc.init_cache_contracts(cache)
		end
	end

	dc.char_caches = dc.char_caches or {}
	dc.char_caches[char_id] = cache
end
