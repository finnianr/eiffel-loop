note
	description: "Query condition"
	tests: "Class ${CONTAINER_STRUCTURE_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 11:35:23 GMT (Tuesday 8th August 2023)"
	revision: "12"

deferred class
	EL_QUERY_CONDITION [G]

feature -- Status query

	met (item: G): BOOLEAN
		-- True if condition is met for `item`
		deferred
		end

feature -- Addition

	conjuncted alias "and" (right: EL_QUERY_CONDITION [G]): EL_AND_QUERY_CONDITION [G]
		do
			create Result.make (Current, right)
		end

	disjuncted alias "or" (right: EL_QUERY_CONDITION [G]): EL_OR_QUERY_CONDITION [G]
		do
			create Result.make (Current, right)
		end

	negated alias "not": EL_NOT_QUERY_CONDITION [G]
		do
			create Result.make (Current)
		end

end