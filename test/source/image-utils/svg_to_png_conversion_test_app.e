note
	description: "Svg to png conversion test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 7:35:09 GMT (Sunday 12th January 2020)"
	revision: "8"

class
	SVG_TO_PNG_CONVERSION_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			Option_name, initialize
		end

	EL_MODULE_SVG

	EL_MODULE_EVOLICITY_TEMPLATES

create
	make

feature -- Basic operations

	initialize
		do
			Precursor
			create environment_variables.make_from_string_table (Execution_environment.starting_environment_variables)
		end

	test_run
			--
		do
			Test.set_binary_file_extensions (<< "png" >>)
			Test.do_file_test ("svg/button.svg", agent test_conversion, 3145856811)
		end

feature -- Tests

	convert_to_width_and_color (width: INTEGER; color: INTEGER; svg_path: EL_FILE_PATH)
		local
			output_path: EL_FILE_PATH
		do
			log.enter ("convert_to_width_and_color")
			log.put_integer_field ("width", width)
			log.put_labeled_string (" color code", color.to_hex_string)
			output_path := svg_path.without_extension
			output_path.add_extension (width.to_hex_string)
			output_path.add_extension (color.to_hex_string)
			output_path.add_extension ("png")
			SVG.write_png_of_width (svg_path, output_path, width, color)
			log.exit
		end

	test_conversion (svg_path: EL_FILE_PATH)
			--
		local
			svg_background_path: EL_FILE_PATH; svg_file: EL_PLAIN_TEXT_FILE
		do
			log.enter ("test_conversion")
			Evolicity_templates.put_file (svg_path, Utf_8_encoding)
			create svg_file.make_open_write (svg_path)
			Evolicity_templates.merge_to_file (svg_path, environment_variables, svg_file)
			svg_file.close
			across Sizes as size loop
				across Colors as color loop
					convert_to_width_and_color (size.item, color.item, svg_path)
				end
			end
			log.exit
		end

feature {NONE} -- Internal attributes

	environment_variables: EVOLICITY_CONTEXT_IMP

feature {NONE} -- Constants

	Colors: ARRAY [INTEGER]
		once
			Result := << 0, 0x008B8B, 0xA52A2A, 0xFFFFFF, 0x1000000 >>
		end

	Description: STRING = "Test SVG to PNG conversion"

	Option_name: STRING = "svg_to_png"

	Sizes: ARRAY [INTEGER]
		once
			Result := << 64, 128, 256 >>
		end

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_utf_8
		end

end
