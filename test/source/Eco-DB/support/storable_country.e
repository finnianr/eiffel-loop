note
	description: "Storable country"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 8:07:34 GMT (Wednesday 19th May 2021)"
	revision: "13"

class
	STORABLE_COUNTRY

inherit
	COUNTRY
		rename
			is_any_field as is_storable_field
		undefine
			is_storable_field, new_meta_data, Transient_fields, is_equal, use_default_values
		end

	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		undefine
			new_representations
		select
			is_storable_field
		end

create
	make, make_default

feature {NONE} -- Constants

	Field_hash: NATURAL_32 = 2853853112

end