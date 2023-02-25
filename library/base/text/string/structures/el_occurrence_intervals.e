note
	description: "[
		List of all occurrence intervals of a `search_string' in a string conforming to
		[$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-23 15:31:54 GMT (Thursday 23rd February 2023)"
	revision: "18"

class
	EL_OCCURRENCE_INTERVALS

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as make_sized,
			fill as fill_from
		redefine
			make_empty
		end

	EL_STRING_8_CONSTANTS

create
	make, make_empty, make_by_string, make_sized

feature {NONE} -- Initialization

	make (a_target: READABLE_STRING_GENERAL; search_character: CHARACTER_32)
		do
			make_empty
			fill (a_target, search_character, 0)
		end

	make_by_string (a_target, search_string: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		do
			make_empty
			fill_by_string (a_target, search_string, 0)
		end

	make_empty
		do
			area_v2 := Default_area
		end

feature -- Basic operations

	fill (a_target: READABLE_STRING_GENERAL; search_character: CHARACTER_32; adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			fill_intervals (a_target, Empty_string_8, search_character, adjustments)
		end

	fill_by_string (a_target, search_string: READABLE_STRING_GENERAL; adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			if search_string.count = 1 then
				fill_intervals (a_target, Empty_string_8, search_string [1], adjustments)
			else
				fill_intervals (a_target, search_string, '%U', adjustments)
			end
		end

feature -- Contract Support

	valid_adjustments (bitmap: INTEGER): BOOLEAN
		do
			Result := 0 <= bitmap and then bitmap <= {EL_STRING_ADJUST}.Both
		end

feature {NONE} -- Implementation

	extend_buffer (
		a_target: READABLE_STRING_GENERAL
		l_area: like Intervals_buffer; search_index, search_string_count, adjustments: INTEGER
		final: BOOLEAN
	)
		do
			if not final then
				l_area.extend (search_index, search_index + search_string_count - 1)
			end
		end

	fill_intervals (
		a_target, search_string: READABLE_STRING_GENERAL; search_character: CHARACTER_32
		adjustments: INTEGER
	)
		require
			valid_search_string: search_string.count /= 1
		local
			i, string_count, search_string_count, search_index: INTEGER
			l_area: like Intervals_buffer; string_8_target: detachable STRING_8
			search_character_8: CHARACTER
		do
			l_area := Intervals_buffer
			l_area.wipe_out

			string_count := a_target.count
			if search_string.is_empty then
				search_string_count := 1
			else
				search_string_count := search_string.count
			end
			if search_string_count = 1 and then attached {READABLE_STRING_8} a_target as str_8 then
				string_8_target := str_8; search_character_8 := search_character.to_character_8
			end
			from i := 1 until i = 0 or else i > string_count - search_string_count + 1 loop
				if search_string_count = 1 then
					if attached string_8_target as str_8 then
						i := str_8.index_of (search_character_8, i)
					else
						i := a_target.index_of (search_character, i)
					end
				else
					i := a_target.substring_index (search_string, i)
				end
				if i > 0 then
					search_index := i
					extend_buffer (a_target, l_area, search_index, search_string_count, adjustments, False)
					i := i + search_string_count
				end
			end
			extend_buffer (a_target, l_area, search_index, search_string_count, adjustments, True)
			make_sized (l_area.count)
			area.copy_data (l_area.area, 0, 0, l_area.count * 2)
		end

feature {NONE} -- Constants

	Default_area: SPECIAL [INTEGER]
		once
			create Result.make_empty (0)
		end

	Intervals_buffer: EL_ARRAYED_INTERVAL_LIST
		once
			create Result.make (50)
		end
end