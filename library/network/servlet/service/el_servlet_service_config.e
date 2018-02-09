note
	description: "Servlet service configuration parsed from Pyxis format"

	notes: "[
		A minimal configuration looks like this:
		
			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			config:
				port = 8001

				document-root:
					"/home/john/www"
					
		It can easily be extended to include other information.
		
		The attribute `server_socket_path' is for future use with Unix sockets.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-30 20:12:19 GMT (Monday 30th October 2017)"
	revision: "4"

class
	EL_SERVLET_SERVICE_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, make_from_file, building_action_table
		end

	EL_MODULE_LOG

	EL_MODULE_ARGS

	EL_MODULE_FILE_SYSTEM

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			create document_root_dir
			create error_messages.make_empty
			create server_socket_path
			Precursor
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		do
			if a_file_path.exists then
				Precursor (a_file_path)
				if not server_socket_path.is_empty and then not server_socket_path.parent.exists then
					error_messages.extend ("Invalid socket path: " + server_socket_path.to_string)
				end
			else
				error_messages.extend ("Invalid path: ")
				error_messages.last.append (a_file_path.to_string)
			end
		ensure then
			valid_socket_parameter:
				server_port = 0 implies (not server_socket_path.is_empty and then server_socket_path.parent.exists)
		end

feature -- Access

	document_root_dir: EL_DIR_PATH

	error_messages: EL_ZSTRING_LIST

	server_port: INTEGER
		-- Port server is listening on

	server_socket_path: EL_FILE_PATH
		-- Unix socket path to listen on (for future use)

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := error_messages.is_empty
		end

feature -- Factory

	new_client_socket: EL_STREAM_SOCKET
		do
			if server_port > 0 then
				create {EL_NETWORK_STREAM_SOCKET} Result.make_client_by_port (server_port, "localhost")
			else
				create {EL_UNIX_STREAM_SOCKET} Result.make_client (server_socket_path.to_string)
			end
		end

	new_socket: EL_STREAM_SOCKET
		local
			unix_sock: EL_UNIX_STREAM_SOCKET
		do
			if server_port > 0 then
				create {EL_NETWORK_STREAM_SOCKET} Result.make_server_by_port (server_port)
			else
				if server_socket_path.exists then
					File_system.remove_file (server_socket_path)
				end
				create unix_sock.make_server (server_socket_path.to_string)
				unix_sock.add_permission ("g", "+w")
				Result := unix_sock
			end
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result.make (<<
				["@port", agent do server_port := node end],
				["@socket_path", agent do server_socket_path := node.to_expanded_file_path end],
				["document-root/text()", agent do set_document_root_dir (node.to_string) end]
			>>)
		end

	Root_node_name: STRING = "config"

feature {NONE} -- Implementation

	set_document_root_dir (a_document_root_dir: like document_root_dir)
		do
			document_root_dir := a_document_root_dir
		end

end
