note
	description: "Published book information reflectively settable from XML context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 9:36:35 GMT (Thursday 16th June 2022)"
	revision: "10"

class
	EL_BOOK_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			element_node_fields as All_fields,
			xml_naming as Kebab_case
		redefine
			make_default
		end

	EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT
		rename
			getter_function_table as empty_function_table
		undefine
			is_equal
		redefine
			make_default
		end

	EVOLICITY_REFLECTIVE_XML_CONTEXT
		undefine
			is_equal
		end

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT}
		end

feature -- Access

	author: ZSTRING

	creator: ZSTRING

	description: ZSTRING

	language: STRING

	cover_image_path: FILE_PATH
		-- relative path of cover image

	publication_date: STRING

	publisher: ZSTRING

	subject_heading: ZSTRING

	title: ZSTRING

	uuid: STRING

end