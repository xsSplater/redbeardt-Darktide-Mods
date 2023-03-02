local mod = get_mod("status_colours")
local green_super_light = Color.ui_hud_green_super_light(255, true)
local red_light = Color.ui_hud_red_light(255, true)
local orange_light = Color.ui_orange_light(255, true)

return {
	name = "Status Colours",
	description = mod:localize("mod_description"),
	options = {
		widgets = {
			{
				setting_id = "dead_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[2]
			},
			{
				setting_id = "dead_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[3]
			},
			{
				setting_id = "dead_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[4]
			},
			{
				setting_id = "hogtied_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[2]
			},
			{
				setting_id = "hogtied_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[3]
			},
			{
				setting_id = "hogtied_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[4]
			},
			{
				setting_id = "pounced_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[2]
			},
			{
				setting_id = "pounced_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[3]
			},
			{
				setting_id = "pounced_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[4]
			},
			{
				setting_id = "netted_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[2]
			},
			{
				setting_id = "netted_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[3]
			},
			{
				setting_id = "netted_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[4]
			},
			{
				setting_id = "warp_grabbed_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[2]
			},
			{
				setting_id = "warp_grabbed_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[3]
			},
			{
				setting_id = "warp_grabbed_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[4]
			},
			{
				setting_id = "mutant_charged_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[2]
			},
			{
				setting_id = "mutant_charged_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[3]
			},
			{
				setting_id = "mutant_charged_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[4]
			},
			{
				setting_id = "consumed_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[2]
			},
			{
				setting_id = "consumed_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[3]
			},
			{
				setting_id = "consumed_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[4]
			},
			{
				setting_id = "grabbed_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[2]
			},
			{
				setting_id = "grabbed_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[3]
			},
			{
				setting_id = "grabbed_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = orange_light[4]
			},
			{
				setting_id = "knocked_down_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[2]
			},
			{
				setting_id = "knocked_down_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[3]
			},
			{
				setting_id = "knocked_down_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[4]
			},
			{
				setting_id = "ledge_hanging_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[2]
			},
			{
				setting_id = "ledge_hanging_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[3]
			},
			{
				setting_id = "ledge_hanging_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = red_light[4]
			},
			{
				setting_id = "luggable_r",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[2]
			},
			{
				setting_id = "luggable_g",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[3]
			},
			{
				setting_id = "luggable_b",
				type = "numeric",
				range = { 0, 255 },
				default_value = green_super_light[4]
			},
		}
	}
}
