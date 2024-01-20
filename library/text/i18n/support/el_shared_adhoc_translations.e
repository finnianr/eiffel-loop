note
	description: "[
		Shared ${FUNCTION} to create Pyxis source for adhoc-translations.
		Useful for decrypted credit titles for application "about dialog".
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "2"

deferred class
	EL_SHARED_ADHOC_TRANSLATIONS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Adhoc_translation_source_factory: CELL [FUNCTION [STRING]]
		once ("PROCESS")
			create Result.put (Void)
		end
end