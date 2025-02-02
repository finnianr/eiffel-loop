note
	description: "Test ${EL_URL_FILTER_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-02 12:58:41 GMT (Sunday 2nd February 2025)"
	revision: "3"

class
	URL_FILTER_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_IP_ADDRESS

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["is_hacker_probe",	agent test_is_hacker_probe]
			>>)
		end

feature -- Test

	test_is_hacker_probe
		-- URL_FILTER_TABLE_TEST_SET.test_is_hacker_probe
		local
			filter: EL_URL_FILTER_TABLE; predicates: EL_STRING_8_LIST
		do
			create filter.make (7)
			predicates := "has_extension, starts_with, ends_with"
			if attached filter.new_predicate_list as predicate_list then
				assert ("same predicate names", predicates ~ predicate_list)
				filter.extend (predicate_list [1], "asp")
				filter.extend (predicate_list [2], "bot")
				filter.extend (predicate_list [3], "store")

				assert ("match", filter.is_hacker_probe ("home/index.asp"))
				assert ("match", filter.is_hacker_probe ("bot/api"))
				assert ("match", filter.is_hacker_probe (".ds_store"))
				assert ("not match", not filter.is_hacker_probe ("/en/home.html"))
			end
		end

end