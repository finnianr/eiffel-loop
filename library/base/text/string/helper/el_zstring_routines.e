note
	description: "Convenience routines for [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-29 12:33:56 GMT (Monday 29th October 2018)"
	revision: "8"

class
	EL_ZSTRING_ROUTINES

feature {EL_MODULE_ZSTRING} -- Conversion

	as_zstring, to (str: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (str)
		end

	joined (separator: CHARACTER_32; a_list: ITERABLE [ZSTRING]): ZSTRING
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_from_list (a_list)
			Result := list.joined (separator)
		end

end
