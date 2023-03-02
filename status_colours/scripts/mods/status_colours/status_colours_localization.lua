local loc = {}

local statuses = {
	{ "dead", "Dead" },
	{ "hogtied", "Hogtied" },
	{ "pounced", "Pounced" },
	{ "netted", "Netted", },
	{ "warp_grabbed", "Warp-grabbed" },
	{ "mutant_charged", "Mutant-charged" },
	{ "consumed", "Consumed" },
	{ "grabbed", "Grabbed" },
	{ "knocked_down", "Knocked-down" },
	{ "ledge_hanging", "Hanging" },
	{ "luggable", "Luggable" }
}

for _, v in ipairs(statuses) do
	loc[v[1] .. "_r"] = { en = v[2] .. " - " .. "Red" }
	loc[v[1] .. "_g"] = { en = v[2] .. " - " .. "Green" }
	loc[v[1] .. "_b"] = { en = v[2] .. " - " .. "Blue" }
end

loc.mod_description = {
	en = "Here you can set the colour of the marker that appears over another player's portrait when they enter any disabled status. Each one is broken down into a red, green, and blue component."
}

return loc
