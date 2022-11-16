note
	description: "[
		[$source EL_END_OF_LINE_CHAR_TP] optimized for string conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 15:39:18 GMT (Wednesday 16th November 2022)"
	revision: "3"

class
	EL_STRING_8_END_OF_LINE_CHAR_TP

inherit
	EL_END_OF_LINE_CHAR_TP
		undefine
			i_th_matches, make_with_character
		end

	EL_STRING_8_LITERAL_CHAR_TP
		rename
			make as make_with_character,
			make_with_action as make_literal_with_action
		undefine
			match_count, meets_definition, name_inserts, Name_template
		end

create
	make

end