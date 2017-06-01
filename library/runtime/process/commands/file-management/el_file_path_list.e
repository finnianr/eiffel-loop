note
	description: "File path list from OS command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-31 19:58:30 GMT (Wednesday 31st May 2017)"
	revision: "2"

class
	EL_FILE_PATH_LIST

inherit
	EL_SORTABLE_ARRAYED_LIST [EL_FILE_PATH]
		rename
			make as make_with_count,
			first as first_path,
			item as path,
			last as last_path
		end

	EL_MODULE_OS
		undefine
			is_equal, copy
		end

create
	make, make_empty, make_with_count, make_from_array

feature {NONE} -- Initialization

	make (a_dir_path: EL_DIR_PATH; wildcard: STRING)
			--
		do
			make_empty
			append_files (a_dir_path, wildcard)
		end

feature -- Element change

	append_files (a_dir_path: EL_DIR_PATH; wildcard: STRING)
		do
			append (OS.file_list (a_dir_path, wildcard))
		end

end
