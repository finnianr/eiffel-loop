note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

deferred class
	EL_INITIALIZEABLE

inherit
	DISPOSABLE
		rename
			dispose as uninitialize
		undefine
			default_create
		end

feature -- Access

	is_initialized: BOOLEAN
		
invariant
	initialized: is_initialized

end
