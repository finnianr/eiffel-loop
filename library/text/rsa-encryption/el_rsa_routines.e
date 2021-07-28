note
	description: "RSA routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-27 9:34:37 GMT (Tuesday 27th July 2021)"
	revision: "17"

class
	EL_RSA_ROUTINES

inherit
	ANY

	EL_MODULE_BASE_64

	EL_MODULE_HEXADECIMAL

feature -- Conversion

	integer_x_from_base_64 (base_64_string: STRING): INTEGER_X
		--
		do
			Result := integer_x_from_array (Base_64.decoded_special (base_64_string))
		end

	integer_x_from_array (byte_array: SPECIAL [NATURAL_8]): INTEGER_X
			--
		do
			create Result.make_from_bytes (byte_array, byte_array.lower, byte_array.upper)
		end

end