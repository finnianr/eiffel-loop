note
	description: "Share instances of classes conforming to [$source EL_STRING_POOL [S -> STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 16:01:24 GMT (Monday 6th November 2023)"
	revision: "1"

deferred class
	EL_SHARED_STRING_POOLS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Shared_string_pool: EL_STRING_POOL [ZSTRING]
		once
			create Result.make (8)
		end

	Shared_string_pool_8: EL_STRING_POOL [STRING_8]
		once
			create Result.make (8)
		end

	Shared_string_pool_32: EL_STRING_POOL [STRING_32]
		once
			create Result.make (8)
		end
end