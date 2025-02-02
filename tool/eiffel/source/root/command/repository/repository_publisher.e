note
	description: "[
		Publishes an Eiffel repository as a website based on a set of [./library/evolicity.html Evolicity templates]
		and a configuration file listing the libraries and clusters to include.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-17 11:31:40 GMT (Thursday 17th October 2024)"
	revision: "90"

class
	REPOSITORY_PUBLISHER

inherit
	ANY

	EL_MODULE_CONSOLE; EL_MODULE_FILE; EL_MODULE_LIO

	EL_MODULE_OS; EL_MODULE_USER_INPUT

	PUBLISHER_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_file_path: FILE_PATH; a_version: STRING; a_cpu_percentage: INTEGER)
		do
			cpu_percentage := a_cpu_percentage
			log_cpu_percentage
			lio.put_line ("Reading ECF configuration files")
			create config.make (a_file_path, is_ftp_required)
			lio.put_new_line
			config.version.share (a_version)
			if config.test_mode then
				Console.show ({EL_FILE_SYNC_MANAGER})
			end

			create ecf_list.make (config)
			ecf_list.read_class_sources (a_cpu_percentage)
			ecf_list.order_by (agent {EIFFEL_CONFIGURATION_FILE}.category_and_name, True)
		end

feature -- Access

	config: PUBLISHER_CONFIGURATION

	copied_path_list: EL_FILE_PATH_LIST
		do
			Result := config.copied_path_list
		end

	ecf_list: EIFFEL_CONFIGURATION_LIST [EIFFEL_CONFIGURATION_FILE]

feature -- Measurement

	cpu_percentage: INTEGER

feature -- Basic operations

	ask_user
		do
			if attached User_input.line ("Press <Enter> to update " + User_input.ESC_to_quit) as response then
				user_quit := response.is_character ('%/27/')
			end
		end

	execute
		local
			current_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]
			sync_manager: EL_FILE_SYNC_MANAGER
		do
			if execution_count > 0 then
				copied_path_list.wipe_out
				ecf_list.update_class_sources (cpu_percentage)
			end
			create current_set.make_equal (ecf_list.class_count)
			if config.version /~ previous_version then
				output_sub_directories.do_if (agent OS.delete_tree, agent {DIR_PATH}.exists)
			end
			ecf_list.set_client_examples
			ecf_list.sink_source_subsitutions
			ecf_list.get_sync_items (current_set)

			lio.put_new_line
			ecf_list.serialize_modified (current_set)
			github_contents.serialize
			write_version

			lio.put_line ("Creating sync manager")
			if current_set.is_empty then
				create sync_manager.make_empty (config.output_dir, config.ftp_host, Html)
			else
				create sync_manager.make (current_set)
			end
			has_changes := sync_manager.has_changes
			if has_changes then
				if attached config.new_medium as medium then
					login (medium)
					if is_logged_in then
						sync_manager.track_update (medium, config.progress_display)
						lio.put_line ("Synchronized")
					else
						lio.put_line ("Login failed")
					end
				end
			else
				lio.put_line ("No changes")
			end
			execution_count := execution_count + 1
		end

feature -- Status query

	has_changes: BOOLEAN

	has_version_changed: BOOLEAN
		do
			Result := config.version /~ previous_version
		end

	is_ftp_required: BOOLEAN
		-- `False' for descendant REPOSITORY_SOURCE_LINK_EXPANDER
		do
			Result := True
		end

	is_logged_in: BOOLEAN

	user_quit: BOOLEAN

feature {NONE} -- Implementation

	github_contents: GITHUB_REPOSITORY_CONTENTS_MARKDOWN
		do
			create Result.make (Current, config.output_dir + "Contents.md")
		end

	log_cpu_percentage
		do
			lio.put_labeled_substitution ("CPU resource usage", "%S%% of available processors", [cpu_percentage])
			lio.put_new_line
		end

	login (medium: EL_FILE_SYNC_MEDIUM)
		do
			if attached {EL_FTP_FILE_SYNC_MEDIUM} medium as ftp then
				ftp.login
				is_logged_in := ftp.is_logged_in
			else
				is_logged_in := True
			end
		end

	output_sub_directories: EL_ARRAYED_LIST [DIR_PATH]
		local
			set: EL_HASH_SET [ZSTRING]; first_step: ZSTRING; relative_path: DIR_PATH
		do
			create Result.make (10)
			create set.make_equal (10)
			across ecf_list as tree loop
				relative_path := tree.item.relative_dir_path
				first_step := relative_path.first_step
				set.put (first_step)
				if set.inserted then
					Result.extend (config.output_dir #+ first_step)
				end
			end
		end

	previous_version: STRING
		do
			if version_path.exists then
				Result := File.plain_text (version_path)
			else
				create Result.make_empty
			end
		end

	version_path: FILE_PATH
		do
			Result := config.output_dir + "version.txt"
		end

	write_version
		local
			text_out: PLAIN_TEXT_FILE
		do
			create text_out.make_open_write (version_path)
			text_out.put_string (config.version)
			text_out.close
		end

feature {EIFFEL_CONFIGURATION_FILE} -- Internal attributes

	execution_count: INTEGER

end