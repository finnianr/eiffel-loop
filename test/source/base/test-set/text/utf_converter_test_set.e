note
	description: "Test ${EL_UTF_CONVERTER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "12"

class
	UTF_CONVERTER_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["little_endian_utf_16_substring_conversion", agent test_little_endian_utf_16_substring_conversion],
				["utf_8_substring_conversion",					 agent test_utf_8_substring_conversion]
			>>)
		end

feature -- Test

	test_little_endian_utf_16_substring_conversion
		do
			do_test (agent test_utf_16_le)
			test_utf_16_le (Text.G_clef, 0, 0)
		end

	test_utf_8_substring_conversion
		-- UTF_CONVERTER_TEST_SET.test_utf_8_substring_conversion
		do
			do_test (agent test_utf_8)
		end

feature {NONE} -- Implementation

	do_test (test_utf: PROCEDURE [STRING_32, INTEGER, INTEGER])
		local
			str_32: STRING_32; i, leading_count, trailing_count: INTEGER
		do
			across Text.lines as line loop
				str_32 := line.item
				from i := 1 until i > str_32.count or else str_32.code (i) > 0x7F loop
					i := i + 1
				end
				leading_count := i - 1
				from i := str_32.count until i = 0 or else str_32.code (i) > 0x7F loop
					i := i - 1
				end
				trailing_count := str_32.count - i
				test_utf (str_32, leading_count, trailing_count)
			end
		end

	test_utf_16_le (str_32: STRING_32; leading_count, trailing_count: INTEGER)
		local
			utf_16_le_string: STRING_8; utf_16_le: EL_UTF_16_LE_CONVERTER; substring_32: STRING_32
		do
			utf_16_le_string := utf_16_le.string_32_to_string_8 (str_32)
			create substring_32.make_empty
			utf_16_le.substring_8_into_string_32 (
				utf_16_le_string, leading_count * 2 + 1, utf_16_le_string.count - trailing_count * 2, substring_32
			)
			assert ("same string", str_32.substring (leading_count + 1, str_32.count - trailing_count) ~ substring_32)
		end

	test_utf_8 (str_32: STRING_32; leading_count, trailing_count: INTEGER)
		local
			utf_8_string: STRING_8; utf_8: EL_UTF_8_CONVERTER; substring_32: STRING_32
		do
			utf_8_string := utf_8.string_32_to_string_8 (str_32)
			create substring_32.make_empty
			utf_8.substring_8_into_string_general (
				utf_8_string, leading_count + 1, utf_8_string.count - trailing_count, substring_32
			)
			assert ("same string", str_32.substring (leading_count + 1, str_32.count - trailing_count) ~ substring_32)
		end

end