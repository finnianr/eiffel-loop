note
	description: "Summary description for {EL_VISION_2_GUI_ROUTINES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_VISION_2_GUI_ROUTINES_IMPL

inherit
	EL_PLATFORM_IMPL

create
	make

feature -- Access

	Text_field_background_color: EV_COLOR
			--
		local
			system_colors: WEL_SYSTEM_COLORS
			color_window: WEL_COLOR_REF
		once
			create system_colors
			color_window := system_colors.system_color_window
			create Result.make_with_8_bit_rgb (color_window.red, color_window.green, color_window.blue)
		end
end
