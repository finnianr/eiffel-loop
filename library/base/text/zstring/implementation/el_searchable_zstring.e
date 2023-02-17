note
	description: "Searchable aspects of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-17 9:13:05 GMT (Friday 17th February 2023)"
	revision: "21"

deferred class
	EL_SEARCHABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

feature -- Access

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			c: CHARACTER
		do
			if uc.code <= Max_7_bit_code then
				Result := internal_index_of (uc.to_character_8, start_index)
			else
				c := Codec.encoded_character (uc)
				if c = Substitute then
					Result := unencoded_index_of (uc, start_index)
				else
					Result := internal_index_of (c, start_index)
				end
			end
		ensure then
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
			zero_if_absent: (Result = 0) = not substring (start_index, count).has (uc)
			found_if_present: substring (start_index, count).has (uc) implies item (Result) = uc
			none_before: substring (start_index, count).has (uc) implies
				not substring (start_index, Result - 1).has (uc)
		end

	index_of_z_code (a_z_code: NATURAL; start_index: INTEGER): INTEGER
		do
			if a_z_code <= 0xFF then
				Result := internal_index_of (a_z_code.to_character_8, start_index)
			else
				Result := unencoded_index_of (z_code_to_unicode (a_z_code).to_character_32, start_index)
			end
		ensure then
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
			zero_if_absent: (Result = 0) = not substring (start_index, count).has_z_code (a_z_code)
			found_if_present: substring (start_index, count).has_z_code (a_z_code) implies z_code (Result) = a_z_code
			none_before: substring (start_index, count).has_z_code (a_z_code) implies
				not substring (start_index, Result - 1).has_z_code (a_z_code)
		end

	last_index_of (uc: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
			-- Position of last occurrence of `c',
			-- 0 if none.
		local
			c: CHARACTER
		do
			if uc.code <= Max_7_bit_code then
				Result := internal_last_index_of (uc.to_character_8, start_index_from_end)
			else
				c := Codec.encoded_character (uc)
				if c = Substitute then
					Result := unencoded_last_index_of (uc, start_index_from_end)
				else
					Result := internal_last_index_of (c, start_index_from_end)
				end
			end
		end

	substring_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		local
			has_mixed_in_range: BOOLEAN
		do
			has_mixed_in_range := has_unencoded_between_optimal (area, start_index, count)
			inspect current_other_bitmap (has_mixed_in_range, other.has_mixed_encoding)
				when Only_current, Neither then
					Result := String_8.substring_index (Current, other, start_index)

				when Both_have_mixed_encoding then
--					Result := mixed_encoding_substring_index (other, start_index, count)
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (current_readable, other.as_expanded (1), start_index, count)

				when Only_other then
					Result := 0
			else
			end
		end

	substring_index_general (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := substring_index (adapted_argument (other, 1), start_index)
		end

	substring_index_in_bounds (other: EL_READABLE_ZSTRING; start_pos, end_pos: INTEGER): INTEGER
		local
			has_mixed_in_range: BOOLEAN
		do
			has_mixed_in_range := has_unencoded_between_optimal (area, start_pos, end_pos)

			inspect current_other_bitmap (has_mixed_in_range, other.has_mixed_encoding)
				when Both_have_mixed_encoding then
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (current_readable, other.as_expanded (1), start_pos, end_pos)
				when Only_current, Neither then
					Result := String_8.substring_index_in_bounds (Current, other, start_pos, end_pos)
				when Only_other then
					Result := 0
			else
			end
		end

	substring_index_in_bounds_general (other: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER): INTEGER
		do
			Result := substring_index_in_bounds (adapted_argument (other, 1), start_pos, end_pos)
		end

	substring_right_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		-- index to right of first occurrence of `other' if valid index or else 0
		do
			Result := substring_index (other, start_index)
			if Result > 0 then
				Result := Result + other.count
			end
		end

	substring_right_index_general (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := substring_index_general (other, start_index)
			if Result > 0 then
				Result := Result + other.count
			end
		end

	word_index (word: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		local
			has_left_boundary, has_right_boundary, found: BOOLEAN
			index: INTEGER
		do
			from index := start_index; Result := 1 until Result = 0 or else found or else index + word.count - 1 > count loop
				Result := substring_index (word, index)
				if Result > 0 then
					has_left_boundary := Result = 1 or else not is_alpha_numeric_item (Result - 1)
					has_right_boundary := Result + word.count - 1 = count or else not is_alpha_numeric_item (Result + word.count)
					if has_left_boundary and has_right_boundary then
						found := True
					else
						index := Result + 1
					end
				end
			end
		end

	word_index_general (word: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := word_index (adapted_argument (word, 1), start_index)
		end

feature {NONE} -- Implementation

	internal_substring_index_list (str: EL_READABLE_ZSTRING): ARRAYED_LIST [INTEGER]
		-- shared list of indices of `str' occurring in `Current'
		local
			index, l_count, str_count: INTEGER; unencoded: like unencoded_indexable
			str_z_code: NATURAL; str_character: CHARACTER; str_uc: CHARACTER_32
			searcher: like String_searcher; pattern: READABLE_STRING_GENERAL
		do
			l_count := count; str_count := str.count
			Result := Once_substring_indices; Result.wipe_out
			if str = Current or else str_count = 0 then
				Result.extend (1)

			elseif str_count <= l_count then
				inspect respective_encoding (str)
					when Both_have_mixed_encoding then
						if str_count = 1 then
							str_z_code := str.z_code (1)
							if str_z_code > 0xFF then
								str_uc := z_code_to_unicode (str_z_code).to_character_32
								unencoded := unencoded_indexable
							else
								str_character := str.area [0]
							end
						else
							searcher := String_searcher
							pattern := str.as_expanded (1)
							searcher.initialize_deltas (pattern)
						end
						from index := 1 until index = 0 or else index > l_count - str_count + 1 loop
							if str_z_code.to_boolean then
								if str_character /= '%U' then
									index := internal_index_of (str_character, index)
								else
									index := unencoded.index_of (str_uc, index)
								end
							else
								index := searcher.substring_index_with_deltas (current_readable, pattern, index, l_count)
							end
							if index > 0 then
								Result.extend (index)
								index := index + str_count
							end
						end
					when Only_other then
						-- cannot find `str'
						do_nothing

					when Only_current, Neither then
						from index := 1 until index = 0 or else index > l_count - str_count + 1 loop
							index := String_8.substring_index (Current, str, index)
							if index > 0 then
								Result.extend (index)
								index := index + str_count
							end
						end

				else
				end
			end
		end

	is_alpha_numeric_item (i: INTEGER): BOOLEAN
		deferred
		end

	same_characters_zstring (other: EL_READABLE_ZSTRING; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- the same characters of current string starting at index `index_pos'
		deferred
		end

feature {NONE} -- Constants

	String_searcher: EL_ZSTRING_SEARCHER
		once
			create Result.make
		end

end