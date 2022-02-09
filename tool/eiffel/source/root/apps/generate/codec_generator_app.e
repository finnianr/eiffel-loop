note
	description: "Command-line interface to [$source CODEC_GENERATOR] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 17:53:44 GMT (Wednesday 9th February 2022)"
	revision: "21"

class
	CODEC_GENERATOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [CODEC_GENERATOR]
		redefine
			Option_name
		end

	EIFFEL_LOOP_TEST_ROUTINES

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("c_source", "C source code path", << file_must_exist >>),
				optional_argument ("template", "Eiffel codec template", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (default_decoder_c_path, "doc/zcodec_template.evol")
		end

	default_decoder_c_path: FILE_PATH
		do
			Result := Eiffel_loop_dir + "contrib/C/VTD-XML.2.7/source/decoder.c"
		end

feature {NONE} -- Constants

	Option_name: STRING = "generate_codecs"

end