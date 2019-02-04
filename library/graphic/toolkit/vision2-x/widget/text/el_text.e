note
	description: "Text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:35:26 GMT (Friday 21st December 2018)"
	revision: "6"

class
	EL_TEXT

inherit
	EV_TEXT
		redefine
			create_implementation, implementation, paste
		end

	EL_UNDOABLE_TEXT
		undefine
			copy, is_in_default_state, paste
		redefine
			implementation
		end

create
	default_create

feature -- Basic operations

	paste (a_position: INTEGER)
			-- Insert text from `clipboard' at `a_position'.
			-- No effect if clipboard is empty.
		local
			old_caret_position: INTEGER
		do
			old_caret_position := caret_position
			implementation.paste (a_position)
			if old_caret_position = a_position then
				set_caret_position (old_caret_position)
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EL_TEXT_I

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_TEXT_IMP} implementation.make
		end
end
