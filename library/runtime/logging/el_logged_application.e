note
	description: "Logged sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-20 14:59:03 GMT (Tuesday 20th June 2023)"
	revision: "23"

deferred class
	EL_LOGGED_APPLICATION

inherit
	EL_APPLICATION
		rename
			init_console as init_console_and_logging
		undefine
			new_lio
		redefine
			do_application, help_requested, init_console_and_logging, io_put_header, print_help,
			standard_options
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_SHARED_LOG_OPTION

feature -- Status query

	help_requested: BOOLEAN
		-- `True' if user requested help or other information
		do
			Result := App_option.help or Log_option.log_filters
		end

	is_logging_active: BOOLEAN
		do
			Result := Log_option.logging
		end

	is_logging_initialized: BOOLEAN

feature -- Basic operations

	print_help
		do
			if Log_option.log_filters then
				lio.put_labeled_string ("LOGGED ROUTINES", "(All threads)")
				lio.put_new_line
				lio.tab_right

				across Log_filter_list_table.item (Current) as list loop
					list.item.print_to (lio)
					if not list.is_last then
						lio.put_new_line
					end
				end
				lio.tab_left; lio.put_new_line
			else
				Precursor
			end
		end

feature {NONE} -- Implementation

	do_application
		local
			log_stack_pos: INTEGER; ctrl_c_pressed, other_exception: BOOLEAN
		do
			if ctrl_c_pressed then
				on_operating_system_signal

			elseif other_exception then
				on_exception
			else
				log.enter ("make")
				log_stack_pos := log.call_stack_count
				Precursor
			end
			log.exit
			Log_manager.close_logs

			if not other_exception then
				Log_manager.delete_logs
			end
		rescue
			if Exception.is_termination_signal then
				ctrl_c_pressed := True
			else
				other_exception := True
			end
			log.restore (log_stack_pos)
			retry -- for normal exit
		end

	empty_log_filter_set: EL_LOG_FILTER_SET [TUPLE]
			--
		do
			create Result.make_empty
		end

	init_console_and_logging
			--
		local
			manager: like new_log_manager; global_logging: EL_GLOBAL_LOGGING
		do
			Precursor
			manager := new_log_manager
			manager.initialize

			create global_logging.make (is_logging_active)
			if global_logging.is_active then
				global_logging.set_loggable_routines (Log_filter_list_table.item (Current))
			else
				if manager.is_console_manager_active then
					lio.put_string ("Thread logging disabled")
				end
			end
			manager.add_thread (new_identified_main_thread)
			is_logging_initialized := true
		end

	io_put_header
		do
			log.enter_no_header ("io_put_header")
			Precursor
			log.exit_no_trailer
			if not Logging.is_active then
				lio.put_new_line
			end
		end

	log_filter_set: EL_LOG_FILTER_SET [TUPLE]
		-- set of loggable classes
		deferred
		end

	on_exception
		do
			Exception.put_last_trace (log)
		end

	standard_options: EL_DEFAULT_COMMAND_OPTION_LIST
		do
			Result := Precursor + Log_option
		end

feature {EL_LOGGED_APPLICATION} -- Factory

	new_identified_main_thread: EL_IDENTIFIED_MAIN_THREAD
		do
			create Result.make ("Main")
		end

	new_log_filter_list: LIST [EL_LOG_FILTER]
		do
			Result := new_log_filter_set.linear_representation
		end

	new_log_filter_set: EL_LOG_FILTER_SET [TUPLE]
			--
		do
			Result := log_filter_set
		end

	new_log_manager: EL_LOG_MANAGER
		do
			create Result.make (is_logging_active, Log_output_directory)
		end

feature {NONE} -- Constants

	Log_filter_list_table: EL_FUNCTION_RESULT_TABLE [EL_LOGGED_APPLICATION, LIST [EL_LOG_FILTER]]
		-- table of filter lists by sub-application type
		once
			create Result.make (11, agent {EL_LOGGED_APPLICATION}.new_log_filter_list)
		end

	Log_output_directory: DIR_PATH
		once
			Result := Directory.Sub_app_data #+ "logs"
		end

end