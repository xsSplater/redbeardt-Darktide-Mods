local mod = get_mod("status_colours")
local loc = {
	mod_name = {
		en = "Status Colours",
		["zh-cn"] = "状态图标颜色",
	},
	mod_description = {
		en = "Here you can set the colour of the marker that appears over another player's portrait when they enter any disabled status. Each one is broken down into a red, green, and blue component.",
		["zh-cn"] = "可以在这里设置其他玩家倒地或被控状态下头像状态图标的颜色。每项的颜色分为红绿蓝三部分设置。",
	},
}

local statuses = {
	dead = {
		en = "Dead",
		["zh-cn"] = "死亡",
	},
	hogtied = {
		en = "Hogtied",
		["zh-cn"] = "可营救",
	},
	pounced = {
		en = "Pounced",
		["zh-cn"] = "被扑倒",
	},
	netted = {
		en = "Netted",
		["zh-cn"] = "被网住",
	},
	warp_grabbed = {
		en = "Warp-grabbed",
		["zh-cn"] = "被亚空间抓取",
	},
	mutant_charged = {
		en = "Mutant-charged",
		["zh-cn"] = "被变种人冲锋",
	},
	consumed = {
		en = "Consumed",
		["zh-cn"] = "被吞噬",
	},
	grabbed = {
		en = "Grabbed",
		["zh-cn"] = "被抓取",
	},
	knocked_down = {
		en = "Knocked-down",
		["zh-cn"] = "被击倒",
	},
	ledge_hanging = {
		en = "Hanging",
		["zh-cn"] = "悬挂",
	},
	luggable = {
		en = "Luggable",
		["zh-cn"] = "携带物品",
	},
}

for k, v in pairs(statuses) do
	loc[k .. "_r"] = {
		en = v["en"] .. " - " .. "Red",
		["zh-cn"] = v["zh-cn"] .. " - " .. "红",
	}
	loc[k .. "_g"] = {
		en = v["en"] .. " - " .. "Green",
		["zh-cn"] = v["zh-cn"] .. " - " .. "绿",
	}
	loc[k .. "_b"] = {
		en = v["en"] .. " - " .. "Blue",
		["zh-cn"] = v["zh-cn"] .. " - " .. "蓝",
	}
end

return loc
