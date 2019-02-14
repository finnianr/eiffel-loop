note
	description: "Search engine test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-14 12:40:10 GMT (Thursday 14th February 2019)"
	revision: "1"

class
	SEARCH_ENGINE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [SEARCH_ENGINE_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["persistent_word_table", agent item.test_persistent_word_table]
			>>)
		end
end
