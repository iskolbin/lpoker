-- Original Java source by Griffin DeJohn (gdejohn)
-- https://gist.github.com/gdejohn/8293321

local HIGH_CARD = 0
local ONE_PAIR = HIGH_CARD+1
local TWO_PAIRS = ONE_PAIR+1
local THREE_OF_A_KIND = TWO_PAIRS+1
local STRAIGHT = THREE_OF_A_KIND+1
local FLUSH = STRAIGHT+1
local FULL_HOUSE = FLUSH+1
local FOUR_OF_A_KIND = FULL_HOUSE+1
local STRAIGHT_FLUSH = FOUR_OF_A_KIND+1

-- TODO add joker
-- TODO add encode/decode, format maybe base64?
return {
	HIGH_CARD = HIGH_CARD,
	ONE_PAIR = ONE_PAIR,
	TWO_PAIRS = TWO_PAIRS,
	THREE_OF_A_KIND = THREE_OF_A_KIND,
	STRAIGHT = STRAIGHT,
	FLUSH = FLUSH,
	FULL_HOUSE = FULL_HOUSE,
	FOUR_OF_A_KIND = FOUR_OF_A_KIND,
	STRAIGHT_FLUSH = STRAIGHT_FLUSH,

	-- TODO unrolled cards, i.e. 10 elements instead of 5 pairs
	evalhand = function( cards )
		assert( #cards == 5 )
		local suits, ranks, distinctranks = {}, {}, {}
		for i = 1, 5 do
			local suit, rank = cards[i][1], cards[i][2]
			-- TODO count nsuits here
			suits[suit] = true
			ranks[rank] = (ranks[rank] or 0) + 1
		end
		-- TODO refactor
		local sorted = {}
		for rank, count in pairs( ranks ) do
			sorted[#sorted+1] = {count,rank}
		end
		table.sort( sorted, function(a,b) return a[2] < b[2] end )
		table.sort( sorted, function(a,b) return a[1] < b[1] end )
		for i = 1, #sorted do
			table.insert( distinctranks, 1, sorted[i] )
		end
		-- 
		local first = distinctranks[1][2]
		local distinctcount = #distinctranks
		if distinctcount == 5 then
			local nsuits = 0
			for _, _ in next, suits do
				nsuits = nsuits+1
			end
			local flush = nsuits == 1
			if first - distinctranks[#distinctranks][1] == 4 then
				return flush and STRAIGHT_FLUSH or STRAIGHT
			-- TODO 14 is an ACE, add constant
			elseif first == 14 and distinctranks[1][1] == 5 then
				-- TODO probably should add STRAIGHT_FLUSH_LOW and STRAIGHT_LOW as different combo
				return flush and STRAIGHT_FLUSH or STRAIGHT
			-- TODO probably should add ROYAL_FLUSH
			else
				return flush and FLUSH or HIGH_CARD
			end
		elseif distinctcount == 4 then
			return ONE_PAIR
		elseif distinctcount == 3 then
			return ranks[first] == 2 and TWO_PAIRS or THREE_OF_A_KIND
		else
			return ranks[first] == 3 and FULL_HOUSE or FOUR_OF_A_KIND
			-- TODO and maybe FIVE_OF_A_KIND?
		end
	end
}
