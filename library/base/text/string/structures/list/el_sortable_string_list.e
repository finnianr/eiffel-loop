note
	description: "Sortable list of strings conforming to READABLE_STRING_GENERAL"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_SORTABLE_STRING_LIST [S -> READABLE_STRING_GENERAL]

inherit
	READABLE_INDEXABLE [S]

feature -- Measurement

	count: INTEGER
		deferred
		end

	item_index_of (uc: CHARACTER_32): INTEGER
		require
			valid_item: not off
		deferred
		end

feature -- Status query

	off: BOOLEAN
		deferred
		end

feature -- Basic operations

	go_i_th (i: INTEGER)
			-- Move cursor to `i'-th position.
		deferred
		end

	sort (in_ascending_order: BOOLEAN)
		deferred
		end
end
