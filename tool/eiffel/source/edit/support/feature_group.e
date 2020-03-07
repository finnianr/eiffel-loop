note
	description: "Group of class features with common export status"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-07 10:53:53 GMT (Saturday 7th March 2020)"
	revision: "7"

class
	FEATURE_GROUP

create
	make

feature {NONE} -- Initialization

	make (a_header: EL_ZSTRING_LIST)
		local
			pos_comment, pos_new_line: INTEGER
		do
			header := a_header.joined_lines
			create features.make (5)

			pos_comment := header.substring_index (Comment_marks, 1)
			if pos_comment > 0 then
				name := header.substring_end (pos_comment + 2)
				pos_new_line := name.index_of ('%N', 1)
				if pos_new_line > 0 then
					name.keep_head (pos_new_line - 1)
				end
				name.adjust
			else
				create name.make_empty
			end
		end

feature -- Access

	features: EL_ARRAYED_LIST [CLASS_FEATURE]

	header: ZSTRING

	name: ZSTRING

	string_count: INTEGER
		do
			Result := features.sum_integer (agent {CLASS_FEATURE}.string_count)
		end

feature -- Element change

	append (line: ZSTRING)
		do
			features.last.lines.extend (line)
		end

feature {NONE} -- Constants

	Comment_marks: ZSTRING
		once
			Result := "--"
		end

end
