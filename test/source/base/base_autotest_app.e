note
	description: "Finalized executable tests for library [./library/base.html base.ecf]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-27 14:54:22 GMT (Wednesday 27th January 2021)"
	revision: "104"

class
	BASE_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [
		ARRAYED_LIST_TEST_SET,
		CHAIN_TEST_SET,
		DATE_TEXT_TEST_SET,
		ESCAPED_TEXT_TEST_SET,
		FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET,
		GENERAL_TEST_SET,
		L1_UC_STRING_TEST,
		MODULE_CRC_32_TEST_SET,

		PATH_TEST_SET,
		PATH_STEPS_TEST_SET,

		REFLECTION_TEST_SET,

		SE_ARRAY2_TEST_SET,
		SEQUENTIAL_INTERVALS_TEST_SET,
		STRING_EDITION_HISTORY_TEST_SET,
		STRING_EDITOR_TEST_SET,
		STRING_32_ROUTINES_TEST_SET,
		STRING_LIST_TEST_SET,
		SUBSTITUTION_TEMPLATE_TEST_SET,

		TEMPLATE_TEST_SET,

		URL_ENCODING_TEST_SET,
		URI_PATH_TEST_SET,
		UTF_CONVERTER_TEST_SET,
		UUID_TEST_SET,

		ZSTRING_TEST_SET,
		ZSTRING_TOKEN_TABLE_TEST_SET
	]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_STRING_8_UNESCAPER,
		EL_STRING_32_TEMPLATE, EL_LINKED_STRING_LIST [STRING_GENERAL],
		EL_MAKEABLE_FROM_STRING [STRING_GENERAL],
		EL_SHARED_INITIALIZER [EL_INITIALIZEABLE],
		EL_EXTERNAL_LIBRARY [EL_INITIALIZEABLE],

		EL_XML_STRING_8_ESCAPER, EL_DOCUMENT_NODE_STRING
	]
		-- classes compiled for maintenance
		do
			create Result
		end

	visible_types: TUPLE [STRING_LIST_TEST_SET, EL_GVFS_OS_COMMAND]
		do
			create Result
		end

note
	notes: "[
		Command option: `-base_autotest'

		**Test Sets**

			[$source ARRAYED_LIST_TEST_SET]
			[$source CHAIN_TEST_SET]
			[$source DATE_TEXT_TEST_SET]
			[$source ESCAPED_TEXT_TEST_SET],
			[$source FILE_AND_DIRECTORY_TEST_SET]
			[$source FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET]
			[$source GENERAL_TEST_SET]
			[$source L1_UC_STRING_TEST]
			[$source MODULE_CRC_32_TEST_SET]
			[$source PATH_TEST_SET]
			[$source PATH_STEPS_TEST_SET]
			[$source REFLECTION_TEST_SET]

			[$source SE_ARRAY2_TEST_SET]
			[$source SEQUENTIAL_INTERVALS_TEST_SET]
			[$source STRING_EDITION_HISTORY_TEST_SET]
			[$source STRING_EDITOR_TEST_SET]
			[$source STRING_32_ROUTINES_TEST_SET]
			[$source STRING_LIST_TEST_SET]
			[$source SUBSTITUTION_TEMPLATE_TEST_SET]
			[$source SUBSTRING_32_ARRAY_TEST_SET]

			[$source TEMPLATE_TEST_SET]
			
			[$source URL_ENCODING_TEST_SET]
			[$source URI_ENCODING_TEST_SET]
			[$source URI_PATH_TEST_SET]
			[$source UTF_CONVERTER_TEST_SET]
			
			[$source ZSTRING_TEST_SET]
			[$source ZSTRING_TOKEN_TABLE_TEST_SET]
	]"
end