note
	description: "Pyxis parser Constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-22 9:03:30 GMT (Friday 22nd July 2022)"
	revision: "5"

deferred class
	EL_PYXIS_PARSER_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Parser states

	State_parse_line: NATURAL_8 = 1

	State_gather_verbatim_lines: NATURAL_8 = 2

	State_output_content_lines: NATURAL_8 = 3

	State_gather_comments: NATURAL_8 = 4

feature {NONE} -- Constants

	Document_end: STRING = "doc-end:"

	Pyxis_doc: TUPLE [encoding, name, version: STRING]
		once
			create Result
			Tuple.fill (Result, "encoding, pyxis-doc, version")
		end
end