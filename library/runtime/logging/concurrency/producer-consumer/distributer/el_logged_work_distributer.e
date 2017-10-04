note
	description: "Summary description for {EL_LOGGED_WORK_DISTRIBUTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-03 13:26:00 GMT (Tuesday 3rd October 2017)"
	revision: "2"

class
	EL_LOGGED_WORK_DISTRIBUTER [R -> ROUTINE]

inherit
	EL_WORK_DISTRIBUTER [R]
		redefine
			threads
		end

create
	make

feature {NONE} -- Internal attributes

	threads: EL_ARRAYED_LIST [EL_LOGGED_WORK_DISTRIBUTION_THREAD]
		-- threads of worker threads

end
