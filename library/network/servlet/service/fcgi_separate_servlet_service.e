note
	description: "A `FCGI_SERVLET_SERVICE' service operating in a separate thread."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-06 14:00:36 GMT (Monday 6th November 2017)"
	revision: "2"

deferred class
	FCGI_SEPARATE_SERVLET_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			make, accepting_connection
		end

	EL_COMMAND
		rename
			execute as launch
		select
			launch
		end

	EL_LOGGED_IDENTIFIED_THREAD
		rename
			make_default as make_thread,
			state as thread_state
		redefine
			stop
		end

	EL_SINGLE_THREAD_ACCESS
		rename
			mutex as accepting_mutex,
			make_default as make_access
		end

	EL_SHARED_THREAD_MANAGER

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_dir: EL_DIR_PATH; config_name: ZSTRING)
		do
			Precursor (config_dir, config_name)
			make_access
			make_thread
		end

feature -- Basic operations

	stop
		local
			client_socket: EL_NETWORK_STREAM_SOCKET; response_ok: BOOLEAN
		do
			if accepting_mutex.try_lock then
				-- is currently processing a request
				Precursor -- setting `is_stopping' to True will cause `accepting_connection' to set `state' to `final'
				accepting_mutex.unlock
			else
				-- is in `accepting_connection' state so send a request to end the service
				from until response_ok loop
					create client_socket.make_client_by_port (port_number, "localhost")
					client_socket.connect
					End_service.write (client_socket)
					if not client_socket.was_error then
						client_socket.read_stream (2)
						response_ok := client_socket.last_string ~ "ok"
					end
					client_socket.close
				end
			end
		end

feature {NONE} -- States

	accepting_connection
		do
			restrict_access
				if is_stopping then
					state := final
				else
					Precursor
				end
			end_restriction
		end

feature {NONE} -- Constants

	End_service: FCGI_END_SERVICE_RECORD
		-- message record to end the service
		once
			create Result.make
		end
end
