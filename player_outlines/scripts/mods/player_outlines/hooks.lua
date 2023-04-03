local mod = get_mod("player_outlines")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")

mod:hook_origin("GameModeManager", "disable_hologram", function()
	return false
end)

mod:hook_origin("PlayerUnitHologramExtension", "update", function(self, unit, dt, t)
	self._timer = self._timer + dt

	if self._timer < PlayerOutlines.update_interval then
		return
	end

	self._timer = 0
	local state_name = self._character_state_component.state_name
	local hologram_unit = self._hologram_unit
	local should_switch_unit = PlayerOutlines.switch_states[state_name] and self._current_spawned_state ~= state_name or PlayerOutlines.switch_states[self._current_spawned_state] and not PlayerOutlines.switch_states[state_name]

	if state_name == "dead" or not mod.settings["show_hologram"] or
		(Managers.state and Managers.state.game_mode and
			Managers.state.game_mode:game_mode_name() == "hub"
			and not mod.settings["show_in_hub"]) then
		if hologram_unit then
			PlayerOutlines.despawn_hologram(self._world, hologram_unit)
			self._hologram_unit = nil
		end

		return
	else
		if not hologram_unit or should_switch_unit then
			if hologram_unit then
				PlayerOutlines.despawn_hologram(self._world, hologram_unit)
			end

			hologram_unit = PlayerOutlines.spawn_hologram(self._world, self._unit_resources, self._unit, state_name)
			self._hologram_unit = hologram_unit
			self._current_spawned_state = state_name
		end

		local health_percent = self._target_health_extension:current_health_percent()
		local is_disabled = PlayerUnitStatus.is_disabled(self._character_state_component)

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

mod:hook("PlayerUnitOutlineExtension", "update", function(func, self, unit, dt, t)
	self._timer = self._timer + dt

	if self._timer < PlayerOutlines.update_interval then
		return
	end

	if not Managers.state or not Managers.state.game_mode then
		return
	end

	if Managers.state.game_mode:game_mode_name() == "hub" and
			not mod.settings["show_in_hub"] then
		PlayerOutlines.clear_outlines(unit)
		return func(self, unit, dt, t)
	end

	PlayerOutlines.update_outline(self, unit, dt)
end)

mod:hook_require("scripts/ui/hud/elements/world_markers/templates/world_marker_template_player_assistance", function(instance)
	PlayerOutlines.instances.wmt_player_assistance = instance
	mod.on_setting_changed("assist_marker_max_distance")
end)

mod:hook_require("scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_combat", function(instance)
	PlayerOutlines.instances.wmt_nameplate_combat = instance
	mod.on_setting_changed("mission_nameplates_max_distance")
end)
