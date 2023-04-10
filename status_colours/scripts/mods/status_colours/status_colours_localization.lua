local mod = get_mod("status_colours")
local loc = {
	mod_name = {
		en = "Status Colours",
		["zh-cn"] = "状态图标颜色",
		ru = "Цвета статуса",
	},
	mod_description = {
		en = "Here you can set the colour of the marker that appears over another player's portrait when they enter any disabled status. Each one is broken down into a red, green, and blue component.",
		["zh-cn"] = "可以在这里设置其他玩家倒地或被控状态下头像状态图标的颜色。每项的颜色分为红绿蓝三部分设置。",
		ru = "Status Colours - Здесь вы можете установить цвет маркера, который появляется над портретом другого игрока, когда он переходит в какой-либо статус, при выходе из строя. Каждый из них разбит на красную, зеленую и синюю составляющие.",
	},
}

local statuses = {
	dead = {
		en = "Dead",
		["zh-cn"] = "死亡",
		ru = "Мёртв",
	},
	hogtied = {
		en = "Hogtied",
		["zh-cn"] = "可营救",
		ru = "Можно спасти",
	},
	pounced = {
		en = "Pounced",
		["zh-cn"] = "被扑倒",
		ru = "Напала гончая",
	},
	netted = {
		en = "Netted",
		["zh-cn"] = "被网住",
		ru = "Пойман в сеть",
	},
	warp_grabbed = {
		en = "Warp-grabbed",
		["zh-cn"] = "被亚空间抓取",
		ru = "Захвачен варпом",
	},
	mutant_charged = {
		en = "Mutant-charged",
		["zh-cn"] = "被变种人冲锋",
		ru = "Сбит мутантом",
	},
	consumed = {
		en = "Consumed",
		["zh-cn"] = "被吞噬",
		ru = "Проглочен",
	},
	grabbed = {
		en = "Grabbed",
		["zh-cn"] = "被抓取",
		ru = "Схвачен",
	},
	knocked_down = {
		en = "Knocked-down",
		["zh-cn"] = "被击倒",
		ru = "Сбит с ног",
	},
	ledge_hanging = {
		en = "Hanging",
		["zh-cn"] = "悬挂",
		ru = "Висит",
	},
	luggable = {
		en = "Luggable",
		["zh-cn"] = "携带物品",
		ru = "Несёт предмет",
	},
}

for k, v in pairs(statuses) do
	loc[k .. "_r"] = {
		en = v["en"] .. " - " .. "Red",
		["zh-cn"] = v["zh-cn"] .. " - " .. "红",
		ru = v["ru"] .. " - " .. "Красный",
	}
	loc[k .. "_g"] = {
		en = v["en"] .. " - " .. "Green",
		["zh-cn"] = v["zh-cn"] .. " - " .. "绿",
		ru = v["ru"] .. " - " .. "Зелёный",
	}
	loc[k .. "_b"] = {
		en = v["en"] .. " - " .. "Blue",
		["zh-cn"] = v["zh-cn"] .. " - " .. "蓝",
		ru = v["ru"] .. " - " .. "Синий",
	}
end

return loc
