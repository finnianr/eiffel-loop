note
	description: "Extended version of access control class ${STRING_HANDLER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 7:40:23 GMT (Sunday 25th August 2024)"
	revision: "1"

deferred class
	EL_STRING_HANDLER

inherit
	STRING_HANDLER
		undefine
			copy, default_create, is_equal, out
		end

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	string_storage_type (general: READABLE_STRING_GENERAL): CHARACTER
		-- character code representing number of bytes per character in string `general'
		-- 'X' means an indeterminate number for ZSTRING type
		do
			if general.is_string_8 then
				Result := '1' -- bytes
			elseif Empty_string.same_type (general) then
				Result := 'X'
			else
				Result := '4' -- bytes
			end
		ensure
			valid_code: valid_string_storage_type (Result)
		end

feature -- Contract Support

	valid_string_storage_type (code: CHARACTER): BOOLEAN
		do
			inspect code
				when '1', '4', 'X' then
					Result := True
			else
			end
		end
end