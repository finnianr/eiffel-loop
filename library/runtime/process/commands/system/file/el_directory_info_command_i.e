note
	description: "Command to find file count and directory file content size"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-26 17:47:28 GMT (Tuesday 26th May 2020)"
	revision: "4"

deferred class
	EL_DIRECTORY_INFO_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as target_path,
			set_dir_path as set_target_path
		undefine
			do_command, new_command_parts
		redefine
			make, var_name_path, reset
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			make_default
		redefine
			reset
		end

feature {NONE} -- Initialization

	make (a_target_path: like target_path)
			--
		do
			Precursor (a_target_path)
			execute
		end

feature -- Access

	file_count: INTEGER

	size: INTEGER

feature {NONE} -- Evolicity reflection

	Var_name_path: STRING = "target_path"

feature {NONE} -- Implementation

	reset
		do
			Precursor {EL_CAPTURED_OS_COMMAND_I}
			file_count := 0
			size := 0
		end
end
