note
	description: "Test parsing of Eiffel language expressions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-04 10:28:08 GMT (Friday 4th February 2022)"
	revision: "8"

class
	EIFFEL_PARSING_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

	EL_ENCODING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("code_highlighting", agent test_code_highlighting)
		end

feature -- Tests

	test_code_highlighting
		note
			testing: "covers/{EL_FILE_PARSER_TEXT_EDITOR}.edit",
				"covers/{EL_XML_ROUTINES}.escaped_128_plus",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.comment",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.unescaped_manifest_string",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.character_manifest",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.identifier",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.quoted_manifest_string"
		local
			writer: CODE_HIGHLIGHTING_WRITER; html_path: FILE_PATH
			xdoc: EL_XPATH_ROOT_NODE_CONTEXT; xpath: STRING
		do
			assert ("source exists", file_list.count > 0)
			html_path := file_list.first_path.with_new_extension ("html")
			if attached open (html_path, Write) as html_out then
				html_out.set_encoding (Latin_1)
				create writer.make (html_out)
				writer.set_file_path (file_list.first_path)
				writer.edit
			end
			create xdoc.make_from_file (html_path)

			across Emphasis_counts as count loop
				xpath := Xpath_count_template #$ [count.key]
				lio.put_labeled_string ("check xpath", xpath)
				lio.put_new_line
				assert ("same count " + count.key, xdoc.integer_at_xpath (xpath) = count.item)
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "el_mp3_convert_command.e" >>)
		end

feature {NONE} -- Constants

	Emphasis_counts: EL_HASH_TABLE [INTEGER, STRING]
		once
			create Result.make (<<
				["quote", 13],
				["class", 21],
				["comment", 13],
				["keyword", 7]
			>>)
		end

	Data_dir: DIR_PATH
		once
			Result := Eiffel_loop_dir #+ "tool/eiffel/test-data/sources/latin-1/os-command"
		end

	Is_zstring_source: BOOLEAN = False

	Xpath_count_template: ZSTRING
		once
			Result := "count (//em[@id='%S'])"
		end

end