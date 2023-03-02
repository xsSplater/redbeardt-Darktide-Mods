local mod = get_mod("tweax")
local UISettings = require("scripts/settings/ui/ui_settings")
local wmt_location_ping_template = nil

mod:hook_require("scripts/ui/hud/elements/world_markers/templates/world_marker_template_location_ping", function(instance)
	if not wmt_location_ping_template then
		wmt_location_ping_template = instance
		mod:hook(wmt_location_ping_template, "on_enter", function(func, widget, marker, template)
			if not mod:get("fix_marker_colours") then
				return func(widget, marker, template)
			end

			local content = widget.content
			content.spawn_progress_timer = 0
			local data = marker.data
			local player = data.player
			local tagger_player = data.tag_instance:tagger_player()
			local player_slot = (tagger_player or player):slot()
			local player_slot_color = UISettings.player_slot_colors[player_slot] or Color.ui_hud_green_light(255, true)
			local style = widget.style
			style.icon.color = table.clone(player_slot_color)
			style.entry_icon_1.color = table.clone(player_slot_color)
			style.entry_icon_2.color = table.clone(player_slot_color)
		end)
	end
end)
