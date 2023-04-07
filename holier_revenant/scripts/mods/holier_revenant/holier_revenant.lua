local mod = get_mod("holier_revenant")

local fn = "holier_revenant/scripts/mods/holier_revenant/HudElementHolierRevenant"
local class_name = "HudElementHolierRevenant"

mod:add_require_path(fn)

local is_in_hub = function()
	return Managers.state.game_mode:game_mode_name() == "hub"
end

mod:hook("UIHud", "init", function(func, self, elements, ...)
	if not (is_in_hub() or table.find_by_key(elements, "class_name", class_name)) then
		table.insert(elements, {
			class_name = class_name,
			filename = fn,
			use_hud_scale = true,
			visibility_groups = { "alive" }
		})
	end

	return func(self, elements, ...)
end)
