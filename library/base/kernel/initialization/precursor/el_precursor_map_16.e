note
	description: "[
		Tracks whether a routine has been called already or not during `make' precursor calls.
		This is a variation of class ${EL_PRECURSOR_MAP} but with the `done_bitmap' defined
		as ${NATURAL_16} instead of ${NATURAL_32}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_PRECURSOR_MAP_16

feature {NONE} -- Status query

	done (routine: POINTER): BOOLEAN
		-- `True' if routine with address `routine' has already been called on `Current'
		do
			Result := (done_bitmap & done_mask (routine)).to_boolean
		end

feature {NONE} -- Element change

	set_done (routine: POINTER)
		-- mark routine with address `routine' as being done for `Current'
		do
			done_bitmap := done_bitmap | done_mask (routine)
		end

feature {NONE} -- Implementation

	done_bitmap: NATURAL_16
		-- each bit refers to a make routine

	done_mask (routine: POINTER): NATURAL_16
		local
			table: like done_mask_table
		do
			table := done_mask_table
			if table.is_empty then
				table.put (1, routine)
			else
				table.put (table.found_item |<< 1, routine)
			end
			Result := table.found_item
		ensure
			no_more_than_16_flag_bits: done_mask_table.count <= {PLATFORM}.Natural_16_bits
		end

	done_mask_table: HASH_TABLE [NATURAL_16, POINTER]
		-- implement as a once function for each class heirarchy
		deferred
		end

end