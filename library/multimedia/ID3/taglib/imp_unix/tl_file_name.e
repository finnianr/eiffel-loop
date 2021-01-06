note
	description: "[
		Wraps Taglib::FileName <tiostream.h>
			typedef const char *FileName;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 9:45:57 GMT (Tuesday 5th January 2021)"
	revision: "5"

class
	TL_FILE_NAME

inherit
	TL_FILE_NAME_I

	MANAGED_POINTER
		rename
			make as make_sized
		export
			{NONE} all
			{EL_C_OBJECT} item, count
		end

	EL_SHARED_ONCE_STRING_8

create
	make, make_from_string

convert
	make ({EL_FILE_PATH})

feature {NONE} -- Initialization

	make_from_string (name: ZSTRING)
		local
			utf_8: STRING; to_c: ANY
		do
			utf_8 := once_empty_string_8
			name.append_to_utf_8 (utf_8)
			to_c := utf_8.to_c
			make_from_pointer ($to_c, utf_8.count + 1)
		end
end