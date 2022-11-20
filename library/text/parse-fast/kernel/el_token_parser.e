note
	description: "Token parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-20 8:53:47 GMT (Sunday 20th November 2022)"
	revision: "10"

deferred class
	EL_TOKEN_PARSER  [L -> EL_FILE_LEXER create make end]

inherit
	EL_PARSER
		rename
			source_text as tokens_text,
			set_source_text as set_tokens_text,
			default_source_text as default_tokens_text
		export
			{NONE} all
			{ANY} parse
		redefine
			make_default, default_tokens_text
		end

	EL_FILE_SOURCE_TEXT
		redefine
			make_default, set_source_text
		end

	EL_STRING_32_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_PARSER}
			Precursor {EL_FILE_SOURCE_TEXT}
			create source_interval_list.make (0)
		end

feature -- Element change

	set_source_text (a_source_text: ZSTRING)
		local
			lexer: L
		do
			source_text := a_source_text
			create lexer.make (a_source_text)
			source_interval_list := lexer.source_interval_list
			set_tokens_text (lexer.tokens_text)
		end

feature {NONE} -- Implementation

	default_tokens_text: STRING_32
		do
			Result := Empty_string_32
		end

	keyword, symbol (a_token_id: NATURAL_32): EL_LITERAL_CHAR_TP
			--
		do
			Result := core.new_character_literal (a_token_id.to_character_32)
		end

	source_text_for_token (i: INTEGER): ZSTRING
			-- source text corresponding to i'th token in matched_tokens
		require
			valid_array_index: source_interval_list.valid_index (i)
		local
			interval: INTEGER_64
		do
			interval := source_interval_list.i_th (i)
			Result := source_text.substring ((interval |>> 32).to_integer_32, interval.to_integer_32)
		end

	token_occurrences (a_token: NATURAL; start_index, end_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			from i := start_index until i > end_index loop
				if tokens_text.code (i) = a_token then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	source_interval_list: EL_ARRAYED_INTERVAL_LIST
		-- substring intervals for `source_text'

end