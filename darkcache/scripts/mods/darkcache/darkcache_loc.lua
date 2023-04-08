return {
	mod_name = {
		en = "DarkCache",
		["zh-cn"] = "暗潮缓存",
	},
	mod_description = {
		en = "Adds prefetching and caching to various menus in the Mourningstar so that they're more responsive. Toggles for each type of cache are available in-case something breaks, or you want to forcibly refresh a cache type.",
		["zh-cn"] = "为哀星号上的各种菜单启用预读取和缓存，使它们响应更快。如果遇到问题，或者想强制刷新，则可以单独开关某种类型的缓存。",
	},
	armoury_caching = {
		en = "Armoury Caching",
		["zh-cn"] = "武器商店缓存",
	},
	armoury_caching_description = {
		en = "Toggles whether the armoury should prefetch and cache its item listings.",
		["zh-cn"] = "开关是否应该预读取和缓存武器商店的物品列表。",
	},
	melk_caching = {
		en = "Melk Caching",
		["zh-cn"] = "梅尔克商店缓存",
	},
	melk_caching_description = {
		en = "Toggles whether Melk should prefetch and cache its item listings.",
		["zh-cn"] = "开关是否应该预读取和缓存梅尔克商店的物品列表。",
	},
	contracts_caching = {
		en = "Contracts Caching",
		["zh-cn"] = "每周协议缓存",
	},
	contracts_caching_description = {
		en = "Toggles whether the contracts list should be prefetched and cached. The contracts list will be prefetched when entering the Mourningstar, and expire when you enter a mission.",
		["zh-cn"] = "开关是否应该预读取和缓存每周协议列表。协议列表会在进入哀星号时预读取，并在进入任务时过期。",
	},
	mission_board_caching = {
		en = "Mission Board Caching",
		["zh-cn"] = "任务面板缓存",
	},
	mission_board_caching_description = {
		en = "Toggles whether the mission board should prefetch and cache mission information. This cache expires whenever a mission expires so it probably prefetches too often if anything.",
		["zh-cn"] = "开关是否应该预读取和缓存任务信息。缓存会在任一任务过期时过期，所以此预读取过程可能会频繁进行。",
	},
	premium_store_caching = {
		en = "Premium Store Caching",
		["zh-cn"] = "高级饰品商店缓存",
	},
	premium_store_caching_description = {
		en = "Toggles whether the premium store should be prefetched and cached. I opted to make this cache not expire at all since I have no way of knowing when cosmetics will drop. Restart client or toggle this on/off to forcibly refresh.",
		["zh-cn"] = "开关是否应该预读取和缓存高级饰品商店。此缓存完全不会过期，因为我无法知道饰品会在什么时候刷新。重启游戏或者重新开关此选项以强制刷新缓存。",
	},
	hub_caching = {
		en = "Mourningstar Caching",
		["zh-cn"] = "哀星号缓存",
	},
	hub_caching_description = {
		en = "Causes the game to not release resources loaded when first loading the Mourningstar. This greatly reduces the time that subsequent loads take, but increases memory usage.",
		["zh-cn"] = "使游戏在首次进入哀星号后不释放已加载的资源。这会大幅度减少后续加载的时间，但会增加内存占用。",
	},
	dev_mode = {
		en = "Developer Mode",
		["zh-cn"] = "开发者模式",
	},
	dev_mode_description = {
		en = "Enables commands and output for dev and debugging purposes. This is probably not very useful for most players but hey you can enable it if you're curious.",
		["zh-cn"] = "启用开发者调试用的命令和输出。对于多数玩家来说没有实际作用，但如果你很好奇可以尝试一下。",
	},
	enabled = {
		en = "enabled",
		["zh-cn"] = "启用",
	},
	disabled = {
		en = "disabled",
		["zh-cn"] = "禁用",
	},
	loc_premium_store_caching_enabled = {
		en = "Cache will be rebuilt. Prefetching can take up to 10 seconds to complete.",
		["zh-cn"] = "将会重建缓存。预读取过程可能需要 10 秒。",
	},
	loc_hub_caching_enabled = {
		en = "This will dramatically increase your memory usage and could cause stuttering or crashing for some systems.",
		["zh-cn"] = "这会显著增加内存占用，在某些系统上可能造成卡顿或崩溃。",
	},
	loc_hub_caching_disabled = {
		en = "Please note that due to how this caching works, disabling it won't take effect until you restart the game (for now).",
		["zh-cn"] = "请注意，由于此缓存的工作原理，（目前）禁用后需要重启游戏才能生效。",
	}
}
