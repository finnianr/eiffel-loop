note
	description: "Base class for reflected fields of common expanded types"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "28"

deferred class
	EL_REFLECTED_EXPANDED_FIELD [G]

inherit
	EL_REFLECTED_FIELD
		redefine
			value
		end

	EL_STRING_REPRESENTABLE_FIELD [G]
		undefine
			is_equal
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			set_from_integer (a_object, 0)
		end

feature -- Access

	address (a_object: EL_REFLECTIVE): POINTER
		local
			offset: INTEGER
		do
			offset := {ISE_RUNTIME}.field_offset_of_type (index, object_type)
			Result := {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0) + offset
		end

	value (a_object: EL_REFLECTIVE): G
		deferred
		end

feature -- Conversion

	to_natural_64 (a_object: EL_REFLECTIVE): NATURAL_64
		deferred
		end

feature -- Status query

	has_string_representation: BOOLEAN
		do
			Result := attached {EL_STRING_FIELD_REPRESENTATION [ANY, ANY]} representation
		end

	is_expanded: BOOLEAN
		do
			Result := True
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			Result := value (a_current) = value (other)
		end

feature -- Basic operations

	set_from_natural_64 (a_object: EL_REFLECTIVE; a_value: NATURAL_64)
		deferred
		end

feature {NONE} -- Implementation

	append_value (string: STRING_GENERAL; a_value: G)
		deferred
		end

note
	descendants: "[
			EL_REFLECTED_EXPANDED_FIELD* [G]
				${EL_REFLECTED_NUMERIC_FIELD}* [N -> ${NUMERIC}]
					${EL_REFLECTED_INTEGER_8}
					${EL_REFLECTED_INTEGER_16}
					${EL_REFLECTED_INTEGER_32}
					${EL_REFLECTED_INTEGER_64}
					${EL_REFLECTED_NATURAL_8}
					${EL_REFLECTED_NATURAL_32}
					${EL_REFLECTED_NATURAL_16}
					${EL_REFLECTED_REAL_32}
					${EL_REFLECTED_REAL_64}
					${EL_REFLECTED_NATURAL_64}
				${EL_REFLECTED_CHARACTER_8}
				${EL_REFLECTED_CHARACTER_32}
				${EL_REFLECTED_BOOLEAN}
				${EL_REFLECTED_POINTER}
	]"
end