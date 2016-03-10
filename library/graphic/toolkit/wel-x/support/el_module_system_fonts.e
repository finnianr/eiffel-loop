note
	description: "Summary description for {EL_MODULE_SYSTEM_FONTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_MODULE_SYSTEM_FONTS

inherit
	EL_MODULE

feature -- Access

	System_fonts: EL_WEL_SYSTEM_FONTS
		once
			create Result
		end

end
