note
	description: "Command-line interface to [$source ECF_TO_PECF_COMMAND]"
	to_do: "[
		* 1st Aug 2020 Throw an exception for invalid cluster names in form doc/config.pyx
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:46:40 GMT (Saturday 5th February 2022)"
	revision: "24"

class
	ECF_TO_PECF_APP

inherit
	EL_COMMAND_LINE_APPLICATION [ECF_TO_PECF_COMMAND]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument (
					"location", "Path to Eiffel library/projects directory tree", << directory_must_exist >>
				)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "ecf_to_pecf"

end