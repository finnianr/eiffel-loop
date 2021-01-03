note
	description: "General string unescaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-03 17:42:57 GMT (Sunday 3rd January 2021)"
	revision: "1"

deferred class
	EL_STRING_GENERAL_UNESCAPER [S -> READABLE_STRING_GENERAL]

inherit
	HASH_TABLE [NATURAL, NATURAL]
		rename
			make as make_table
		export
			{NONE} all
		end

	STRING_HANDLER undefine copy, is_equal end

feature {NONE} -- Initialization

	make (escape_character: CHARACTER_32; table: HASH_TABLE [CHARACTER_32, CHARACTER_32])
		local
			key_code, code: NATURAL
		do
			make_table (table.count + 1)
			across table as char loop
				key_code := character_to_code (char.key)
				code := character_to_code (char.item)
				extend (code, key_code)
			end
			escape_code := character_to_code (escape_character)
		end

feature -- Access

	unescaped (str: S): STRING_GENERAL
		deferred
		end

feature -- Element change

	set_escape_character (escape_character: CHARACTER_32)
		do
			remove (escape_code)
			escape_code := character_to_code (escape_character)
			put (escape_code, escape_code)
		end

feature {NONE} -- Implementation

	character_to_code (character: CHARACTER_32): NATURAL
		do
			Result := character.natural_32_code
		end

	i_th_code (str: S; index: INTEGER): NATURAL
		do
			Result := str.code (index)
		end

	numeric_sequence_count (str: S; index: INTEGER): INTEGER
		do
		end

	sequence_count (str: S; index: INTEGER): INTEGER
		do
			if index <= str.count then
				if has_key (i_th_code (str, index)) then
					-- `found_item' is referenced in `unescaped_code'
					Result := 1
				else
					Result := numeric_sequence_count (str, index)
				end
			end
		end

	unescaped_code (index, a_sequence_count: INTEGER): NATURAL
		do
			if a_sequence_count = 1 and then found then
				Result := found_item
			end
		end

feature {NONE} -- Internal attributes

	escape_code: NATURAL

end