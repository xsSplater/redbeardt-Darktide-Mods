local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local MasterItems = require("scripts/backend/master_items")
local mod = get_mod("stuff_searcher")
local search_focused = false
local delayed_search_focus = false

mod:hook("ViewElementInputLegend", "_handle_input", function(func, self, dt, t, input_service)
	if not search_focused then
		func(self, dt, t, input_service)
	end
end)

local build_search_string = function(item)
	local str = Localize(item.__master_item.display_name) .. " " .. item.__master_item.itemLevel
	if item.__master_item.traits then
		for _, v in ipairs(item.__master_item.traits) do
			str = str .. " " .. Localize(MasterItems.get_item(v.id).display_name)
		end
	end
	return str
end

local apply_search_to_layout = function(item_grid)
	local input = item_grid._widgets_by_name["stuff_searcher_input"]
	if not input or not input.content then return end

	if delayed_search_focus then
		input.content.is_writing = true
		delayed_search_focus = false
	end

	-- Make sure we can escape input focus with the Escape key.
	for _, ks in ipairs(Keyboard.keystrokes()) do
		if ks == Keyboard.ESCAPE then
			input.content.is_writing = false
			return
		elseif ks == "s" then
			delayed_search_focus = true
			return
		end
	end

	search_focused = input.content.is_writing
	local last_text = input.last_text
	local current_text = input.content.input_text
	if last_text == current_text then return end
	input.last_text = current_text

	-- Store original filtered layout so we can use it as a basis for our filtering.
	if not item_grid._stored_layout then
		local stored_layout = {}

		for _, v in ipairs(item_grid._filtered_offer_items_layout) do
			table.insert(stored_layout, v)
		end

		item_grid._stored_layout = stored_layout
	end

	local filtered = {}
	local layout = item_grid._stored_layout

	-- Build list containing only matching items.
	for i = 1, #layout do
		if layout[i] and layout[i].item and layout[i].item.__master_item and
			layout[i].item.__master_item.display_name then
			local search_name = build_search_string(layout[i].item)
			if string.find(string.lower(search_name), string.lower(current_text)) then
				table.insert(filtered, layout[i])
			end
		end
	end

	item_grid._filtered_offer_items_layout = filtered

	if item_grid._sort_options then
		item_grid:_sort_grid_layout(item_grid._sort_options[item_grid._selected_sort_option_index or 1].sort_function)
	else
		item_grid:_sort_grid_layout()
	end
end

mod:hook_require("scripts/ui/views/inventory_weapons_view/inventory_weapons_view_definitions", function(instance)
	instance.grid_settings.top_padding = 20
	instance.scenegraph_definition.stuff_searcher_label = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "left",
		size = { 100, 30 },
		position = { 20, 120, 3 }
	}
	instance.scenegraph_definition.stuff_searcher_input = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "left",
		size = { 200, 30, },
		position = { 110, 120, 3 }
	}
	instance.widget_definitions.stuff_searcher_label = UIWidget.create_definition({
		{
			value = "Search: ",
			value_id = "text",
			pass_type = "text",
			style = table.clone(UIFontSettings.body)
		}
	}, "stuff_searcher_label")
	instance.widget_definitions.stuff_searcher_input = UIWidget.create_definition(TextInputPassTemplates.simple_input_field, "stuff_searcher_input")
end)

mod:hook("InventoryWeaponsView", "_update_equip_button_status", function(func, self)
	local idx = self:selected_grid_index()
	local widgets = self:grid_widgets()
	local widget = widgets[idx]
	if not widget then return end
	return func(self)
end)

mod:hook("InventoryWeaponsView", "_preview_item", function(func, self, item)
	if not item then return end
	return func(self, item)
end)

mod:hook_safe("InventoryWeaponsView", "_present_layout_by_slot_filter", function(self)
	apply_search_to_layout(self)
end)

mod:hook_safe("InventoryWeaponsView", "update", function(self)
	apply_search_to_layout(self)
end)
