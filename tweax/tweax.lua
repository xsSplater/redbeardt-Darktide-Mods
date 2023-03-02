local mod = get_mod("tweax")

Mods.file.dofile("tweax/tweax_hud_element_smart_tagging")
-- mod:dofile("tweax/tweax_hud_element_smart_tagging")

local SETTINGS = {
	THREAT_SKULL_MARKER_MAX_DISTANCE = "threat_skull_marker_max_distance",
	FIX_MARKER_COLOURS = "fix_marker_colours",
}

-- WMT == "world marker template"
local PATHS = {
	WMT_UNIT_THREAT = "scripts/ui/hud/elements/world_markers/templates/world_marker_template_unit_threat",
}

local instances = {
	unit_threat_template = nil,
}

local apply = function(name)
	if name == SETTINGS.THREAT_SKULL_MARKER_MAX_DISTANCE then
		instances.unit_threat_template.max_distance = mod:get(SETTINGS.THREAT_SKULL_MARKER_MAX_DISTANCE)
	end
end

mod:hook_require(PATHS.WMT_UNIT_THREAT, function(instance)
	if not instances.unit_threat_template then
		instances.unit_threat_template = instance
		apply(SETTINGS.THREAT_SKULL_MARKER_MAX_DISTANCE)
	end
end)

----------------
---- Events ----
----------------
mod.on_setting_changed = function(setting_id)
	if setting_id == SETTINGS.THREAT_SKULL_MARKER_MAX_DISTANCE then
		apply(SETTINGS.THREAT_SKULL_MARKER_MAX_DISTANCE)
	end
end

-- mod.on_unload = function(exit_game)
	-- TODO: Apply all tweaks based on current settings?
-- end
