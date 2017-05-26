note
	description: "Summary description for {EL_SEPARATE_PROCEDURE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:33:23 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	EL_SEPARATE_PROCEDURE [OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_SHARED_THREAD_MANAGER
		undefine
			default_create
		end

create
	make, default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			create consumer.make
			thread_manager.extend (consumer)
			create call_queue.make
			call_queue.attach_consumer (consumer)
		end

	make (procedure: PROCEDURE [OPEN_ARGS])
			--
		do
			default_create
			consumer.set_action (procedure)
		end

feature -- Element change

	set_action (procedure: PROCEDURE [OPEN_ARGS])
			--
		do
			consumer.set_action (procedure)
		end

feature -- Basic operations

	launch
			--
		do
			consumer.launch
		end

	call (tuple: OPEN_ARGS)
			--
		do
			call_queue.put (tuple)
		end

feature {NONE} -- Implementation

	consumer: EL_TUPLE_CONSUMER_THREAD [OPEN_ARGS]

	call_queue: EL_THREAD_PRODUCT_QUEUE [OPEN_ARGS]

end
