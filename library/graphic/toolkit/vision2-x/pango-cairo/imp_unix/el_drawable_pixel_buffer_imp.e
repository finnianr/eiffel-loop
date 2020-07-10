note
	description: "Drawable pixel buffer imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-06 8:46:35 GMT (Monday 6th July 2020)"
	revision: "10"

class
	EL_DRAWABLE_PIXEL_BUFFER_IMP

inherit
	EV_PIXEL_BUFFER_IMP
		rename
			data_ptr as pixel_data,
			draw_text as buffer_draw_text,
			draw_pixel_buffer as draw_pixel_buffer_at_rectangle,
			lock as lock_rgb_24,
			unlock as unlock_rgb_24,
			make_with_pixmap as make_rgb_24_with_pixmap,
			make_with_size as make_rgb_24_with_size,
			set_with_named_path as set_rgb_24_with_path,
			height as buffer_height,
			width as buffer_width
		undefine
			default_create
		redefine
			interface, old_make
		end

	EL_DRAWABLE_PIXEL_BUFFER_I
		redefine
			interface
		end

	EL_MODULE_COLOR
		rename
			Color as Mod_color
		end

	EL_SHARED_IMAGE_UTILS_API

create
	make

feature {NONE} -- Initialization

	make_argb_32 (a_width, a_height: INTEGER)
		do
			gdk_pixbuf := {GTK}.gdk_pixbuf_new ({GTK}.gdk_colorspace_rgb_enum, True, 8, a_width, a_height)
		end

	old_make (an_interface: EL_DRAWABLE_PIXEL_BUFFER)
			-- Creation method.
		do
			assign_interface (an_interface)
		end

feature -- Basic operations

	save_as_jpeg (file_path: EL_FILE_PATH; quality: INTEGER)
		require else
			valid_gtk_version: {GTK}.gtk_maj_ver >= 2
		local
			jpeg: EL_JPEG_PIXMAP_IMP
		do
			if interface.is_rgb_24_format then
				create jpeg.make (gdk_pixbuf, quality, False)
				jpeg.save_as (file_path)
			else
				interface.to_rgb_24_buffer.save_as_jpeg (file_path, quality)
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation attributes

	interface: detachable EL_DRAWABLE_PIXEL_BUFFER note option: stable attribute end;

feature {NONE} -- Implementation

	adjust_color_channels
		local
			l_gdk_pixbuf: POINTER
		do
			Image_utils.format_argb_to_abgr (pixel_data, width * height)
			l_gdk_pixbuf := {GTK2}.gdk_pixbuf_add_alpha (gdk_pixbuf, False, 0, 0, 0)
			{GTK2}.object_unref (gdk_pixbuf)
			gdk_pixbuf := l_gdk_pixbuf
		end

end
