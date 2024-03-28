note
	description: "[
		Edit strings of type ${STRING_32} by applying an editing procedure to all
		occurrences of substrings that begin and end with a pair of delimiters.

		See `{${EL_STRING_EDITOR}}.delete_interior' for an example of an editing procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-28 8:58:24 GMT (Thursday 28th March 2024)"
	revision: "7"

class
	EL_STRING_32_EDITOR

inherit
	EL_STRING_EDITOR [STRING_32]
		redefine
			new_string
		end

create
	make, make_empty

feature {NONE} -- Implementation

	area_count: INTEGER
		do
			Result := target.area.count
		end

	modify_target (str: STRING_32)
		do
			target.share (str)
		end

	new_string (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := general.to_string_32
		end

	trim
		-- trim target
		do
			target.trim
		end

	wipe_out (str: STRING_32)
		do
			str.wipe_out
		end
end