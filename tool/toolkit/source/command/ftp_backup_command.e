note
	description: "Ftp backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 10:32:34 GMT (Tuesday 8th February 2022)"
	revision: "6"

class
	FTP_BACKUP_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_file_path: FILE_PATH; a_ask_user_to_upload: BOOLEAN)
		do
			create config.make (config_file_path)
			create archive_upload_list.make (0)
			ask_user_to_upload := a_ask_user_to_upload
		end

feature -- Access

	Description: STRING = "Create tar.gz backups and upload them with FTP protocol"

	config: BACKUP_CONFIG

	archive_upload_list: EL_ARRAYED_LIST [EL_FTP_UPLOAD_ITEM]

feature -- Basic operations

	execute
		local
			website: EL_FTP_WEBSITE; mega_bytes: REAL
		do
			archive_upload_list.wipe_out

			across config.backup_list as backup loop
				backup.item.create_archive (archive_upload_list)
			end
			mega_bytes := (config.backup_list.sum_natural (agent {FTP_BACKUP}.total_byte_count) / 1000_000).truncated_to_real

			if not config.ftp_url.is_empty and not config.ftp_home_dir.is_empty then
				lio.put_new_line
				if mega_bytes > Max_mega_bytes_to_send then
					lio.put_string ("WARNING, total backup size ")
					lio.put_real (mega_bytes)
					lio.put_string (" megabytes exceeds limit (")
					lio.put_real (Max_mega_bytes_to_send)
					lio.put_string (")")
					lio.put_new_line
				end
			end

			if ask_user_to_upload then
				if User_input.approved_action_y_n ("Copy files offsite?") then
					create website.make ([config.ftp_url, config.ftp_home_dir])
					website.login
					if website.is_logged_in then
						website.do_ftp_upload (archive_upload_list)
					end
				end
			end
		end

feature {NONE} -- Implementation: attributes

	ask_user_to_upload: BOOLEAN

feature {NONE} -- Constants

	Max_mega_bytes_to_send: REAL = 20.0
end