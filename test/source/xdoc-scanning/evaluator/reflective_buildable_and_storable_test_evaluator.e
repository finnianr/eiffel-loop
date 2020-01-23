note
	description: "Reflective buildable and storable as xml test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:56:57 GMT (Thursday 23rd January 2020)"
	revision: "5"

class
	REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("reflective_buildable_and_storable_as_xml", agent item.test_reflective_buildable_and_storable_as_xml)
			test ("read_write", agent item.test_read_write)
		end

end
