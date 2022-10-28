note
	description: "Match alphabetical character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-26 21:17:25 GMT (Wednesday 26th October 2022)"
	revision: "7"

class
	EL_ALPHA_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN
		rename
			make_default as make
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := "letter"
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
		do
			if text.count > 0 and then code_matches (text.code (1)) then
				Result := 1
			else
				Result := Match_fail
			end
		end

	code_matches (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_alpha
		end

end