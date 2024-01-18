note
	description: "[
		${EL_SPLIT_INTERVALS} optimized for strings conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-22 10:47:01 GMT (Friday 22nd December 2023)"
	revision: "4"

class
	EL_STRING_8_SPLIT_INTERVALS

inherit
	EL_SPLIT_INTERVALS
		undefine
			fill_by_string
		redefine
			is_white_space
		end

	EL_STRING_8_OCCURRENCE_INTERVALS
		undefine
			extend_buffer
		end

create
	make, make_adjusted, make_empty, make_by_string, make_sized, make_from_special

feature {NONE} -- Implementation

	is_white_space (a_target: READABLE_STRING_8; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

end