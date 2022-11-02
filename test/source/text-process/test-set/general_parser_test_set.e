note
	description: "First text parser test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-02 8:16:18 GMT (Wednesday 2nd November 2022)"
	revision: "20"

class
	GENERAL_PARSER_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_EIFFEL_TEXT_PATTERN_FACTORY
		undefine
			default_create
		end

	EL_SHARED_TEST_TEXT

	EL_SHARED_TEST_NUMBERS

	EL_SHARED_TEST_XML_DATA

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("back_reference_match", agent test_back_reference_match)
			eval.call ("find_all", agent test_find_all)
			eval.call ("integer_match", agent test_integer_match)
			eval.call ("match_p1_while_not_p2", agent test_match_p1_while_not_p2)
			eval.call ("numbers_array_parsing", agent test_numbers_array_parsing)
			eval.call ("numeric_match", agent test_numeric_match)
			eval.call ("quoted_string", agent test_quoted_string)
			eval.call ("recursive_match", agent test_recursive_match)
			eval.call ("string_view", agent test_string_view)
			eval.call ("unencoded_as_latin", agent test_unencoded_as_latin)
			eval.call ("xpath_parser", agent test_xpath_parser)
		end

feature -- Test

	test_back_reference_match
		note
			testing: "covers/{EL_BACK_REFERENCE_MATCH_TP}.match_count"
		local
			name, output: ZSTRING; pattern: like all_of
		do
			create output.make_empty
			pattern := xml_text_element (agent append_matched_1 (?, output))
			pattern.parse (XML.name_template #$ [Name_susan])
			assert ("match_count OK", Name_susan ~ output)
		end

	test_find_all
		note
			testing: "covers/{EL_TEXT_PATTERN}.find_all"
		local
			pattern: EL_TEXT_PATTERN; comma_separated_list, source_line: STRING
		do
			create comma_separated_list.make_empty
			pattern := pyxis_assignment (comma_separated_list)
			source_line := XML.pyxis_attributes_line (XML.Attribute_table)
			pattern.find_all (source_line, agent on_unmatched_text (?, comma_separated_list))
			assert ("find_all OK", XML.Attributes_comma_separated_values ~ comma_separated_list)
		end

	test_integer_match
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count"
		local
			double: DOUBLE; boolean: BOOLEAN
		do
			across Number.Doubles_list as n loop
				double := n.item
				if double.rounded /~ double then
					boolean := not integer_constant.matches_string_general (double.out)
				else
					boolean := integer_constant.matches_string_general (double.out)
				end
				assert ("matches_string_general OK", boolean)
			end
		end

	test_match_p1_while_not_p2
		local
			list: ARRAYED_LIST [STRING]; boolean: BOOLEAN; start_index, end_index: INTEGER_32
			assignment: like eiffel_string_assignment; view: EL_STRING_8_VIEW
		do
			create list.make (1)
			assignment := eiffel_string_assignment (list)
			view := Eiffel_statement
			assignment.match (view)
			if assignment.is_matched and then assignment.count = Eiffel_statement.count then
				assignment.call_actions (view)
				start_index := Eiffel_statement.index_of ('"', 1) + 1
				end_index := Eiffel_statement.count - 1
				boolean := list.first ~ Eiffel_statement.substring (start_index, end_index)
			end
			assert ("match_p1_while_not_p2 OK", boolean)
		end

	test_numbers_array_parsing
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count",
						"covers/{EL_LITERAL_TEXT_PATTERN}.match_count",
						"covers/{EL_MATCH_ZERO_OR_MORE_TIMES_TP}.match_count",
						"covers/{EL_MATCH_ANY_CHAR_IN_SET_TP}.match_count",
						"covers/{EL_LITERAL_CHAR_TP}.match_count",
						"covers/{EL_MATCH_CHAR_IN_ASCII_RANGE_TP}.match_count"
		local
			pattern: like numeric_array_pattern; view: EL_STRING_8_VIEW
			is_full_match: BOOLEAN; number_list: ARRAYED_LIST [DOUBLE]
		do
			create number_list.make (10)
			pattern := numeric_array_pattern (number_list)
			create view.make (Text.doubles_array_manifest)
			pattern.match (view)
			is_full_match := pattern.is_matched and pattern.count = view.count
			assert ("numeric_array_pattern: is_full_match OK", is_full_match)
			pattern.call_actions (view)
			assert ("parsed Eiffel numeric array OK", number_list.to_array ~ Number.Doubles_list)
		end

	test_numeric_match
		note
			testing: "covers/{EL_MATCH_ALL_IN_LIST_TP}.match_count"
		local
			double: DOUBLE
		do
			across Number.Doubles_list as n loop
				double := n.item
				assert ("matches_string_general OK", numeric_constant.matches_string_general (double.out))
			end
		end

	test_quoted_string
		local
			pattern: like quoted_string
			str_1, str_2: ZSTRING
		do
			str_1 := "one two"; create str_2.make_empty
			pattern := quoted_string (string_literal ("\%""), agent on_unmatched_text (?, str_2))
			pattern.parse (str_1.enclosed ('"', '"'))
			assert ("match OK", str_1 ~ str_2)
		end

	test_recursive_match
		note
			testing: "covers/{EL_RECURSIVE_TEXT_PATTERN}.match"
		local
			eiffel_type: like type; type_string: ZSTRING
		do
			eiffel_type := type
			across Eiffel_types.split_list ('%N') as line loop
				type_string := line.item
				assert ("match OK", type_string.matches (eiffel_type))
				type_string := type_string + " X"
				assert ("not match OK", not type_string.matches (eiffel_type))
			end
		end

	test_string_view
		local
			str, second_word: ZSTRING; view: EL_ZSTRING_VIEW
		do
			str := Text.russian; second_word := str.split_list (' ').i_th (2)
			create view.make (str)
			view.prune_leading (str.substring_index (second_word, 1) - 1)
			view.set_count (second_word.count)
			assert ("same as second word", view.to_string.same_string (second_word))
		end

	test_unencoded_as_latin
		-- test with characters not encodeable as Latin-1
		note
			testing: "covers/{EL_MATCH_ONE_OR_MORE_TIMES_TP}.match_count",
						"covers/{EL_MATCH_ANY_CHAR_IN_SET_TP}.match_count",
						"covers/{EL_ZSTRING_VIEW}.to_string, covers/{EL_ZSTRING_VIEW}.append_substring_to",
						"covers/{EL_PARSER}.find_all"
		local
			pattern: like repeated_character_in_set
			source_text, character_set: ZSTRING; output: ZSTRING
			matcher: EL_TEXT_MATCHER
		do
			create output.make_empty
			source_text := Text.russian
			character_set := source_text.substring_end (source_text.count - 1) -- last two
			create matcher.make
			matcher.set_source_text (source_text)

			across << agent append_matched_1 (?, output), agent append_matched_2 (?, output) >> as action loop
				output.wipe_out
				pattern := repeated_character_in_set (character_set, action.item)
				matcher.set_pattern (pattern)
				matcher.find_all
				assert ("last two occur twice", output ~ character_set.multiplied (2))
			end
		end

	test_xpath_parser
		note
			testing: "covers/{EL_XPATH_PARSER}.parse"
		local
			parser: EL_XPATH_PARSER; steps: LIST [STRING]; parsed_step: EL_PARSED_XPATH_STEP
			index_of_at, index_of_equal: INTEGER
		do
			create parser.make
			across XML.Xpaths.split ('%N') as xpath loop
				steps := xpath.item.split ('/')
				parser.set_source_text (xpath.item)
				parser.parse
				across steps as step loop
					parsed_step := parser.step_list.i_th (step.cursor_index)
					assert ("parser OK", parsed_step.step ~ step.item)
					index_of_at := step.item.index_of ('@', 1)
					if index_of_at > 0 then
						index_of_equal := step.item.index_of ('=', 1)
						assert ("parser OK",
							parsed_step.selecting_attribute_name ~ step.item.substring (index_of_at, index_of_equal - 1)
						)
					end
				end
			end
		end

feature {NONE} -- Patterns

	double_quote_escape_sequence: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<< string_literal ("\\"), string_literal ("\%"") >>)
		end

	numeric_array_pattern (list: ARRAYED_LIST [DOUBLE]): like all_of
		do
			Result := all_of (<<
				string_literal ("<<"), maybe_white_space,
				numeric_constant |to| agent on_numeric (? ,list),
				zero_or_more (
					all_of (<<
						maybe_white_space, character_literal (','), maybe_white_space,
						numeric_constant |to| agent on_numeric (? ,list)
					>>)
				),
				maybe_white_space,
				string_literal (">>")
			>>)
		end

	pyxis_assignment (comma_separated_list: STRING): like all_of
			--
		do
			Result := all_of ( <<
				character_literal ('='),
				maybe_non_breaking_white_space,
				one_of (<<
					xml_identifier |to| agent on_value (?, comma_separated_list),
					numeric_constant |to| agent on_value (?, comma_separated_list),
					quoted_string (double_quote_escape_sequence, agent on_quoted_value (?, 2, comma_separated_list)),
					single_quoted_string (single_quote_escape_sequence, agent on_quoted_value (?, 1, comma_separated_list))
				>>)
			>> )
		end

	repeated_character_in_set (character_set: ZSTRING; on_match: PROCEDURE [EL_STRING_VIEW]): like one_or_more
		do
			Result := one_or_more (one_character_from (character_set)) |to| on_match
		end

	single_quote_escape_sequence: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of ( << string_literal ("\\"), string_literal ("\'") >> )
		end

	xml_text_element (a_action: like default_action): like all_of
		local
			tag_name: like c_identifier
			any_text: like while_not_p1_repeat_p2
		do
			any_text := while_not_p1_repeat_p2 (character_literal ('<'), any_character )
			any_text.set_action_combined_p2 (a_action)
			tag_name := c_identifier
			Result := all_of (<<
				character_literal ('<'),
				tag_name,
				character_literal ('>'),
				any_text,
				character_literal ('/'),
				previously_matched (tag_name),
				character_literal ('>')
			>>)
		end

feature {NONE} -- Parse events handlers

	on_numeric (matched: EL_STRING_VIEW; list: ARRAYED_LIST [DOUBLE])
		local
			str: STRING
		do
			str := matched.to_string_8
			if str.is_double then
				list.extend (str.to_double)
			end
		end

	on_quoted_value (matched: EL_STRING_VIEW; quote_count: INTEGER; comma_separated_list: STRING)
		local
			s: EL_STRING_8_ROUTINES
		do
			if not comma_separated_list.is_empty then
				comma_separated_list.append_character (',')
			end
			comma_separated_list.append_string (s.quoted (matched.to_string_8, quote_count))
		end

	on_str (matched: EL_STRING_VIEW; list: ARRAYED_LIST [STRING])
		do
			list.extend (matched.to_string_8)
		end

	on_unmatched_text (matched: EL_STRING_VIEW; source: EL_ZSTRING)
		do
			source.append_string (matched.to_string)
		end

	on_value (matched: EL_STRING_VIEW; comma_separated_list: STRING)
		do
			if not comma_separated_list.is_empty then
				comma_separated_list.append_character (',')
			end
			comma_separated_list.append_string (matched.to_string_8)
		end

feature {NONE} -- Implementation

	append_matched_1 (matched: EL_STRING_VIEW; str: ZSTRING)
		do
			str.append (matched.to_string)
		end

	append_matched_2 (matched: EL_STRING_VIEW; str: ZSTRING)
		do
			matched.append_to (str)
		end

	eiffel_string_assignment (list: ARRAYED_LIST [STRING]): like all_of
		do
			Result := all_of (<<
				identifier, maybe_non_breaking_white_space, string_literal (":="), maybe_non_breaking_white_space,
				quoted_manifest_string (agent on_str (?, list))
			>>)
		end

	xml_identifier_character: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
		do
			Result := identifier_character
			Result.extend (character_literal ('-'))
		end

	xml_identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				one_of (<< letter, character_literal ('_') >> ),
				zero_or_more (xml_identifier_character)
			>>)
		end

feature {NONE} -- Constants

	Eiffel_statement: STRING = "[
		str := "1%N2%"/3"
	]"

	Eiffel_types: ZSTRING
		once
			Result := "[
				STRING
				ARRAY [STRING]
				HASH_TABLE [STRING, STRING]
				ARRAY [HASH_TABLE [STRING, STRING]]
				HASH_TABLE [ARRAY [HASH_TABLE [STRING, STRING]], STRING]
			]"
		end

	Is_zstring_source: BOOLEAN = True

	Name_susan: ZSTRING
		once
			Result := "Susan Miller"
		end

end