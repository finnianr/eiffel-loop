note
	description: "[
		Provides global access to the Evolicity template substitution engine.

		The templating substitution language was named "Evolicity" as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:15:59 GMT (Monday 12th November 2018)"
	revision: "4"

class
	EL_MODULE_EVOLICITY_TEMPLATES

inherit
	EL_MODULE

feature {NONE} -- Constants

	Evolicity_templates: EVOLICITY_TEMPLATES
			--
		once
			create Result.make
		end

end
