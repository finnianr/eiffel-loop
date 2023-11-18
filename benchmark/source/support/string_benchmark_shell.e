﻿note
	description: "String related benchmark comparisons"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 9:30:21 GMT (Saturday 18th November 2023)"
	revision: "39"

class
	STRING_BENCHMARK_SHELL

inherit
	EL_BENCHMARK_COMMAND_SHELL
		export
			{EL_COMMAND_CLIENT} make
		end

create
	make

feature -- Constants

	Description: STRING = "String related benchmark comparisons"

feature {NONE} -- Implementation

	new_benchmarks: TUPLE [
		APPEND_GENERAL_VS_APPEND,
		APPEND_Z_CODE_VS_APPEND_CHARACTER,
		ARRAYED_INTERVAL_LIST_COMPARISON,
		ATTACH_TEST_VS_BOOLEAN_COMPARISON,

		IF_ATTACHED_ITEM_VS_CONFORMING_INSTANCE_TABLE,
		IMMUTABLE_STRING_SPLIT_COMPARISON,
		LINE_STATE_MACHINE_COMPARISON,

		MAKE_GENERAL_COMPARISON,

		STRING_CONCATENATION_COMPARISON,
		STRING_SPLIT_ITERATION_COMPARISON,
		STRING_ITEM_8_VS_ITEM,
		STRING_8_SPLIT_VS_SPLIT_ON_CHARACTER_8,
		SUBSTRING_INDEX_COMPARISON,

		REPLACE_SUBSTRING_ALL_VS_GENERAL,

		UNENCODED_CHARACTER_ITERATION_COMPARISON,
		UNENCODED_CHARACTER_LIST_GENERATION,
		UNICODE_ITEM_COMPARISON,

		ZSTRING_INTERVAL_SEARCH_COMPARISON,
		ZSTRING_SAME_CHARACTERS_COMPARISON,
		ZSTRING_SPLIT_COMPARISON,
		ZSTRING_SPLIT_LIST_COMPARISON,
		ZSTRING_TOKENIZATION_COMPARISON
	]
		do
			create Result
		end

end