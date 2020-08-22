note
	description: "Relatives positions, dimensions and axes"
	notes: "[
		See class [$source EL_MODULE_ORIENTATION] for validation routines in `Orientation'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-22 12:28:39 GMT (Saturday 22nd August 2020)"
	revision: "1"

class
	EL_DIRECTION

feature -- Clockwise positions

	Top_left: INTEGER = 1

	Top: INTEGER = 2

	Top_right: INTEGER = 4

	Right: INTEGER = 8

	Bottom_right: INTEGER = 16

	Bottom: INTEGER = 32

	Bottom_left: INTEGER = 64

	Left: INTEGER = 128

feature -- Center position

	Center: INTEGER = 256

feature -- Dimensions

	By_height: NATURAL_8 = 1

	By_width: NATURAL_8 = 2

feature -- Axis

	X_axis: INTEGER = 1

	Y_axis: INTEGER = 2

end
