note
	description: "Windows implemenation of interface [$source TL_STRING_SETTER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-23 18:45:38 GMT (Tuesday 23rd November 2021)"
	revision: "3"

class
	TL_STRING_SETTER_IMP

inherit
	TL_STRING_SETTER_I [NATURAL_16]

feature {NONE} -- Implementation

	extend_part (p: NATURAL)
		do
			extend (p.to_natural_16)
		end
end