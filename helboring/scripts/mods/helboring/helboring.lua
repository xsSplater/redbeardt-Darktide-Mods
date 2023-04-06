local mod = get_mod("helboring")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")

mod:hook_safe("HudElementCrosshair", "_get_current_charge_level", function(self)
	local parent = self._parent
	local extensions = parent:player_extensions()
	if not extensions then return end

	local crosshair_type = self:_get_current_crosshair_type()
	if crosshair_type ~= "charge_up_ads" then return end

	local unit_data_extension = extensions.unit_data
	local action_module_charge_component = unit_data_extension:read_component("action_module_charge")
	local charge_level = action_module_charge_component.charge_level

	if charge_level > 0.99 then
		self._widget.style.charge_mask_left.color = { 255, 255, 0, 0 }
		self._widget.style.charge_mask_right.color = { 255, 255, 0, 0 }
	else
		self._widget.style.charge_mask_left.color = UIHudSettings.color_tint_main_1
		self._widget.style.charge_mask_right.color = UIHudSettings.color_tint_main_1
	end
end)

-- mod:hook_safe("PlayerUnitWeaponExtension", "on_slot_wielded", function(self, slot_name, ...)
-- 	if slot_name == "secondary" then
-- 		return
-- 	end
-- end)

-- mod:hook_origin("PlayerUnitWeaponExtension", "start_action", function(self, action_name, t)
-- 	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)
-- 	local template = weapon.template
-- 	self:_start_action(action_name, action_settings, t, nil, "forced")
-- end)
