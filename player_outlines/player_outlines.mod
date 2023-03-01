return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`player_outlines` encountered an error loading the Darktide Mod Framework.")

		new_mod("player_outlines", {
			mod_script       = "player_outlines/scripts/mods/player_outlines/player_outlines",
			mod_data         = "player_outlines/scripts/mods/player_outlines/player_outlines_data",
			mod_localization = "player_outlines/scripts/mods/player_outlines/player_outlines_localization",
		})
	end,
	packages = {},
}
