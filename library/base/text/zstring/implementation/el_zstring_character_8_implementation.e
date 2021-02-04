note
	description: "Aspect of [$source EL_ZSTRING] as an array of 8-bit characters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-04 16:35:23 GMT (Thursday 4th February 2021)"
	revision: "13"

deferred class
	EL_ZSTRING_CHARACTER_8_IMPLEMENTATION

inherit
	STRING_HANDLER

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate space for at least `n' characters.
		do
			count := 0
			reset_hash
			create area.make_filled ('%/000/', n + 1)
		end

	make_from_string (s: READABLE_STRING_8)
		-- initialize with string that has the same encoding as codec
		local
			l_str: EL_STRING_8
		do
			l_str := Once_string_8
			l_str.make_from_string (s)
			set_from_string_8 (l_str)
		end

feature -- Access

	area: SPECIAL [CHARACTER_8]
			-- Storage for characters.

	hash_code: INTEGER
			-- Hash code value
		local
			i, nb: INTEGER; l_area: like area
		do
			l_area := area
				-- The magic number `8388593' below is the greatest prime lower than
				-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
			from i := 0; nb := count until i = nb loop
				Result := ((Result \\ 8388593) |<< 8) + l_area.item (i).natural_32_code.to_integer_32
				i := i + 1
			end
		end

	index_of (c: CHARACTER_8; start_index: INTEGER): INTEGER
			-- Position of first occurrence of `c' at or after `start_index';
			-- 0 if none.
		require
			start_large_enough: start_index >= 1
			start_small_enough: start_index <= count + 1
		local
			a: like area
			i, nb, l_lower_area: INTEGER
		do
			nb := count
			if start_index <= nb then
				from
					l_lower_area := area_lower
					i := start_index - 1 + l_lower_area
					nb := nb + l_lower_area
					a := area
				until
					i = nb or else a.item (i) = c
				loop
					i := i + 1
				end
				if i < nb then
						-- We add +1 due to the area starting at 0 and not at 1
						-- and substract `area_lower'
					Result := i + 1 - l_lower_area
				end
			end
		ensure
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
		end

	item (i: INTEGER): CHARACTER_8
			-- Character at position `i'.
		do
			Result := area.item (i - 1)
		end

	last_index_of (c: CHARACTER_8; start_index_from_end: INTEGER): INTEGER
			-- Position of last occurrence of `c',
			-- 0 if none.
		require
			start_index_small_enough: start_index_from_end <= count
			start_index_large_enough: start_index_from_end >= 1
		local
			a: like area
			i, l_lower_area: INTEGER
		do
			from
				l_lower_area := area_lower
				i := start_index_from_end - 1 + l_lower_area
				a := area
			until
				i < l_lower_area or else a.item (i) = c
			loop
				i := i - 1
			end
				-- We add +1 due to the area starting at 0 and not at 1.
			Result := i + 1 - l_lower_area
		ensure
			valid_result: 0 <= Result and Result <= start_index_from_end
			zero_if_absent: (Result = 0) = not substring (1, start_index_from_end).has (c)
			found_if_present: substring (1, start_index_from_end).has (c) implies item (Result) = c
			none_after: substring (1, start_index_from_end).has (c) implies
				not substring (Result + 1, start_index_from_end).has (c)
		end

	substring_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		do
			Result := current_string_8.substring_index (string_8_argument (other, 1), start_index)
		end

feature -- Measurement

	capacity: INTEGER
			-- Allocated space
		do
			Result := area.count - 1
		end

	count: INTEGER
			-- Actual number of characters making up the string

	occurrences (c: CHARACTER_8): INTEGER
			-- Number of times `c' appears in the string
		do
			Result := current_string_8.occurrences (c)
		ensure
			zero_if_empty: count = 0 implies Result = 0
		end

feature -- Status query

	ends_with (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION): BOOLEAN
			-- Does string finish with `s'?
		do
			Result := current_string_8.ends_with (string_8_argument (s, 1))
		ensure
			definition: Result = s.string.same_string (substring (count - s.count + 1, count))
		end

	has (c: CHARACTER_8): BOOLEAN
			-- Does string include `c'?
		do
			Result := current_string_8.has (c)
		ensure then
			false_if_empty: count = 0 implies not Result
			true_if_first: count > 0 and then item (1) = c implies Result
		end

	is_boolean: BOOLEAN
			-- Does `Current' represent a BOOLEAN?
		do
			Result := current_string_8.is_boolean
		end

	is_double, is_real_64: BOOLEAN
		do
			Result := current_string_8.is_double
		end

	is_integer, is_integer_32: BOOLEAN
		do
			Result := current_string_8.is_integer
		end

	starts_with (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION): BOOLEAN
			-- Does string begin with `s'?
		do
			Result := current_string_8.starts_with (string_8_argument (s, 1))
		ensure
			definition: Result = s.string.same_string (substring (1, s.count))
		end

	valid_index (i: INTEGER): BOOLEAN
		deferred
		end

feature -- Resizing

	adapt_size
			-- Adapt the size to accommodate `count' characters.
		do
			resize (count)
		end

	grow (newsize: INTEGER)
			-- Ensure that the capacity is at least `newsize'.
		do
			if newsize > capacity then
				resize (newsize)
			end
		end

	resize (newsize: INTEGER)
			-- Rearrange string so that it can accommodate
			-- at least `newsize' characters.
		do
			area := area.aliased_resized_area_with_default ('%/000/', newsize + 1)
		end

	trim
			-- <Precursor>
		local
			n: like count
		do
			n := count
			if n < capacity then
				area := area.aliased_resized_area (n + 1)
			end
		ensure then
			same_string: same_string (old twin)
		end

feature -- Comparison

 	same_characters (other: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `index_pos'.
		require
			valid_start_pos: other.valid_index (start_pos)
			valid_end_pos: other.valid_index (end_pos)
			valid_bounds: (start_pos <= end_pos) or (start_pos = end_pos + 1)
			valid_index_pos: valid_index (index_pos)
		local
			nb: INTEGER
		do
			nb := end_pos - start_pos + 1
			if nb <= count - index_pos + 1 then
				Result := area.same_items (other.area, other.area_lower + start_pos - 1, area_lower + index_pos - 1, nb)
			end
		ensure
			same_characters: Result = substring (index_pos, index_pos + end_pos - start_pos).same_string (other.substring (start_pos, end_pos))
		end

	same_string (other: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION): BOOLEAN
			-- Do `Current' and `other' have same character sequence?
		require
			other_not_void: other /= Void
		local
			nb: INTEGER
		do
			if other = Current then
				Result := True
			else
				nb := count
				if nb = other.count then
					Result := nb = 0 or else same_characters (other, 1, nb, 1)
				end
			end
		ensure
			definition: Result = (string ~ other.string)
		end

feature -- Conversion

	elks_checking: BOOLEAN
		deferred
		end

	linear_representation: LINEAR [CHARACTER_8]
			-- Representation as a linear structure
		do
			Result := string.linear_representation
		end

	string: EL_STRING_8
		do
			create Result.make_from_zstring (Current)
		end

	substring (start_index, end_index: INTEGER): like string
		do
			Result := string.substring (start_index, end_index)
		end

	to_boolean: BOOLEAN
		do
			Result := current_string_8.to_boolean
		end

	to_double, to_real_64: DOUBLE
		do
			Result := current_string_8.to_double
		end

	to_integer, to_integer_32: INTEGER_32
		do
			Result := current_string_8.to_integer
		end

feature {NONE} -- Element change

	fill_character (c: CHARACTER_8)
			-- Fill with `capacity' characters all equal to `c'.
		local
			l_cap: like capacity
		do
			l_cap := capacity
			if l_cap /= 0 then
				area.fill_with (c, 0, l_cap - 1)
				count := l_cap
				reset_hash
			end
		ensure
			filled: count = capacity
			same_size: capacity = old capacity
			-- all_char: For every `i' in 1..`capacity', `item' (`i') = `c'
		end

	insert_character (c: CHARACTER_8; i: INTEGER)
			-- Insert `c' at index `i', shifting characters between ranks
			-- `i' and `count' rightwards.
		require
			valid_insertion_index: 1 <= i and i <= count + 1
		local
			str: like current_string_8
		do
			str := current_string_8; str.insert_character (c, i)
			set_from_string_8 (str)
		ensure
			one_more_character: count = old count + 1
			inserted: item (i) = c
			stable_before_i: elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: elks_checking implies substring (i + 1, count) ~ (old substring (i, count))
		end

	insert_string (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; i: INTEGER)
			-- Insert `s' at index `i', shifting characters between ranks
			-- `i' and `count' rightwards.
		require
			valid_insertion_index: 1 <= i and i <= count + 1
		local
			str: like current_string_8
		do
			str := current_string_8
			str.insert_string (string_8_argument (s, 1), i)
			set_from_string_8 (str)
		ensure
			inserted: elks_checking implies (string ~ (old substring (1, i - 1) + old (s.string) + old substring (i, count)))
		end

	keep_head (n: INTEGER)
			-- Remove all characters except for the first `n';
			-- do nothing if `n' >= `count'.
		do
			if n < count then
				count := n
				reset_hash
			end
		end

	keep_tail (n: INTEGER)
			-- Remove all characters except for the last `n';
			-- do nothing if `n' >= `count'.
		local
			nb: like count
		do
			nb := count
			if n < nb then
				area.overlapping_move (nb - n, 0, n)
				count := n
				reset_hash
			end
		end

	left_adjust
			-- Remove leading whitespace.
		local
			str: like current_string_8
		do
			str := current_string_8; str.left_adjust
			set_from_string_8 (str)
		end

	prune_all (c: CHARACTER)
			-- Remove all occurrences of `c'.
		local
			str: like current_string_8
		do
			str := current_string_8; str.prune_all (c)
			set_from_string_8 (str)
		ensure then
			changed_count: count = (old count) - (old occurrences (c))
			-- removed: For every `i' in 1..`count', `item' (`i') /= `c'
		end

	replace_substring (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; start_index, end_index: INTEGER)
			-- Replace characters from `start_index' to `end_index' with `s'.
		require
			valid_start_index: 1 <= start_index
			valid_end_index: end_index <= count
			meaningfull_interval: start_index <= end_index + 1
		local
			str: like current_string_8
		do
			str := current_string_8
			str.replace_substring (string_8_argument (s, 1), start_index, end_index)
			set_from_string_8 (str)
		ensure
			new_count: count = old count + old s.count - end_index + start_index - 1
			replaced: elks_checking implies (string ~ (old (substring (1, start_index - 1) + s.string + substring (end_index + 1, count))))
		end

	replace_substring_all (original, new: EL_READABLE_ZSTRING)
		local
			str, l_original, l_new: like current_string_8
		do
			str := current_string_8
			l_original := string_8_argument (original, 1)
			l_new := string_8_argument (new, 2)
			str.replace_substring_all (l_original, l_new)
			set_from_string_8 (str)
		end

	right_adjust
			-- Remove trailing whitespace.
		local
			str: like current_string_8
		do
			str := current_string_8; str.right_adjust
			set_from_string_8 (str)
		end

feature {NONE} -- Implementation

	split (a_separator: CHARACTER): LIST [EL_STRING_8]
		do
			Result := current_string_8.split (a_separator)
		end

	mirror
		local
			str: like current_string_8
		do
			str := current_string_8; str.mirror
			set_from_string_8 (str)
		end

	share (other: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Make current string share the text of `other'.
			-- Subsequent changes to the characters of current string
			-- will also affect `other', and conversely.
		do
			area := other.area
			count := other.count
			reset_hash
		ensure
			shared_count: other.count = count
			shared_area: other.area = area
		end

feature -- Removal

	remove (i: INTEGER)
			-- Remove `i'-th character.
		local
			l_count: INTEGER
		do
			l_count := count
				-- Shift characters to the left.
			area.overlapping_move (i, i - 1, l_count - i)
				-- Update content.
			count := l_count - 1
			reset_hash
		end

	remove_substring (start_index, end_index: INTEGER)
			-- Remove all characters from `start_index'
			-- to `end_index' inclusive.
		require
			valid_start_index: 1 <= start_index
			valid_end_index: end_index <= count
			meaningful_interval: start_index <= end_index + 1
		local
			str: like current_string_8
		do
			str := current_string_8
			str.remove_substring (start_index, end_index)
			set_from_string_8 (str)
		ensure
			removed: elks_checking implies string ~ (old substring (1, start_index - 1) + old substring (end_index + 1, count))
		end

	wipe_out
			-- Remove all characters.
		do
			count := 0
		ensure then
			is_empty: count = 0
			same_capacity: capacity = old capacity
		end

feature {STRING_HANDLER} -- Implementation

	frozen set_count (number: INTEGER)
			-- Set `count' to `number' of characters.
		do
			count := number
			reset_hash
		end

feature {EL_ZSTRING_CHARACTER_8_IMPLEMENTATION} -- Implementation

	additional_space: INTEGER
		deferred
		end

	area_lower: INTEGER
			-- Minimum index
		do
		ensure
			area_lower_non_negative: Result >= 0
			area_lower_valid: Result <= area.upper
		end

	area_upper: INTEGER
			-- Maximum index
		do
			Result := area_lower + count - 1
		ensure
			area_upper_valid: Result <= area.upper
			area_upper_in_bound: area_lower <= Result + 1
		end

	copy_area (old_area: like area; other: like Current)
		do
			if old_area = Void or else old_area = other.area or else old_area.count <= count then
					-- Prevent copying of large `area' if only a few characters are actually used.
				area := area.resized_area (count + 1)
			else
				old_area.copy_data (area, 0, 0, count)
				area := old_area
			end
		end

	current_string_8: EL_STRING_8
		do
			Result := Once_string_8
			Result.set_area_and_count (area, count)
		end

	order_comparison (this, other: like area; this_index, other_index, n: INTEGER): INTEGER
			-- Compare `n' characters from `this' starting at `this_index' with
			-- `n' characters from and `other' starting at `other_index'.
			-- 0 if equal, < 0 if `this' < `other',
			-- > 0 if `this' > `other'
		require
			this_not_void: this /= Void
			other_not_void: other /= Void
			n_non_negative: n >= 0
			n_valid: n <= (this.upper - this_index + 1) and n <= (other.upper - other_index + 1)
		local
			i, j, nb: INTEGER; c, c_other: CHARACTER
		do
			from
				i := this_index
				nb := i + n
				j := other_index
			until
				i = nb
			loop
				c := this [i]; c_other := other [j]
				if c /= c_other then
					Result := c |-| c_other
					i := nb - 1 -- Jump out of loop
				end
				i := i + 1
				j := j + 1
			end
		end

	reset_hash
		deferred
		end

	set_from_ascii (str: READABLE_STRING_8)
		require
			is_7_bit: string_8.is_ascii (str)
		local
			s: STRING_8
		do
			create s.make_from_string (str)
			area := s.area
			set_count (str.count)
		end

	set_from_string_8 (str: EL_STRING_8)
		do
			area := str.area; set_count (str.count)
		end

	string_8_argument (zstr: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; index: INTEGER): EL_STRING_8
		require
			valid_index: 1 <= index and index <= 2
		do
			Result := String_8_args [index - 1]
			Result.set_area_and_count (zstr.area, zstr.count)
		end

	string_8: EL_STRING_8_ROUTINES
		do
		end

feature -- Constants

	Once_string_8: EL_STRING_8
		once
			create Result.make_empty
		end

	String_8_args: SPECIAL [EL_STRING_8]
		once
			create Result.make_filled (create {EL_STRING_8}.make_empty, 2)
			Result [1] := create {EL_STRING_8}.make_empty
		end
end