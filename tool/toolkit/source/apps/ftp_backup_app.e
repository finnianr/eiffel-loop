note
	description: "Ftp backup app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-09 18:38:14 GMT (Monday 9th September 2019)"
	revision: "13"

class
	FTP_BACKUP_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [FTP_BACKUP_COMMAND]
		rename
			command as ftp_command
		redefine
			Option_name, ftp_command, initialize
		end

	EL_INSTALLABLE_SUB_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			Console.show ({EL_FTP_PROTOCOL})
			Precursor
		end

feature -- Test operations

	test_run
		do
--			Test.set_binary_file_extensions (<< "mp3" >>)

--			Test.do_file_tree_test ("bkup", agent test_gpg_normal_run (?, "rhythmdb.bkup"), 4026256056)
--			Test.do_file_tree_test ("bkup", agent test_normal_run (?, "id3$.bkup"), 813868097)
			Test.do_file_tree_test ("bkup", agent test_normal_run (?, "Eiffel-Loop.bkup"), 813868097)

			Test.print_checksum_list
		end

	test_gpg_normal_run (data_path: EL_DIR_PATH; backup_name: STRING)
			--
		local
			gpg_recipient: STRING
		do
			log.enter ("test_gpg_normal_run")
			ftp_command := test_backup (data_path, backup_name)

			gpg_recipient := User_input.line ("Enter an encryption recipient id for gpg")
			Execution_environment.put (gpg_recipient, "RECIPIENT")

			normal_run
			log.exit
		end

	test_normal_run (data_path: EL_DIR_PATH; backup_name: STRING)
			--
		do
			log.enter ("test_normal_run")
			ftp_command := test_backup (data_path, backup_name)
			normal_run
			log.exit
		end

	test_backup (data_path: EL_DIR_PATH; backup_name: STRING): FTP_BACKUP_COMMAND
		local
			file_list: EL_FILE_PATH_LIST
		do
			create file_list.make_from_array (<< Directory.Working.joined_dir_path (data_path) + backup_name >>)
			create Result.make (file_list, False)
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument (
					"scripts", "List of files to backup (Must be the last parameter)", << file_must_exist >>
				),
				optional_argument ("upload", "Upload the archive after creation")
			>>
		end

	default_make: PROCEDURE [like ftp_command]
		do
			Result := agent {like ftp_command}.make (create {EL_FILE_PATH_LIST}.make_with_count (0), False)
		end

	ftp_command: FTP_BACKUP_COMMAND

feature {NONE} -- Constants

	Option_name: STRING = "ftp_backup"

	Description: STRING = "Tar directories and ftp them off site"

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/General utilities/ftp backup")
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FTP_BACKUP_APP}, All_routines],
				[{ARCHIVE_FILE}, All_routines],
				[{INCLUSION_LIST_FILE}, All_routines],
				[{EXCLUSION_LIST_FILE}, All_routines],
				[{BACKUP_CONFIG}, All_routines]
			>>
		end

end
