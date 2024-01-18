note
	description: "Command line interface to command ${CAD_MODEL_SLICER}"
	instructions: "[
		**Usage:**
		
			el_toolkit -cad_model_slicer -model <json model path> [-logging]

			el_toolkit -cad_model_slicer -help

			el_toolkit -version

		**Output**
		
		If the input file is named, `my-model.json', the output will be named
			
			my-model-dry.json
			my-model-wet.json
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	CAD_MODEL_SLICER_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [CAD_MODEL_SLICER]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("model", "Path to model data in JSON format", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, CAD_MODEL_SLICER]
			--
		do
			create Result.make
		end

end