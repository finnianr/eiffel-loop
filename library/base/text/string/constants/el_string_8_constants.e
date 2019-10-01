note
	description: "Constants for class STRING"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 14:03:31 GMT (Tuesday   1st   October   2019)"
	revision: "8"

deferred class
	EL_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implemenation

	character_string_8 (c: CHARACTER): STRING
		do
			Result := n_character_string_8 (c, 1)
		end

	n_character_string_8 (c: CHARACTER; n: NATURAL): STRING
		do
			Result := Character_string_8_table.item (n |<< 8 | c.natural_32_code)
		end

	new_filled_string_8 (key: NATURAL): STRING
		do
			create Result.make_filled (key.to_character_8, (key |>> 8).to_integer_32)
		end

feature {NONE} -- Constants

	Character_string_8_table: EL_CACHE_TABLE [STRING, NATURAL]
		once
			create Result.make_equal (7, agent new_filled_string_8)
		end

	Empty_string_8: STRING = ""

	frozen String_8_pool: EL_STRING_POOL [STRING]
		once
			create Result.make (3)
		end

invariant
	string_8_always_empty: Empty_string_8.is_empty
end
