﻿note
	description: "Command shell for various kinds of performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 16:23:47 GMT (Friday 11th February 2022)"
	revision: "21"

class
	BENCHMARK_COMMAND_SHELL

inherit
	EL_BENCHMARK_COMMAND_SHELL
		export
			{EL_COMMAND_CLIENT} make
		end

create
	make

feature -- Constants

	Description: STRING = "Menu driven benchmark tests"

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [EL_BENCHMARK_COMPARISON]
		once
			create Result.make (<<
				["call on expanded vs once ref object",			{EXPANDED_VS_ONCE_COMPARISON}],
				["filling linked VS arrayed list",					{ARRAYED_LIST_VS_LINKED_LIST_COMPARISON}],
				["finding files with extension",						{FINDING_FILES_WITH_EXTENSION_COMPARISON}],
				["list iteration methods",								{LIST_ITERATION_COMPARISON}],
				["hash-set vs linear search",							{HASH_SET_VERSUS_LINEAR_COMPARISON}],
				["hash-table vs nameables-list search",			{HASH_TABLE_VS_NAMEABLES_LIST_COMPARISON}],
				["setting agent routine argument",					{SET_ROUTINE_ARGUMENT_COMPARISON}],
				["string concatenation methods",						{STRING_CONCATENATION_COMPARISON}],
				["unencoded list generation",							{UNENCODED_CHARACTER_LIST_GENERATION}],

				["CSV parsing methods",									{CSV_PARSING_COMPARISON}],
				["STRING split iteration methods",					{STRING_SPLIT_ITERATION_COMPARISON}],
				["XML parsers",											{XML_PARSING_COMPARISON}],

				["{L1_UC_STRING}.make_general",						{MAKE_GENERAL_COMPARISON}],
				["{L1_UC_STRING}.unicode",								{UNICODE_ITEM_COMPARISON}],
				["{ZSTRING}.append_zcode VS append_character",	{APPEND_Z_CODE_VS_APPEND_CHARACTER}],
				["{ZSTRING}.replace_substring",						{REPLACE_SUBSTRING_COMPARISON}],
				["{ZSTRING}.substring_index",							{SUBSTRING_INDEX_COMPARISON}],
				["{ZSTRING}.split_intervals",							{ZSTRING_SPLIT_COMPARISON}]
			>>)
		end

end