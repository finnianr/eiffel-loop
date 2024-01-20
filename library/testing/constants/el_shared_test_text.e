﻿note
	description: "Shared instance of ${EL_TEST_TEXT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:19:45 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SHARED_TEST_TEXT

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Text: EL_TEST_TEXT
		once
			create Result
		end
end