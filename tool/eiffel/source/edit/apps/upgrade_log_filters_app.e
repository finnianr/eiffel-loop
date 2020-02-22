note
	description: "Upgrade syntax of Eiffel Loop logging filter arrays"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-20 17:48:58 GMT (Thursday 20th February 2020)"
	revision: "8"

class
	UPGRADE_LOG_FILTERS_APP

inherit
	SOURCE_TREE_EDITING_SUB_APPLICATION
		rename
			extra_log_filter as no_log_filter
		redefine
			Option_name, test_run
		end

create
	make

feature {NONE} -- Implementation

	new_editor (file_path_list: LIST [EL_FILE_PATH]): LOG_FILTER_ARRAY_SOURCE_EDITOR
		do
			create Result.make
		end

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("Eiffel/latin1-sources/sub_applications", agent test_source_tree, checksum [1])
		end

feature {NONE} -- Constants

	Checksum: ARRAY [NATURAL]
			-- 4 Aug 2016
		once
			Result := << 1767075359, 0 >>
		end

	Option_name: STRING = "log_upgrade"

	Description: STRING = "Change class names in {EL_SUB_APPLICATION}.Log_filter from strings to class types"

end
