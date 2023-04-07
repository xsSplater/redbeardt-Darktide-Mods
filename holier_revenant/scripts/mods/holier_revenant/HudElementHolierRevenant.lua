local mod = get_mod("holier_revenant")

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")

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
	},
	icon_path = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_base_2"
}

settings.icon_position = {
	-450 - settings.icon_size[1] - settings.icon_margin,
	-40,
	1
}

-- Add scenegraph for icon.
local sg_defs = {
	screen = UIWorkspaceSettings.screen,
	icon = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = settings.icon_size,
		position = settings.icon_position
	}
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
local widget_defs = {
	icon = UIWidget.create_definition({
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
					talent_icon = settings.icon_path
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
	}, "icon")
}

local HudElementHolierRevenant = class("HudElementHolierRevenant", "HudElementBase")

HudElementHolierRevenant.init = function(self, parent, draw_layer, start_scale, definitions)
	HudElementHolierRevenant.super.init(self, parent, draw_layer, start_scale, {
		scenegraph_definition = sg_defs,
		widget_definitions = widget_defs
	})

	self._player_unit = Managers.player:local_player(1).player_unit
end

HudElementHolierRevenant.update = function(self, dt, t, ui_renderer,
		render_settings, input_service)

	HudElementHolierRevenant.super.update(self, dt, t, ui_renderer,
		render_settings, input_service)

	if self._player_unit then
		local buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
		local widget = self._widgets_by_name.icon

		if buff_extension then
			for _, buff in ipairs(buff_extension._buffs_by_index) do
				local template = buff:template()
				if template.name == hr_buff_name then
					local cd = template.cooldown_duration
					local active_start_time = buff._active_start_time
					local lapsed = Managers.time:time("gameplay") - active_start_time

					if lapsed < cd then
						if mod:get("gradual_background_update") then
							widget.style.icon.material_values.progress = lapsed / cd
						else
							widget.style.icon.material_values.progress = 0
						end

						widget.style.frame.color = settings.frame.inactive_colour
						widget.style.frame_glow.visible = false
						widget.content.counter_text = string.format("%.0f", (cd - lapsed))
					elseif widget.style.icon.material_values.progress ~= 1 then
						widget.style.icon.material_values.progress = 1
						widget.style.frame.color = settings.frame.active_colour
						widget.style.frame_glow.visible = true
						widget.content.counter_text = " "
						Managers.ui:play_2d_sound(UISoundEvents.ability_off_cooldown)
					end

					widget.visible = true
					widget.dirty = true
					return
				end
			end
		end

		widget.visible = false
		widget.dirty = true
	end
end

return HudElementHolierRevenant
