note
	description: "[
		Convert [$source READABLE_STRING_GENERAL] string to type conforming to [$source STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 16:50:36 GMT (Wednesday 15th March 2023)"
	revision: "6"

deferred class
	EL_TO_STRING_GENERAL_TYPE [G -> READABLE_STRING_GENERAL]

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [G]
		redefine
			new_type_description, type
		end

feature -- Access

	type: TYPE [STRING_GENERAL]

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: G; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_reference (value, index)
		end

feature {NONE} -- Implementation

	new_type_description: STRING
		-- terse English language description of type
		do
			if {ISE_RUNTIME}.type_conforms_to (type.type_id, ({STRING_GENERAL}).type_id) then
				create Result.make_empty
			else
				Result := "fixed "
			end
			if {ISE_RUNTIME}.type_conforms_to (type.type_id, ({READABLE_STRING_8}).type_id) then
				Result.append ("latin-1 string")
			else
				Result.append ("unicode string")
			end
		end
end