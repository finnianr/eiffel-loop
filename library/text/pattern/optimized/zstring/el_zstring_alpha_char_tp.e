note
	description: "Match alphabetical character for [$source ZSTRING] text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-12 9:59:40 GMT (Saturday 12th November 2022)"
	revision: "1"

class
	EL_ZSTRING_ALPHA_CHAR_TP

inherit
	EL_ALPHA_CHAR_TP
		redefine
			i_th_matches
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.is_alpha_item (i)
		end

end