local mod = get_mod("pickup_notif_tweaker")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UISettings = require("scripts/settings/ui/ui_settings")
local TextUtils = require("scripts/utilities/ui/text")
local WalletSettings = require("scripts/settings/wallet_settings")

mod:hook("PickupSystem", "_show_collected_materials_notification", function(func, self, peer_id, material_type, material_size)

	if material_type ~= "plasteel" and material_type ~= "diamantine" then
		return func(self, peer_id, material_type, material_size)
	end

	local show_text = mod:get("show_text")
	local show_icons = mod:get("show_icons")
	local play_sounds = mod:get("play_sounds")

	if not show_text and not show_icons and not play_sounds then
		return
	end

	local player = Managers.player:player(peer_id, 1)
	local player_name = player and player:name()
	local player_slot = player and player.slot and player:slot()
	local player_slot_colors = UISettings.player_slot_colors
	local player_slot_color = player_slot and player_slot_colors[player_slot]

	if player_name and player_slot_color then
		player_name = TextUtils.apply_color_to_text(player_name, player_slot_color)
	end

	local optional_localization_key = "loc_tactical_overlay_crafting_mat_notification"

	Managers.event:trigger("event_add_notification_message", "currency", {
		currency = material_type,
		amount_size = material_size,
		player_name = player_name,
		optional_localization_key = optional_localization_key,
		show_text = show_text,
		show_icon = show_icons,
		play_sounds = play_sounds
	})
end)

mod:hook("ConstantElementNotificationFeed", "_generate_notification_data", function(func, self, message_type, data, ...)

	if message_type ~= "currency" or
			(data.currency ~= "diamantine" and data.currency ~= "plasteel") then
		return func(self, message_type, data, ...)
	end

	local notification_data = nil
	local amount = data.amount
	local wallet_settings = WalletSettings[data.currency]

	if wallet_settings then
		local selected_color = Color.terminal_corner_selected(255, true)
		amount = string.format("{#color(%d,%d,%d)}%s %s{#reset()}", selected_color[2], selected_color[3], selected_color[4], data.amount_size or TextUtils.format_currency(amount), Localize(wallet_settings.display_name))

		local background_colour = mod:get("use_custom_background_colour") and {
				mod:get("custom_background_alpha"),
				mod:get("custom_background_red"),
				mod:get("custom_background_green"),
				mod:get("custom_background_blue")
			} or Color.terminal_grid_background(100, true)

		notification_data = {
			icon_size = "currency",
			texts = {
				{
					display_name = data.show_text and Localize(data.optional_localization_key or
						"loc_notification_feed_currency_acquired", true, {
						amount = amount,
						player_name = data.player_name
					}) or ""
				}
			},
			icon = data.show_icon and
				(wallet_settings and wallet_settings.icon_texture_big) or nil,
			color = background_colour,
			enter_sound_event = data.play_sounds and
				wallet_settings.notification_sound_event or nil,
			line_color = background_colour,
			is_pickup = true
		}
	end

	if not notification_data then return end
	notification_data.type = message_type
	notification_data.enter_sound_event = notification_data.enter_sound_event or
		UISoundEvents.notification_default_enter
	notification_data.exit_sound_event = notification_data.exit_sound_event or
		UISoundEvents.notification_default_exit

	return notification_data
end)

mod:hook("ConstantElementNotificationFeed", "_create_notification_entry", function(func, self, notification_data)
	if notification_data.is_pickup then
		local result = func(self, notification_data)
		local style = result.widget.style
		local scale = mod:get("scale") / 100
		local text_icon_margin = 70
		local vertical_background_padding = 5
		local icon_edge_margin = 10

		if not mod:get("show_background") or (
				not mod:get("show_text") and
				not mod:get("show_icons")) then
			-- If setting are to not show background, set its size to 0.
			style.background.size = { 0, 0 }
		elseif mod:get("show_icons") and not mod:get("show_text") then
			-- If show_icon is set & show_text isn't, resize background to only cover icon.
			style.background.size[1] = 80
		end

		for _, v in pairs(style) do
			if v.size then v.size = { v.size[1] * scale, v.size[2] * scale } end
			if v.font_size then v.font_size = v.font_size * scale end
			if v.line_spacing then v.line_spacing = v.line_spacing * scale end
			if v.text_horizontal_alignment then v.text_horizontal_alignment = "right" end
			if v.horizontal_alignment then v.horizontal_alignment = "right" end
			if v.text_vertical_alignment then v.text_vertical_alignment = "center" end
			if v.vertical_alignment then v.vertical_alignment = "center" end
		end

		local bg_height = style.background.size[2]
		local text_offset = {
			-style.icon.size[1] - text_icon_margin, -vertical_background_padding
		}

		style.background.size_addition = { 0, vertical_background_padding * 4 }
		style.icon.offset = { -icon_edge_margin, -vertical_background_padding }
		style.icon.size[2] = bg_height
		style.text_1.size[2] = bg_height
		style.text_2.size[2] = bg_height
		style.text_3.size[2] = bg_height
		style.text_1.offset = text_offset
		style.text_2.offset = text_offset
		style.text_3.offset = text_offset
		result.widget.size[2] = style.background.size[2]

		return result
	end

	return func(self, notification_data)
end)

local random_element = function(table)
	local i = 0
	for _, _ in pairs(table) do
		i = i + 1
	end

	local random_index = math.random(i)

	i = 0
	for _, v in pairs(table) do
		i = i + 1
		if i == random_index then
			return v
		end
	end
end

mod:command("pnt_test", "Generates a random pickup notification.", function()
	local random_player_peer_id = random_element(Managers.player:human_players())._peer_id
	local pickup_system = Managers.state.extension:system("pickup_system")
	pickup_system:_show_collected_materials_notification(random_player_peer_id,
		({"plasteel", "diamantine"})[math.random(2)],
		({"large", "small"})[math.random(2)])
end)
