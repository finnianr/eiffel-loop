note
	description: "List of STRING_32 strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 16:31:36 GMT (Sunday 19th December 2021)"
	revision: "10"

class
	EL_STRING_32_LIST

inherit
	EL_STRING_LIST [STRING_32]

create
	make, make_empty, make_split, make_adjusted_split, make_with_lines, make_word_split, make_from_array, make_from_tuple,
	make_from_general, make_comma_split

convert
	make_from_array ({ARRAY [STRING_32]}), make_from_tuple ({TUPLE}), make_comma_split ({STRING_32})
end