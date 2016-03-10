note
	description: "Platform dependent implementation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PLATFORM_IMPL

feature {NONE} -- Initialization

	make
		do
		end

feature -- Element change

	set_interface (a_interface: like interface)
		do
			interface := a_interface
		end

feature {NONE} -- Implementation

	interface: ANY

end
