note
	description: "Eiffel source code routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-19 10:47:04 GMT (Friday 19th January 2024)"
	revision: "10"

expanded class
	EL_EIFFEL_SOURCE_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_EIFFEL_KEYWORDS

	EL_EIFFEL_CONSTANTS

	STRING_HANDLER

feature -- Conversion

	class_name (text: ZSTRING): ZSTRING
		local
			break: BOOLEAN; i: INTEGER; c: CHARACTER
		do
			create Result.make (text.count)
			if starts_with_upper_letter (text) then
				Result.append_character (text [1])
				from i := 2 until i > text.count or break loop
					c := text.item_8 (i)
					if Class_name_character_set.has (c) then
						Result.append_character (c)
					else
						break := True
					end
					i := i + 1
				end
			end
		end

	parsed_class_name (text: ZSTRING): ZSTRING
		-- class name parsed from text with possible generic parameter list
		-- Eg. "HASH_TABLE [G, K -> HASHABLE]"
		local
			pos_bracket: INTEGER
		do
			pos_bracket := text.index_of ('[', 1)
			if pos_bracket > 0 then
				-- remove class parameter
				Result := text.substring (1, pos_bracket - 1)
				Result.right_adjust
				Result := class_name (Result)
			else
				Result := class_name (text)
			end
		end

feature -- Status query

	is_class_definition_start (line: ZSTRING): BOOLEAN
		do
			Result := across Class_declaration_keywords as list some line.starts_with (list.item) end
		end

	is_class_name (text: ZSTRING): BOOLEAN
		do
			Result := starts_with_upper_letter (text) and then text.has_only_8 (Class_name_character_set)
		end

	is_reserved_word (word: ZSTRING): BOOLEAN
		do
			Result := Reserved_word_set.has (word)
		end

	is_type_name (text: ZSTRING): BOOLEAN
		do
			Result := starts_with_upper_letter (text) and then text.has_only_8 (Type_name_character_set)
		end

feature {NONE} -- Implementation

	starts_with_upper_letter (text: ZSTRING): BOOLEAN
		do
			if text.count > 0 then
				inspect text.item_8 (1)
					when 'A' .. 'Z' then
						Result := True
				else
				end
			end
		end

feature -- Constants

	Class_name_character_set: EL_EIFFEL_CLASS_NAME_CHARACTER_SET
		-- Set of characters permissible in class name
		once
			create Result
		end
	Type_name_character_set: EL_EIFFEL_TYPE_NAME_CHARACTER_SET
		-- Set of characters permissible in type name (which may have generic parameters)
		once
			create Result
		end

end