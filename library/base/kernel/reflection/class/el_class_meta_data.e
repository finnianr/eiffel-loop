note
	description: "Class reflective meta data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-11 17:58:59 GMT (Sunday 11th December 2022)"
	revision: "58"

class
	EL_CLASS_META_DATA

inherit
	REFLECTED_REFERENCE_OBJECT
		export
			{NONE} all
		redefine
			make, enclosing_object
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as alphabetical_list,
			new_item as new_alphabetical_list,
			actual_item as actual_alphabetical_list
		end

	EL_REFLECTION_CONSTANTS

	EL_MODULE_EIFFEL

	EL_MODULE_NAMING

	EL_REFLECTION_HANDLER

	EL_STRING_8_CONSTANTS

	EL_SHARED_NEW_INSTANCE_TABLE

	EL_SHARED_READER_WRITER_TABLE

	EL_SHARED_CLASS_ID; EL_SHARED_FACTORIES

create
	make

feature {NONE} -- Initialization

	make (a_enclosing_object: like enclosing_object)
		do
			Precursor (a_enclosing_object)
			New_instance_table.extend_from_list (a_enclosing_object.new_instance_functions)
			Reader_writer_table.merge (a_enclosing_object.new_extra_reader_writer_table)
			create cached_field_indices_set.make_equal (3, agent new_field_indices_set)

			field_list := new_field_list
			field_table := field_list.to_table (a_enclosing_object)
			if attached a_enclosing_object.foreign_naming as foreign_naming then
				across field_table as table loop
					foreign_naming.inform (table.key)
				end
			end
			across enclosing_object.new_representations as representation loop
				if field_table.has_key (representation.key) then
					field_table.found_item.set_representation (representation.item)
				end
			end
		ensure then
			same_order: across field_table as table all
				table.key.is_equal (field_list.i_th (table.cursor_index).name)
			end
		end

feature -- Access

	cached_field_indices_set: EL_CACHE_TABLE [EL_FIELD_INDICES_SET, STRING]

	enclosing_object: EL_REFLECTIVE

	field_list: EL_REFLECTED_FIELD_LIST

	field_table: EL_REFLECTED_FIELD_TABLE

feature -- Basic operations

	print_fields (a_object: EL_REFLECTIVE; a_lio: EL_LOGGABLE)
		local
			name: STRING; value: ZSTRING; l_field: EL_REFLECTED_FIELD
			line_length, length: INTEGER
		do
			create value.make_empty
			if attached cached_field_indices_set.item (enclosing_object.Hidden_fields) as hidden then
				across field_list as fld loop
					l_field := fld.item
					if not hidden.has (l_field.index) then
						name := l_field.name
						value.wipe_out
						value.append_string_general (l_field.to_string (a_object))
						length := name.count + value.count + 2
						if line_length > 0 then
							a_lio.put_string (", ")
							if line_length + length > Info_line_length then
								a_lio.put_new_line
								line_length := 0
							end
						end
						a_lio.put_labeled_string (name, value)
						line_length := line_length + length
					end
				end
			end
			a_lio.put_new_line
		end

feature -- Status query

	same_data_structure (a_field_hash: NATURAL): BOOLEAN
		-- `True' if order, type and names of fields are unchanged
		do
			Result := field_list.field_hash = a_field_hash
		end

	same_fields (a_current, other: EL_REFLECTIVE; name_list: STRING): BOOLEAN
		-- `True' if all fields in `name_list' have same value
		do
			Result := True
			if attached cached_field_indices_set.item (name_list) as field_set and then attached field_list as list then
				from list.start until not Result or list.after loop
					if field_set.has (list.item.index) then
						Result := list.item.are_equal (a_current, other)
					end
					list.forth
				end
			end
		end

feature -- Comparison

	all_fields_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		local
			i, count: INTEGER
		do
			if attached field_list as list then
				count := list.count
				Result := True
				from i := 1 until not Result or i > count loop
					Result := list [i].are_equal (a_current, other)
					i := i + 1
				end
			end
		end

feature {NONE} -- Factory

	new_alphabetical_list: EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		-- fields sorted alphabetically
		do
			Result := field_list.ordered_by (agent {EL_REFLECTED_FIELD}.name, True)
		end

	new_expanded_field (index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		local
			type_id: INTEGER
		do
			type_id := field_static_type (index)
			create {EL_REFLECTED_REFERENCE [ANY]} Result.make (enclosing_object, index, name)
		end

	new_field_indices_set (field_names: detachable STRING): EL_FIELD_INDICES_SET
		do
			if field_names.is_empty then
				Result := Empty_field_indices_set
			else
				create Result.make (Current, field_names)
			end
		end

	new_field_list: EL_REFLECTED_FIELD_LIST
		-- list of field names with empty strings in place of excluded fields
		local
			i, count: INTEGER; excluded_fields: EL_FIELD_INDICES_SET
		do
			excluded_fields := new_field_indices_set (enclosing_object.Transient_fields)
			count := field_count
			create Result.make (count - excluded_fields.count)
			from i := 1 until i > count loop
				if not (is_field_transient (i) or else excluded_fields.has (i))
					and then enclosing_object.field_included (field_type (i), field_static_type (i))
				then
					if attached field_name (i) as name and then not is_once_object (name) then
						-- remove underscore used to distinguish field name from keyword
						name.prune_all_trailing ('_')
						Result.extend (new_reflected_field (i, name))
					end
				end
				i := i + 1
			end
			Result.set_order (Current)
		end

	new_reference_field (index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		local
			type_id, item_type_id: INTEGER; found: BOOLEAN
			collection_factory: EL_REFLECTED_COLLECTION_FACTORY [ANY, EL_REFLECTED_COLLECTION [ANY]]
		do
			type_id := field_static_type (index)
			across Reference_type_tables as table until found loop
				if table.item.has_type (type_id) then
					Result := Field_factory.new_item (table.item.found_item, enclosing_object, index, name)
					found := True
				end
			end
			if found then
				do_nothing

			elseif Eiffel.type_conforms_to (type_id, Class_id.COLLECTION_ANY) then
				item_type_id := Eiffel.collection_item_type (type_id)
				if item_type_id > 0 then
					collection_factory := Collection_field_factory.new_item_factory (item_type_id)
					Result := collection_factory.new_field (enclosing_object, index, name)
				else
					create {EL_REFLECTED_REFERENCE [ANY]} Result.make (enclosing_object, index, name)
				end

			else
				create {EL_REFLECTED_REFERENCE [ANY]} Result.make (enclosing_object, index, name)
			end
		end

	new_reflected_field (index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		local
			type: INTEGER
		do
			type := field_type (index)
			inspect type
				when Reference_type then
					Result := new_reference_field (index, name)

				when Expanded_type then
					Result := new_expanded_field (index, name)
			else
				Result := Field_factory.new_item (Standard_field_types [type], enclosing_object, index, name)
			end
		end

feature {NONE} -- Implementation

	is_once_object (name: STRING): BOOLEAN
		-- `True' if `name' is a once ("OBJECT") field name
		do
			Result := name.count > 0 and then name [1] = '_'
		end

feature {NONE} -- Constants

	Collection_field_factory: EL_INITIALIZED_OBJECT_FACTORY [
		EL_REFLECTED_COLLECTION_FACTORY [ANY, EL_REFLECTED_COLLECTION [ANY]], EL_REFLECTED_COLLECTION [ANY]
	]
		once
			create Result
		end

	Empty_field_indices_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end

	Field_factory: EL_INITIALIZED_FIELD_FACTORY
		once
			create Result
		end

	Info_line_length: INTEGER
		once
			Result := 100
		end

	Reference_type_tables: ARRAY [EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY]]]
		once
			Result := <<
				String_type_table,
				Boolean_ref_type_table,
				Makeable_from_string_type_table,
				String_convertable_type_table
			>>
		end

	frozen Standard_field_types: ARRAY [TYPE [EL_REFLECTED_FIELD]]
		-- standard expanded types
		once
			create Result.make_filled ({EL_REFLECTED_CHARACTER_8}, 0, 16)
				-- Characters
				Result [Character_8_type] := {EL_REFLECTED_CHARACTER_8}
				Result [Character_32_type] := {EL_REFLECTED_CHARACTER_32}

				-- Integers
				Result [Integer_8_type] := {EL_REFLECTED_INTEGER_8}
				Result [Integer_16_type] := {EL_REFLECTED_INTEGER_16}
				Result [Integer_32_type] := {EL_REFLECTED_INTEGER_32}
				Result [Integer_64_type] := {EL_REFLECTED_INTEGER_64}

				-- Naturals
				Result [Natural_8_type] := {EL_REFLECTED_NATURAL_8}
				Result [Natural_16_type] := {EL_REFLECTED_NATURAL_16}
				Result [Natural_32_type] := {EL_REFLECTED_NATURAL_32}
				Result [Natural_64_type] := {EL_REFLECTED_NATURAL_64}

				-- Reals
				Result [Real_32_type] := {EL_REFLECTED_REAL_32}
				Result [Real_64_type] := {EL_REFLECTED_REAL_64}

				-- Others
				Result [Boolean_type] := {EL_REFLECTED_BOOLEAN}
				Result [Pointer_type] := {EL_REFLECTED_POINTER}
			end

end