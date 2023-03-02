local mod = get_mod("player_outlines")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local UPDATE_WAITING_PERIOD = 0.5
local known_units = {}

local SWITCH_STATES = {
	consumed = true
}

local IGNORED_DISABLED_OUTLINE_STATES = {
	grabbed = false,
	catapulted = false,
	consumed = false
}

local instances = {
	wmt_player_assistance = nil,
	wmt_nameplate_combat = nil
}

local spawn_hologram = function(world, resources, parent_unit, state_name)
	if not world then
		return nil
	end

	local resource = SWITCH_STATES[state_name] and resources[state_name] or resources.default
	local hologram_unit = World.spawn_unit_ex(world, resource)

	World.link_unit(world, hologram_unit, 1, parent_unit, 1, true)
	Unit.set_unit_culling(hologram_unit, false, true)

	local player_visibility_system = ScriptUnit.has_extension(parent_unit, "player_visibility_system")

	if player_visibility_system and not player_visibility_system:visible() then
		Unit.set_unit_visibility(hologram_unit, false, true)
	end

	return hologram_unit
end

local despawn_hologram = function(world, hologram_unit)
	World.unlink_unit(world, hologram_unit, true)
	World.destroy_unit(world, hologram_unit)
end

mod:hook(CLASS.GameModeManager, "disable_hologram", function(func, self)
	return false
end)

-- Mostly copied from player_unit_hologram_extension.lua
mod:hook(CLASS.PlayerUnitHologramExtension, "update", function(func, self, unit, dt, t)
	self._timer = self._timer + dt

	if self._timer < UPDATE_WAITING_PERIOD then
		return
	end

	self._timer = 0
	local state_name = self._character_state_component.state_name
	local hologram_unit = self._hologram_unit
	local should_switch_unit = SWITCH_STATES[state_name] and self._current_spawned_state ~= state_name or SWITCH_STATES[self._current_spawned_state] and not SWITCH_STATES[state_name]

	if state_name == "dead" or not mod:get("show_hologram") or
		(Managers.state.game_mode:game_mode_name() == "hub"
			and not mod:get("show_in_hub")) then
		if hologram_unit then
			despawn_hologram(self._world, hologram_unit)
			self._hologram_unit = nil
		end

		return
	else
		if not hologram_unit or should_switch_unit then
			if hologram_unit then
				despawn_hologram(self._world, hologram_unit)
			end

			hologram_unit = spawn_hologram(self._world, self._unit_resources, self._unit, state_name)
			self._hologram_unit = hologram_unit
			self._current_spawned_state = state_name
		end

		local health_percent = self._target_health_extension:current_health_percent()
		local is_disabled = PlayerUnitStatus.is_disabled(self._character_state_component) and not IGNORED_DISABLED_OUTLINE_STATES[state_name]

		if health_percent == self._health and is_disabled == self._was_disabled then
			return
		end

		local shader_input = 1

		if not is_disabled then
			shader_input = 1 - health_percent
		end

		Unit.set_scalar_for_materials(hologram_unit, "health_value", shader_input, false)

		self._health = health_percent
		self._was_disabled = is_disabled
	end
end)

local get_outline_name = function()
	local show_outline = mod:get("show_outline")

	if mod:get("show_mesh") then
		if show_outline then
			return "default_both_always"
		else
			return "default_mesh_always"
		end
	elseif show_outline then
		return "default_outlines_always"
	end
end

local clear_outlines = function(self, unit)
	if not self or not self._outline_system then return end
	self._outline_system:remove_outline(unit, "default_both_always")
	self._outline_system:remove_outline(unit, "default_mesh_always")
	self._outline_system:remove_outline(unit, "default_outlines_always")
end

local set_outline = function(func, self, unit, dt, t)
	if Managers.state.game_mode:game_mode_name() == "hub" and not mod:get("show_in_hub") then
		clear_outlines(self, unit)
		if func then return func(self, unit, dt, t) else return end
	end

	local added_outline = self._added_disabled_outline
	local character_state_component = self._character_state_component
	local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

	if is_disabled and not added_outline and not IGNORED_DISABLED_OUTLINE_STATES[character_state_component.state_name] then
		self._outline_system:add_outline(unit, "knocked_down")
		self._added_disabled_outline = true
	elseif added_outline and not is_disabled then
		self._outline_system:remove_outline(unit, "knocked_down")
		self._added_disabled_outline = false
	end

	self._timer = self._timer + dt
	if self._timer < UPDATE_WAITING_PERIOD then return end
	self._timer = 0

	if not self._is_local_unit then
		local outline_name = get_outline_name()
		if outline_name then
			table.insert(known_units, {
				func = func,
				self = self,
				unit = unit,
				dt = dt,
				t = t
			})

			self._outline_system:add_outline(unit, outline_name)
		end
	end
end

local reset_outlines = function()
	for i, value in ipairs(known_units) do
		if not value then table.remove(known_units, i) end
		clear_outlines(value.self, value.unit)
		if mod:get("show_mesh") or mod:get("show_outline") then
			set_outline(value.func, value.self, value.unit, value.dt, value.t)
		end
	end
end

mod.on_setting_changed = function(setting_id)
	-- Instantly update visuals when a setting is changed.
	if setting_id == "show_hologram"
			or setting_id == "show_mesh"
			or setting_id == "show_outline"
			or setting_id == "show_in_hub" then
		reset_outlines()
	elseif setting_id == "mission_nameplates_max_distance" then
		if instances.wmt_nameplate_combat then
			instances.wmt_nameplate_combat.max_distance =
				mod:get("mission_nameplates_max_distance")
		end
	elseif setting_id == "assist_marker_max_distance" then
		if instances.wmt_player_assistance then
			instances.wmt_player_assistance.max_distance =
				mod:get("assist_marker_max_distance")
		end
	end
end

mod.on_unload = function(exit_game)
	reset_outlines()
end

mod:hook(CLASS.PlayerUnitOutlineExtension, "extensions_ready", function(func, self, world, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local outline_system = Managers.state.extension:system("outline_system")
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._outline_system = outline_system
	self._smart_tag_system = smart_tag_system
end)

-- The bit that actually keeps things current and working.. Probably could be
-- a bit more performant.
mod:hook(CLASS.PlayerUnitOutlineExtension, "update", function(func, self, unit, dt, t)
	return set_outline(func, self, unit, dt, t)
end)

mod:hook_require("scripts/ui/hud/elements/world_markers/templates/world_marker_template_player_assistance", function(instance)
	instances.wmt_player_assistance = instance
	mod.on_setting_changed("assist_marker_max_distance")
end)

mod:hook_require("scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_combat", function(instance)
	instances.wmt_nameplate_combat = instance
	mod.on_setting_changed("mission_nameplates_max_distance")
end)
