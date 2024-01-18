note
	description: "Unix implementation of ${EL_MOVE_FILE_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_MOVE_FILE_COMMAND_IMP

inherit
	EL_MOVE_FILE_COMMAND_I

	EL_OS_COMMAND_IMP
	
create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		mv
		#if $is_file_destination then
			--no-target-directory
		#end
	 	$source_path $destination_path
	]"

end