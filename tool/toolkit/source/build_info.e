note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

	date: "2023-04-12 13:09:02 GMT (Wednesday 12th April 2023)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = 01_09_00

	Build_number: NATURAL = 613

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/toolkit"
		end

end