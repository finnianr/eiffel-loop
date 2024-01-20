note
	description: "Shared instance of ${EL_NATIVE_STRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SHARED_NATIVE_STRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Native_string: EL_NATIVE_STRING
		once
			create Result.make_empty (0)
		end

end