note
	description: "Root class of sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-23 8:39:06 GMT (Wednesday 23rd November 2022)"
	revision: "41"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		AUTOTEST_APP,
		BINARY_DECODE_APP,

		CAD_MODEL_SLICER_APP,
		CRYPTO_COMMAND_SHELL_APP,

		EL_DEBIAN_PACKAGER_APP,
		DIAGNOSTICS_APP,
		DUPLICITY_BACKUP_APP,
		DUPLICITY_RESTORE_APP,

		FILTER_INVALID_UTF_8_APP,
		FILE_TREE_TRANSFORM_SCRIPT_APP,
		FTP_BACKUP_APP, -- uses ftp (depends eposix)
		FTP_AUTOTEST_APP,
		FILE_MANIFEST_APP,

		CURRENCY_EXCHANGE_HISTORY_APP,
		HTML_BODY_WORD_COUNTER_APP,

		PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP,
		PYXIS_ENCRYPTER_APP,
		PYXIS_TO_XML_APP,
		PYXIS_TREE_TO_XML_COMPILER_APP,

		LOCALIZATION_COMMAND_SHELL_APP,
		LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP,
		LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP,

		SLIDE_SHOW_APP,
		STOCK_CONSUMPTION_CALCULATOR_APP,

		THUNDERBIRD_BOOK_EXPORTER_APP,
		THUNDERBIRD_WWW_EXPORTER_APP,

		UNDATED_PHOTO_FINDER_APP,
		USER_AGENT_APP,

		VCF_CONTACT_SPLITTER_APP,
		VCF_CONTACT_NAME_SWITCHER_APP,

		XML_TO_PYXIS_APP,
		YOUTUBE_VIDEO_DOWNLOADER_APP
	]

create
	make

note
	ideas: "[]"

	to_do: "[]"

end