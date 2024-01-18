note
	description: "[
		Object for managing a list of event listeners. It can all be used to make a one-many event
		listener, as the list itself conforms to ${EL_EVENT_LISTENER}.
		
		Due to limitations of Eiffel ${ARRAY [G]} manifest conformance checking, the automatic conversion
		is not useable as intended with compiler version 16.05, but perhaps in a future version
		it will be useable.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 11:47:24 GMT (Monday 7th August 2023)"
	revision: "7"

class
	EL_EVENT_LISTENER_LIST

inherit
	EL_ARRAYED_LIST [EL_EVENT_LISTENER]
		rename
			make_from_array as make,
			make as make_with_count
		export
			{NONE} all
		end

	EL_EVENT_LISTENER
		rename
			listener_count as count,
			notify as notify_all
		undefine
			copy, is_equal, count
		end

create
	make

convert
	make ({ARRAY [EL_EVENT_LISTENER]})

feature -- Basic operations

	notify_all
		do
			from start until after loop
				item.notify
				forth
			end
		end
end