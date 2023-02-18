﻿note
	description: "Test strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-18 15:30:12 GMT (Saturday 18th February 2023)"
	revision: "8"

deferred class
	TEST_STRINGS [S -> STRING_GENERAL create make end]

inherit
	ANY

	EL_MODULE_EIFFEL

	SHARED_HEXAGRAM_STRINGS

	BENCHMARK_CONSTANTS

	STRING_HANDLER

feature {NONE} -- Initialization

	make (routines: EL_STRING_8_LIST; a_format: STRING; escape_character: CHARACTER_32)
		require
			valid_input_format:
				across new_input_arguments (a_format) as c all
					c.item.is_alpha implies c.item.is_upper
				end
		local
			parts_32: EL_STRING_LIST [S]; format_args: STRING; i, count: INTEGER
			conv: EL_UTF_CONVERTER
		do
			make_default
			format := a_format
			format_args := new_input_arguments (a_format)
			format_columns := new_format_columns (format_args)

			set_escape_character (escape_character)

			if not across General_concat_tests as name some routines.has (name.item) end then
				across Hexagram.string_arrays as array loop
					create parts_32.make (format_columns.count)
					from i := 1 until i > format_columns.upper loop
						parts_32.extend (new_filled (array.item [format_columns [i]]))
						i := i + 1
					end
					string_list.extend (parts_32.joined_words)
					if routines.has ("append_utf_8") then
						utf_8_string_list.extend (conv.string_32_to_utf_8_string_8 (string_list.last.to_string_32))

					elseif routines.has ("is_equal") then
						string_list_twin.extend (string_list.last.twin)

					elseif routines.has ("replace_character") then
						character_set_list.extend (new_character_set (string_list.last))
					end
					if across routines as name some name.item.starts_with ("ends") end then
						tail_words_list.extend (new_tail_words (string_list.last))
					end
					if across routines as name some name.item.starts_with ("starts") end then
						head_words_list.extend (new_head_words (string_list.last))
					end
				end
			end
			if a_format.starts_with (Padded) then
				pad_input_strings (format_args)
			elseif a_format.starts_with (Put_amp) then
				put_ampersands_input_strings
			elseif a_format.starts_with (Escaped) then
				escape_input_strings
			end
			across string_list as string loop
				if attached string.item as str then
					if across routines as name some Search_string_tests.has (name.item) end then
						search_string_list.extend (new_search_strings (str))
					end
					if across routines as name some Substring_tests.has (name.item) end then
						substring_list.extend (new_substrings (str))
						if routines.has ("translate") and then attached substring_list.last as last then
							substitution_list.extend (new_substitution (last))
						end
					end
					if across routines as name some Character_pair_tests.has (name.item) end then
						character_pair_list.extend ([str [1], str [str.count]])
					end
				end
			end
		end

	make_default
		do
			create string_list.make (64)
			create character_set_list.make (64)
			create utf_8_string_list.make (64)
			create string_list_twin.make (64)
			create last_word_list.make (64)
			create search_string_list.make (64)
			create substring_list.make (64)
			create character_pair_list.make (64)
			create substitution_list.make (64)
			create head_words_list.make (64)
			create tail_words_list.make (64)
		end

feature -- Access

	character_pair_list: ARRAYED_LIST [TUPLE [first_character, last_character: CHARACTER_32]]

	character_set_list: ARRAYED_LIST [EL_HASH_SET [CHARACTER_32]]

	display_format: STRING
		local
			pos_first, pos_last: INTEGER
		do
			pos_first := format.index_of ('$', 1)
			if pos_first > 0 then
				Result := format.twin
				Result.insert_character ('"', pos_first)
				pos_last := Result.last_index_of ('$', Result.count)
				Result.insert_character ('"', pos_last + 2)
			else
				Result := format
			end
		end

	format: STRING

	format_columns: ARRAY [INTEGER]

	new_string (n: INTEGER): S
		do
			create Result.make (n)
		end

	unescaped (target: S): S
		do
			Result := unescaper.unescaped (target)
		end

feature -- Test strings

	last_word_list: like string_list

	head_words_list: ARRAYED_LIST [like new_head_words]

	search_string_list: ARRAYED_LIST [like new_search_strings]

	string_list: EL_STRING_LIST [S]

	string_list_twin: like string_list

	substitution_list: ARRAYED_LIST [like new_substitution]

	substring_list: ARRAYED_LIST [like new_substrings]

	tail_words_list: ARRAYED_LIST [like new_tail_words]

	utf_8_string_list: ARRAYED_LIST [STRING]

feature -- Measurement

	storage_bytes (s: S): INTEGER
		deferred
		end

	strings_count: INTEGER
		do
			Result := Hexagram.string_arrays.count
		end

feature -- Conversion

	to_utf_8 (string: S): STRING
		deferred
		end

	xml_escaped (target: S): S
		deferred
		end

feature -- Basic operations

	append_utf_8 (target: S; utf_8: STRING)
		deferred
		end

	insert_character (target: S; uc: CHARACTER_32; i: INTEGER)
		deferred
		end

	insert_string (target, insertion: S; index: INTEGER)
		deferred
		end

	prune_all (target: S; uc: CHARACTER_32)
		deferred
		end

	remove_substring (target: S; start_index, end_index: INTEGER)
		deferred
		end

	replace_character (target: S; uc_old, uc_new: CHARACTER_32)
		deferred
		end

	replace_substring (target, insertion: S; start_index, end_index: INTEGER)
		deferred
		end

	replace_substring_all (target, original, new: S)
		deferred
		end

	to_lower (string: S)
		deferred
		end

	to_upper (string: S)
		deferred
		end

	translate (target, old_characters, new_characters: S)
		deferred
		end

	translate_general (str: S; old_characters, new_characters: READABLE_STRING_GENERAL)
		deferred
		end

	wipe_out (str: S)
		deferred
		end

feature {NONE} -- Factory

	new_character_set (str: S): EL_HASH_SET [CHARACTER_32]
		deferred
		end

	new_filled (str: READABLE_STRING_GENERAL): S
		do
			create Result.make (str.count)
			Result.append (str)
		end

	new_format_columns (a_format: STRING): ARRAY [INTEGER]
		local
			c: CHARACTER; l_array: ARRAYED_LIST [CHARACTER]; i: INTEGER
		do
			create l_array.make (4)
			if a_format.has ('$') then
				across a_format.split (' ') as str loop
					l_array.extend (str.item [str.item.count])
				end
			else
				across a_format.split (',') as str loop
					l_array.extend (str.item [1])
				end
			end
			create Result.make (1, l_array.count)
			from i := 1 until i > l_array.count loop
				c := l_array [i]
				Result [i] := c.natural_32_code.to_integer_32 - {ASCII}.upper_a + 1
				i := i + 1
			end
		end

	new_head_words (str: S): TUPLE [first_two: S; first_two_32: STRING_32]
		local
			words: EL_STRING_LIST [S]
		do
			create words.make_word_split (str)
			create Result
			Result.first_two := words.sub_list (1, words.count.min (2)).joined_words
			Result.first_two_32 := Result.first_two.to_string_32
		end

	new_input_arguments (a_format: STRING): STRING
		local
			pos_left_bracket: INTEGER
		do
			pos_left_bracket := a_format.index_of ('(', 1)
			if pos_left_bracket > 0 then
				Result := a_format.substring (pos_left_bracket + 1, a_format.count - 1)
			else
				Result := a_format
			end
		end

	new_search_strings (str: S): ARRAYED_LIST [S]
		local
			index: INTEGER
		do
			create Result.make (3)
			if attached str.split (' ') as words then
				from until Result.full loop
					if Result.is_empty then
						Result.extend (words.last)
					else
						index := words.count - Result.count
						if words.valid_index (index) then
							Result.extend (words [index] + Space + Result.last)
						else
							Result.extend (words.last + Space)
						end
					end
				end
			end
		end

	new_substitution (substrings: like new_substrings): TUPLE [old_characters, new_characters: S]
		local
			count: INTEGER
		do
			count := substrings.first_word.count.min (substrings.last_word.count)
			Result := [substrings.first_word.twin, substrings.last_word.twin]
			Result.old_characters.keep_head (count)
			Result.new_characters.keep_head (count)
		end

	new_substrings (str: S): TUPLE [first_word, middle_word, last_word, first_character, last_character: S]
		local
			count: INTEGER
		do
			create Result
			count := str.count
			if attached str.split (' ') as words then
				Result.first_word := words [1]
				Result.middle_word := words [(words.count // 2) + 1]
				Result.last_word := words [words.count]
				Result.first_character := str.substring (1, 1)
				Result.last_character := str.substring (count, count)
			end
		end

	new_tail_words (str: S): TUPLE [last_two: S; last_two_32: STRING_32]
		local
			words: EL_STRING_LIST [S]
		do
			create words.make_word_split (str)
			create Result
			Result.last_two := words.sub_list ((words.count - 1).max (1), words.count).joined_words
			Result.last_two_32 := Result.last_two.to_string_32
		end

feature {NONE} -- Implementation

	escape_input_strings
		local
			i: INTEGER
		do
			across string_list as string loop
				translate_general (string.item, " ", "\")
				from i := string.item.index_of (Pinyin_u, 1) until i = 0 loop
					insert_character (string.item, Back_slash, i)
					i := string.item.index_of (Pinyin_u, i + 2)
				end
			end
		end

	pad_input_strings (format_args: STRING)
		do
			across string_list as string loop
				if across "BC" as letter some format_args.has (letter.item) end then
					string.item.prepend (Ogham_padding); string.item.append (Ogham_padding)
				else
					string.item.prepend (Space_padding); string.item.append (Space_padding)
				end
			end
		end

	put_ampersands_input_strings
		do
			across string_list as string loop
				replace_character (string.item, ' ', '&')
			end
		end

	set_escape_character (escape_character: CHARACTER_32)
		do
			C_escape_table.remove (escape_character)
			C_escape_table [escape_character] := escape_character
			C_escape_table.set_escape_character (escape_character)
			unescaper.set_escape_character (escape_character)
		end

	unescaper: EL_STRING_GENERAL_UNESCAPER [READABLE_STRING_GENERAL, S]
		deferred
		end

end