note
	description: "Shared instance of class conforming to [$source CAIRO_GDK_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 9:13:51 GMT (Thursday 2nd June 2022)"
	revision: "10"

deferred class
	CAIRO_SHARED_GDK_API

inherit
	EL_ANY_SHARED

feature -- Access

	Gdk: CAIRO_GDK_I
		once
			create {CAIRO_GDK_API} Result.make
		end
end