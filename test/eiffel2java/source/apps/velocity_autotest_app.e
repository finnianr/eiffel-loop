note
	description: "Execute test set [$source VELOCITY_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 22:10:49 GMT (Tuesday 18th January 2022)"
	revision: "1"

class
	VELOCITY_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [VELOCITY_TEST_SET]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [JAVA_ENVIRONMENT_IMP]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

end