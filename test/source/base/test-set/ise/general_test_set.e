﻿note
	description: "General test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 14:50:17 GMT (Sunday 9th May 2021)"
	revision: "6"

class
	GENERAL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_DOUBLE_MATH undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("math_precision", agent test_math_precision)
			eval.call ("any_array_numeric_type_detection", agent test_any_array_numeric_type_detection)
			eval.call ("character_32_status_queries", agent test_character_32_status_queries)
			eval.call ("environment_put", agent test_environment_put)
		end

feature -- Tests

	test_any_array_numeric_type_detection
		local
			array: ARRAY [ANY]
		do
			array := << (1).to_reference, 1.0, (1).to_integer_64 >>
			assert ("same types", array.item (1).generating_type ~ {INTEGER_32_REF})
			assert ("same types", array.item (2).generating_type ~ {DOUBLE})
			assert ("same types", array.item (3).generating_type ~ {INTEGER_64})
		end

	test_character_32_status_queries
		do
--			Bug in finalized exe for compiler version 16.05
--			assert ("not is_space", not ({CHARACTER_32}'€').is_space)
--			assert ("not is_digit ", not ({CHARACTER_32}'€').is_digit)

			assert ("not is_alpha", not ({CHARACTER_32}'€').is_alpha)
			assert ("not is_punctuation", not ({CHARACTER_32}'€').is_punctuation)
			assert ("not is_control", not ({CHARACTER_32}'€').is_control)
		end

	test_environment_put
		local
			name: STRING
		do
			name := "EIFFEL_LOOP_DOC"
			Execution_environment.put ("eiffel-loop", name)
			Execution_environment.put ("", name)
			assert ("not attached", not attached Execution_environment.item (name))
		end

	test_math_precision
		local
			math: EL_DOUBLE_MATH_ROUTINES
		do
			assert ("equal within 1 percent", math.approximately_equal (169, 170, 0.01))
			assert ("not equal within 1 percent", not math.approximately_equal (168, 170, 0.01))
		end

end