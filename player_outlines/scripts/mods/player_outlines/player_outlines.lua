local mod = get_mod("player_outlines")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")

PlayerOutlines = PlayerOutlines or {}
PlayerOutlines.switch_states = { consumed = true }
PlayerOutlines.update_interval = 0.5
PlayerOutlines.instances = {}
mod.settings = {}

PlayerOutlines.spawn_hologram = function(world, resources, parent_unit, state_name)
	if not world then return end

	local resource = PlayerOutlines.switch_states[state_name] and
		resources[state_name] or
		resources.default
	local hologram_unit = World.spawn_unit_ex(world, resource)

	World.link_unit(world, hologram_unit, 1, parent_unit, 1, true)
	Unit.set_unit_culling(hologram_unit, false, true)

	local player_visibility_system = ScriptUnit.has_extension(parent_unit, "player_visibility_system")

	if player_visibility_system and not player_visibility_system:visible() then
		Unit.set_unit_visibility(hologram_unit, false, true)
	end

	return hologram_unit
end

PlayerOutlines.despawn_hologram = function(world, hologram_unit)
	if not world or not hologram_unit then return end
	World.unlink_unit(world, hologram_unit, true)
	World.destroy_unit(world, hologram_unit)
end

PlayerOutlines.selected_outline_name = function()
	local show_outline = mod.settings["show_outline"]

	if mod.settings["show_mesh"] then
		return show_outline and "default_both_always" or "default_mesh_always"
	elseif show_outline then
		return "default_outlines_always"
	end
end

PlayerOutlines.clear_outlines = function(unit)
	if not Managers.state or not Managers.state.extension or not unit then
		return
	end

	Managers.state.extension:system("outline_system"):remove_all_outlines(unit)
end

PlayerOutlines.update_outline = function(extension, unit, dt)
	local added_outline = extension._added_disabled_outline
	local character_state_component = extension._character_state_component
	local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

	if is_disabled and not added_outline then
		extension._outline_system:add_outline(unit, "knocked_down")
		extension._added_disabled_outline = true
	elseif added_outline and not is_disabled then
		extension._outline_system:remove_outline(unit, "knocked_down")
		extension._added_disabled_outline = false
	end

	extension._timer = extension._timer + dt
	if extension._timer < PlayerOutlines.update_interval then return end
	extension._timer = 0

	if not extension._is_local_unit then
		local outline_name = PlayerOutlines.selected_outline_name()

		if outline_name then
			extension._outline_system:add_outline(unit, outline_name)
		end
	end
end

PlayerOutlines.reset_outlines = function()
	if not Managers.player then return end

	for _, player in pairs(Managers.player:players()) do
		PlayerOutlines.clear_outlines(player.player_unit)
	end
end

PlayerOutlines.init_settings_cache = function()
	mod.settings["assist_marker_max_distance"] = mod:get("assist_marker_max_distance")
	mod.settings["mission_nameplates_max_distance"] = mod:get("mission_nameplates_max_distance")
	mod.settings["show_hologram"] = mod:get("show_hologram")
	mod.settings["show_in_hub"] = mod:get("show_in_hub")
	mod.settings["show_mesh"] = mod:get("show_mesh")
	mod.settings["show_outline"] = mod:get("show_outline")
end

PlayerOutlines.init_settings_cache()

Mods.file.dofile("player_outlines/scripts/mods/player_outlines/mod_events")
Mods.file.dofile("player_outlines/scripts/mods/player_outlines/hooks")
