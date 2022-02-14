note
	description: "Uniform Resource Identifier as defined by [https://tools.ietf.org/html/rfc3986 RFC 3986]"
	notes: "[
	  The following are two example URIs and their component parts:

			  foo://example.com:8042/over/there
			  \_/   \______________/\_________/
			   |           |            |
			scheme     authority       path
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 19:06:53 GMT (Monday 14th February 2022)"
	revision: "1"

deferred class
	EL_URI_ZPATH

inherit
	EL_ZPATH
		redefine
			make, Separator, is_absolute, is_uri
		end

	EL_MODULE_URI

	EL_PROTOCOL_CONSTANTS
		rename
			Protocol as Protocol_name
		end

	STRING_HANDLER
		undefine
			copy, default_create, is_equal
		end

feature -- Initialization

	make (a_uri: READABLE_STRING_GENERAL)
		require else
			is_uri: is_uri_string (a_uri)
			is_absolute: is_uri_absolute (a_uri)
		do
			Precursor (a_uri)
		end

	make_file (a_path: READABLE_STRING_GENERAL)
			-- make with implicit `file' scheme
		require
			is_absolute: a_path.starts_with (Forward_slash)
		do
			make_scheme (Protocol_name.file, create {EL_FILE_ZPATH}.make (a_path))
		end

	make_from_file_path (a_path: EL_ZPATH)
			-- make from file or directory path
		require
			absolute: a_path.is_absolute
		do
			if attached {EL_URI_ZPATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
			else
				make_scheme (Protocol_name.file, a_path)
			end
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

	make_scheme (a_scheme: STRING; a_path: EL_ZPATH)
		require
			path_absolute_for_file_scheme: is_file_scheme (a_scheme) implies a_path.is_absolute
			path_relative_for_other_schemes:
				(not is_file_scheme (a_scheme) and not attached {EL_URI_ZPATH} a_path) implies not a_path.is_absolute
		local
			l_path: ZSTRING
		do
			if attached {EL_URI_ZPATH} a_path as l_uri_path then
				make_from_other (l_uri_path)
				set_scheme (a_scheme)
			else
				l_path := temporary_copy (a_scheme)
				l_path.append_string_general (Colon_slash_x2)
				make_tokens (l_path.occurrences (Separator) + 1 + a_path.step_count)
				Step_table.put_tokens (l_path.split (Separator), area)
				if not ({PLATFORM}.is_windows and a_path.is_absolute) then
					remove_tail (1)
				end
				append (a_path)
			end
		end

feature -- Access

	authority: ZSTRING
		do
			Result := i_th_step (Index_authority).twin
		end

	scheme: STRING
		do
			Result := i_th_step (Index_scheme)
			Result.prune_all_trailing (':')
		end

feature -- Status query

	is_absolute: BOOLEAN
		do
			if has_scheme (Protocol_name.file) and then step_count >= Index_authority then
				Result := i_th (Index_authority)	= Step_table.token_empty_string
			else
				Result := True
			end
		end

	is_uri: BOOLEAN
		do
			Result := True
		end

	has_scheme (a_scheme: STRING): BOOLEAN
		do
			if step_count > 0 and then attached Step_table.to_step (i_th (1)) as l_scheme then
				Result := l_scheme.count - 1 = a_scheme.count and then l_scheme.starts_with_general (a_scheme)
			end
		end

feature -- Element change

	set_authority (a_authority: READABLE_STRING_GENERAL)
		do
			put_i_th_step (a_authority, Index_authority)
		end

	set_scheme (a_scheme: STRING)
		do
			put_i_th_step (a_scheme, Index_scheme)
		end

feature -- Contract Support

	is_file_scheme (a_scheme: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := a_scheme.same_string (Protocol_name.file)
		end

	is_uri_absolute (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := URI.is_absolute (a_uri)
		end

	is_uri_string (a_uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := URI.is_valid (a_uri)
		end

feature -- Constants

	Separator: CHARACTER_32
		once
			Result := Unix_separator
		end

feature {NONE} -- Implementation

	empty_uri_path: like URI_path_string
		do
			Result := URI_path_string; Result.wipe_out
		end

feature {NONE} -- Constants

	Index_authority: INTEGER = 3

	Index_scheme: INTEGER = 1

	URI_path_string: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

end