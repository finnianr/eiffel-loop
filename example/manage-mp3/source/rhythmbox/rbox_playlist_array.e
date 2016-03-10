note
	description: "Summary description for {RBOX_PLAYLIST_ARRAY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:04 GMT (Monday 22nd July 2013)"
	revision: "4"

class
	RBOX_PLAYLIST_ARRAY

inherit
	EL_ARRAYED_LIST [RBOX_PLAYLIST]
		rename
			make as make_array
		end

	EL_BUILDABLE_XML_FILE_PERSISTENT
		rename
			make as make_storable
		undefine
			is_equal, copy
		redefine
			building_action_table, getter_function_table, build_from_file, utf8_encoded
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH; a_database: RBOX_DATABASE)
			-- Build object from xml file
		do
			database := a_database
			make_array (7)

			create non_static_playlist_lines.make
			create xml_string.make_empty

			make_from_file (a_file_path)
		end

feature -- Cursor movement

	search_by_name (playlist_name: STRING)
			--
		local
			found: BOOLEAN
		do
			from start until found or after loop
				if playlist_name ~ item.name then
					found := True
				else
					forth
				end
			end
		end

feature -- Status query

	is_backup_mode: BOOLEAN

	utf8_encoded: BOOLEAN
		do
			Result := True
		end

feature -- Basic operations

	backup
			-- Create backup using track id's instead of location
		local
			l_temp_path: EL_FILE_PATH
		do
			l_temp_path := output_path
			output_path := output_path.with_new_extension ({STRING_32} "backup.xml")
			is_backup_mode := True
			store
			is_backup_mode := False
			output_path := l_temp_path
		end

feature {NONE} -- Build from XML

	build_playlist
			--
		do
			extend (create {RBOX_PLAYLIST}.make (database))
			set_next_context (last)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: rhythmdb-playlists
		do
			create Result.make (<<
				["playlist[@type='static']", agent build_playlist]
			>>)
		end

	Root_node_name: STRING = "rhythmdb-playlists"

feature {NONE} -- Evolicity reflection

	get_playlists: ITERABLE [RBOX_PLAYLIST]
			--
		do
			Result := Current
		end

	get_non_static_playlist_lines: ITERABLE [STRING]
			--
		do
			Result := non_static_playlist_lines
		end

	get_is_backup_mode: BOOLEAN_REF
		do
			Result := is_backup_mode.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["playlists", agent get_playlists],
				["non_static_playlist_lines", agent get_non_static_playlist_lines],
				["is_backup_mode", agent get_is_backup_mode]
			>>)
		end

feature {NONE} -- State line procedures

	find_playlist (line: EL_ASTRING)
			--
		local
			l_line: EL_ASTRING
			is_static: BOOLEAN
		do
			l_line := line.string; l_line.left_adjust
			if l_line.starts_with ("<playlist") then
				if l_line.has_substring (Static_type_attribute) then
					static_playlist_count := static_playlist_count + 1
					is_static := True
				end
				append_playlist_lines (line, is_static)
				if not l_line.ends_with ("/>") then
					state := agent append_playlist_lines (?, is_static)
				end

			elseif l_line.starts_with (Final_closing_tag) then
				append_to_xml (line)
				state := agent final
			else
				append_to_xml (line)
			end
		end

	append_playlist_lines (line: EL_ASTRING; a_is_static_playlist: BOOLEAN)
			--
		local
			l_line: EL_ASTRING
		do
			l_line := line.string; l_line.left_adjust
			if a_is_static_playlist then
				append_to_xml (line)
			else
				non_static_playlist_lines.extend (line)
			end
			if l_line.starts_with (Playlist_end_tag) then
				state := agent find_playlist
			end
		end

feature {RBOX_DATABASE} -- Implementation

	build_from_file (a_file_path: EL_FILE_PATH)
		local
			lines: EL_FILE_LINE_SOURCE
		do
			create xml_string.make (File_system.file_byte_count (a_file_path))
			create lines.make (a_file_path)
			do_with_lines (agent find_playlist, lines)
			make_array (static_playlist_count)
			build_from_string (xml_string)
		end

	append_to_xml (a_line: EL_ASTRING)
		do
			xml_string.append (a_line)
			xml_string.append_character ('%N')
		end

	database: RBOX_DATABASE

	static_playlist_count: INTEGER

	non_static_playlist_lines: LINKED_LIST [EL_ASTRING]
		-- automatic playlists generated by Rhythmbox

	xml_string: EL_ASTRING
		-- XML source with automatically generated playlists removed

feature {NONE} -- Type definitions

	Type_songs: INDEXABLE [EL_FILE_PATH, INTEGER]
		do
		end

feature {NONE} -- Constants

	Template: STRING_32 = "[
		<?xml version="1.0"?>
		<rhythmdb-playlists>
		#across $non_static_playlist_lines as $line loop
		$line.item
		#end
		#across $playlists as $list loop
			#if $list.item.count > 0 then	
			<playlist name="$list.item.name" type="static">
			#across $list.item.entries as $song loop
				#if $is_backup_mode then
			    <track-id>$song.item.track_id</track-id>
			    #else
			    <location>$song.item.location_uri</location>
			    #end
			#end
			</playlist>
			#end
		#end
		</rhythmdb-playlists>
	]"

	Final_closing_tag: STRING = "</rhythmdb-playlists>"

	Playlist_end_tag: STRING = "</playlist>"

	XML_declaration: STRING = "<?xml version=%"1.0%"?>"

	Static_type_attribute: STRING = "type=%"static%">"
end
