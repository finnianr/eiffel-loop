note
	description: "[
		Table for grouping items into sets according to a hashable key.
		The set items are implemented as ${EL_ARRAYED_LIST [G]}.
	]"
	notes: "[
		Each item list inherits the object comparison status of the ''Current'' table
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-05 15:56:54 GMT (Thursday 5th September 2024)"
	revision: "7"

class
	EL_GROUPED_SET_TABLE [G, K -> HASHABLE]

inherit
	EL_GROUPED_LIST_TABLE [G, K]
		rename
			found_list as found_set,
			list_of_lists as list_of_sets,
			wipe_out_lists as wipe_out_sets
		redefine
			is_set
		end

create
	make, make_equal

feature {NONE} -- Implementation

	is_set: BOOLEAN
		do
			Result := True
		end
end