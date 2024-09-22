note
	description: "Batch file script to build Praat with MSVC compiler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:42:52 GMT (Sunday 22nd September 2024)"
	revision: "2"

class
	PRAAT_BUILD_SCRIPT

inherit
	EVOLICITY_SERIALIZEABLE

create
	make

feature {NONE} -- Initialization

	make (a_c_library_name_list: LIST [ZSTRING]; output_dir: DIR_PATH; a_praat_version_no: STRING)
		do
			make_from_file (output_dir.joined_file_tuple (["build_all_" + a_praat_version_no + ".bat"]))
		end

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["c_library_name_list",	agent: LIST [ZSTRING] do Result := c_library_name_list end],
				["praat_version_no",		agent: STRING do Result := praat_version_no end]
			>>)
		end

feature {NONE} -- Internal attributes

	c_library_name_list: LIST [ZSTRING]

	praat_version_no: STRING

feature {NONE} -- Constants

	Template: STRING = "[
		Rem DO NOT EDIT
		Rem Generated by Eiffel-LOOP build tool from class PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP

		set INCLUDE=%MSVC%\include;%PLATFORM_SDK%\Include;%EIFFEL_LOOP%\C_library\dirent\include
		set LIB=%LIB%;%PLATFORM_SDK%\Lib;%MSVC%\lib

		#foreach $directory in $c_library_name_list loop
		cd sources_$praat_version_no\$directory
		nmake /f Makefile
		cd ..\..
		#end
		echo FINISHED!
		pause
	]"

end