Mods.file.dofile("stuff_searcher/scripts/mods/stuff_searcher/log_manager")

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local MasterItems = require("scripts/backend/master_items")
local mod = get_mod("stuff_searcher")
local views = "scripts/ui/views/"
local logman = LogManager:new(mod, "stuff_searcher: ")

local is_writing = function()
	mod:info(mod.input_field and mod.input_field.content and
		mod.input_field.content.is_writing)
	return mod.input_field and mod.input_field.content and
		mod.input_field.content.is_writing
end

local set_is_writing = function(value)
	if not mod.input_field then
		return logman:error("set_is_writing: input_field == nil.")
	elseif not mod.input_field.content then
		return logman:error("set_is_writing: input_field.content == nil")
	end

	mod.input_field.content.is_writing = value
end

local build_search_string = function(item)
	-- Add item's display name.
	local str = Localize(item.__master_item.display_name) ..
		" " .. item.__master_item.itemLevel

	-- Add all of the item's traits/blessings
	if item.__master_item.traits then
		for _, v in ipairs(item.__master_item.traits) do
			str = str .. " " .. Localize(MasterItems.get_item(v.id).display_name)
		end
	end

	if item.__master_item.perks then
		for _, v in ipairs(item.__master_item.perks) do
			str = str .. " " .. Localize(MasterItems.get_item(v.id).description)
		end
	end

	return str
end

local apply_to_layout = function(view)
	if not view then return end
	mod.view = view
	mod.input_field = view._widgets_by_name["stuff_searcher_input"]

	if not view then
		return logman:error("apply_to_layout: view == nil")
	elseif not view._item_grid then
		return logman:error("apply_to_layout: view._item_grid == nil")
	elseif not mod.input_field then
		return logman:error("apply_to_layout: mod.input_field == nil")
	end

	-- Used to focus the input field for next update.
	if mod.set_is_writing_asap then
		set_is_writing(true)
		mod.set_is_writing_asap = false
	end

	-- Make sure we can escape input focus with the Escape key.
	for _, ks in ipairs(Keyboard.keystrokes()) do
		if is_writing() and ks == Keyboard.ESCAPE then
			set_is_writing(false)
			mod.block_next_legend_escape_check = true
			return
		elseif ks == "s" then
			-- Lets us process the 's' keystroke without inputting it into field.
			mod.set_is_writing_asap = true
			return
		end
	end

	-- Only actually update if the text in the field has changed.
	local last_text = mod.input_field.last_text
	local current_text = mod.input_field.content.input_text
	if last_text == current_text then return end
	mod.input_field.last_text = current_text

	-- Store original filtered layout so we can use it as a basis for our filtering.
	if not view._stored_layout then
		local stored_layout = {}

		for _, v in ipairs(view._filtered_offer_items_layout) do
			table.insert(stored_layout, v)
		end

		view._stored_layout = stored_layout
	end

	local filtered = {}
	local layout = view._stored_layout

	-- Build list containing only matching items.
	for i = 1, #layout do
		if layout[i] and layout[i].item and layout[i].item.__master_item and
				layout[i].item.__master_item.display_name then
			local search_name = string.lower(build_search_string(layout[i].item))
			local term = string.gsub(string.lower(current_text), "%%", "%%%%")
			if string.find(search_name, term) then
				table.insert(filtered, layout[i])
			end
		end
	end

	view._filtered_offer_items_layout = filtered
	view:_sort_grid_layout(view._sort_options and view._sort_options[view.selected_sort_option_index or 1].sort_function)
end

local append_to_view_defs = function(defs)
	if not defs then return end -- No point if the view has no definitions.
	defs.grid_settings = defs.grid_settings or {}
	defs.screnegraph_definition = defs.scenegraph_definition or {}
	defs.widget_definitions = defs.widget_definitions or {}

	local top_padding = 20
	local x_offset = (defs.grid_settings.grid_spacing and defs.grid_settings.grid_spacing[1] * 2) or 20
	local y_offset = (defs.grid_settings.title_height or 12) + 12

	defs.grid_settings.top_padding = top_padding

	defs.scenegraph_definition.stuff_searcher_label = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "left",
		size = { 100, 30 },
		position = { x_offset, y_offset, 3 }
	}

	defs.scenegraph_definition.stuff_searcher_input = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "left",
		size = { 510, 30 },
		position = { x_offset + 90, y_offset, 3 }
	}

	defs.widget_definitions.stuff_searcher_label = UIWidget.create_definition({
		{
			value = "Search: ",
			value_id = "text",
			pass_type = "text",
			style = table.clone(UIFontSettings.body)
		}
	}, "stuff_searcher_label")

	defs.widget_definitions.stuff_searcher_input =
		UIWidget.create_definition(TextInputPassTemplates.simple_input_field,
		"stuff_searcher_input")
end

local block_sort_if_writing = function(func, self, ...)
	return not is_writing() and func(self, ...)
end

local preview_safely = function(func, self, item)
	return item and func(self, item)
end

-- Takes focus from search field if player clicks on grid entries.
local stop_writing_passthru = function(func, ...)
	set_is_writing(false)
	func(...)
end

mod:hook_require(views.."inventory_weapons_view/inventory_weapons_view_definitions", append_to_view_defs)
mod:hook_require(views.."marks_vendor_view/marks_vendor_view_definitions", append_to_view_defs)
mod:hook_require(views.."credits_vendor_view/credits_vendor_view_definitions", append_to_view_defs)

mod:hook_safe("CreditsVendorView", "update", apply_to_layout)
mod:hook_safe("MarksVendorView", "update", apply_to_layout)
mod:hook_safe("InventoryWeaponsView", "update", apply_to_layout)
mod:hook_safe("CraftingModifyView", "update", apply_to_layout)

mod:hook_safe("CreditsVendorView", "_present_layout_by_slot_filter", apply_to_layout)
mod:hook_safe("MarksVendorView", "_present_layout_by_slot_filter", apply_to_layout)
mod:hook_safe("InventoryWeaponsView", "_present_layout_by_slot_filter", apply_to_layout)
mod:hook_safe("CraftingModifyView", "_present_layout_by_slot_filter", apply_to_layout)

mod:hook("InventoryWeaponsView", "_preview_item", preview_safely)
mod:hook("CraftingModifyView", "_preview_item", preview_safely)
mod:hook("CreditsVendorView", "_preview_item", preview_safely)
mod:hook("MarksVendorView", "_preview_item", preview_safely)

mod:hook("ViewElementGrid", "_cb_on_sort_button_pressed", block_sort_if_writing)
mod:hook("ViewElementGrid", "cb_on_grid_entry_left_pressed", stop_writing_passthru)
mod:hook("ViewElementGrid", "cb_on_grid_entry_double_click_pressed", stop_writing_passthru)

------------------------------------------
---- InventoryWeaponsView / inventory ----
------------------------------------------
-- Make sure player can't click equip in the instance that no item is selected.
mod:hook("InventoryWeaponsView", "_update_equip_button_status", function(func, self)
	return self:grid_widgets()[self:selected_grid_index()] and func(self)
end)

---------------------------------------
---- CraftingModifyView / Hadron's ----
---------------------------------------
-- Rather than dig up the logic to position the widgets in all instances it was
-- just easier to give Hadron's a few special rules. Oh well.
mod:hook_require("scripts/ui/views/crafting_modify_view/crafting_modify_view_definitions", function(instance)
	append_to_view_defs(instance)
	local special_y_offset = 32
	instance.scenegraph_definition.stuff_searcher_label.position[2] = special_y_offset
	instance.scenegraph_definition.stuff_searcher_input.position[2] = special_y_offset
end)

-- Resets search parameters when switching tab.
mod:hook_safe("CraftingModifyView", "cb_switch_tab", function(self)
	self._stored_layout = nil
	mod.input_field.content.input_text = ""
	apply_to_layout()
end)

-- Prevents switching tabs by hitting left/right actions while typing in field.
mod:hook("ViewElementTabMenu", "update", function(func, self, ...)
	self._was_handling_navigation_input =
		self._was_handling_navigation_input or self._is_handling_navigation_input
	self._is_handling_navigation_input =
		not is_writing() and self._was_handling_navigation_input
	func(self, ...)
end)

-- Prevents Legend hotkeys from triggering while search field is focused.
mod:hook("ViewElementInputLegend", "_handle_input", function(func, ...)
	if mod:get("escape_defocuses") and
			(is_writing() or mod.block_next_legend_escape_check) then
		mod.block_next_legend_escape_check = false
		return
	end

	func(...)
end)
