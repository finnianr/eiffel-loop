note
	description: "${STRING_8} implementation of ${XML_ESCAPER_IMP [STRING_GENERAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "19"

class
	XML_STRING_8_ESCAPER_IMP

inherit
	XML_ESCAPER_IMP [STRING_8]
		undefine
			bit_count, make, to_code, to_unicode
		end

	EL_STRING_8_ESCAPER_IMP
		undefine
			append_escape_sequence, is_escaped
		end

create
	make
end