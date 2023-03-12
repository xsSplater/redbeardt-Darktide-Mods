local mod = get_mod("barter_with_hadron")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local barter_button_def = nil

mod:hook_safe("CraftingModifyView", "init", function()
	CraftingModifyView.cb_on_discard_held = function(self, _, input_pressed)
		if input_pressed then
			self._hotkey_item_discard_pressed = true
		end

		local selected = self:selected_grid_widget()

		if selected and not selected.content.equipped and (self._hotkey_item_discard_pressed or self._discard_item_timer) then
			self._update_item_discard = true

			if not self._discard_item_timer then
				self:_play_sound(UISoundEvents.weapons_discard_hold)
			end
		end
	end

	CraftingModifyView._mark_item_for_discard = function(self, grid_index)
		local widgets = self:grid_widgets()
		local widget = widgets[grid_index]
		local content = widget.content
		local gear_id = content.element.item.gear_id
		local inv_items = self._inventory_items

		for i = 1, #inv_items do
			if inv_items[i].gear_id == gear_id then
				table.remove(self._inventory_items, i)
				break
			end
		end

		for i, v in ipairs(self._filtered_offer_items_layout) do
			if v.item.gear_id == gear_id then
				table.remove(self._filtered_offer_items_layout, i)
				break
			end
		end

		-- self:_sort_grid_layout(self._sort_options and self._sort_options[self.selected_sort_option_index or 1].sort_function)

		Managers.data_service.gear:delete_gear(gear_id):next(function(result)
			self._inventory_items[gear_id] = nil
			local rewards = result and result.rewards

			if rewards then
				local creds = rewards[1] and rewards[1].amount or 0
				Managers.event:trigger("event_force_wallet_update")
				Managers.event:trigger("event_add_notification_message", "currency", {
					currency = "credits",
					amount = creds
				})
			end

			if self._profile_presets_element then
				self._profile_presets_element:sync_profiles_states()
			end
		end)
	end
end)

mod:hook_safe("CraftingModifyView", "_handle_input", function(self, input_service)
	if not self._discard_item_timer then
		self._hotkey_item_discard_pressed = input_service:get("hotkey_item_discard_pressed")
	end
end)

mod:hook_safe("CraftingModifyView", "update", function(self, dt)
	local selected = self:selected_grid_index()

	if self._update_item_discard and selected then
		self._update_item_discard = nil

		if not self._discard_item_timer then
			self._discard_item_timer = 0
		end

		local time = self._discard_item_timer + dt
		local progress = math.min(time / 0.75, 1)
		self._discard_item_hold_progress = progress

		if progress < 1 then
			self._discard_item_timer = time
		else
			self._discard_item_timer = nil
			self._discard_item_hold_progress = nil
			if selected then
				self:_mark_item_for_discard(selected)
				local grid = self._item_grid:grid()
				grid:remove_widget(self:grid_widgets()[selected])
				grid:clear_scroll_progress()
				local focus_el_idx = (selected or 1) - 1
				local focus_el = selected > 0 and self:element_by_index(focus_el_idx)

				if focus_el then
					self:focus_on_item(focus_el)
				else
					self:_stop_previewing()
				end

				self:update_grid_widgets_visibility()
			end

			self:_play_sound(UISoundEvents.weapons_discard_complete)
		end
	elseif self._discard_item_timer then
		self._discard_item_timer = nil
		self._discard_item_hold_progress = nil
		self:_play_sound(UISoundEvents.weapons_discard_release)
	end
end)

mod:hook_require("scripts/ui/views/crafting_view/crafting_view_definitions", function(instance)

	local legend_buttons = instance.crafting_tab_params.select_item.tabs_params[1].input_legend_buttons

	barter_button_def = {
		input_action = "hotkey_item_discard",
		display_name = "loc_inventory_item_discard",
		alignment = "right_alignment",
		use_mouse_hold = true,
		on_pressed_callback = "cb_on_discard_held",
		visibility_function = function(parent)
			local cmv = Managers.ui:view_instance("crafting_modify_view")
			if cmv and cmv._item_grid then
				local selected = cmv:selected_grid_widget()
				if selected and selected.content then
					return not selected.content.equipped
				end
			end

			return false
		end
	}

	for i = 1, #legend_buttons do
		if legend_buttons[i].input_action == "hotkey_item_discard" then
			legend_buttons[i] = barter_button_def
			return
		end
	end

	table.insert(legend_buttons, barter_button_def)
end)

