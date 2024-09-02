note
	description: "Application root class"
	to_do: "[

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 7:14:10 GMT (Sunday 1st September 2024)"
	revision: "64"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
	--	Test
		AUTOTEST_APP,

	-- Analysis
		CHECK_LOCALE_STRINGS_APP,
		CLASS_DESCENDANTS_APP,
		CODE_METRICS_APP,
		FIND_CODE_PATTERN_APP,
		ENCODING_CHECK_APP,
		REGULAR_EXPRESSION_SEARCH_APP,
		REPOSITORY_NOTE_LINK_CHECKER_APP,

	-- Class editing
		CLASS_RENAMING_APP,
		FEATURE_EDITOR_APP,
		FIND_AND_REPLACE_APP,
		NOTE_DATE_FIXER_APP,
		NOTE_EDITOR_APP,
		OPEN_GREP_RESULT_APP,
		SOURCE_FILE_NAME_NORMALIZER_APP,
		SOURCE_LEADING_SPACE_CLEANER_APP,
		SOURCE_LOG_LINE_REMOVER_APP,

	-- Code generators
		COMPRESS_MANIFEST_APP,
		ZCODEC_GENERATOR_APP,
		ID3_FRAME_CODE_CLASS_GENERATOR_APP,
		LIBRARY_OVERRIDE_APP,

	-- Source code migration
		LIBRARY_MIGRATION_APP,
		UPGRADE_DEFAULT_POINTER_SYNTAX_APP,
		UPGRADE_LOG_FILTERS_APP,
		UPGRADE_TEST_SET_CALL_BACK_CODE_APP,

	--	Utilities
		COMPILE_DESKTOP_PROJECTS_APP,

		GITHUB_MANAGER_APP,

		ECF_TO_PECF_APP,
		EIFFEL_VIEW_APP,

		IMP_CLASS_LOCATION_NORMALIZER_APP,

		PROJECT_MANAGER_APP,
		PYXIS_LOCALE_COMPILER_APP,
		PYXIS_ECF_CONVERTER_APP,

		REPOSITORY_SOURCE_LINK_EXPANDER_APP,

		WINZIP_SOFTWARE_PACKAGE_BUILDER_APP,

	-- Obsolete once-off apps
		UNDEFINE_PATTERN_COUNTER_APP
	]

create
	make

end