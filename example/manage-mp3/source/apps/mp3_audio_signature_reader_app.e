note
	description: "Mp3 audio signature reader app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 12:01:31 GMT (Sunday 23rd January 2022)"
	revision: "16"

class
	MP3_AUDIO_SIGNATURE_READER_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [EL_MP3_AUDIO_SIGNATURE_READER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("music", "Location of music files", << directory_must_exist >>),
				optional_argument ("clean_up", "Remove duplicates with same name", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", False)
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "read_signatures"

end