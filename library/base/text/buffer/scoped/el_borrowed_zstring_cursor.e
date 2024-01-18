note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary
		${ZSTRING} buffer can be borrowed from a shared pool. After iterating
		just once the scope finishes and the buffer item is automatically returned to
		the shared `pool' stack.
	]"
	tests: "[
		${GENERAL_TEST_SET}.test_reusable_strings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-22 8:39:33 GMT (Wednesday 22nd November 2023)"
	revision: "8"

class
	EL_BORROWED_ZSTRING_CURSOR

inherit
	EL_BORROWED_STRING_CURSOR [ZSTRING]
		undefine
			bit_count
		redefine
			copied_item, sized_item, substring_item
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

create
	make

feature -- Access

	copied_item (general: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := best_item (general.count)
			inspect Class_id.character_bytes (general)
				when 'X' then
					if attached {EL_READABLE_ZSTRING} general as zstr then
						Result.append (zstr)
					end
			else
				Result.append_string_general (general)
			end
		end

	sized_item (n: INTEGER): ZSTRING
		do
			Result := best_item (n)
			Result.grow (n)
			Result.set_count (n)
		end

	substring_item (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): ZSTRING
		do
			Result := best_item (end_index - start_index + 1)
			Result.append_substring_general (general, start_index, end_index)
		end
end