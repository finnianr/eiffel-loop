﻿note
	description: "[
		Decode internal Thunderbird subject lines
		Example:
			"=?ISO-8859-15?Q?=DCber_My_Ching?=" -> "Über My Ching"
		
			"=?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=" -> Über€ My Ching
			
			"=?UTF-8?Q?3.Journaleintr=c3=a4ge_bearbeiten?=" -> "Journaleinträge bearbeiten"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 11:56:46 GMT (Thursday 14th May 2020)"
	revision: "7"

class
	EL_SUBJECT_LINE_DECODER

inherit
	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		end

	EL_SHARED_ZCODEC_FACTORY

	EL_MODULE_BASE_64

	EL_MODULE_HEXADECIMAL

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make
		do
			make_encodeable (Latin_1)
			set_codec
			add_encoding_change_action (agent set_codec)
			create line.make_empty
		end

feature -- Element change

	set_line (a_line: like line)
		do
			line := a_line
		end

feature -- Access

	decoded_line: ZSTRING
		local
			parts: EL_ZSTRING_LIST; latin_str: STRING
		do
			if line.starts_with (Encoded_begin) and then line.ends_with (Encoded_end) then
				create parts.make_with_separator (line.substring (3, line.count - 2), '?', False)

				set_encoding_from_name (parts.first)
				inspect parts.i_th (2) [1]
					when 'Q' then
						-- Eg: =?ISO-8859-15?Q?=DCber_My_Ching?=
						latin_str := unescaped (parts.last)
					when 'B' then
						-- Eg: =?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=
						latin_str := Base_64.decoded (parts.last)
				else
					latin_str := unescaped (parts.last)
				end
				create Result.make_from_general (codec.as_unicode (latin_str, False))
			else
				Result := line
			end
		end

feature {NONE} -- Implementation

	set_codec
		do
			codec := Codec_factory.codec (Current)
		end

	unescaped (str: ZSTRING): STRING
		do
			create Result.make_empty
			from until str.is_empty loop
				inspect str [1]
					when '=' then
						Result.append_code (hexadecimal.substring_to_natural_32 (str, 2, 3))
						str.remove_head (3)
					when '_' then
						Result.append_character (' ')
						str.remove_head (1)
				else
					Result.append_character (str.item (1).to_character_8)
					str.remove_head (1)
				end
			end
		end

feature {NONE} -- Internal attributes

	line: ZSTRING

	codec: EL_ZCODEC

feature {NONE} -- Constants

	Encoded_begin: ZSTRING
		once
			Result := "=?"
		end

	Encoded_end: ZSTRING
		once
			Result := "?="
		end

end
