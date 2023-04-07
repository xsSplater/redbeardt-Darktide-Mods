local dc = DarkCache

-- Make linter happy
table.clear = table.clear or function(...) end
table.enum = table.enum or function(...) return #{...} end

local LOAD_STATES = table.enum("none", "level_load", "packages_load", "done")
local cleanup_states = { was_hub = 0, was_other = 1, was_nothing = 2 }
local hub_mission_name = "hub_ship"
local loading_mission_name = ""
local last_loaded_mission_name = ""
local loading_hub = false
local loading_done = false
local loading_start_time = -1

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

	dc.dev.echo("HubCaching: Mission name == " .. loading_mission_name)

	func(self, state_machine, shared_state)
end)

dc.mod:hook("LocalLoadersState", "update", function(func, self, dt)
	local value = func(self, dt)

	if not loading_done and value == "load_done" then
		dc.dev.echo("HubCaching: LocalLoaderState load_done.")
		last_loaded_mission_name = loading_mission_name
		loading_mission_name = ""
		loading_done = true
		loading_hub = false
		local elapsed = os.time() - loading_start_time
		loading_start_time = -1
		dc.dev.echo("HubCaching: Loaded in " .. elapsed .. " seconds.")
	end

	return value
end)

local start_loading = function(loader, func, loader_instance, mission_name, ...)
	if not loading_hub then
		dc.dev.echo("HubCaching: " .. loader.name .. " loading " .. mission_name)
		return func(loader_instance, mission_name, ...)
	end

	if not loader.cached then
		dc.dev.echo("HubCaching: " .. loader.name .. " loading -> cache.")
		return func(loader_instance, mission_name, ...)
	end

	dc.dev.echo("HubCaching: " .. loader.name .. " loading from cache.")
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
		dc.dev.echo("HubCaching: " .. loader.name .. " loaded -> cache.")
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
		dc.dev.echo("HubCaching: " .. loader.name .. " cleanup hub.")
		return cleanup_states.was_hub
	end

	dc.dev.echo("HubCaching: " .. loader.name .. " cleanup " .. last_loaded_mission_name .. ".")
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
	-- local prefix = nil

	if dc.settings.cache.hub_caching then
		-- prefix = "Enabling hook"
		toggle_func = dc.mod.hook_enable
	else
		-- prefix = "Disabling hook"
		toggle_func = dc.mod.hook_disable
	end

	for _, v in ipairs(dc.hub_caching_hooks) do
		-- dc.dev.echo(prefix .. " " .. v.obj .. "." .. v.method)
		toggle_func(dc.mod, v.obj, v.method)
	end
end
