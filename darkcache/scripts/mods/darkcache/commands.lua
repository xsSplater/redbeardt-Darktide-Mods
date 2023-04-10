local dc = DarkCache

dc.mod:command("dc_contracts", "Prints contracts data.", function()
	local rv = Managers.backend.interfaces.contracts:get_current_contract(
		dc.get_current_char_id())
	dc.rt:dev_echo(rv)
end)

dc.mod:command("dc_server_time", "Prints the server time.", function()
	dc.rt:dev_echo("Server time: " .. dc.server_time)
end)

dc.mod:command("dc_game_time", "Prints the game time.", function()
	dc.rt:dev_echo("Game time: " .. dc.main_time)
end)

dc.mod:command("dc_delete_caches", "Deletes all caches.", function()
	dc.agnostic_cache = nil
	dc.char_caches = {}
	dc.rt:dev_echo("Caches deleted.")
end)

dc.mod:command("dc_dump_missions", "Fetches mission board data & dumps response to log.", function()
	dc.rt:dev_echo("Fetching mission data...")
	Managers.data_service.mission_board:fetch(nil, 1):next(
		function(data)
			dc.mod:dump(data, "___mission_board_data", 3)
			dc.rt:dev_echo("Mission data fetched and dumped to log.")
		end)
end)

dc.mod:command("dc_echo_char_id", "Prints current character id.", function()
	dc.rt:dev_echo(dc.get_current_char_id())
end)

dc.mod:command("dc_init", "Initialises based on current context.", function()
	if not RedTools.Utils.player_in_hub() then
		dc.rt:dev_echo("Only run this in the hub.")
		return
	end

	dc.settings_manager.build_cache()
	dc.settings_manager.update_chat_command_availability()
	dc.build_agnostic_cache()
	dc.build_char_cache()
end)
