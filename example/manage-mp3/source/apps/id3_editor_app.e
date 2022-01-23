note
	description: "Id3 editor app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 12:01:31 GMT (Sunday 23rd January 2022)"
	revision: "16"

class
	ID3_EDITOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [ID3_EDITOR]
		redefine
			Option_name, Ask_user_to_quit
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("mp3_dir", "Path to root directory of MP3 files",  << directory_must_exist >>),
				required_argument ("task", "Edition task name", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "default")
		end

feature {NONE} -- Constants

	Option_name: STRING = "id3_edit"

	Ask_user_to_quit: BOOLEAN = False

end