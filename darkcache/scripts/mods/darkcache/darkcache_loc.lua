return {
	mod_description = {
		en = "Adds prefetching and caching to various menus in the Mourningstar so that they're more responsive. Toggles for each type of cache are available in-case something breaks, or you want to forcibly refresh a cache type.",
	},
	armoury_caching = {
		en = "Armoury Caching"
	},
	armoury_caching_description = {
		en = "Toggles whether the armoury should prefetch and cache its item listings."
	},
	melk_caching = {
		en = "Melk Caching"
	},
	melk_caching_description = {
		en = "Toggles whether Melk should prefetch and cache its item listings."
	},
	contracts_caching = {
		en = "Contracts Caching"
	},
	contracts_caching_description = {
		en = "Toggles whether the contracts list should be prefetched and cached. The contracts list will be prefetched when entering the Mourningstar, and expire when you enter a mission."
	},
	mission_board_caching = {
		en = "Mission Board Caching"
	},
	mission_board_caching_description = {
		en = "Toggles whether the mission board should prefetch and cache mission information. This cache expires whenever a mission expires so it probably prefetches too often if anything."
	},
	premium_store_caching = {
		en = "Premium Store Caching"
	},
	premium_store_caching_description = {
		en = "Toggles whether the premium store should be prefetched and cached. I opted to make this cache not expire at all since I have no way of knowing when cosmetics will drop. Restart client or toggle this on/off to forcibly refresh."
	},
	hub_caching = {
		en = "Mourningstar Caching"
	},
	hub_caching_description = {
		en = "Causes the game to not release resources loaded when first loading the Mourningstar. This greatly reduces the time that subsequent loads take, but increases memory usage."
	},
	dev_mode = {
		en = "Developer Mode"
	},
	dev_mode_description = {
		en = "Enables commands and output for dev and debugging purposes. This is probably not very useful for most players but hey you can enable it if you're curious."
	},
	enabled = {
		en = "enabled"
	},
	disabled = {
		en = "disabled"
	},
	loc_premium_store_caching_enabled = {
		en = "Cache will be rebuilt. Prefetching can take up to 10 seconds to complete."
	},
	loc_hub_caching_enabled = {
		en = "This will dramatically increase your memory usage and could cause stuttering or crashing for some systems."
	},
	loc_hub_caching_disabled = {
		en = "Please note that due to how this caching works, disabling it won't take effect until you restart the game (for now)."
	}
}
