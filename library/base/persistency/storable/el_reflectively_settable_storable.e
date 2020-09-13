note
	description: "[
		Object that can read and write itself to a memory buffer of type [$source EL_MEMORY_READER_WRITER].
		Field reading, writing and object comparison is handled using class reflection.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-13 10:53:07 GMT (Sunday 13th September 2020)"
	revision: "23"

deferred class
	EL_REFLECTIVELY_SETTABLE_STORABLE

inherit
	EL_STORABLE
		undefine
			is_equal, print_meta_data
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_storable_field,
			export_name as export_default,
			import_name as import_default
		export
			{EL_MEMORY_READER_WRITER} make_default, generating_type
		redefine
			is_equal, new_meta_data, use_default_values, Except_fields
		end

	EL_MODULE_LIO

	EL_MODULE_EXECUTABLE

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		local
			field_array: EL_REFLECTED_FIELD_LIST
			i, field_count: INTEGER_32
		do
			field_array := Meta_data_by_type.item (Current).field_list
			field_count := field_array.count
			from i := 1 until i > field_count loop
				write_field (field_array [i], a_writer)
				i := i + 1
			end
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		local
			field_array: EL_REFLECTED_FIELD_LIST
			i, field_count: INTEGER_32
		do
			field_array := Meta_data_by_type.item (Current).field_list
			field_count := field_array.count
			from i := 1 until i > field_count loop
				read_field (field_array [i], a_reader)
				i := i + 1
			end
		end

feature -- Status query

	ordered_alphabetically: BOOLEAN
		-- when `True' read/write fields in alphabetical order of field name
		do
		end

feature {EL_STORABLE_CLASS_META_DATA} -- Implementation

	adjust_field_order (fields: EL_REFLECTED_FIELD_LIST)
		do
			if ordered_alphabetically then
				fields.order_by (agent {EL_REFLECTED_FIELD}.name, True)
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Comparison
		do
			Result := all_fields_equal (other)
		end

feature {EL_STORABLE_CLASS_META_DATA} -- Access

	field_hash: NATURAL_32
		-- CRC checksum for field names and types of generating type
		deferred
		end

feature {NONE} -- Implementation

	is_storable_field (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			Result := Eiffel.is_storable_type (basic_type, type_id)
		end

	new_meta_data: EL_STORABLE_CLASS_META_DATA
		local
			exception: POSTCONDITION_VIOLATION; field_structure_error: STRING
		do
			create Result.make (Current)
			if not Result.same_data_structure (field_hash) then
				field_structure_error := "ERROR: Field structure has changed"
				lio.put_new_line
				lio.put_labeled_string ("class " + generator, field_structure_error)
				lio.put_new_line
				print_field_meta_data (lio, Result.field_list.to_array)
				lio.put_new_line
				if not Executable.is_work_bench then
					create exception
					exception.set_description (field_structure_error)
					exception.raise
				end
			end
		ensure then
			same_data_structure: Result.same_data_structure (field_hash)
		end

	read_field (field: EL_REFLECTED_FIELD; a_reader: EL_MEMORY_READER_WRITER)
			-- Read operations
		do
			if attached {EL_REFLECTED_READABLE [ANY]} field as readable then
				readable.read (Current, a_reader)
			else
				field.set_from_readable (Current, a_reader)
			end
		end

	use_default_values: BOOLEAN
		do
			Result := True
		end

	write_field (field: EL_REFLECTED_FIELD; a_writer: EL_MEMORY_READER_WRITER)
			-- Write operations
		do
			if attached {EL_REFLECTED_STORABLE} field as storable_field then
				storable_field.write (Current, a_writer)
			else
				field.write (Current, a_writer)
			end
		end

feature {NONE} -- Constants

	Except_fields: STRING_8
			-- list of comma-separated fields to be excluded
		once
			Result := Precursor + ", is_deleted"
		end

note
	notes: "[
		There is support for automatic serialization fo the following types of field:

		**1.** All basic types and string references

		**2.** All references conforming to [$source EL_STORABLE]

		**3.** TUPLE with type members that are either basic types or string references

		Override the once string Except_fields to list any fields which should not be stored.

			Except_fields: STRING
				once
					Result := Precursor + ", foo_bar"
				end

		**Initialization**

		Routine `make_default' automatically initializes attribute fields as follows:

		**1.** String references are automatically initialized to a shared empty string.

		**2.** TUPLE references are initialized with a new tuple of the appropriate type.
		Any string tuple members are initialized to a shared empty string.

		**3.** Any type that is listed in a redefinition of routine `{[$source EL_REFLECTIVE]}.default_values'
	]"

end

