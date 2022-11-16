note
	description: "Praat gcc source to msvc convertor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 17:00:15 GMT (Wednesday 16th November 2022)"
	revision: "15"

class
	PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR

inherit
	EL_APPLICATION_COMMAND

	EVOLICITY_SERIALIZEABLE
		rename
			template as build_batch_file_template
		export
			{NONE} all
		end

	EL_TEXT_PATTERN_FACTORY_2
		export
			{NONE} all
		end

	EL_MODULE_LOG

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (input_dir, output_dir: DIR_PATH)
		do
			make_default

			create praat_version_no.make_empty
			create output_directory_text.make_empty
			create directory_content_processor.make (input_dir, output_dir #+ input_dir.base)

			directory_content_processor.do_all (agent set_version_from_path, Praat_source)

			if praat_version_no.is_empty then
				lio.put_labeled_string ("ERROR", "Failed to determine version number from source directory!")
				lio.put_new_line
			else
				create make_file_parser.make

				create converter_table.make (5)
				converter_table.compare_objects

				converter_table ["default"] := create {GCC_TO_MSVC_CONVERTER}.make
				converter_table ["praat.c"] := create {FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER}.make
				converter_table ["motifEmulator.c"] := create {FILE_MOTIF_EMULATOR_C_GCC_TO_MSVC_CONVERTER}.make
				converter_table ["gsl__config.h"] := create {FILE_GSL_CONFIG_H_GCC_TO_MSVC_CONVERTER}.make
				converter_table ["NUM2.c"] := create {FILE_NUM2_C_GCC_TO_MSVC_CONVERTER}.make
			end
		end

feature -- Constants

	Description: STRING = "Convert Praat C source file directory and make file to compile with MS Visual C++"

feature -- Basic operations

	execute
			--
		local
			build_all_batch_file: FILE_PATH; batch_file_name: ZSTRING
		do
			if not praat_version_no.is_empty then
				directory_content_processor.do_all (agent convert_make_file, Source_type.make_file)
				directory_content_processor.do_all (agent convert_c_source_file, Source_type.c_header)
				directory_content_processor.do_all (agent convert_c_source_file, Source_type.c_source)

				batch_file_name := "build_all_" + praat_version_no + ".bat"
				build_all_batch_file := directory_content_processor.output_dir + batch_file_name

				serialize_to_file (build_all_batch_file)
			end
		end

feature {NONE} -- Implementation

	convert_c_source_file (
		input_file_path: FILE_PATH; output_directory: DIR_PATH
		input_file_name, input_file_extension: ZSTRING
	)
			--
		local
			output_file_path: FILE_PATH
			converter: GCC_TO_MSVC_CONVERTER
			source_name: ZSTRING
		do
			log.enter_with_args ("convert_c_source_file", [input_file_path, output_directory, input_file_name])

			output_file_path := input_file_name
			output_file_path.add_extension (input_file_extension)

			source_name := input_file_name.twin
			source_name.append_character ('.')
			source_name.append (input_file_extension)

			converter_table.search (source_name)
			if converter_table.found then
				converter := converter_table.found_item
			else
				converter := converter_table ["default"]
			end

			converter.set_input_file_path (input_file_path)
			converter.set_output_file_path (output_directory + output_file_path)
			converter.edit

			log.exit
		end

	convert_make_file (
		input_file_path: FILE_PATH; output_directory: DIR_PATH; input_file_name, input_file_extension: ZSTRING
	)
			--
		do
			log.enter_with_args ("convert_makefile", [input_file_path, output_directory, input_file_name])
			make_file_parser.new_c_library (input_file_path)

			log.put_string (input_file_path.out)
			log.put_new_line

			if make_file_parser.c_library.is_valid then
				log.put_string_field ("Library name" , make_file_parser.c_library.library_name)
				log.put_new_line
				log.put_integer_field (
					"Number of include directories" , make_file_parser.c_library.include_directory_list.count
				)
				log.put_new_line
				log.put_integer_field ("Number of C objects" , make_file_parser.c_library.object_file_list.count)
				log.put_new_line

				make_file_parser.c_library.set_praat_version_no (praat_version_no)
				make_file_parser.c_library.serialize_to_file (output_directory + input_file_name)
			end
			log.exit
		end

	set_praat_version_no (start_index, end_index: INTEGER)
			--
		do
			praat_version_no := output_directory_text.substring (start_index, end_index)
		end

	set_version_from_path (
		input_file_path: FILE_PATH; output_directory: DIR_PATH
		input_file_name, input_file_extension: ZSTRING
	)
			--
		local
			path_processor: EL_SOURCE_TEXT_PROCESSOR
		once
			log.enter_with_args ("set_version_from_path", [output_directory])
			output_directory_text := output_directory

			create path_processor.make_with_delimiter (agent output_directory_pattern)
			path_processor.set_source_text (output_directory_text)
			path_processor.do_all (Void)
			log.exit
		end

	output_directory_pattern: like all_of
		do
			Result := all_of (<<
				character_literal (Operating_environment.Directory_separator),
				string_literal ("sources_"),
				(digit #occurs (4 |..| 4)) |to| agent set_praat_version_no (? , ?)
			>>)
		end

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["c_library_name_list",	agent: ITERABLE [ZSTRING] do Result := make_file_parser.c_library_name_list end],
				["praat_version_no",		agent: ZSTRING do Result := praat_version_no end]
			>>)
		end

feature {NONE} -- Internal attributes

	converter_table: HASH_TABLE [GCC_TO_MSVC_CONVERTER, STRING]

	directory_content_processor: EL_DIRECTORY_CONTENT_PROCESSOR

	make_file_parser: PRAAT_MAKE_FILE_PARSER

	output_directory_text: ZSTRING

	praat_version_no: STRING

feature {NONE} -- Constants

	Build_batch_file_template: STRING = "[
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

	Praat_source: ZSTRING
		once
			Result := "praat.c"
		end

	Source_type: TUPLE [make_file, c_header, c_source: ZSTRING]
		once
			create Result
			Result.make_file := "Makefile"
			Result.c_header := "*.h"
			Result.c_source := "*.c"
		end

end