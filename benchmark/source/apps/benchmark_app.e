note
	description: "[
		Command line interface to class [$source EL_BENCHMARK_COMMAND_SHELL] which
		contains a menu of benchmarks for various classes.
	]"
	notes: "[
		Command switch: -benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-05 15:56:13 GMT (Sunday 5th February 2023)"
	revision: "23"

class
	BENCHMARK_APP

inherit
	EL_COMMAND_SHELL_APPLICATION [BENCHMARK_COMMAND_SHELL]
		redefine
			argument_specs, default_make, initialize
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (0)
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