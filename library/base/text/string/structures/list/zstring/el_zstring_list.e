note
	description: "List of strings of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-24 8:12:22 GMT (Thursday 24th August 2023)"
	revision: "24"

class
	EL_ZSTRING_LIST

inherit
	EL_STRING_LIST [ZSTRING]
		rename
			append_code as append_z_code,
			separator_code as separator_z_code
		redefine
			append_z_code, item_indent, make_split, proper_cased, tab_string, separator_z_code
		end

	EL_SHARED_ZSTRING_CODEC

	EL_CHARACTER_32_CONSTANTS

create
	make, make_empty, make_with_lines, make_filled,
	make_from, make_from_if, make_from_array, make_from_tuple, make_from_general,
	make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [ZSTRING]}), make_comma_split ({STRING, STRING_32, ZSTRING}), make_from_tuple ({TUPLE})

feature {NONE} -- Initialization

	make_split (a_string: READABLE_STRING_GENERAL; delimiter: CHARACTER_32)
		do
			if attached {ZSTRING} a_string as zstr and then attached zstr.split_list (delimiter) as list then
				area_v2 := list.area_v2
				compare_objects
			else
				Precursor (a_string, delimiter)
			end
		end

feature -- Access

	item_indent: INTEGER
		do
			Result := item.leading_occurrences ('%T')
		end

feature -- Element change

	expand_tabs (space_count: INTEGER)
		-- Expand tab characters as `space_count' spaces
		do
			do_all (agent {ZSTRING}.expand_tabs (space_count))
		end

feature {NONE} -- Implementation

	append_z_code (str: ZSTRING; z_code: NATURAL)
		do
			str.append_z_code (z_code)
		end

	proper_cased (word: ZSTRING): ZSTRING
		do
			Result := word.as_proper_case
		end

	separator_z_code (a_separator: CHARACTER_32): NATURAL
		do
			Result := codec.as_z_code (a_separator)
		end

	tab_string (n: INTEGER): ZSTRING
		do
			Result := tab * n
		end

end