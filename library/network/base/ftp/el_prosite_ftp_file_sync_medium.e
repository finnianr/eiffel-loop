note
	description: "${EL_FTP_FILE_SYNC_MEDIUM} adapted for fasthosts.co.uk Prosite FTP"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-08 6:18:40 GMT (Wednesday 8th May 2024)"
	revision: "1"

class
	EL_PROSITE_FTP_FILE_SYNC_MEDIUM

inherit
	EL_FTP_FILE_SYNC_MEDIUM
		rename
			receive_entry_list_count as receive_entry_list_response
		undefine
			read_entry_count, receive_entry_list_response
		end

	EL_PROSITE_FTP_PROTOCOL
		rename
			set_current_directory as set_remote_home,
			current_directory as home_dir
		undefine
			Max_login_attempts
		end

create
	make_write

end