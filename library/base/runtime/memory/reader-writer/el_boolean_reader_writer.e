note
	description: "[
		Adapter interface to read a ${BOOLEAN} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:46:16 GMT (Wednesday 21st December 2022)"
	revision: "6"

class
	EL_BOOLEAN_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [BOOLEAN]

feature -- Factory

	new_item: BOOLEAN
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): BOOLEAN
		do
			Result := reader.read_boolean
		end

	write (item: BOOLEAN; writer: EL_WRITABLE)
		do
			writer.write_boolean (item)
		end

	set (item: BOOLEAN; reader: EL_READABLE)
		do
		end

end