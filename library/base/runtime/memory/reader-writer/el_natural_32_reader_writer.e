note
	description: "[
		Adapter interface to read a ${NATURAL_32} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_NATURAL_32_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [NATURAL_32]

feature -- Factory

	new_item: NATURAL_32
		do
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): NATURAL_32
		do
			Result := reader.read_natural_32
		end

	write (item: NATURAL_32; writer: EL_WRITABLE)
		do
			writer.write_natural_32 (item)
		end

	set (item: NATURAL_32; reader: EL_READABLE)
		do
		end

end