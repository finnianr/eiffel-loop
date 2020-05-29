note
	description: "Uniform Resource Identifier as defined by [https://tools.ietf.org/html/rfc3986 RFC 3986]"
	notes: "[
	  The following are two example URIs and their component parts:

	         foo://example.com:8042/over/there?name=ferret#nose
	         \_/   \______________/\_________/ \_________/ \__/
	          |           |            |            |        |
	       scheme     authority       path        query   fragment
	          |   _____________________|__
	         / \ /                        \
	         urn:example:animal:ferret:nose
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-29 14:49:13 GMT (Friday 29th May 2020)"
	revision: "18"

deferred class
	EL_URI_PATH

inherit
	EL_PATH
		export
			{ANY} Forward_slash
		redefine
			append_file_prefix, default_create, make, make_from_other, escaped,
			is_uri, is_equal, is_less,
			set_path, part_count, part_string,
			Separator, Type_parent
		end

	EL_PROTOCOL_CONSTANTS
		rename
			Protocol as Protocol_name
		end

	EL_MODULE_UTF

	EL_MODULE_URI

	EL_SHARED_ONCE_ZSTRING

feature {NONE} -- Initialization

	default_create
		do
			Precursor {EL_PATH}
			authority := Empty_path; scheme := Empty_path
		end

feature -- Initialization

	make (a_uri: READABLE_STRING_GENERAL)
		require else
			is_uri: is_uri_string (a_uri)
			is_absolute: is_uri_absolute (a_uri)
		local
			l_path, l_scheme: ZSTRING; start_index, pos_separator: INTEGER
		do
			l_path := temporary_copy (a_uri)
			start_index := a_uri.substring_index (Colon_slash_x2, 1)
			if start_index > 0 then
				l_scheme := empty_once_string
				l_scheme.append_substring_general (a_uri, 1, start_index - 1)
				set_scheme (l_scheme)
				l_path.remove_head (start_index + Colon_slash_x2.count - 1)
			end
			if scheme ~ Protocol_name.file then
				create authority.make_empty
				Precursor (l_path)
			else
				pos_separator := l_path.index_of (Separator, 1)
				authority := l_path.substring (1, pos_separator - 1)
				l_path.remove_head (pos_separator - 1)
				Precursor (l_path)
			end
		ensure then
			is_absolute: is_absolute
		end

	make_file (a_path: READABLE_STRING_GENERAL)
			-- make with implicit `file' scheme
		require
			is_absolute: a_path.starts_with (Forward_slash)
		do
			make_scheme (Protocol_name.file, create {EL_FILE_PATH}.make (a_path))
		end

	make_from_file_path (a_path: EL_PATH)
			-- make from file or directory path
		require
			absolute: a_path.is_absolute
		do
			if attached {EL_URI_PATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
			elseif {PLATFORM}.is_windows then
				make_file (Forward_slash + a_path.as_unix.to_string)
			else
				make_scheme (Protocol_name.file, a_path)
			end
		end

	make_from_other (other: EL_URI_PATH)
		do
			authority := other.authority.twin
			scheme := other.scheme
			Precursor {EL_PATH} (other)
		end

	make_from_encoded (a_uri: STRING)
		local
			qmark_index: INTEGER; l_path: like empty_uri_path
		do
			l_path := empty_uri_path
			qmark_index := a_uri.index_of ('?', 1)
			if qmark_index > 0 then
				l_path.append_substring (a_uri, 1, qmark_index - 1)
			else
				l_path.append_raw_8 (a_uri)
			end
			make (l_path.decoded_32 (False))
		end

	make_scheme (a_scheme: READABLE_STRING_GENERAL; a_path: EL_PATH)
		require
			path_absolute_for_file_scheme: is_file_scheme (a_scheme) implies a_path.is_absolute
			path_relative_for_other_schemes:
				(not is_file_scheme (a_scheme) and not attached {EL_URI_PATH} a_path) implies not a_path.is_absolute
		local
			l_path: ZSTRING
		do
			if attached {EL_URI_PATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
			else
				create l_path.make (a_scheme.count + Colon_slash_x2.count + a_path.count)
				l_path.append_string_general (a_scheme)
				l_path.append_string_general (Colon_slash_x2)
				a_path.append_to (l_path)
				make (l_path)
			end
		end

feature -- Access

	authority: ZSTRING

	scheme: ZSTRING

feature -- Element change

	set_scheme (a_scheme: READABLE_STRING_GENERAL)
		local
			l_scheme: ZSTRING
		do
			if attached {ZSTRING} a_scheme as zstr then
				l_scheme := zstr
			else
				l_scheme := temporary_copy (a_scheme)
			end
			if Scheme_set.has_key (l_scheme) then
				scheme := Scheme_set.found_item
			else
				scheme := l_scheme.twin
				Scheme_set.put (scheme)
			end
		end

	set_path (a_path: ZSTRING)
		do
			make (a_path)
		end

feature -- Status query

	is_uri: BOOLEAN
		do
			Result := True
		end

feature -- Conversion

	escaped: ZSTRING
		do
			Result := to_encoded_utf_8
		end

	to_file_path: EL_PATH
		deferred
		end

	to_encoded_utf_8: STRING
		local
			i: INTEGER; l_path: like empty_uri_path
		do
			l_path := empty_uri_path
			from i := 1 until i > part_count loop
				l_path.append_general (part_string (i))
				i := i + 1
			end
			create Result.make_from_string (l_path)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := Precursor {EL_PATH} (other) and then scheme ~ other.scheme and then authority ~ other.authority
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if scheme ~ other.scheme then
				if authority ~ other.authority then
					Result := Precursor (other)
				else
					Result := authority < other.authority
				end
			else
				Result := scheme < other.scheme
			end
		end

feature -- Contract Support

	is_uri_absolute (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		local
			l_uri: ZSTRING
		do
			l_uri := temporary_copy (a_uri)
			if URI.scheme (l_uri) ~ Protocol_name.file then
				Result := URI.path (l_uri).starts_with (Forward_slash)
			else
				Result := URI.path (l_uri).has (Forward_slash [1])
			end
		end

	is_file_scheme (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := URI.is_file (a_uri)
		end

	is_uri_string (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := URI.is_valid (a_uri)
		end

feature {NONE} -- Implementation

	append_file_prefix (a_uri: EL_URI_STRING_8)
		do
		end

	part_count: INTEGER
		do
			Result := 5
		end

	part_string (index: INTEGER): ZSTRING
		do
			inspect index
				when 1 then
					Result := scheme
				when 2 then
					Result := Colon_slash_x2
				when 3 then
					Result := authority
				when 4 then
					Result := parent_path
			else
				Result := base
			end
		end

feature {NONE} -- Type definitions

	Type_parent: EL_DIR_URI_PATH
		once
		end

feature -- Constants

	Separator: CHARACTER_32
		once
			Result := Unix_separator
		end

feature {NONE} -- Constants

	Scheme_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (50)
		end

	Separator_string: ZSTRING
		once
			Result := "/"
		end

end
