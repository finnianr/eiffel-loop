note
	description: "Test simple server"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 20:16:09 GMT (Monday 6th January 2020)"
	revision: "6"

class
	TEST_SIMPLE_SERVER

inherit
	TEST_SUB_APPLICATION
		redefine
			option_name, initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create server.make_local (8000)
		end

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_test ("empty.txt", agent test_server, 235123026)
		end

feature -- Test

	test_server (file_path: EL_FILE_PATH)
		do
			log.enter ("test_server")
			server.do_service_loop
			log.exit
		end

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{TEST_SIMPLE_SERVER}, All_routines],
				[{SIMPLE_COMMAND_HANDLER}, All_routines]
			>>
		end

feature {NONE} -- Internal attributes

	server: EL_SIMPLE_SERVER [SIMPLE_COMMAND_HANDLER]

feature {NONE} -- Constants

	Description: STRING = "Test class EL_SIMPLE_SERVER"

	Option_name: STRING = "simple_server"

end
