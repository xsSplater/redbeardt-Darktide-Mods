local mod = get_mod("no_skull")

mod:hook_require("scripts/ui/hud/elements/world_markers/templates/world_marker_template_unit_threat", function(instance)
	instance.max_distance = 0
end)
