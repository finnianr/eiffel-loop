note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-21 11:21:50 GMT (Tuesday 21st January 2025)"
	revision: "8"

class
	EL_TRAFFIC_ANALYSIS_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			make_from_file as make
		end

create
	make

feature -- Access

	log_path: FILE_PATH

	crawler_substrings: EL_ZSTRING_LIST

	page_list: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Element_node_fields: STRING = "crawler_substrings, page_list"

end