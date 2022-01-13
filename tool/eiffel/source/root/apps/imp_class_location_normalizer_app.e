note
	description: "Command-line interface to command [$source IMP_CLASS_LOCATION_NORMALIZER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:28:51 GMT (Thursday 13th January 2022)"
	revision: "5"

class
	IMP_CLASS_LOCATION_NORMALIZER_APP

inherit
	REPOSITORY_PUBLISHER_SUB_APPLICATION [IMP_CLASS_LOCATION_NORMALIZER]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", 0)
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, EIFFEL_CONFIGURATION_FILE, EIFFEL_CONFIGURATION_INDEX_PAGE
	]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "normalize_imp_location"

end