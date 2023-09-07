note
	description: "[
		Default implementation of [$source EL_SERIALIZEABLE_AS_XML]
		
		**to_xml:**
		
			<?xml version="1.0" encoding="UTF-8"?>
			<default/>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 14:11:44 GMT (Thursday 7th September 2023)"
	revision: "9"

class
	EL_DEFAULT_SERIALIZEABLE_XML

inherit
	EL_SERIALIZEABLE_AS_XML

	EL_MODULE_XML

	EL_CHARACTER_8_CONSTANTS

feature -- Conversion

	to_xml: STRING
			--
		do
			Result := new_line.joined (XML.header (1.0, {CODE_PAGE_CONSTANTS}.Utf8), "<default/>")
		end

end