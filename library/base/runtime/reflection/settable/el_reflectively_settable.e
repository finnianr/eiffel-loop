note
	description: "Object with `field_table' attribute of field getter-setter's"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		Override `use_default_values' to return `False' if the default values set
		by `set_default_values' is not required.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-15 12:22:38 GMT (Monday 15th January 2018)"
	revision: "10"

deferred class
	EL_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVE
		redefine
			Except_fields, is_equal, field_table
		end

feature {NONE} -- Initialization

	make_default
		do
			if not attached field_table then
				field_table := Meta_data_by_type.item (Current).field_table
				if use_default_values then
					set_default_values
				end
			end
		end

feature -- Access

	comma_separated_names: STRING
		--
		do
			Result := field_name_list.joined (',')
		end

	comma_separated_values: ZSTRING
		--
		local
			table: like field_table; list: EL_ZSTRING_LIST; csv: like CSV_escaper
			value: ZSTRING
		do
			table := field_table; csv := CSV_escaper
			create list.make (table.count)
			create value.make_empty
			from table.start until table.after loop
				value.wipe_out
				value.append_string_general (table.item_for_iteration.to_string (Current))
				list.extend (csv.escaped (value, True))
				table.forth
			end
			Result := list.joined (',')
		end

feature {EL_REFLECTION_HANDLER} -- Access

	field_table: EL_REFLECTED_FIELD_TABLE

feature -- Element change

	set_default_values
		local
			table: like field_table
		do
			table := field_table
			from table.start until table.after loop
				table.item_for_iteration.set_default_value (Current)
				table.forth
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := all_fields_equal (other)
		end

feature {NONE} -- Implementation

	use_default_values: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Constants

	Except_fields: STRING
			-- list of comma-separated fields to be excluded
		once
			Result := "field_table"
		end

	CSV_escaper: EL_COMMA_SEPARATED_VALUE_ESCAPER
		once
			create Result.make
		end

end
