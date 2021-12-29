note
	description: "Functions by result type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 17:53:07 GMT (Sunday 26th December 2021)"
	revision: "4"

class
	EL_FUNCTIONS_BY_RESULT_TYPE

inherit
	HASH_TABLE [FUNCTION [ANY], INTEGER_32]
		rename
			make as make_table
		end

	EL_MODULE_ITERABLE

create
	make

feature {NONE} -- Initialization

	make (functions: ARRAY [like item])
		do
			make_table (Iterable.count (functions))
			extend_from_list (functions)
		end

feature -- Element change

	extend_from_list (functions: ITERABLE [like item])
		do
			accommodate (count + Iterable.count (functions))
			across functions as f loop
				put (f.item, f.item.generating_type.generic_parameter_type (2).type_id)
			end
		end

end