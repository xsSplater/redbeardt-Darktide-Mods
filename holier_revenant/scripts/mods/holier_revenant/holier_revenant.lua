local mod = get_mod("holier_revenant")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")

local hud_elements_path = "scripts/ui/hud/elements/"
local hr_buff_name = "zealot_maniac_resist_death_improved_with_leech"

local settings = {
	icon_size = { 92, 80 },
	icon_margin = 20,
	frame = {
		size = { 128, 128 },
		glow_colour = { 255, 255, 192, 0 },
		active_colour = { 255, 192, 0, 0 },
		inactive_colour = { 255, 32, 32, 32 }
	},
	triangles = {
		offset = { 25, 40 },
		colour = { 255, 0, 0, 0 }
	}
}

settings.icon_position = {
	-450 - settings.icon_size[1] - settings.icon_margin,
	-40,
	1
}

mod:hook_require(hud_elements_path ..
		"player_buffs/hud_element_player_buffs_definitions",
		function(instance)
	-- Add scenegraph for icon.
	instance.scenegraph_definition.holier_revenant_icon = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = settings.icon_size,
		position = settings.icon_position
	}

	local counter_text_style = table.clone(UIFontSettings.hud_body)
	counter_text_style.horizontal_alignment = "center"
	counter_text_style.vertical_alignment = "center"
	counter_text_style.text_horizontal_alignment = "center"
	counter_text_style.text_vertical_alignment = "center"
	counter_text_style.size = settings.icon_size
	counter_text_style.text_color = { 255, 255, 192, 0 }
	counter_text_style.font_type = "machine_medium"
	counter_text_style.font_size = 32
	counter_text_style.offset = { 0, 0, 2 }
	counter_text_style.drop_shadow = true

	-- Add widget for icon.
	instance.widget_definitions.holier_revenant_icon = UIWidget.create_definition({
		{
			value_id = "counter_text",
			style_id = "counter_text",
			pass_type = "text",
			value = "",
			style = counter_text_style
		}, {
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/talents/hud/combat_container",
			style = {
				material_values = {
					progress = 1,
					talent_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_base_2"
				},
				offset = { 0, 0, 0 },
				color = { 255, 255, 255, 255 }
			}
		}, {
			value = "content/ui/materials/icons/talents/hud/combat_frame_inner",
			style_id = "frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = { 0, 0, 3 },
				color = settings.frame.active_colour,
				size = settings.frame.size
			}
		}, {
			value = "content/ui/materials/effects/hud/combat_talent_glow",
			style_id = "frame_glow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = { 0, 0, 4 },
				color = settings.frame.glow_colour,
				size = settings.frame.size
			}
		}, {
			style_id = "triangle_top_left",
			pass_type = "triangle",
			style = {
				offset = { 0, 0, 1 },
				color = settings.triangles.colour,
				triangle_corners = {
					{ 0, 0 },
					{ settings.triangles.offset[1], 0 },
					{ 0, settings.triangles.offset[2] }
				}
			}
		}, {
			style_id = "triangle_top_right",
			pass_type = "triangle",
			style = {
				offset = { settings.icon_size[1], 0, 1 },
				color = settings.triangles.colour,
				triangle_corners = {
					{ 0, 0 },
					{ -settings.triangles.offset[1], 0 },
					{ 0, settings.triangles.offset[2] }
				}
			}
		}, {
			style_id = "triangle_bottom_left",
			pass_type = "triangle",
			style = {
				offset = { 0, settings.icon_size[2], 1 },
				color = settings.triangles.colour,
				triangle_corners = {
					{ 0, 0 },
					{ settings.triangles.offset[1], 0 },
					{ 0, -settings.triangles.offset[2] }
				}
			}
		}, {
			style_id = "triangle_bottom_right",
			pass_type = "triangle",
			style = {
				offset = { settings.icon_size[1], settings.icon_size[2], 1 },
				color = settings.triangles.colour,
				triangle_corners = {
					{ 0, 0 },
					{ -settings.triangles.offset[1], 0 },
					{ 0, -settings.triangles.offset[2] }
				}
			}
		}
	}, "holier_revenant_icon")
end)

mod:hook("HudElementPlayerBuffs", "_update_buffs", function(func, self, ...)
	local hr_icon = self._widgets_by_name.holier_revenant_icon
	if not hr_icon then return end

	for i = 1, #self._active_buffs_data do
		local data = self._active_buffs_data[i]
		local instance = data.buff_instance

		if instance and instance._template_name == hr_buff_name then
			local cd = instance._template.cooldown_duration
			local active_start_time = instance._active_start_time
			local t = Managers.time:time("gameplay")
			local lapsed = t - active_start_time

			if lapsed < cd then
				if mod:get("gradual_background_update") then
					hr_icon.style.icon.material_values.progress = lapsed / cd
				else
					hr_icon.style.icon.material_values.progress = 0
				end

				hr_icon.style.frame.color = settings.frame.inactive_colour
				hr_icon.style.frame_glow.visible = false
				hr_icon.content.counter_text = string.format("%.0f", (cd - lapsed) + 1)
			elseif hr_icon.style.icon.material_values.progress ~= 1 then
				hr_icon.style.icon.material_values.progress = 1
				hr_icon.style.frame.color = settings.frame.active_colour
				hr_icon.style.frame_glow.visible = true
				hr_icon.content.counter_text = " "
				Managers.ui:play_2d_sound(UISoundEvents.ability_off_cooldown)
			end

			hr_icon.visible = true
			hr_icon.dirty = true
			return
		end
	end

	hr_icon.visible = false
	hr_icon.dirty = true

	func(self, ...)
end)

mod:hook_safe("HudElementPlayerBuffs", "_update_buff_alignments", function(self)
	local buffs = self._active_buffs_data
	local found = false

	for i = 1, #buffs do
		local instance = buffs[i].buff_instance

		if found then
			buffs[i].widget.offset[1] = buffs[i].widget.offset[1] -
				4.25 -- It works.. but why? It's visually a lot more than 4.25 pixels.
			buffs[i].widget.dirty = true
		elseif instance and instance._template_name == hr_buff_name then
			found = true
			buffs[i].widget.visible = false
			buffs[i].widget.dirty = true
		end
	end
end)
