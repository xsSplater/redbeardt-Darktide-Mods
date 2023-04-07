local dc = DarkCache

dc.Utils = {}
local ns = dc.Utils -- namespace

-- Checks given extra params in sequence as descendents of root for nils and
-- returns the object at the end of the hierarchy if none were found, or nil
-- if anything was nil.
ns.nonil = function(root, ...)
	local obj = root

	for _, name in ipairs({...}) do
		obj = obj[name]
		if not obj then return nil end
	end

	return obj
end

ns.in_game_mode = function(mode)
	return Managers and Managers.state and Managers.state.game_mode and
		Managers.state.game_mode.game_mode_name and
		type(Managers.state.game_mode.game_mode_name) == "function" and
		Managers.state.game_mode:game_mode_name() == mode
end

ns.player_in_mission = function()
	return ns.in_game_mode("coop_complete_objective")
end

ns.player_in_hub = function()
	return ns.in_game_mode("hub")
end

ns.get_current_char_id = function()
	return dc.current_char_id
	-- if Managers and
	-- 		Managers.player and
	-- 		Managers.player.local_player_backend_profile then
	-- 	local profile = Managers.player:local_player_backend_profile()
	-- 	if profile then
	-- 		return profile.character_id
	-- 	end
	-- end
end
