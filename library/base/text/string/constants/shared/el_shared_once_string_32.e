note
	description: "Shared instance of class `STRING_32' that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 10:23:14 GMT (Tuesday 5th January 2021)"
	revision: "3"

deferred class
	EL_SHARED_ONCE_STRING_32

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	once_adjusted_32 (str: STRING_32): STRING_32
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := once_empty_string_32
			Result.append_substring (str, s.left_white_count (str) + 1, str.count - s.right_white_count (str))
		end

	once_empty_string_32: like Once_string_32
		do
			Result := Once_string_32
			Result.wipe_out
		end

	once_copy_32 (str_32: STRING_32): STRING_32
		do
			Result := once_empty_string_32
			Result.append (str_32)
		end

	once_copy_general_32 (str: READABLE_STRING_GENERAL): STRING_32
		do
			Result := once_empty_string_32
			if attached {ZSTRING} str as zstr then
				zstr.append_to_string_32 (Result)
			else
				Result.append_string_general (str)
			end
		end

	once_substring_32 (str_32: STRING_32; start_index, end_index: INTEGER): STRING_32
		do
			Result := once_empty_string_32
			Result.append_substring (str_32, start_index, end_index)
		end

feature {NONE} -- Constants

	Once_string_32: STRING_32
		once
			create Result.make_empty
		end
end