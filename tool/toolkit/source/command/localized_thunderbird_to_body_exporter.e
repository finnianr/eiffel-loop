note
	description: "Localized thunderbird to body exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-12 9:48:46 GMT (Friday 12th October 2018)"
	revision: "2"

class
	LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER

inherit
	EL_LOCALIZED_THUNDERBIRD_ACCOUNT_READER
		export
			{EL_COMMAND_CLIENT} make_from_file
		end

create
	make_from_file

feature {NONE} -- Implementation

	new_reader (a_output_dir: EL_DIR_PATH): EL_THUNDERBIRD_EXPORT_AS_XHTML_BODY
		do
			create Result.make (a_output_dir)
		end

feature {NONE} -- Constants

	Is_language_code_first: BOOLEAN = True

end
