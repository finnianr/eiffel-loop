note
	description: "Measureable aspects of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-29 10:51:34 GMT (Friday 29th December 2023)"
	revision: "25"

deferred class
	EL_MEASUREABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_READABLE_ZSTRING_I

feature -- Measurement

	leading_occurrences (uc: CHARACTER_32): INTEGER
		-- Returns count of continous occurrences of `uc' or white space starting from the begining
		local
			i, i_upper, block_index: INTEGER; encoded_c: CHARACTER
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			inspect uc.code
				when 0 .. Max_ascii_code then
					encoded_c := uc.to_character_8
			else
				encoded_c := Codec.encoded_character (uc)
			end
			i_upper := count - 1
			if attached area as l_area then
				if encoded_c = Substitute and then attached unencoded_area as area_32 and then area_32.count > 0 then
					from i := 0 until i > i_upper loop
						inspect l_area [i]
							when Substitute then
								Result := Result + (iter.item ($block_index, area_32, i + 1) = uc).to_integer
						else
							i := i_upper -- break out of loop
						end
						i := i + 1
					end
				else
					from i := 0 until i > i_upper loop
						-- `Unencoded_character' is space
						if l_area [i] = encoded_c then
							Result := Result + 1
						else
							i := i_upper -- break out of loop
						end
						i := i + 1
					end
				end
			end
		ensure
			substring_agrees: substring (1, Result).occurrences (uc) = Result
		end

	leading_white_space: INTEGER
		do
			Result := internal_leading_white_space (area, count)
		end

	occurrences (uc: CHARACTER_32): INTEGER
		local
			c: like area.item
		do
			inspect uc.code
				when 0 .. Max_ascii_code then
					c := uc.to_character_8
			else
				c := Codec.encoded_character (uc)
			end
			if c = Substitute then
				Result := unencoded_occurrences (uc)
			else
				Result := String_8.occurrences (Current, c)
			end
		end

	substitution_marker_count: INTEGER
		-- count of unescaped template substitution markers '%S' AKA '#'
		local
			index, escaped_count, i: INTEGER
		do
			if attached substitution_marker_index_list.area as marker_area then
				from until i = marker_area.count loop
					index := marker_area [i]
					if index - 1 > 0 and then item_8 (index - 1) = '%%' then
						escaped_count := escaped_count + 1
					end
					i := i + 1
				end
				Result := marker_area.count - escaped_count
			end
		end

	trailing_occurrences (uc: CHARACTER_32): INTEGER
			-- Returns count of continous occurrences of `uc' or white space starting from the end
		local
			i, block_index: INTEGER; encoded_c: CHARACTER
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			inspect uc.code
				when 0 .. Max_ascii_code then
					encoded_c := uc.to_character_8
			else
				encoded_c := Codec.encoded_character (uc)
			end
			if attached area as l_area then
				if encoded_c = Substitute then
					if attached unencoded_area as area_32 and then area_32.count > 0 then
						from i := count - 1 until i < 0 loop
							inspect l_area [i]
								when Substitute then
									Result := Result + (iter.item ($block_index, area_32, i + 1) = uc).to_integer
							else
								i := 0 -- break out of loop
							end
							i := i - 1
						end
					end
				else
					from i := count - 1 until i < 0 loop
						-- `Unencoded_character' is space
						if l_area [i] = encoded_c then
							Result := Result + 1
						else
							i := 0 -- break out of loop
						end
						i := i - 1
					end
				end
			end
		ensure
			substring_agrees: substring (count - Result + 1, count).occurrences (uc) = Result
		end

	trailing_white_space: INTEGER
		do
			Result := internal_trailing_white_space (area)
		end

	utf_8_byte_count: INTEGER
		do
			Result := Codec.utf_8_byte_count (area, count) + unencoded_utf_8_byte_count
		end

feature {NONE} -- Implementation

	internal_leading_white_space (a_area: like area; a_count: INTEGER): INTEGER
		local
			c32: EL_CHARACTER_32_ROUTINES; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			block_index, i: INTEGER; c_i: CHARACTER
		do
			-- `Substitute' is space
			if attached unencoded_area as area_32 and then area_32.count > 0 then
				from i := 0 until i = a_count loop
					c_i := a_area [i]
					inspect c_i
						when Substitute then
							if c32.is_space (iter.item ($block_index, area_32, i + 1)) then
								Result := Result + 1
							else
								i := a_count - 1 -- break out of loop
							end
					else
						if c_i.is_space then
							Result := Result + 1
						else
							i := a_count - 1 -- break out of loop
						end
					end
					i := i + 1
				end
			else
				from i := 0 until i = a_count loop
					c_i := a_area [i]
					if c_i.is_space then
						Result := Result + 1
					else
						i := a_count - 1 -- break out of loop
					end
					i := i + 1
				end
			end
		ensure then
			substring_agrees: substring (1, Result).is_space_filled
		end

	internal_trailing_white_space (a_area: like area): INTEGER
		local
			c32: EL_CHARACTER_32_ROUTINES; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			block_index, i: INTEGER; c_i: CHARACTER
		do
			-- `Substitute' is space
			if attached unencoded_area as area_32 and then area_32.count > 0 then
				from i := count - 1 until i < 0 loop
					c_i := a_area [i]
					inspect c_i
						when Substitute then
							if c32.is_space (iter.item ($block_index, area_32, i + 1)) then
								Result := Result + 1
							else
								i := 0 -- break out of loop
							end
					else
						if c_i.is_space then
							Result := Result + 1
						else
							i := 0 -- break out of loop
						end
					end
					i := i - 1
				end
			else
				from i := count - 1 until i < 0 loop
					if a_area [i].is_space then
						Result := Result + 1
					else
						i := 0 -- break out of loop
					end
					i := i - 1
				end
			end
		end

end