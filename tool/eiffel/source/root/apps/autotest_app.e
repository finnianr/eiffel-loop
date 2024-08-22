note
	description: "Finalized executable tests for sub-applications"
	notes: "[
		Command option: `-autotest'
		
		**Test Sets**
		
			${CLASS_FILE_NAME_NORMALIZER_TEST_SET}
			${CLASS_RENAMING_TEST_SET}
			${COMPRESS_MANIFEST_COMMAND_TEST_SET}
			${EIFFEL_GREP_COMMAND_TEST_SET}
			${EIFFEL_SOURCE_COMMAND_TEST_SET}
			${FEATURE_EDITOR_COMMAND_TEST_SET}
			${LIBRARY_MIGRATION_COMMAND_TEST_SET}
			${LIBRARY_MIGRATION_CIRCULAR_COMMAND_TEST_SET}
			${NOTE_EDITOR_TEST_SET}
			${PYXIS_ECF_PARSER_TEST_SET}
			${REPOSITORY_PUBLISHER_TEST_SET}
			${REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET}
			${PYXIS_EIFFEL_CONFIG_TEST_SET}
			${UNDEFINE_PATTERN_COUNTER_TEST_SET}
			${UPGRADE_DEFAULT_POINTER_SYNTAX_TEST_SET}
			${ZCODEC_GENERATOR_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 7:36:32 GMT (Thursday 22nd August 2024)"
	revision: "63"

class
	AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [
		CLASS_FILE_NAME_NORMALIZER_TEST_SET,
		CLASS_RENAMING_TEST_SET,
		COMPRESS_MANIFEST_COMMAND_TEST_SET,
		EIFFEL_GREP_COMMAND_TEST_SET,
		EIFFEL_SOURCE_COMMAND_TEST_SET,
		FEATURE_EDITOR_COMMAND_TEST_SET,
		LIBRARY_MIGRATION_COMMAND_TEST_SET,
		LIBRARY_MIGRATION_CIRCULAR_COMMAND_TEST_SET,
		NOTE_EDITOR_TEST_SET,
		PYXIS_ECF_PARSER_TEST_SET,
		REPOSITORY_PUBLISHER_TEST_SET,
		REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET,
		PYXIS_EIFFEL_CONFIG_TEST_SET,
		UNDEFINE_PATTERN_COUNTER_TEST_SET,
		UPGRADE_DEFAULT_POINTER_SYNTAX_TEST_SET,
		ZCODEC_GENERATOR_TEST_SET
	]
		redefine
			new_log_filter_set, visible_types
		end

create
	make

feature {NONE} -- Implementation

	new_log_filter_set: EL_LOG_FILTER_SET [TUPLE]
			--
		do
			Result := Precursor
			Result.show_all ({EIFFEL_CONFIGURATION_FILE})
			Result.show_all ({EIFFEL_CONFIGURATION_INDEX_PAGE})
		end

	visible_types: TUPLE [
		EL_PYXIS_LOCALE_COMPILER,
		EIFFEL_GREP_COMMAND,
		FEATURE_EDITOR_COMMAND,
		UNDEFINE_PATTERN_COUNTER_COMMAND,
		ZCODEC_GENERATOR_TEST_SET,
		EL_MERGED_PYXIS_LINE_LIST
	]
		do
			create Result
		end

end