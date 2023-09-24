note
	description: "[
		Wrapper for PangoFontDescription convertable from class [$source EV_FONT].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "14"

class
	CAIRO_PANGO_FONT

inherit
	EL_OWNED_C_OBJECT
		rename
			self_ptr as item
		export
			{ANY} item
		end

	CAIRO_SHARED_PANGO_API

	CAIRO_PANGO_CONSTANTS
		export
			{NONE} all
			{ANY} is_valid_stretch
		end

	EL_SHARED_UTF_8_STRING

create
	make, default_create

convert
	make ({EV_FONT})

feature {NONE} -- Initialization

	make (a_font: EV_FONT)
		local
			c_name: ANY
		do
			make_from_pointer (Pango.new_font_description)

			if attached UTF_8_string as name then
				name.set_from_general (a_font.name)
				c_name := name.to_c
				Pango.set_font_family (item, $c_name)
			end
			Pango.set_font_style (item, pango_style (a_font.shape))
			Pango.set_font_weight (item, pango_weight (a_font.weight))
			set_stretch (Stretch_normal)

			set_height (a_font.height_in_points * Pango.pango_scale)
		end

feature -- Access

	height: INTEGER
		-- height in pango units

feature -- Status change

	scale (factor: DOUBLE)
		do
			set_height ((height * factor).rounded)
		end

	set_stretch (value: INTEGER)
		require
			valid_value: is_valid_stretch (value)
		do
			Pango.set_font_stretch (item, value)
		end

feature -- Element change

	set_height (a_height: INTEGER)
		do
			height := a_height
			Pango.set_font_size (item, height)
		end

feature {NONE} -- Implementation

	pango_weight (vision_2_weight: INTEGER): INTEGER
		do
			inspect vision_2_weight
				when {EV_FONT_CONSTANTS}.Weight_thin then
					Result := Weight_thin

				when {EV_FONT_CONSTANTS}.Weight_regular then
					Result := Weight_normal

				when {EV_FONT_CONSTANTS}.Weight_bold then
					Result := Weight_bold

				when {EV_FONT_CONSTANTS}.Weight_black then
					Result := Weight_heavy

			else
				Result := Weight_normal
			end
		end

	pango_style (vision_2_shape: INTEGER): INTEGER
		do
			if vision_2_shape = {EV_FONT_CONSTANTS}.Shape_italic then
				Result := Style_italic
			else
				Result := Style_normal
			end
		end

feature {NONE} -- Disposal

	c_free (this: POINTER)
			--
		do
			if not is_in_final_collect then
				Pango.font_description_free (this)
			end
		end

end
