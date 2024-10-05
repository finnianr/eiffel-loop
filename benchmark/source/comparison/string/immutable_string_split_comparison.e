note
	description: "Compare iterating immutable VS changeable string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "15"

class
	IMMUTABLE_STRING_SPLIT_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

create
	make

feature -- Access

	Description: STRING = "Iterating immutable VS changeable list"

feature -- Basic operations

	execute
		local
			split_list_1: EL_SPLIT_STRING_32_LIST; split_list_2: EL_SPLIT_IMMUTABLE_STRING_32_LIST
		do
			create split_list_1.make_adjusted (Name_manifest, ',', {EL_SIDE}.Left)
			create split_list_2.make_shared_adjusted (Name_manifest, ',', {EL_SIDE}.Left)

			compare ("compare split list iteration", <<
				["EL_SPLIT_STRING_32_LIST", agent changeable_split_list (split_list_1)],
				["EL_SPLIT_IMMUTABLE_STRING_32_LIST", agent immutable_split_list (split_list_2)]
			>>)
		end

feature {NONE} -- Operations

	changeable_split_list (list: EL_SPLIT_STRING_32_LIST)
		local
			count: INTEGER
		do
			from list.start until list.after loop
				count := list.item.count
				list.forth
			end
		end

	immutable_split_list (list: EL_SPLIT_IMMUTABLE_STRING_32_LIST)
		local
			count: INTEGER
		do
			from list.start until list.after loop
				count := list.item.count
				list.forth
			end
		end

end