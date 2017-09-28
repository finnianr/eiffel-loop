﻿note
	description: "Summary description for {LOCALIZATION_COMMAND_SHELL_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-22 14:06:00 GMT (Saturday 22nd July 2017)"
	revision: "1"

class
	LOCALIZATION_COMMAND_SHELL_TEST_SET

inherit
	EL_TEST_DATA_TEST_SET

	EL_MODULE_LOG
		undefine
			default_create
		end

feature -- Tests

	test_add_unchecked
		local
			shell: LOCALIZATION_COMMAND_SHELL
			list: EL_ZSTRING_LIST
		do
			log.enter ("test_add_unchecked")
			create shell.make (work_dir)
			shell.add_check_attribute

			create list.make_empty
			shell.file_list.do_all (agent shell.add_unchecked (list, "de", ?))
			assert ("Same set", list.count = Unchecked_de_list.count and then list.for_all (agent Unchecked_de_list.has))
			log.exit
		end

feature {NONE} -- Constants

	Relative_dir: EL_DIR_PATH
		once
			Result := "pyxis/localization"
		end

	Unchecked_de_list: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<<
				"{credits}", {STRING_32} "{€}", "Enter a passphrase"
			>>)
		end

end
