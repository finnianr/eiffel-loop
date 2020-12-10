note
	description: "`REAL_64' field with enumerated values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-07 12:39:15 GMT (Monday 7th December 2020)"
	revision: "2"

class
	EL_REFLECTED_ENUM_REAL_64

inherit
	EL_REFLECTED_ENUMERATION [REAL_64]
		rename
			field_value as real_64_field
		undefine
			reset
		end

	EL_REFLECTED_REAL_64
		rename
			make as make_field
		undefine
			to_string, set_from_string, write_crc
		end

create
	make

feature {NONE} -- Implementation

	is_numeric (string: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := string.is_real_64
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: REAL_64)
		do
			crc.add_real_64 (enum_value)
		end

end