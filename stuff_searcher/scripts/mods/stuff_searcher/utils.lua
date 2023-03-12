Utils = {}

Utils.get_locale_language = function()
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
