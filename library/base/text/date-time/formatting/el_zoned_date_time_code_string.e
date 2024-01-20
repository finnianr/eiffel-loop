note
	description: "${EL_DATE_TIME_CODE_STRING} class with support for time zone designators"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_ZONED_DATE_TIME_CODE_STRING

inherit
	EL_DATE_TIME_CODE_STRING
		rename
			make as make_code_string
		redefine
			adjusted_format, append_to, new_parser
		end

create
	make

feature {NONE} -- Initialization

	make (format: STRING; a_zone_designator_count: INTEGER)
		do
			zone_designator_count := a_zone_designator_count
			make_code_string (format)
		end

feature -- Access

	new_parser: EL_ZONED_DATE_TIME_PARSER
		do
			create Result.make (Current)
		end

	zone_designator_count: INTEGER

feature -- Basic operations

	append_to (str: STRING; dt: DATE_TIME)
		do
			Precursor (str, dt)
			str.append (Zone_designator [zone_designator_count])
		end

feature {NONE} -- Implementation

	adjusted_format (a_str: STRING): STRING
		-- `format' with time zone designators removed
		local
			s: EL_STRING_8_ROUTINES; end_index: INTEGER
		do
			end_index := s.leading_string_count (a_str, zone_designator_count)
			Result := a_str.substring (1, end_index)
		end

feature {NONE} -- Constants

	Zone_designator: SPECIAL [STRING]
		once
			create Result.make_filled (Empty_string_8, 3)
			Result [1] := " UTC"
			Result [2] := " GMT+0000 (GMT)"
		end

end