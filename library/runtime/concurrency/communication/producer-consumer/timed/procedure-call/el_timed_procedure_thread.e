note
	description: "Summary description for {EL_TIMED_PROCEDURE_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TIMED_PROCEDURE_THREAD  [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_TIMED_PROCEDURE [BASE_TYPE, OPEN_ARGS]
		undefine
			is_equal, copy, stop_consumer
		redefine
			make, make_default
		end

	EL_COUNT_CONSUMER_THREAD
		rename
			make as make_consumer,
			stop as stop_consumer,
			launch as launch_consumer
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_TIMED_PROCEDURE}
			Precursor {EL_COUNT_CONSUMER_THREAD}
		end

	make (a_procedure: like procedure; interval_millisecs: INTEGER)
		do
			Precursor (a_procedure, interval_millisecs)
			create product_count.make (0)
		end
end
