note
	description: "Volume info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:42:27 GMT (Thursday 16th June 2022)"
	revision: "8"

class
	VOLUME_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			element_node_fields as Empty_set,
			xml_naming as eiffel_naming
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			name := "."
			id3_version := 2.3
			is_windows_format := True
		end

feature -- Access

	destination_dir: DIR_PATH

	id3_version: REAL

	major_version: INTEGER
		do
			Result := (id3_version * 10).rounded \\ 10
		end

	is_windows_format: BOOLEAN

	name: ZSTRING

	type: ZSTRING

feature -- Conversion

	to_gvfs: EL_GVFS_VOLUME
		do
			create Result.make (name, is_windows_format)
			Result.enable_path_translation
		end

feature -- Element change

	set_destination_dir (a_destination_dir: DIR_PATH)
		do
			destination_dir := a_destination_dir
		end

	set_name (a_name: ZSTRING)
		do
			name := a_name
		end
end