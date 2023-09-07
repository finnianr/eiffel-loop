note
	description: "[
		A command line interface to the command [$source CODEBASE_STATISTICS_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-03 12:04:41 GMT (Sunday 3rd September 2023)"
	revision: "25"

class
	CODEBASE_STATISTICS_APP

inherit
	SOURCE_MANIFEST_APPLICATION [CODEBASE_STATISTICS_COMMAND]
		redefine
			option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "codebase_stats"

end