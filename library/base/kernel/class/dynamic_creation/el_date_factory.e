note
	description: "Factory to create items conforming to [$source DATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 7:48:09 GMT (Thursday 8th December 2022)"
	revision: "4"

class
	EL_DATE_FACTORY [G -> DATE create make_now end]

inherit
	EL_FACTORY [G]

feature -- Access

	new_item: G
		do
			create Result.make_now
		end

end