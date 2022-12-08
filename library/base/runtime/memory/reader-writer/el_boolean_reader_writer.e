note
	description: "[
		Adapter interface to read a [$source BOOLEAN] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITEABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 16:44:37 GMT (Thursday 8th December 2022)"
	revision: "4"

class
	EL_BOOLEAN_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [BOOLEAN]

feature -- Basic operations

	read_item (reader: EL_READABLE): BOOLEAN
		do
			Result := reader.read_boolean
		end

	write (item: BOOLEAN; writer: EL_WRITEABLE)
		do
			writer.write_boolean (item)
		end

	set (item: BOOLEAN; reader: EL_READABLE)
		do
		end

end