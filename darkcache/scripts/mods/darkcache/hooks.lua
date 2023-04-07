local dc = DarkCache

dc.mod:hook_safe("Account", "set_selected_character", function(_, char_id)
	dc.current_char_id = char_id
	dc.build_char_cache(char_id)
end)

dc.mod:hook_safe("MainMenuView", "init", function()
	dc.current_char_id = nil
	dc.settings.build_cache()
	dc.settings.update_chat_command_availability()
	dc.build_agnostic_cache()
	dc.update_hub_caching_hooks()
end)

local cached_data_fetch = function(cache, cache_item_key, fetch_func, ...)
	if not cache then
		return fetch_func(...)
	end

	local item = cache:get(cache_item_key)

	if not item or item.fetching then
		return fetch_func(...)
	end

	return item:try_get_data()
end

dc.mod:hook("StoreService", "get_credits_store", function(...)
	return cached_data_fetch(dc.get_current_char_cache(), "credits_store", ...)
end)

-- Brunt's Armoury
-- dc.mod:hook("StoreService", "get_credits_goods_store", function(...)
-- 	return cached_data_fetch(dc.get_current_char_cache(), "credits_goods_store", ...)
-- end)

dc.mod:hook("StoreService", "get_credits_cosmetics_store", function(...)
	return cached_data_fetch(dc.get_current_char_cache(), "credits_cosmetics_store", ...)
end)

dc.mod:hook("StoreService", "get_credits_weapon_cosmetics_store", function(...)
	return cached_data_fetch(dc.get_current_char_cache(), "credits_weapon_cosmetics_store", ...)
end)

dc.mod:hook("StoreService", "get_marks_store", function(...)
	return cached_data_fetch(dc.get_current_char_cache(), "marks_store", ...)
end)

dc.mod:hook("StoreService", "get_marks_store_temporary", function(...)
	return cached_data_fetch(dc.get_current_char_cache(), "marks_store_temporary", ...)
end)

dc.mod:hook("StoreService", "get_premium_store", function(func, self, storefront)
	return cached_data_fetch(dc.agnostic_cache, storefront, func, self, storefront)
end)

dc.mod:hook("Contracts", "get_current_contract", function(...)
	return cached_data_fetch(dc.get_current_char_cache(), "contracts_list", ...)
end)

-- Expire contracts cache when completing and rerolling tasks.
local refresh_contracts = function(func, ...)
	local promise = func(...)

	-- Wait for request to complete before trying to update cache with new data.
	promise:next(function()
		local cache = dc.get_current_char_cache()

		if cache then
			local item = cache:get("contracts_list")

			if item then
				dc.dev.echo("Got contracts_list. Expiring and refreshing...")
				item:expire()
				item:try_get_data()
			end
		end
	end)

	return promise
end

dc.mod:hook("Contracts", "complete_contract", refresh_contracts)
dc.mod:hook("Contracts", "reroll_task", refresh_contracts)

dc.mod:hook("MissionBoardService", "fetch", function(...)
	return cached_data_fetch(dc.agnostic_cache, "mission_board", ...)
end)

-- Expire stores when purchases are made so that the displayed item listings
-- reflect the purchase.

local cause_store_update = function(store_cache_id)
	local cache = dc.get_current_char_cache()
	if not cache then return end
	local item = cache:get(store_cache_id)
	if not item then return end
	item:expire()
	item:try_get_data()
end

dc.mod:hook_safe("CreditsVendorView", "_on_purchase_complete", function()
	cause_store_update("credits_store")
	cause_store_update("credits_cosmetics_store")
	cause_store_update("credits_weapon_cosmetics_store")
end)

dc.mod:hook_safe("MarksVendorView", "_on_purchase_complete", function()
	cause_store_update("marks_store_temporary")
end)

dc.mod:hook_safe("MarksGoodsVendorView", "_on_purchase_complete", function()
	cause_store_update("marks_store")
end)

-- Creates a wrapper around the function that updates and returns account
-- info for the premium store view so that the total data package that results
-- from the function's default recursive logic can be captured and cached.
dc.mod:hook("StoreView", "_update_account_items", function(func, self, wrapped, promise)
	if not dc.settings.cache.premium_store_caching then
		return func(self, wrapped, promise)
	end

	local returned_promise = cached_data_fetch(dc.agnostic_cache,
		"premium_store_account_update", func, wrapped, promise)

	if returned_promise and returned_promise.is_promise then
		returned_promise:next(function()
			self._account_items = dc.storeview_account_items
		end)
	end

	return returned_promise
end)

dc.premium_store_fetch_wrap = function(wrapped, promise)
	if not wrapped then
		dc.storeview_account_items = {}
		local promise_inner = Promise.new()

		Managers.data_service.gear:fetch_account_items_paged(100):next(function(wrapped_inner)
			dc.premium_store_fetch_wrap(wrapped_inner, promise_inner)
		end)

		return promise_inner
	else
		for _, item in pairs(wrapped.items) do
			dc.storeview_account_items[#dc.storeview_account_items + 1] = item
		end

		if wrapped.has_next then
			wrapped.next_page():next(function(wrapped_inner)
				dc.premium_store_fetch_wrap(wrapped_inner, promise)
			end)
		else
			promise:resolve()
		end
	end
end
