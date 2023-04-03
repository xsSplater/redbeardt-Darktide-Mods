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

	if charge_level == 1 then
		self._widget.style.charge_mask_left.color = { 255, 255, 0, 0 }
		self._widget.style.charge_mask_right.color = { 255, 255, 0, 0 }
	else
		self._widget.style.charge_mask_left.color = UIHudSettings.color_tint_main_1
		self._widget.style.charge_mask_right.color = UIHudSettings.color_tint_main_1
	end
end)
