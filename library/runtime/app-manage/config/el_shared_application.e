note
	description: "Shared access to first created instance of object conforming to ${EL_APPLICATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_SHARED_APPLICATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application: EL_APPLICATION
		-- Currently running application
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_APPLICATION]}
		end
end