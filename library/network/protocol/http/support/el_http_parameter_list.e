note
	description: "Summary description for {EL_HTTP_PARAMETER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-09 19:49:24 GMT (Thursday 9th November 2017)"
	revision: "3"

class
	EL_HTTP_PARAMETER_LIST [P -> EL_HTTP_PARAMETER]

inherit
	EL_ARRAYED_LIST [P]

	EL_HTTP_PARAMETER
		rename
			extend as extend_table
		undefine
			is_equal, copy
		end

create
	make, make_from_array

convert
	make_from_array ({ARRAY [P]})


feature -- Conversion

	to_table: EL_HTTP_HASH_TABLE
		do
			create Result.make_equal (count)
			extend_table (Result)
		end

feature {NONE} -- Implementation

	extend_table (table: like to_table)
		do
			from start until after loop
				item.extend (table)
				forth
			end
		end

end
