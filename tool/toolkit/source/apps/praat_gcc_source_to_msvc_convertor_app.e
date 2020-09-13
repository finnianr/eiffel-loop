note
	description: "[
		Tool to convert Praat C source file directory and make file to compile with MS Visual C++
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-13 11:30:30 GMT (Sunday 13th September 2020)"
	revision: "7"

class
	PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR]
		redefine
			Option_name
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source_tree", "Praat C source tree", << directory_must_exist >>),
				optional_argument ("output_dir", "Output directory for MS VC compatible code")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (
				"", execution.variable_dir_path ("EIFFEL_LOOP").joined_dir_path ("C_library/Praat-MSVC")
			)
		end

feature {NONE} -- Constants

	Option_name: STRING = "praat_to_msvc"

	Description: STRING = "Convert Praat C source file directory and make file to compile with MS Visual C++"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			 Result := <<
				[{PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP}, All_routines],
				[{FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER}, All_routines],
				[{PROCEDURE_PRAAT_RUN_GCC_TO_MSVC_CONVERTER}, All_routines]
			>>
		end

end
