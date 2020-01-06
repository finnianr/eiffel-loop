note
	description: "Sub-application to aid development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 19:28:49 GMT (Monday 6th January 2020)"
	revision: "59"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			Build_info, Option_name
		end

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{HTTP_CONNECTION_TEST_SET}, All_routines]
			>>
		end

feature {NONE} -- Constants

	Build_info: BUILD_INFO
		once
			create Result
		end

	Evaluator_types: TUPLE [DATE_TEXT_TEST_EVALUATOR]
		once
			create Result
		end

	Evaluator_types_all: TUPLE [
		DATE_TEXT_TEST_EVALUATOR,
		FILE_AND_DIRECTORY_TEST_EVALUATOR,
		HTTP_CONNECTION_TEST_EVALUATOR,
		SEARCH_ENGINE_TEST_EVALUATOR,
		ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR,
		REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_EVALUATOR,
		ID3_TAG_INFO_TEST_EVALUATOR,
		TAGLIB_TEST_EVALUATOR,
		ZSTRING_TEST_EVALUATOR
	]
		once
			create Result
		end

--	Tests that still need an evaluator
	Unmigrated_tests: TUPLE [
		AUDIO_COMMAND_TEST_SET,
		CHAIN_TEST_SET,
		COMMA_SEPARATED_IMPORT_TEST_SET,
		DIGEST_ROUTINES_TEST_SET, DIR_URI_PATH_TEST_SET,
		FILE_AND_DIRECTORY_TEST_SET, FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET, FTP_TEST_SET,
		JSON_NAME_VALUE_LIST_TEST_SET,
		OS_COMMAND_TEST_SET,
		PATH_TEST_SET, PATH_STEPS_TEST_SET,
		REFLECTION_TEST_SET, REFLECTIVE_TEST_SET,
		SE_ARRAY2_TEST_SET, SETTABLE_FROM_JSON_STRING_TEST_SET, STRING_32_ROUTINES_TEST_SET,
		STRING_EDITION_HISTORY_TEST_SET, STRING_EDITOR_TEST_SET, SUBSTITUTION_TEMPLATE_TEST_SET,
		TEXT_PARSER_TEST_SET, TRANSLATION_TABLE_TEST_SET,
		URI_ENCODING_TEST_SET,
		ZSTRING_TOKEN_TABLE_TEST_SET
	]

	Option_name: STRING = "autotest"

end
