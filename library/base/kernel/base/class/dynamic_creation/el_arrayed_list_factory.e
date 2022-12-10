note
	description: "Factory to create items conforming to [$source ARRAYED_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-10 11:22:07 GMT (Saturday 10th December 2022)"
	revision: "5"

class
	EL_ARRAYED_LIST_FACTORY [G -> ARRAYED_LIST [ANY] create make end]

inherit
	EL_FACTORY [G]

feature -- Access

	new_item: G
		do
			create Result.make (0)
		end

end