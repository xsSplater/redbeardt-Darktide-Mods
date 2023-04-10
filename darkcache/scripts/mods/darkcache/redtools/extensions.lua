-- Gets # elements in a table regardless of whether it has keys or a numeric index.
table.get_length = function(tbl)
	local count = 0

	for _, _ in pairs(tbl) do
		count = count + 1
	end

	return count
end
