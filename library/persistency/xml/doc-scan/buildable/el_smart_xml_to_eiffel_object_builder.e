note
	description: "[
		Detects the desired target type from XML processing instruction `create {G}' 
		and sets the type of target_object to G where G is a type conforming to ${EL_BUILDABLE_FROM_XML}. 
		Built object is made available as `product'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER

inherit
	EL_SMART_BUILDABLE_FROM_NODE_SCAN
		rename
			make as make_buildable
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_buildable ({EL_EXPAT_XML_PARSER})
		end

end