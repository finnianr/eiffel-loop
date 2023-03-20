note
	description: "Iterable string split with separator of type **G**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-20 10:26:17 GMT (Monday 20th March 2023)"
	revision: "8"

deferred class
	EL_ITERABLE_SPLIT [S -> READABLE_STRING_GENERAL, G]

inherit
	ITERABLE [S]

	EL_SIDE_ROUTINES

feature {NONE} -- Initialization

	make (a_target: like target; a_separator: like separator)
		do
			make_adjusted (a_target, a_separator, 0)
		end

	make_adjusted (a_target: like target; a_separator: like separator; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_sides (adjustments)
		do
			target := a_target; separator := a_separator; adjustments := a_adjustments
		end

feature -- Access

	new_cursor: EL_ITERABLE_SPLIT_CURSOR [S, G]
			-- Fresh cursor associated with current structure
		deferred
		end

	count: INTEGER
		do
			across Current as item loop
				Result := Result + 1
			end
		end

	target: S

feature -- Status query

	left_adjusted: BOOLEAN
		do
			Result := has_left_side (adjustments)
		end

	right_adjusted: BOOLEAN
		do
			Result := has_right_side (adjustments)
		end

feature -- Element change

	set_target (a_target: like target)
		do
			target := a_target
		end

feature {NONE} -- Internal attributes

	adjustments: INTEGER

	separator: G

end