note
	description: "Abstraction for source tree editing sub-application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-08 16:56:37 GMT (Saturday 8th January 2022)"
	revision: "12"

deferred class
	SOURCE_TREE_EDITING_SUB_APPLICATION

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		redefine
			visible_types
		end

	EL_ARGUMENT_TO_ATTRIBUTE_SETTING

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			if Is_test_mode then
				Console.show ({EL_REGRESSION_TESTING_ROUTINES})
			end
			set_defaults
			set_attribute_from_command_opt (tree_path, "source_tree", "Directory tree path")
		end

feature -- Basic operations

	normal_run
		local
			tree_processor: SOURCE_TREE_PROCESSOR
		do
			create tree_processor.make (tree_path, agent new_editor)
			tree_processor.do_all
		end

feature -- Testing	

	test_run
			--
		do
			across test_sources as source loop
				Test.do_file_tree_test (source.item, agent test_source_tree, checksum [source.cursor_index])
			end
		end

	test_source_tree (dir_path: DIR_PATH)
		do
			set_defaults
			tree_path := dir_path
			normal_run
		end

feature {NONE} -- Implementation

	checksum: ARRAY [NATURAL]
		deferred
		end

	new_editor (file_path_list: LIST [FILE_PATH]): EL_EIFFEL_SOURCE_EDITOR
		deferred
		end

	set_defaults
		do
			create tree_path
		end

	test_sources: ARRAY [STRING]
		do
			Result := << "sources/latin-1", "sources/utf-8" >>
		ensure
			same_count_as_checksum: Result.count = checksum.count
		end

	visible_types: TUPLE [SOURCE_TREE_PROCESSOR]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Internal attributes

	tree_path: DIR_PATH

end
