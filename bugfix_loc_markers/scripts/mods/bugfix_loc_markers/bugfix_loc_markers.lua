local mod = get_mod("bugfix_loc_markers")
local UISettings = require("scripts/settings/ui/ui_settings")
local wmt_location_ping_template = require("scripts/ui/hud/elements/world_markers/templates/world_marker_template_location_ping")
local original_func = wmt_location_ping_template.on_enter
local replacement_func = function(widget, marker)
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
end

mod.on_enabled = function()
	wmt_location_ping_template.on_enter = replacement_func
end

mod.on_disabled = function()
	wmt_location_ping_template.on_enter = original_func
end

