note
	description: "[
		Routines to supplement handling of strings conforming to [$source READABLE_STRING_8] [$source READABLE_STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-01 10:02:58 GMT (Friday 1st July 2022)"
	revision: "3"

deferred class
	EL_READABLE_STRING_X_ROUTINES [READABLE_STRING_X -> READABLE_STRING_GENERAL]

inherit
	STRING_HANDLER

feature -- Status query

	has_double_quotes (s: READABLE_STRING_X): BOOLEAN
			--
		do
			Result := has_quotes (s, 2)
		end

	has_enclosing (s, ends: READABLE_STRING_X): BOOLEAN
			--
		require
			ends_has_2_characters: ends.count = 2
		do
			Result := s.count >= 2
				and then s.item (1) = ends.item (1) and then s.item (s.count) = ends.item (2)
		end

	has_quotes (s: READABLE_STRING_X; type: INTEGER): BOOLEAN
		require
			double_or_single: 1 <= type and type <= 2
		local
			quote_code: NATURAL
		do
			if type = 1 then
				quote_code := ('%'').natural_32_code
			else
				quote_code := ('"').natural_32_code
			end
			Result := s.count >= 2 and then s.code (1) = quote_code and then s.code (s.count) = quote_code
		end

	has_single_quotes (s: READABLE_STRING_X): BOOLEAN
			--
		do
			Result := has_quotes (s, 1)
		end

	is_identifier_boundary (str: READABLE_STRING_X; lower, upper: INTEGER): BOOLEAN
		-- `True' if indices `lower' to `upper' are an identifier boundary
		do
			Result := True
			if upper + 1 <= str.count then
				Result := not is_identifier_character (str, upper + 1)
			end
			if Result and then lower - 1 >= 1 then
				Result := not is_identifier_character (str, lower - 1)
			end
		end

feature -- Comparison

	caseless_ends_with (big, small: READABLE_STRING_X): BOOLEAN
		-- `True' if `big.ends_with (small)' is true regardless of case of `small'
		do
			if small.is_empty then
				Result := True

			elseif big.count >= small.count then
				Result := occurs_caseless_at (big, small, big.count - small.count + 1)
			end
		end

	occurs_at (big, small: READABLE_STRING_X; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		deferred
		end

	occurs_caseless_at (big, small: READABLE_STRING_X; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		deferred
		end

	same_caseless (a, b: READABLE_STRING_X): BOOLEAN
		-- `True' if all characters in `str' are in the ASCII character set: 0 .. 127
		do
			if a.count = b.count then
				Result := occurs_caseless_at (a, b, 1)
			end
		end

feature -- Character query

	is_identifier_character (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		deferred
		end

feature -- Substring

	adjusted (str: READABLE_STRING_X): READABLE_STRING_X
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - cursor (str).trailing_white_count
			if end_index.to_boolean then
				start_index := cursor (str).leading_white_count + 1
			else
				start_index := 1
			end
			if start_index = 1 and then end_index = str.count then
				Result := str
			else
				Result := str.substring (start_index, end_index)
			end
		end

	substring_to (str: READABLE_STRING_X; uc: CHARACTER_32; start_index_ptr: POINTER): READABLE_STRING_X
		-- substring from INTEGER at memory location `start_index_ptr' up to but not including index of `uc'
		-- or else `substring_end (start_index)' if `uc' not found
		-- `start_index' is 1 if `start_index_ptr = Default_pointer'
		-- write new start_index back to `start_index_ptr'
		-- if `uc' not found then new `start_index' is `count + 1'
		local
			start_index, index: INTEGER; pointer: EL_POINTER_ROUTINES
		do
			if start_index_ptr = Default_pointer then
				start_index := 1
			else
				start_index := pointer.read_integer (start_index_ptr)
			end
			index := str.index_of (uc, start_index)
			if index > 0 then
				Result := str.substring (start_index, index - 1)
				start_index := index + 1
			else
				Result := str.substring (start_index, str.count)
				start_index := str.count + 1
			end
			if start_index_ptr /= Default_pointer then
				start_index_ptr.memory_copy ($start_index, {PLATFORM}.Integer_32_bytes)
			end
		end

	substring_to_reversed (str: READABLE_STRING_X; uc: CHARACTER_32; start_index_from_end_ptr: POINTER): READABLE_STRING_X
		-- the same as `substring_to' except going from right to left
		-- if `uc' not found `start_index_from_end' is set to `0' and written back to `start_index_from_end_ptr'
		local
			start_index_from_end, index: INTEGER; pointer: EL_POINTER_ROUTINES
		do
			if start_index_from_end_ptr = Default_pointer then
				start_index_from_end := str.count
			else
				start_index_from_end := pointer.read_integer (start_index_from_end_ptr)
			end
			index := last_index_of (str, uc, start_index_from_end)
			if index > 0 then
				Result := str.substring (index + 1, start_index_from_end)
				start_index_from_end := index - 1
			else
				Result := str.substring (1, start_index_from_end)
				start_index_from_end := 0
			end
			if start_index_from_end_ptr /= Default_pointer then
				pointer.put_integer (start_index_from_end, start_index_from_end_ptr)
			end
		end

	truncated (str: READABLE_STRING_X; max_count: INTEGER): READABLE_STRING_X
		-- return `str' truncated to `max_count' characters, adding ellipsis where necessary
		do
			if str.count <= max_count then
				Result := str
			else
				Result := str.substring (1, max_count - 2) + Ellipsis_dots
			end
		end

feature {NONE} -- Implementation

	cursor (s: READABLE_STRING_X): EL_STRING_ITERATION_CURSOR
		deferred
		end

	last_index_of (str: READABLE_STRING_X; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		deferred
		end

feature {NONE} -- Constants

	Ellipsis_dots: STRING = ".."

end