note
	description: "Code highlighting test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 12:39:26 GMT (Thursday 7th May 2020)"
	revision: "9"

class
	CODE_HIGHLIGHTING_TEST_APP

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		rename
			extra_log_filter as no_log_filter
		redefine
			Option_name
		end

	EL_FILE_OPEN_ROUTINES

create
	make

feature -- Basic operations

	normal_initialize
			--
		do
		end

	test_run
			--
	 	do
			Test.do_all_files_test ("latin1-sources/kernel", "*.e", agent test_code_highlighting, 2427639648)
	 	end

	normal_run
		do
		end

feature -- Tests

	test_code_highlighting (file_path: EL_FILE_PATH)
			--
		local
			transformer: CODE_HIGHLIGHTING_TRANSFORMER
			output_path: EL_FILE_PATH
		do
			log.enter ("test_code_highlighting")
			output_path := file_path.without_extension
			output_path.add_extension ("e.html")
			if attached open (output_path, Write) as html_file then
				create transformer.make (html_file)
				transformer.set_file_path (file_path)
				transformer.edit
				html_file.close
			end
			log.exit
		end

feature {NONE} -- Constants

	Option_name: STRING = "test_eiffel_code_highlighting"

	Description: STRING = "Test highlighting Eiffel keywords, comments and class names."

end
