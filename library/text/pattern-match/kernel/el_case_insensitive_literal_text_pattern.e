note
	description: "Case insensitive literal text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 9:46:40 GMT (Tuesday 5th January 2021)"
	revision: "2"

class
	EL_CASE_INSENSITIVE_LITERAL_TEXT_PATTERN

inherit
	EL_LITERAL_TEXT_PATTERN
		redefine
			match_count
		end

	EL_SHARED_ONCE_STRING_32

create
	make_from_string

feature {NONE} -- Implementation

	match_count (a_text: EL_STRING_VIEW): INTEGER
			--
		local
			l_text: STRING_32
		do
			l_text := once_empty_string_32
			a_text.append_substring_to (l_text, 1, text.count)
			if l_text.same_caseless_characters_general (text, 1, text.count, 1) then
				Result := text.count
			else
				Result := Match_fail
			end
		end

end