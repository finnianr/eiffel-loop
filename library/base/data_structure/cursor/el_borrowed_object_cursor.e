note
	description: "[
		Iteration cursor defining a scope in which a single item can be borrowed from a factory pool
		and then returned when **across** loop exits after first iteration.
		See class [$source EL_BORROWED_OBJECT_SCOPE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-22 20:22:22 GMT (Monday 22nd November 2021)"
	revision: "2"

class
	EL_BORROWED_OBJECT_CURSOR [G]

inherit
	ITERATION_CURSOR [G]

create
	make

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
			item := a_pool.borrowed_item
		end

feature -- Access

	item: G

feature -- Status query

	after: BOOLEAN

feature -- Cursor movement

	forth
		do
			after := True
			pool.recycle (item)
		end

feature {NONE} -- Internal attributes

	pool: EL_FACTORY_POOL [G]

end