note
	description: "[
		Command line interface to class ${EL_BENCHMARK_COMMAND_SHELL} which
		contains a menu of benchmarks for various classes.
	]"
	notes: "[
		Command switch: -benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-05 5:42:58 GMT (Wednesday 5th June 2024)"
	revision: "25"

class
	BENCHMARK_APP

inherit
	EL_COMMAND_SHELL_APPLICATION [BENCHMARK_COMMAND_SHELL]
		redefine
			argument_specs, default_make, initialize
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like shell]
		do
			Result := agent {like shell}.make (0)
		end

	initialize
		do
			Precursor
			Console.show ({EL_BENCHMARK_ROUTINE_TABLE})
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("trial_duration", "Routine trial duration in milliseconds", No_checks)
			>>
		end

end