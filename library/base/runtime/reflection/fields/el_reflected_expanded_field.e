note
	description: "Summary description for {EL_REFLECTED_EXPANDED_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 18:27:39 GMT (Wednesday 17th January 2018)"
	revision: "4"

deferred class
	EL_REFLECTED_EXPANDED_FIELD [G]

inherit
	EL_REFLECTED_FIELD

	EL_SHARED_ONCE_STRINGS

feature -- Access

	value (a_object: EL_REFLECTIVE): G
		do
			enclosing_object := a_object
			Result := field_value (index)
		end

feature -- Status query

	is_expanded: BOOLEAN
		do
			Result := True
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			Result := value (a_current) = value (other)
		end

feature {NONE} -- Implementation

	field_value (i: INTEGER): G
		deferred
		end

end
