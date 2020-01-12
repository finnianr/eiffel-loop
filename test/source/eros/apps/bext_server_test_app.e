note
	description: "Bext server test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 7:14:15 GMT (Sunday 12th January 2020)"
	revision: "7"

class
	BEXT_SERVER_TEST_APP

inherit
	EL_EROS_SERVER_SUB_APPLICATION
		redefine
			initialize
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			Precursor
		end

feature -- Basic operations

	serve (client_socket: EL_NETWORK_STREAM_SOCKET)
			--
		local
			wave_form: COLUMN_VECTOR_COMPLEX_DOUBLE
			i: INTEGER
		do
			log.enter ("serve")
			from i := 1 until i > 2 loop
				create wave_form.make_from_binary_stream (client_socket)
				wave_form.set_output_path ("vector." + i.out + ".xml")
				wave_form.store
				i := i + 1
			end
			client_socket.close
			log.exit
		end

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, "*"]
			>>
		end

feature {NONE} -- Constants

	Description: STRING = "Test server for BEXT (Binary Encoded XML Transfer) (Ctrl-c to shutdown)"

end
