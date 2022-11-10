note
	description: "Negated text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-10 13:33:19 GMT (Thursday 10th November 2022)"
	revision: "5"

class
	EL_NEGATED_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN

create
	make

feature {NONE} -- Initialization

	make (a_pattern: like Type_negated_pattern)
			--
		do
			pattern := a_pattern
			actions_array := pattern.actions_array
		end

feature {NONE} -- Implementation

	actual_count: INTEGER
			--
		do
			Result := 0
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			-- Try to match one pattern
		do
			if text.count - a_offset >= actual_count then
				pattern.match (a_offset, text)
				if not pattern.is_matched then
					Result := actual_count
				else
					Result := Match_fail
				end
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets definition of `Current' pattern
		do
			Result := not pattern.is_matched implies count = actual_count
		end

	name_inserts: TUPLE
		do
			Result := [pattern.name]
		end

feature {NONE, EL_NEGATED_TEXT_PATTERN} -- Internal attributes

	pattern: like Type_negated_pattern

feature {NONE} -- Anchored type

	Type_negated_pattern: EL_TEXT_PATTERN
		do
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "not (%S)"
		end
end