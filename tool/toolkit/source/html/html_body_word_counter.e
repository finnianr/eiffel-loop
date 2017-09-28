note
	description: "Summary description for {HTML_BODY_WORD_COUNTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-25 12:36:34 GMT (Tuesday 25th July 2017)"
	revision: "3"

class
	HTML_BODY_WORD_COUNTER

inherit
	EL_FILE_TREE_COMMAND
		rename
			do_with_file as count_words
		export
			{EL_SUB_APPLICATION} make
		undefine
			new_lio
		end

	EL_MODULE_LOG

create
	default_create, make

feature {NONE} -- Implementation

	count_words (body_path: EL_FILE_PATH)
		local
			xhtml: EL_XHTML_UTF_8_SOURCE; xhtml_file: PLAIN_TEXT_FILE
			node_event_generator: EL_XML_NODE_EVENT_GENERATOR; counter: EL_XHTML_WORD_COUNTER
		do
			log.enter_with_args ("count_words", << body_path.to_string.to_utf_8 >>)
			create xhtml.make (File_system.plain_text (body_path))
			create counter
			create node_event_generator.make_with_handler (counter)
			node_event_generator.scan (xhtml.source)
			log.put_integer_field ("Words", counter.count)

			create xhtml_file.make_open_write (body_path.with_new_extension ("xhtml"))
			xhtml_file.put_string (xhtml.source)
			xhtml_file.close
			log.exit
		end

feature {NONE} -- Constants

	Default_extension: STRING = "body"

end
