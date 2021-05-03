note
	description: "Reflected string 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 13:55:31 GMT (Monday 3rd May 2021)"
	revision: "6"

class
	EL_REFLECTED_STRING_32

inherit
	EL_REFLECTED_STRING [STRING_32]

create
	make

feature -- Basic operations

	read_from_set (a_object: EL_REFLECTIVE; reader: EL_CACHED_FIELD_READER; a_set: EL_HASH_SET [STRING_32])
		do
			reader.read_string_32 (a_set)
			set (a_object, a_set.found_item)
		end

	reset (a_object: EL_REFLECTIVE)
		do
			value (a_object).wipe_out
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as str then
				memory.read_into_string_32 (str)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string_32)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			l_value: like value
		do
			l_value := value (a_object)
			if attached {STRING_32} string as string_32 then
				set (a_object, string_32)
			else
				l_value.wipe_out
				if attached {ZSTRING} string as zstr then
					zstr.append_to_string_32 (l_value)
				else
					l_value.append_string_general (string)
				end
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_32 (value (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_32 (value (a_object))
		end

end