note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2021-04-29 13:05:29 GMT (Thursday 29th April 2021)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_03_03

	Build_number: NATURAL = 135

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end