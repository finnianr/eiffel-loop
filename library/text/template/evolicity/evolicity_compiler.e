note
	description: "Evolicity compiler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-20 17:34:03 GMT (Sunday 20th November 2022)"
	revision: "21"

class
	EVOLICITY_COMPILER

inherit
	EL_TOKEN_PARSER [EVOLICITY_FILE_LEXER]
		rename
			match_full as parse,
			parse as parse_and_compile,
			fully_matched as parse_succeeded,
			call_actions as compile
		export
			{ANY} parse, parse_succeeded
		redefine
			set_source_text_from_file, set_source_text_from_line_source
		end

	EVOLICITY_PARSE_ACTIONS
		rename
			make as reset_directives
		end

	EL_TEXT_PATTERN_FACTORY
		rename
			quoted_string as quoted_string_pattern
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_BUILD_INFO

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create modification_time.make_from_epoch (0)
			reset_directives
			encoding := 0 -- indicates a text source by default
		end

feature -- Access

	compiled_template: EVOLICITY_COMPILED_TEMPLATE
		do
			reset_directives
			compile
			create Result.make (compound_directive.to_array, modification_time, Current)
			Result.set_minimum_buffer_length ((source_text.count * 1.5).floor)
		end

	modification_time: EL_DATE_TIME

feature -- Element change

 	set_source_text_from_file (file_path: FILE_PATH)
 		require else
 			valid_encoding_set: valid_encoding (encoding_type | encoding_id)
		do
			modification_time := file_path.modification_date_time
			Precursor (file_path)
		end

	set_source_text_from_line_source (lines: EL_PLAIN_TEXT_LINE_SOURCE)
			--
		local
			compiled_source_path: FILE_PATH
		do
 			source_file_path := lines.file_path
 			set_encoding_from_other (lines) -- May have detected UTF-8 BOM

			compiled_source_path := source_file_path.with_new_extension ("evc")
			if compiled_source_path.exists
				and then same_software_version (compiled_source_path)
				and then compiled_source_path.modification_date_time > source_file_path.modification_date_time
			then
				read_tokens_text (compiled_source_path)
				source_text := lines.joined
	 			reset
			else
	 			set_source_text (lines.joined)
	 			-- Check write permission
				if compiled_source_path.parent.exists_and_is_writeable then
					write_tokens_text (compiled_source_path)
				end
			end
		end

feature {NONE} -- Loop Directives

	across_directive: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_across)	|to| loop_action (Token.keyword_across),
				variable_reference 					|to| loop_action (Token.keyword_in),
				keyword (Token.keyword_as),
				variable_reference					|to| loop_action (Token.keyword_as),
				keyword (Token.keyword_loop),
				recurse (agent zero_or_more_directives, 1),
				keyword (Token.keyword_end)		|to| loop_action (Token.keyword_end)
			>>)
		end

	foreach_directive: like all_of
			-- Match: foreach ( V in V )
		do
			Result := all_of (<<
				keyword (Token.keyword_foreach)	|to| loop_action (Token.keyword_foreach),
				variable_reference					|to| loop_action (Token.keyword_as),
				optional (
					variable_reference				|to| loop_action (Token.keyword_as)
				),
				keyword (Token.keyword_in),
				variable_reference 					|to| loop_action (Token.keyword_in),
				keyword (Token.keyword_loop),
				recurse (agent zero_or_more_directives, 1),
				keyword (Token.keyword_end)		|to| loop_action (Token.keyword_end)
			>>)
		end

feature {NONE} -- Branch Directives

	else_directive: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_else),
				recurse (agent zero_or_more_directives, 1)
			>>)
		end

	if_else_end_directive: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_if) 		|to| if_action (Token.keyword_if),
				boolean_expression,
				keyword (Token.keyword_then) 		|to| if_action (Token.keyword_then),
				recurse (agent zero_or_more_directives, 1),
				optional (else_directive)			|to| if_action (Token.keyword_else),
				keyword (Token.keyword_end) 		|to| if_action (Token.keyword_end)
			>>)
		end

feature {NONE} -- Directives

	control_directive: like one_of
			--
		do
			Result := one_of (<< foreach_directive, across_directive, if_else_end_directive >> )
		end

	directive: like one_of
			--
		do
			Result := one_of (
				<< keyword (Token.Free_text)				|to| agent on_free_text,
					keyword (Token.Double_dollor_sign)	|to| agent on_dollor_sign_escape,
					variable_reference 						|to| agent on_variable_reference,
					evaluate_directive,
					include_directive,
					control_directive
				>>
			)
		end

	evaluate_directive: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_evaluate)					|to| evaluate_action (Token.keyword_evaluate),
				keyword (Token.White_text)							|to| evaluate_action (Token.White_text),
				one_of (<<
					keyword (Token.Template_name_identifier)	|to| evaluate_action (Token.Template_name_identifier),
					keyword (Token.Quoted_string)					|to| evaluate_action (Token.Quoted_string),
					variable_reference 								|to| evaluate_action (Token.operator_dot)
				>>),
				variable_reference 									|to| evaluate_action (0)
			>> )
		end

	include_directive: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_include)	|to| include_action (Token.keyword_include),
				keyword (Token.White_text)			|to| include_action (Token.White_text),
				one_of (<<
					keyword (Token.Quoted_string)	|to| include_action (Token.Quoted_string),
					variable_reference 				|to| include_action (Token.operator_dot)
				>>)
			>> )
		end

	new_pattern: like one_or_more
			--
		do
			Result := one_or_more (directive)
		end

	zero_or_more_directives: like zero_or_more
		do
			Result := zero_or_more (directive)
		end

feature {NONE} -- Expresssions

	boolean_expression: like all_of
			--
		local
			conjunction_plus_right_operand: like all_of
		do
			conjunction_plus_right_operand := all_of (<<
				one_of (<< keyword (Token.keyword_and), keyword (Token.keyword_or) >>),
				simple_boolean_expression
			>>)
			conjunction_plus_right_operand.set_action_last (agent on_boolean_conjunction_expression)

			Result := all_of (<<
				simple_boolean_expression, optional (conjunction_plus_right_operand)
			>>)
		end

	boolean_value: like one_of
			--
		do
			Result := one_of (<<
				numeric_comparison_expression,
				variable_reference |to| agent on_boolean_variable
			>>)
		end

	comparable_numeric: like one_of
		do
			Result := one_of (<<
				variable_reference 						|to| comparable_action (Token.operator_dot),
				keyword (Token.integer_64_constant)	|to| comparable_action (Token.integer_64_constant),
				keyword (Token.double_constant)		|to| comparable_action (Token.double_constant)
			>>)
		end

	constant_pattern: like one_of
			--
		do
			Result := one_of (<<
				keyword (Token.Quoted_string),
				keyword (Token.double_constant),
				keyword (Token.integer_64_constant)
			>>)
		end

	function_call: like all_of
		do
			Result := all_of (<<
				keyword (Token.Left_bracket),
				constant_pattern,
				while_not_p1_repeat_p2 (
					keyword (Token.Right_bracket),
					all_of (<<
						keyword (Token.Comma_sign),
						constant_pattern
					>>)
				)
			>>)
		end

	negated_boolean_value: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.keyword_not), boolean_value
			>>)
			Result.set_action_last (agent on_boolean_not_expression)
		end

	numeric_comparison_expression: like all_of
			--
		do
			Result := all_of ( <<
				comparable_numeric, numeric_comparison_operator, comparable_numeric
			>>)
			Result.set_action_last (agent on_comparison_expression)
		end

	numeric_comparison_operator: like all_of
			--
		do
			Result := one_of ( <<
				keyword (Token.operator_less_than)		|to| numeric_comparison_action ('<'),
				keyword (Token.operator_greater_than)	|to| numeric_comparison_action ('>'),
				keyword (Token.operator_equal_to) 		|to| numeric_comparison_action ('='),
				keyword (Token.operator_not_equal_to)
			>>)
		end

	simple_boolean_expression: like one_of
			--
		do
			Result := one_of (<<
				negated_boolean_value, boolean_value
			>>)
		end

	variable_reference: like all_of
			--
		do
			Result := all_of (<<
				keyword (Token.Unqualified_name),
				zero_or_more (
					all_of (<< keyword (Token.operator_dot), keyword (Token.Unqualified_name) >> )
				),
				optional (function_call)
			>>)
		end

feature {NONE} -- Implementation

	read_tokens_text (compiled_source_path: FILE_PATH)
		local
			l_tokens_text: like tokens_text; l_token_text_array: like source_interval_list
			i, count: INTEGER
		do
			if attached open_raw (compiled_source_path, Read) as compiled_source then
				-- skip software version
				compiled_source.move ({PLATFORM}.Natural_32_bytes)

				compiled_source.read_integer
				count := compiled_source.last_integer
				create tokens_text.make (count)
				l_tokens_text := tokens_text
				from i := 1 until i > count loop
					compiled_source.read_natural
					l_tokens_text.append_code (compiled_source.last_natural)
					i := i + 1
				end

				compiled_source.read_integer
				count := compiled_source.last_integer
				source_interval_list.grow (count)
				l_token_text_array := source_interval_list
				from i := 1 until i > count loop
					compiled_source.read_integer_64
					l_token_text_array.item_extend (compiled_source.last_integer_64)
					i := i + 1
				end
				compiled_source.close
			end
		end

	same_software_version (compiled_source_path: FILE_PATH): BOOLEAN
		do
			if attached open_raw (compiled_source_path, Read) as compiled_source then
				compiled_source.read_natural_32
				Result := Build_info.version_number = compiled_source.last_natural_32
				compiled_source.close
			end
		end

	write_tokens_text (compiled_source_path: FILE_PATH)
		local
			area: like tokens_text.area; array_area: like source_interval_list.area
			i, count: INTEGER
		do
			if attached open_raw (compiled_source_path, Write) as compiled_source then
				area := tokens_text.area
				count := tokens_text.count
				compiled_source.put_natural_32 (Build_info.version_number)
				compiled_source.put_integer (count)
				from i := 0 until i = count loop
					compiled_source.put_natural (area.item (i).natural_32_code)
					i := i + 1
				end

				array_area := source_interval_list.area
				count := source_interval_list.count
				compiled_source.put_integer (count)
				from i := 0 until i = count loop
					compiled_source.put_integer_64 (array_area [i])
					i := i + 1
				end
				compiled_source.close
			end
		end

end