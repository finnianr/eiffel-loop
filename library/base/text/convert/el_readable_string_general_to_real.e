note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source REAL_32] or  [$source REAL_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-14 17:07:03 GMT (Tuesday 14th November 2023)"
	revision: "5"

deferred class
	EL_READABLE_STRING_GENERAL_TO_REAL [N -> NUMERIC]

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [N]
		redefine
			is_convertible, is_convertible_substring, new_type_description
		end

	NUMERIC_INFORMATION
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `N'
		do
			if attached Convertor as l_convertor then
				shared_cursor (str).parse (l_convertor, numeric_type)
				Result := is_real (l_convertor)
			end
		end

	is_convertible_substring (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `str' is convertible to type `N'
		do
			if attached Convertor as l_convertor then
				shared_cursor (str).parse_substring (l_convertor, numeric_type, start_index, end_index)
				Result := is_real (l_convertor)
			end
		end

feature {NONE} -- Implementation

	converted (str: READABLE_STRING_GENERAL): STRING_TO_REAL_CONVERTOR
		do
			Result := Convertor
			shared_cursor (str).parse (Result, Type_no_limitation)
		end

	converted_substring (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_TO_REAL_CONVERTOR
		do
			Result := Convertor
			shared_cursor (str).parse_substring (Result, Type_no_limitation, start_index, end_index)
		end

	is_real (a_convertor: like Convertor): BOOLEAN
		deferred
		end

	new_type_description: STRING
		-- terse English language description of type
		do
			Result := Precursor + once " number"
		end

	numeric_type: INTEGER
		deferred
		end

feature {NONE} -- Constants

	Convertor: STRING_TO_REAL_CONVERTOR
		once
			Result := EL_string_8.Ctor_convertor
		end
end