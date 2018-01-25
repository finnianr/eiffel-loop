note
	description: "Summary description for {STORABLE_COUNTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-23 15:02:29 GMT (Tuesday 23rd January 2018)"
	revision: "3"

class
	STORABLE_COUNTRY

inherit
	COUNTRY
		rename
			is_any_field as is_storable_field
		undefine
			is_storable_field, new_meta_data, Except_fields, is_equal, use_default_values
		end

	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		select
			is_storable_field
		end

create
	make, make_default

feature -- Access

	temperature_range: TUPLE [winter, summer: INTEGER; unit_name: STRING]

feature {NONE} -- Constants

	Field_hash: NATURAL_32 = 2945197152

end
