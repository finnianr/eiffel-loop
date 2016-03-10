note
	description: "Summary description for {DATE_INTERVAL_SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_DATE_INTERVAL_SEARCH_TERM [G -> {EL_WORD_SEARCHABLE, EL_DATEABLE}]

inherit
	EL_CUSTOM_SEARCH_TERM [G]

create
	make

feature {NONE} -- Initialization

	make (from_date, to_date: DATE)
			--
		do
			create date_interval.make (from_date.ordered_compact_date, to_date.ordered_compact_date)
		end

feature -- Access

	date_interval: INTEGER_INTERVAL

feature {NONE} -- Implementation

	matches (target: like Type_target): BOOLEAN
			--
		do
			Result := date_interval.has (target.date.ordered_compact_date)
		end
end
