note
	description: "[
		Broker object used to communicate with the web server across a supplied socket using the
		FastCGI binary protocol. It reads HTTP requests and write responses.
	]"
	notes: "[
		Abort handling in `on_header' is based on this
		[https://github.com/cherokee/webserver/blob/master/qa/fcgi.py QA example client] from Cherokee,
		but there is a question as to whether it conforms to the
		[https://fast-cgi.github.io/spec#54-fcgi_abort_request Fast-CGI specification for aborts].

		Ideally we should find a better example, but in any case the
		[https://github.com/cherokee/webserver/blob/master/cherokee/handler_fcgi.c Fast-CGI handler]
		of our preferered webserver Cherokee, does not even implement aborts as there is no reference
		to `FCGI_ABORT_REQUEST' defined in `fastcgi.h'. This is also the case for Apache.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-08 15:23:47 GMT (Friday 8th December 2017)"
	revision: "4"

class
	FCGI_REQUEST_BROKER

inherit
	FCGI_CONSTANTS

	EL_MODULE_EXCEPTION

create
	make

feature {NONE} -- Initialization

	make
		do
			create {EL_UNIX_STREAM_SOCKET} socket.make
			create parameters.make
			create relative_path_info.make_empty
			end_request_listener := Default_event_listener
		end

feature -- Access

	flags: NATURAL_8

	parameters: FCGI_REQUEST_PARAMETERS
		-- parameters passed to this request.

	relative_path_info: ZSTRING
		-- path info without the leading '/' character

	request_id: NATURAL_16

	request_method: ZSTRING
		do
			Result := parameters.request_method
		end

	role: NATURAL_16

	socket_error: STRING
			-- A string describing the socket error which occurred
		do
			Result := socket.error
		end

	type: NATURAL_8

	version: NATURAL_8

feature -- Status query

	failed: BOOLEAN
		-- Did this request fail?

	read_ok, write_ok: BOOLEAN
		-- `True' if the last socket read or write operation successful?
		do
			Result := not socket.was_error
		end

	is_aborted: BOOLEAN
		-- `True' if request was aborted

	is_end_service: BOOLEAN
		-- `True' if type is request to end service

	is_head_request: BOOLEAN
		do
			Result := parameters.is_head_request
		end

	is_closed: BOOLEAN
		do
			Result := socket.is_closed
		end

feature -- Element change

	set_end_request_listener (listener: like end_request_listener)
		do
			end_request_listener := listener
		end

	set_socket (a_socket: like socket)
		do
			socket := a_socket
		end

feature -- Basic operations

	close
		do
			if not socket.is_closed then
				socket.close
			end
		end

	end_request
		local
			written_ok: BOOLEAN
		do
			if not socket.is_closed then
				Header.set_fields (version, request_id, Fcgi_end_request, Fcgi_end_req_body_len, 0)
				Header.write (Current)
				Header.type_record.write (Current)
				written_ok := write_ok
				socket.close
			end
			if written_ok then
				end_request_listener.notify
			end
			end_request_listener := Default_event_listener
		end

	read
			-- Read a complete request including its begin request, params and stdin records.
		do
			is_aborted := False; is_end_service := False
			parameters.wipe_out

			from request_read := False until not read_ok or request_read loop
				Header.read (Current)
			end
		end

	write_stdout (str: STRING)
		local
			offset, bytes_to_send: INTEGER
		do
			-- split into chunks `Packet_size' bytes or less.
			from offset := 1 until offset > str.count or not write_ok loop
				bytes_to_send := Packet_size.min (str.count - (offset - 1))
				Header.set_fields (version, request_id, Fcgi_stdout, bytes_to_send, 0)
				Header.write (Current)
				if write_ok and then attached {FCGI_STRING_CONTENT_RECORD} Header.type_record as record then
					record.set_content (str, offset)
					record.write (Current)
				end
				offset := offset + Packet_size
			end
			if write_ok then
				Header.set_fields (version, request_id, Fcgi_stdout, 0, 0)
				Header.write (Current)
			end
		end

feature {FCGI_RECORD} -- Record events

	on_begin_request (record: FCGI_BEGIN_REQUEST_RECORD)
		do
			request_id := Header.request_id; version := Header.version; type := Header.type
			role := record.role; flags := record.flags
		end

	on_header (a_header: FCGI_HEADER_RECORD)
		do
			if a_header.is_end_service then
				socket.put_encoded_string_8 ("ok")
				request_read := True; is_end_service := True

			elseif a_header.is_aborted then
				request_read := True; is_aborted := True
				socket.close

			else
				a_header.type_record.read (Current)
			end
		end

	on_parameter (record: FCGI_PARAMETER_RECORD)
		do
			parameters.set_field (record.name, record.value.twin)
		end

	on_parameter_last
		do
			relative_path_info.wipe_out
			relative_path_info.append_substring (parameters.path_info, 2, parameters.path_info.count)
		end

	on_stdin_request (record: FCGI_STRING_CONTENT_RECORD)
		do
			parameters.content.append (record.content)
		end

	on_stdin_request_last
		do
			request_read := True
		end

feature {FCGI_RECORD} -- Internal attributes

	end_request_listener: EL_EVENT_LISTENER
		-- action called on successful write of servlet response

	request_read: BOOLEAN

	socket: EL_STREAM_SOCKET

feature {FCGI_RECORD} -- Constants

	Default_event_listener: EL_DEFAULT_EVENT_LISTENER
		once
			create Result
		end

	Header: FCGI_HEADER_RECORD
		once
			create Result
		end

	Packet_size: INTEGER = 65535

end
