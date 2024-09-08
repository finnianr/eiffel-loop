note
	description: "Iteration_cursor for ${EL_SPLIT_READABLE_STRING_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 15:43:26 GMT (Sunday 8th September 2024)"
	revision: "5"

class
	EL_SPLIT_READABLE_STRING_ITERATION_CURSOR [S -> READABLE_STRING_GENERAL create make end]

inherit
	ARRAYED_LIST_ITERATION_CURSOR [S]
		rename
			area as empty_area,
			area_index as index,
			area_last_index as count
		redefine
			cursor_index, item, last_index, make, target
		end

create
	make

feature {NONE} -- Initialization

	make (t: like target)
		do
			target := t
			empty_area := target.empty_area; area := target.area
			target_string := target.target_string
			index := 1; count := t.count
		end

feature -- Access

	item, item_copy: S
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				Result := target.target_substring (a [i], a [i + 1])
			end
		end

feature -- Measurement

	cursor_index: INTEGER
		do
			Result := index
		end

feature {NONE} -- Implementation

	last_index: INTEGER
			-- <Precursor>
		do
			Result := count
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [INTEGER]

	target: EL_SPLIT_READABLE_STRING_LIST [S]

	target_string: S
end