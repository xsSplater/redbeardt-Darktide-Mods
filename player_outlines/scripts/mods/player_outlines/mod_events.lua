local mod = get_mod("player_outlines")

mod.on_setting_changed = function(setting_id)
	PlayerOutlines.init_settings_cache()

	-- Instantly update visuals when a setting is changed.
	if setting_id == "show_hologram"
			or setting_id == "show_mesh"
			or setting_id == "show_outline"
			or setting_id == "show_in_hub" then
		PlayerOutlines.reset_outlines()
	elseif setting_id == "mission_nameplates_max_distance" and
			PlayerOutlines.instances.wmt_nameplate_combat then
		PlayerOutlines.instances.wmt_nameplate_combat.max_distance =
			mod.settings["mission_nameplates_max_distance"]
	elseif setting_id == "assist_marker_max_distance" and
			PlayerOutlines.instances.wmt_player_assistance then
		PlayerOutlines.instances.wmt_player_assistance.max_distance =
			mod.settings["assist_marker_max_distance"]
	end
end

mod.on_unload = PlayerOutlines.reset_outlines
