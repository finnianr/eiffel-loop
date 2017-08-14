note
	description: "Summary description for {EL_MANAGED_CONTAINABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-03-10 11:00:10 GMT (Friday 10th March 2017)"
	revision: "2"

class
	EL_MANAGED_CONTAINABLE [W -> EV_CONTAINABLE create default_create end]

inherit
	ANY
		redefine
			default_create
		end

create
	make_with_container, default_create

feature {NONE} -- Initialization

	default_create
		do
			make_with_container (create {EV_HORIZONTAL_BOX}, agent create_default_item)
		end

	make_with_container (a_container: like container; a_factory_function: like factory_function)
		do
			container := a_container; factory_function := a_factory_function
			factory_function.apply
			item := factory_function.last_result
			container.extend (item)
		end

feature -- Element change

	update
			-- replace item with a new item
		do
			container.start
			container.search (item)
			if not container.exhausted then
				factory_function.apply
				container.replace (factory_function.last_result)
				item := factory_function.last_result
			end
		end

feature -- Access

	item: W

feature {NONE} -- Implementation

	create_default_item: W
		do
			create Result
		end

	container: EV_DYNAMIC_LIST [EV_CONTAINABLE]

	factory_function: FUNCTION [W]

end
