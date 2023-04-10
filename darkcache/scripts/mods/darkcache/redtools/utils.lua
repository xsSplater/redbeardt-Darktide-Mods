RedTools = RedTools or {}
RedTools.Utils = {}
local s = RedTools.Utils -- Namespace

s.get_locale_language = function()
	if PLATFORM == "win32" then
		return Application.user_setting("language_id") or HAS_STEAM and Steam:language() or "en"
	elseif PLATFORM == "ps4" then
		return PS4.locale() or DEFAULT_LANGUAGE
	elseif PLATFORM == "xb1" then
		return xbox_format_locale(XboxLive.locale() or "error")
	elseif PLATFORM == "xbs" then
		return xbox_format_locale(XboxLive.locale() or "error")
	elseif PLATFORM == "linux" then
		return "en"
	end
end

-- Checks descendents in sequence like the null-conditional operator in C#.
s.nil_check = function(root, ...)
	local obj = root

	for _, name in ipairs({...}) do
		obj = obj[name]
		if not obj then return nil end
	end

	return obj
end

s.in_game_mode = function(mode)
	return Managers and Managers.state and Managers.state.game_mode and
		Managers.state.game_mode.game_mode_name and
		type(Managers.state.game_mode.game_mode_name) == "function" and
		Managers.state.game_mode:game_mode_name() == mode
end

s.player_in_mission = function()
	return s.in_game_mode("coop_complete_objective")
end

s.player_in_hub = function()
	return s.in_game_mode("hub")
end

s.get_char_id_via_profile = function()
	if Managers and Managers.player and
			Managers.player.local_player_backend_profile then
		local profile = Managers.player:local_player_backend_profile()
		if profile then
			return profile.character_id
		end
	end
end
