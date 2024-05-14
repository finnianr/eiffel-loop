note
	description: "[
		${EL_SPLIT_INTERVALS} optimized for strings conforming to ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-14 11:18:55 GMT (Tuesday 14th May 2024)"
	revision: "7"

class
	EL_STRING_32_SPLIT_INTERVALS

inherit
	EL_SPLIT_INTERVALS
		undefine
			fill_by_string_general, make_by_string
		end

	EL_STRING_32_OCCURRENCE_INTERVALS
		undefine
			extend_buffer
		end

create
	make, make_adjusted, make_empty, make_by_string, make_sized, make_from_special

end