note
	description: "FTP file synchronization medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-05 8:07:42 GMT (Sunday 5th May 2024)"
	revision: "6"

class
	EL_FTP_FILE_SYNC_MEDIUM

inherit
	EL_FILE_SYNC_MEDIUM
		undefine
			is_equal
		end

	EL_FTP_PROTOCOL
		rename
			set_current_directory as set_remote_home,
			current_directory as home_dir
		redefine
			Max_login_attempts
		end

create
	make_write

feature -- Basic operations

	copy_item (item: EL_FILE_SYNC_ITEM)
		do
			transfer_file (item.source_path, item.file_path)
		end

	remove_item (item: EL_FILE_SYNC_ITEM)
		-- remove old item
		do
			delete_file (item.file_path)
		end

feature {NONE} -- Constants

	Max_login_attempts: INTEGER
		once
			Result := 1000
		end

end