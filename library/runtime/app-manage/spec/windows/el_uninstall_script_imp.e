note
	description: "Windows implementation of [$source EL_UNINSTALL_SCRIPT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-22 10:08:48 GMT (Friday 22nd June 2018)"
	revision: "4"

class
	EL_UNINSTALL_SCRIPT_IMP

inherit
	EL_UNINSTALL_SCRIPT_I
		redefine
			serialize, script
		end

	EL_OS_IMPLEMENTATION

create
	make

feature -- Basic operations

	serialize
		do
			File_system.make_directory (output_path.parent)
			script.make_open_write (output_path)
			serialize_to_stream (script)
			script.close
		end

feature {NONE} -- Internal attributes

	script: EL_BATCH_SCRIPT_FILE

feature {NONE} -- Constants

	Dot_extension: STRING = "bat"

	Lio_visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		once
			create Result.make_empty
		end

	Remove_dir_and_parent_commands: ZSTRING
		once
			-- '#' = '%S' substitution marker
			Result := "[
				rmdir /S /Q #
				rmdir #
			]"
		end

	Template: STRING = "[
		@echo off
		title $title
		$application_path -uninstall
		if %ERRORLEVEL% neq 0 goto Cancelled
		call $remove_files_script_path
		del $remove_files_script_path
		echo $completion_message
		pause
		del $script_path
		:Cancelled
	]"

end
