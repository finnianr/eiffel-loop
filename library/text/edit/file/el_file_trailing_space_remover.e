﻿note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 16:48:05 GMT (Sunday 20th December 2015)"
	revision: "4"

class
	EL_FILE_TRAILING_SPACE_REMOVER

inherit
	EL_TEXT_FILE_EDITOR
		rename
			make_default as make
		export
			{NONE} set_input_file_path
		end

	EL_ZTEXT_PATTERN_FACTORY

create
	make

feature {NONE} -- Pattern definitions

	delimiting_pattern: like repeat_p1_until_p2
			--
		do
			Result := repeat_p1_until_p2 (character_literal ('%/32/'), end_of_line_character) |to| agent on_trailing_space
		end

feature {NONE} -- Parsing actions

	on_trailing_space (class_name: EL_STRING_VIEW)
			-- Ignore trailing space
		do
			put_new_line
		end

end
