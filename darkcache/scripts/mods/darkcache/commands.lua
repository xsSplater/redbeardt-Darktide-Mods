local dc = DarkCache

dc.mod:command("dc_contracts", "Prints contracts data.", function()
	local rv = Managers.backend.interfaces.contracts:get_current_contract(
		dc.Utils.get_current_char_id())
	dc.dev.echo(rv)
end)

dc.mod:command("dc_server_time", "Prints the server time.", function()
	dc.dev.echo("Server time: " .. dc.server_time)
end)

dc.mod:command("dc_game_time", "Prints the game time.", function()
	dc.dev.echo("Game time: " .. dc.main_time)
end)

dc.mod:command("dc_delete_caches", "Deletes all caches.", function()
	dc.agnostic_cache = nil
	dc.char_caches = {}
	dc.dev.echo("Caches deleted.")
end)

dc.mod:command("dc_dump_missions", "Fetches mission board data & dumps response to log.", function()
	dc.dev.echo("Fetching mission data...")
	Managers.data_service.mission_board:fetch(nil, 1):next(
		function(data)
			dc.mod:dump(data, "___mission_board_data", 3)
			dc.dev.echo("Mission data fetched and dumped to log.")
		end)
end)

dc.mod:command("dc_echo_char_id", "Prints current character id.", function()
	dc.dev.echo(dc.Utils.get_current_char_id())
end)

dc.mod:command("dc_init", "Initialises based on current context.", function()
	if not dc.Utils.player_in_hub() then
		dc.dev.echo("Only run this in the hub.")
		return
	end

	dc.settings.build_cache()
	dc.settings.update_chat_command_availability()
	dc.build_agnostic_cache()
	dc.build_char_cache()
end)
