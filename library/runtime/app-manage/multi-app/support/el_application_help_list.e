note
	description: "Sub-application help list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-07 16:22:09 GMT (Friday 7th October 2022)"
	revision: "10"

class
	EL_APPLICATION_HELP_LIST

inherit
	ARRAYED_LIST [TUPLE [name, description: READABLE_STRING_GENERAL; default_value: ANY]]
		rename
			extend as extend_tuple
		end

	EL_MODULE_LIO

create
	make

feature -- Basic operations

	print_to_lio
		local
			default_value: ZSTRING
		do
			lio.put_line ("COMMAND LINE OPTIONS:")
			lio.put_new_line

			from start until after loop
				lio.put_line (indent (4) + "-" + item.name + ":")
				across item.description.split ('%N') as line loop
					lio.put_line (indent (8) + line.item)
				end
				if attached {READABLE_STRING_GENERAL} item.default_value as str then
					create default_value.make_from_general (str)
				elseif attached {EL_PATH} item.default_value as path then
					default_value := path.to_string
				elseif attached {CHAIN [ANY]} item.default_value as chain then
					create default_value.make_empty
				elseif attached {BOOLEAN_REF} item.default_value as bool then
					if bool.item then
						default_value := "enabled"
					else
						default_value := "disabled"
					end
				else
					default_value := item.default_value.out
				end
				if not default_value.is_empty then
					lio.put_line (indent (8) + "Default: " + default_value)
				end
				lio.put_new_line
				forth
			end
		end

feature -- Element change

	extend (name, description: READABLE_STRING_GENERAL; default_value: ANY)
		do
			extend_tuple ([name, description, default_value])
		end

feature {NONE} -- Implementation

	indent (n: INTEGER): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.n_character_string (' ', n)
		end

end