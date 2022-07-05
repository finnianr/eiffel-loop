note
	description: "[$source GROUPED_ECF_LINES] with an optional common library ''location''"
	notes: "[
		**location** is interpreted as a location prefix only if it's on the first line
		
			libraries:
				location = "$ISE_LIBRARY/library"
				base = "base/base.ecf"
				thread = "thread/thread.ecf"
				time = "time/time.ecf"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-05 11:14:29 GMT (Tuesday 5th July 2022)"
	revision: "3"

class
	LIBRARIES_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			set_from_line, adjust_value
		end

create
	make

feature -- Element change

	set_from_line (line: STRING; tab_count: INTEGER)
		local
			s: EL_STRING_8_ROUTINES
		do
			if not first_line_removed
				and then not attached location_dir and then line.has_substring (Location)
				and then attached shared_name_value_list (line) as nvp_list
				and then nvp_list.count = 1 and then nvp_list.first.name ~ Location
				and then attached nvp_list.first.value as dir
			then
				s.remove_double_quote (dir)
				if dir [dir.count] /= '/' then
					dir.append_character ('/')
				end
				location_dir := dir
			else
				Precursor (line, tab_count)
			end
		end

feature {NONE} -- Implementation

	adjust_value (value: STRING)
		do
			if attached location_dir as dir then
				value.insert_string (dir, 2)
			end
		end

feature {NONE} -- Internal attributes

	location_dir: detachable STRING

feature {NONE} -- Constants

	Location: STRING = "location"

end