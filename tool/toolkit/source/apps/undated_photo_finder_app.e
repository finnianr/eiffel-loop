note
	description: "[
		Command line interface to [$source UNDATED_PHOTO_FINDER] which compiles a
		list of JPEG photos that lack the EXIF field `Exif.Photo.DateTimeOriginal'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:46:40 GMT (Saturday 5th February 2022)"
	revision: "17"

class
	UNDATED_PHOTO_FINDER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [UNDATED_PHOTO_FINDER]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("source", "Source tree directory", << directory_must_exist >>),
				required_argument ("output", "Output directory path", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (".", "undated-photos.txt")
		end

	visible_types: TUPLE [UNDATED_PHOTO_FINDER]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "undated_photos"

end