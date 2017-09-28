note
	description: "Summary description for {XHTML_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-25 14:14:40 GMT (Friday 25th August 2017)"
	revision: "3"

class
	XHTML_WRITER

inherit
	HTML_WRITER
		redefine
			make, image_tag_text
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_text: ZSTRING; output_path: EL_FILE_PATH; a_date_stamp: like date_stamp)
		do
			Precursor (a_source_text, output_path, a_date_stamp)
			set_utf_encoding (8)
		end

feature {NONE} -- Patterns

	delimiting_pattern: like one_of
			--
		do
			Result := one_of (<<
				charset_pattern,
				trailing_line_break,
				empty_tag_set,
				string_literal ("<br>") |to| agent replace (?, XML_line_break),
				preformat_end_tag,
				anchor_element_tag,
				image_element_tag
			>>)
		end

	charset_pattern: like all_of
		do
			Result := all_of (<<
				string_literal ("charset="),
				one_of (<< iso_charset, windows_charset >>),
				character_literal ('"')
			>>) |to| agent on_character_set
		end

	iso_charset: like all_of
		do
			Result := all_of (<<
				one_of_case_literal ("iso-8859"), hyphen, digit #occurs (1 |..| 2)
			>>)
		end

	windows_charset: like all_of
		do
			Result := all_of (<<
				one_of_case_literal ("windows"), hyphen, digit #occurs (4 |..| 4)
			>>)
		end

	hyphen: like character_literal
		do
			Result := character_literal ('-')
		end

feature {NONE} -- Event handling

	on_character_set (text: EL_STRING_VIEW)
		do
			put_string ("charset=UTF-8%"")
		end

feature {NONE} -- Implementation

	image_tag_text (match_text: EL_STRING_VIEW): ZSTRING
		do
			Result := Precursor (match_text)
			Result.insert_character ('/', Result.count - 1)
		ensure then
			tag_is_empty_element: Result.substring_end (Result.count - 1).same_string ("/>")
		end

feature {NONE} -- Constants

	XML_line_break: ZSTRING
		once
			Result := "<br/>"
		end

end
