local dc = DarkCache

-- local ViewLoader = require("scripts/loading/loaders/view_loader")
-- local LevelLoader = require("scripts/loading/loaders/level_loader")
-- local BreedLoader = require("scripts/loading/loaders/breed_loader")
-- local Views = require("scripts/ui/views/views")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local ThemePackage = require("scripts/foundation/managers/package/utilities/theme_package")
local BreedResourceDependencies = require("scripts/utilities/breed_resource_dependencies")
local Breeds = require("scripts/settings/breed/breeds")
local MasterItems = require("scripts/backend/master_items")

-- Make linter happy
table.clear = table.clear or function(...) end
table.enum = table.enum or function(...) return #{...} end

local hub_names = {
	mission = "hub_ship",
	editor = "content/levels/hub/hub_ship/missions/hub_ship",
	circumstance = "default",
	level = "content/levels/hub/hub_ship/missions/hub_ship"
}

local LOAD_STATES = table.enum("none", "level_load", "packages_load", "done")
local cleanup_states = { was_hub = 0, was_other = 1, was_nothing = 2 }
local hub_mission_name = "hub_ship"
local loading_mission_name = ""
local last_loaded_mission_name = ""
local loading_hub = false
local loading_done = false
local loading_start_time = -1
local items_preloaded = 0
local total_preload_items = 0

local new_loader_metadata = function(name)
	local self = {}

	self.name = name
	self.cached = false

	return self
end

local loader_data = {
	view = new_loader_metadata("ViewLoader"),
	level = new_loader_metadata("LevelLoader"),
	breed = new_loader_metadata("BreedLoader")
}

dc.hub_caching_hooks = {
	{ obj = "LocalLoadersState", method = "init" },
	{ obj = "LocalLoadersState", method = "update" },
	{ obj = "ViewLoader", method = "start_loading" },
	{ obj = "ViewLoader", method = "is_loading_done" },
	{ obj = "ViewLoader", method = "cleanup" },
	{ obj = "BreedLoader", method = "start_loading" },
	{ obj = "BreedLoader", method = "is_loading_done" },
	{ obj = "BreedLoader", method = "cleanup" },
	{ obj = "LevelLoader", method = "start_loading" },
	{ obj = "LevelLoader", method = "is_loading_done" },
	{ obj = "LevelLoader", method = "cleanup" },
}

dc.mod:hook("LocalLoadersState", "init", function(func, self, state_machine, shared_state)
	loading_mission_name = shared_state.mission_name
	loading_hub = loading_mission_name == hub_mission_name
	loading_done = false
	loading_start_time = os.time()
	func(self, state_machine, shared_state)
end)

dc.mod:hook("LocalLoadersState", "update", function(func, self, dt)
	local value = func(self, dt)

	if not loading_done and value == "load_done" then
		dc.rt:dev_echo("HubCaching: LocalLoaderState load_done.")

		if loading_hub then
			dc.generate_level_resource_names_file()
			dc.generate_breed_resource_names_file()
		end

		last_loaded_mission_name = loading_mission_name
		loading_mission_name = ""
		loading_done = true
		loading_hub = false
		local elapsed = os.time() - loading_start_time
		loading_start_time = -1
		dc.rt:dev_echo("HubCaching: Loaded in " .. elapsed .. " seconds.")
	end

	return value
end)

local start_loading = function(loader, func, loader_instance, mission_name, ...)
	if not loading_hub then
		dc.rt:dev_echo("HubCaching: " .. loader.name .. " loading " .. mission_name)
		return func(loader_instance, mission_name, ...)
	end

	if not loader.cached then
		dc.rt:dev_echo("HubCaching: " .. loader.name .. " loading -> cache.")
		return func(loader_instance, mission_name, ...)
	end

	dc.rt:dev_echo("HubCaching: " .. loader.name .. " loading from cache.")
end

dc.mod:hook("ViewLoader", "start_loading", function(...)
	start_loading(loader_data.view, ...)
end)

dc.mod:hook("LevelLoader", "start_loading", function(...)
	start_loading(loader_data.level, ...)
end)

dc.mod:hook("BreedLoader", "start_loading", function(...)
	start_loading(loader_data.breed, ...)
end)

local is_loading_done = function(loader, func, ...)
	if loading_hub and loader.cached then
		return true
	end

	local done = func(...)

	if loading_hub and done then
		loader.cached = true
		dc.rt:dev_echo("HubCaching: " .. loader.name .. " loaded -> cache.")
		return true
	end

	return done
end

dc.mod:hook("ViewLoader", "is_loading_done", function(func, ...)
	return is_loading_done(loader_data.view, func, ...)
end)

dc.mod:hook("LevelLoader", "is_loading_done", function(func, ...)
	return is_loading_done(loader_data.level, func, ...)
end)

dc.mod:hook("BreedLoader", "is_loading_done", function(func, ...)
	return is_loading_done(loader_data.breed, func, ...)
end)

local cleanup_hub_check = function(loader)
	if #last_loaded_mission_name == 0 then
		return cleanup_states.was_nothing
	end

	if last_loaded_mission_name == hub_mission_name then
		dc.rt:dev_echo("HubCaching: " .. loader.name .. " cleanup hub.")
		return cleanup_states.was_hub
	end

	dc.rt:dev_echo("HubCaching: " .. loader.name .. " cleanup " .. last_loaded_mission_name .. ".")
	return cleanup_states.was_other
end

dc.mod:hook("ViewLoader", "cleanup", function(func, self)
	local state = cleanup_hub_check(loader_data.view)

	if state == cleanup_states.was_nothing or state == cleanup_states.was_other then
		return func(self)
	end

	for view_name, _ in pairs(self._loading_views or {}) do
		self._loading_views[view_name] = nil
	end

	self._loading_views = nil
	self._load_done = false
end)

dc.mod:hook("LevelLoader", "cleanup", function(func, self)
	local state = cleanup_hub_check(loader_data.level)

	if state == cleanup_states.was_nothing or state == cleanup_states.was_other then
		return func(self)
	end

	Managers.world_level_despawn:flush()
	table.clear(self._package_ids or {})
	table.clear(self._packages_to_load or {})

	if self._level_package_id then
		self._level_loaded = false
		self._level_package_id = nil
		self._level_name = nil
	end

	self._theme_tag = nil
	self._load_state = LOAD_STATES.none
end)

dc.mod:hook("BreedLoader", "cleanup", function(func, self)
	local state = cleanup_hub_check(loader_data.breed)

	if state == cleanup_states.was_nothing or state == cleanup_states.was_other then
		return func(self)
	end

	for id, _ in pairs(self._package_ids or {}) do
		self._package_ids[id] = nil
	end

	self._load_state = LOAD_STATES.none
	table.clear(self._packages_to_load or {})
end)

dc.update_hub_caching_hooks = function()
	local toggle_func = nil

	if dc.settings_manager.cache.hub_caching then
		toggle_func = dc.mod.hook_enable
	else
		toggle_func = dc.mod.hook_disable
	end

	for _, v in ipairs(dc.hub_caching_hooks) do
		toggle_func(dc.mod, v.obj, v.method)
	end
end

dc.cb_item_preloaded = function()
	items_preloaded = items_preloaded + 1

	if items_preloaded == total_preload_items then
		dc.rt:dev_echo("Hub preloaded.")
		loader_data.breed.cached = true
		loader_data.level.cached = true
		-- loader_data.view.cached = true
	end
end

dc.generate_level_resource_names_file = function()
	dc.rt:dev_echo("Generating Level resource names file...")

	local item_packages = ItemPackage.level_resource_dependency_packages(MasterItems.get_cached(), hub_names.level)
	local theme_packages = ThemePackage.level_resource_dependency_packages(hub_names.level, "default")
	local f = Mods.lua.io.open(dc.ext_mod_path .. "hub_level_resource_names", "w")
	local str = ""

	for k, _ in pairs(item_packages) do
		str = str .. k .. "\n"
	end

	for _, v in pairs(theme_packages) do
		str = str .. v .. "\n"
	end

	f:write(str)
	f:close()
end

dc.generate_breed_resource_names_file = function()
	dc.rt:dev_echo("Generating Breed resource names file...")

	local breeds = BreedResourceDependencies.generate(Breeds, MasterItems.get_cached())
	local f = Mods.lua.io.open(dc.ext_mod_path .. "hub_breed_resource_names", "w")
	local str = ""

	for k, _ in pairs(breeds) do
		-- Don't know why this appears in the list if it makes the loading fail,
		-- but I guess I've just gotta exclude it for now..
		if k ~= "content/fx/particles/liquid_area/beast_of_nurgle_slime" and
				not tonumber(k) then
			str = str .. k .. "\n"
		end
	end

	f:write(str)
	f:close()
end

dc.preload_hub = function()
	local dir_path = "./../mods/darkcache/scripts/mods/darkcache/"
	local level_resnames_path = dir_path .. "hub_level_resource_names"
	local breed_resnames_path = dir_path .. "hub_breed_resource_names"
	local f = Mods.lua.io.open(level_resnames_path, "r")

	if not f then
		dc.rt:dev_echo("HubCaching: No level resource names file. Preloading will not occur.")
		return
	end

	local level_ref_name = "LevelLoader (hub_ship)"
	local pkg_mgr = Managers.package

	dc.rt:dev_echo("Preloading hub...")

	pkg_mgr:load(hub_names.level, level_ref_name, dc.cb_item_preloaded)
	local line = f:read()

	while(line) do
		total_preload_items = total_preload_items + 1
		pkg_mgr:load(line, level_ref_name, dc.cb_item_preloaded)
		line = f:read()
	end

	f:close()
	f = Mods.lua.io.open(breed_resnames_path, "r")

	if not f then
		dc.rt:dev_echo("HubCaching: No breed resource names file. Preloading will not occur.")
		return
	end

	line = f:read()

	while(line) do
		total_preload_items = total_preload_items + 1
		pkg_mgr:load(line, "BreedLoader", dc.cb_item_preloaded)
		line = f:read()
	end

	f:close()
	-- local ui_mgr = Managers.ui
	--
	-- for name, settings in pairs(Views) do
	-- 	if settings.load_always or settings.load_in_hub then
	-- 		total_preload_items = total_preload_items + 1
	-- 		ui_mgr:load_view(name, "ViewLoader", dc.cb_item_preloaded)
	-- 	end
	-- end
end
