note
	description: "Test class ${PYXIS_TREE_TO_XML_COMPILER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-24 7:26:16 GMT (Wednesday 24th July 2024)"
	revision: "9"

class
	PYXIS_TREE_TO_XML_COMPILER_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["compiler", agent test_compiler]
			>>)
		end

feature -- Tests

	test_compiler
		note
			testing: "[
				covers/{EL_MERGED_PYXIS_LINE_LIST}.make,
				covers/{PYXIS_TREE_TO_XML_COMPILER}.execute,
				covers/{EL_TRANSLATION_TABLE}.make_from_xdoc
			]"
		local
			compiler: PYXIS_TREE_TO_XML_COMPILER; destination_path: FILE_PATH
			translation_table, merged_table: EL_TRANSLATION_TABLE; xdoc: EL_XML_DOC_CONTEXT
			time_stamp: INTEGER; key: ZSTRING
		do
			destination_path := work_area_data_dir.parent + "localization.xml"
			create compiler.make ("", work_area_data_dir, destination_path)
			compiler.execute
			create xdoc.make_from_file (destination_path)
			create merged_table.make_from_xdoc ("en", xdoc)
			across OS.file_list (work_area_data_dir, "*.pyx") as path loop
				create translation_table.make_from_pyxis ("en", path.item)
				across translation_table as table loop
					key := table.key
					assert ("merged table has key", merged_table.has (key))
				end
			end
			time_stamp := destination_path.modification_time
			compiler.execute
			assert ("file not changed", time_stamp = destination_path.modification_time)
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ "pyxis/localization"
		end

end