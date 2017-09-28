note
	description: "Summary description for {EL_LOCALE_SAVE_CHANGES_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-15 14:53:18 GMT (Tuesday 15th August 2017)"
	revision: "2"

class
	EL_SAVE_CHANGES_CONFIRMATION_DIALOG

inherit
	EL_CONFIRMATION_DIALOG
		rename
			ev_cancel as Eng_discard,
			ev_ok as Eng_save
		redefine
			Eng_save, Eng_discard
		end

create
	default_create, make_with_text, make_with_text_and_actions

feature -- Access

	Eng_save: STRING
			--
		once
			Result := "Save"
		end

	Eng_discard: STRING
			--
		once
			Result := "Discard"
		end
end
