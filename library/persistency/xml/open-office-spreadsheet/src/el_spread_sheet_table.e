note
	description: "Object representing table in OpenDocument Flat XML format spreadsheet"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 16:14:44 GMT (Thursday 3rd February 2022)"
	revision: "7"

class
	EL_SPREAD_SHEET_TABLE

inherit
	ARRAYED_LIST [EL_SPREAD_SHEET_ROW]
		rename
			make as make_rows,
			item as row,
			first as first_row,
			last as last_row
		end

	EL_OPEN_OFFICE
		undefine
			copy, is_equal
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (table_node: EL_XPATH_NODE_CONTEXT; defined_ranges: EL_ZSTRING_HASH_TABLE [ZSTRING])
			--
		local
			l_column_table: like column_table
		do
			if is_lio_enabled then
				lio.put_labeled_substitution (generator, "make (%"%S%")", [table_node.attributes ["table:name"]])
				lio.put_new_line
			end
			name := table_node.attributes ["table:name"]
			l_column_table := column_table (defined_ranges)
			if not l_column_table.is_empty then
				columns := l_column_table.current_keys
			end
			make_rows (table_node.integer_at_xpath ("count (table:table-row)"))
			if capacity > 0 then
				append_rows (table_node.context_list ("table:table-row"), l_column_table)
			end
			if is_lio_enabled then
				lio.put_labeled_substitution ("Size", "%S rows X %S columns", [count, maximum_column_count])
				lio.put_new_line
			end
		end

feature -- Access

	name: ZSTRING

	columns: ARRAY [ZSTRING]

	maximum_column_count: INTEGER
		do
			across Current as l_row loop
				if l_row.item.count > Result then
					Result := l_row.item.count
				end
			end
		end

feature -- Removal

	prune_trailing_blank_rows
			-- prune trailing empty rows
		do
			from finish until before or else not row.is_blank loop
				remove; finish
			end
		end

feature {NONE} -- Implementation

	append_rows (row_list: EL_XPATH_NODE_CONTEXT_LIST; a_column_table: like column_table)
		local
			new_row: EL_SPREAD_SHEET_ROW
			col_count, count_repeated, i: INTEGER
		do
			row_list.start
			if not row_list.after then
				col_count := row_list.context.integer_at_xpath ("count (table:table-cell)")
				from until row_list.after loop
					if row_list.context.attributes.has (Attribute_number_rows_repeated) then
						count_repeated := row_list.context.attributes.integer (Attribute_number_rows_repeated)
						-- Ignore large repeat count occurring at end of every table
						if count_repeated > Maximum_repeat_count then
							count_repeated := 1
						end
					else
						count_repeated := 1
					end
					create new_row.make (row_list.context.context_list (Xpath_table_cell), col_count, a_column_table)
					from i := 1 until i > count_repeated loop
						if i = 1 then
							extend (new_row)
						else
							extend (new_row.deep_twin)
						end
						i := i + 1
					end
					row_list.forth
				end
			end
		end

	column_table (defined_ranges: EL_ZSTRING_HASH_TABLE [ZSTRING]): EL_ZSTRING_HASH_TABLE [INTEGER]

		local
			cell_range_address: EL_ZSTRING_LIST; column_interval: INTEGER_INTERVAL
		do
			create Result.make_equal (11)
			create columns.make_empty
			across defined_ranges as range loop
				create cell_range_address.make_adjusted_split (range.key, '.', {EL_STRING_ADJUST}.Left)
				cell_range_address.first.remove_quotes
				if cell_range_address.first ~ name then
					create column_interval.make (
						cell_range_address.i_th (2).z_code (1).to_integer_32 - 64,
						cell_range_address.i_th (3).z_code (1).to_integer_32 - 64
					)
					if column_interval.count = 1 then
						Result [range.item] := column_interval.lower
					end
				end
			end
		end

feature {NONE} -- Constants

	Xpath_table_cell: STRING_32 = "table:table-cell"

	Attribute_number_rows_repeated: STRING_32 = "table:number-rows-repeated"

	Maximum_repeat_count: INTEGER
		once
			Result := 1000
		end
end