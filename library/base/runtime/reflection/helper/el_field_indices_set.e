note
	description: "Sorted set of field indices for reflected object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-30 10:05:50 GMT (Sunday 30th January 2022)"
	revision: "12"

class
	EL_FIELD_INDICES_SET

inherit
	ARRAY [INTEGER]
		rename
			make as make_count
		end

	EL_STRING_8_CONSTANTS

create
	make, make_empty, make_from_reflective, make_for_any

feature {NONE} -- Initialization

	make_for_any (field_table: EL_REFLECTED_FIELD_TABLE)
		do
			make_filled (0, 1, field_table.count)
			across field_table as table loop
				put (table.item.index, table.cursor_index)
			end
		end

	make_from_reflective (object: EL_REFLECTIVE; field_names: STRING)
		do
			make (create {REFLECTED_REFERENCE_OBJECT}.make (object), field_names)
		end

	make (reflected: REFLECTED_REFERENCE_OBJECT; field_names: STRING)
		local
			field_list: EL_SPLIT_STRING_8_LIST; i, j, field_count: INTEGER
		do
			if field_names.is_empty then
				make_empty
			else
				create field_list.make_adjusted (field_names, ',', {EL_STRING_ADJUST}.Left)

				make_filled (0, 1, field_list.count)
				field_count := reflected.field_count
				from i := 1 until i > field_count loop
					if field_list.has (reflected.field_name (i)) then
						j := j + 1
						put (i, j)
					end
					i := i + 1
				end
			end
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := not has (0)
		end

end