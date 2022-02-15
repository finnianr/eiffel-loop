note
	description: "Unescaped URI to a directory"
	notes: "[
	  The following are two example URIs and their component parts:

			  foo://example.com:8042/over/there
			  \_/   \______________/\_________/
			   |           |            |
			scheme     authority       path
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 9:53:13 GMT (Tuesday 15th February 2022)"
	revision: "2"

class
	EL_DIR_URI_ZPATH

inherit
	EL_URI_ZPATH [EL_DIR_ZPATH]
		rename
			to_file_path as to_dir_path
		end

	EL_DIR_ZPATH
		undefine
			append_path, make, is_absolute, is_uri, last_is_empty, Separator
		redefine
			Type_file_path
		end

create
	default_create, make, make_file, make_from_encoded, make_scheme

convert
	make ({ZSTRING, STRING_32})

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_URI_ZPATH
		once
			create Result
		end

end