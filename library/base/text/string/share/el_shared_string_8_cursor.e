note
	description: "Shared instance of ${EL_STRING_8_ITERATION_CURSOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

deferred class
	EL_SHARED_STRING_8_CURSOR

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	cursor_8 (s: READABLE_STRING_8): EL_STRING_8_ITERATION_CURSOR
		do
			Result := String_8_iteration_cursor
			Result.make (s)
		end

feature {NONE} -- Constants

	String_8_iteration_cursor: EL_STRING_8_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end