note
	description: "Set of 2 file paths indexable by [$source BOOLEAN] values **True** or **False**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-08-23 10:31:28 GMT (Tuesday 23rd August 2022)"
	revision: "1"

class
	EL_FILE_PATH_BINARY_SET

inherit
	EL_BOOLEAN_INDEXABLE [FILE_PATH]

create
	make_with_prefix, make, make_with_function

feature {NONE} -- Initialization

	make_with_prefix (true_item: FILE_PATH; a_prefix: READABLE_STRING_GENERAL; overlap_count: INTEGER)
		-- make with `item_false' derived from from `true_item' by prefixing `true_item.base' with `a_prefix'
		-- overlapping leading characters of `true_item.base' by `overlap_count'
		require
			base_big_enough: overlap_count.to_boolean implies overlap_count <= true_item.base.count
		local
			false_item: FILE_PATH
		do
			false_item := true_item.twin
			if overlap_count > 0 and overlap_count <= true_item.base.count then
				false_item.base.replace_substring_general (a_prefix, 1, overlap_count)
			else
				false_item.base.prepend_string_general (a_prefix)
			end
			make (false_item, true_item)
		ensure
			valid_item: item_false.base.count = a_prefix.count + (item_true.base.count - overlap_count)
		end

feature -- Status query

	all_exist: BOOLEAN
		do
			Result := for_all (agent {FILE_PATH}.exists)
		end

end