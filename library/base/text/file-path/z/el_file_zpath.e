note
	description: "Path to file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-13 11:30:56 GMT (Sunday 13th February 2022)"
	revision: "1"

class
	EL_FILE_ZPATH

inherit
	EL_ZPATH

create
	default_create, make, make_from_steps

create {EL_ZPATH} make_tokens

convert
	make ({IMMUTABLE_STRING_8, ZSTRING, STRING, STRING_32}),

	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL},
	to_obsolete: {FILE_PATH}

feature -- Access

	relative_path (a_parent: EL_DIR_ZPATH): EL_FILE_ZPATH
		do
			if a_parent.step_count <= step_count then
				create Result.make_tokens (step_count - a_parent.step_count)
				Result.append_subpath (Current, a_parent.step_count + 1)
			else
				create Result
			end
		end

feature -- Conversion

	to_obsolete: FILE_PATH
		do
			create Result.make (to_string)
		end

feature {NONE} -- Implementation

	new_path (n: INTEGER): like Current
		do
			create Result.make_tokens (n)
		end
end