note
	description: "[$source BOOL_STRING] with added string conversion functions"

	author: "Finnian Reilly"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

class
	PF_BOOL_STRING

inherit
	BOOL_STRING

create
	make

feature -- Conversion

	to_string_32: STRING_32
		local
			i: INTEGER;
		do
			create Result.make (count)
			from i := 1 until i > count loop
				if item (i) then
					Result.append_code (0x25CF)
				else
					Result.append_code (0x25CE)
				end
				Result.append_character (' ')
				i := i + 1
			end
		end

	to_string_8: STRING_8
		local
			i: INTEGER;
		do
			create Result.make (count)
			from i := 1 until i > count loop
				if item (i) then
					Result.append_code (2)
				else
					Result.append_code (79)
				end
				Result.append_character (' ')
				i := i + 1
			end
		end

	to_general: READABLE_STRING_GENERAL
		do
			if {PLATFORM}.is_windows then
				Result := to_string_8
			else
				Result := to_string_32
			end
		end

end
