local mod = get_mod("status_colours")

local apply_all = function()
	if not mod.psc then return end
	mod.psc.dead = { 255, mod:get("dead_r"), mod:get("dead_g"), mod:get("dead_b") }
	mod.psc.hogtied = { 255, mod:get("hogtied_r"), mod:get("hogtied_g"), mod:get("hogtied_b") }
	mod.psc.pounced = { 255, mod:get("pounced_r"), mod:get("pounced_g"), mod:get("pounced_b") }
	mod.psc.netted = { 255, mod:get("netted_r"), mod:get("netted_g"), mod:get("netted_b") }
	mod.psc.warp_grabbed = { 255, mod:get("warp_grabbed_r"), mod:get("warp_grabbed_g"), mod:get("warp_grabbed_b") }
	mod.psc.mutant_charged = { 255, mod:get("mutant_charged_r"), mod:get("mutant_charged_g"), mod:get("mutant_charged_b") }
	mod.psc.consumed = { 255, mod:get("consumed_r"), mod:get("consumed_g"), mod:get("consumed_b") }
	mod.psc.grabbed = { 255, mod:get("grabbed_r"), mod:get("grabbed_g"), mod:get("grabbed_b") }
	mod.psc.knocked_down = { 255, mod:get("knocked_down_r"), mod:get("knocked_down_g"), mod:get("knocked_down_b") }
	mod.psc.ledge_hanging = { 255, mod:get("ledge_hanging_r"), mod:get("ledge_hanging_g"), mod:get("ledge_hanging_b") }
	mod.psc.luggable = { 255, mod:get("luggable_r"), mod:get("luggable_g"), mod:get("luggable_b") }
end

mod:hook_require("scripts/settings/ui/ui_hud_settings", function(instance)
	mod.psc = instance.player_status_colors
	apply_all()
end)

mod.on_setting_changed = function(setting_id)
	if not mod.psc then return end
	if setting_id:sub(1, #"dead") == "dead" then
		mod.psc.dead = { 255, mod:get("dead_r"), mod:get("dead_g"), mod:get("dead_b") }
	elseif setting_id:sub(1, #"hogtied") == "hogtied" then
		mod.psc.hogtied = { 255, mod:get("hogtied_r"), mod:get("hogtied_g"), mod:get("hogtied_b") }
	elseif setting_id:sub(1, #"pounced") == "pounced" then
		mod.psc.pounced = { 255, mod:get("pounced_r"), mod:get("pounced_g"), mod:get("pounced_b") }
	elseif setting_id:sub(1, #"netted") == "netted" then
		mod.psc.netted = { 255, mod:get("netted_r"), mod:get("netted_g"), mod:get("netted_b") }
	elseif setting_id:sub(1, #"warp_grabbed") == "warp_grabbed" then
		mod.psc.warp_grabbed = { 255, mod:get("warp_grabbed_r"), mod:get("warp_grabbed_g"), mod:get("warp_grabbed_b") }
	elseif setting_id:sub(1, #"mutant_charged") == "mutant_charged" then
		mod.psc.mutant_charged = { 255, mod:get("mutant_charged_r"), mod:get("mutant_charged_g"), mod:get("mutant_charged_b") }
	elseif setting_id:sub(1, #"consumed") == "consumed" then
		mod.psc.consumed = { 255, mod:get("consumed_r"), mod:get("consumed_g"), mod:get("consumed_b") }
	elseif setting_id:sub(1, #"grabbed") == "grabbed" then
		mod.psc.grabbed = { 255, mod:get("grabbed_r"), mod:get("grabbed_g"), mod:get("grabbed_b") }
	elseif setting_id:sub(1, #"knocked_down") == "knocked_down" then
		mod.psc.knocked_down = { 255, mod:get("knocked_down_r"), mod:get("knocked_down_g"), mod:get("knocked_down_b") }
	elseif setting_id:sub(1, #"ledge_hanging") == "ledge_hanging" then
		mod.psc.ledge_hanging = { 255, mod:get("ledge_hanging_r"), mod:get("ledge_hanging_g"), mod:get("ledge_hanging_b") }
	elseif setting_id:sub(1, #"luggable") == "luggable" then
		mod.psc.luggable = { 255, mod:get("luggable_r"), mod:get("luggable_g"), mod:get("luggable_b") }
	end
end
