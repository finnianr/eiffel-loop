note
	description: "ID3 tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 18:25:01 GMT (Tuesday 17th March 2020)"
	revision: "7"

deferred class
	TL_ID3_TAG

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_SHARED_FRAME_ID_ENUM

	TL_SHARED_ONCE_STRING

feature -- Access

	album: ZSTRING
		deferred
		end

	artist: ZSTRING
		deferred
		end

	comment: ZSTRING
		deferred
		end

	duration: INTEGER
		deferred
		end

	header: TL_ID3_HEADER
		do
			create Result
		end

	picture: TL_ID3_PICTURE
		do
			create Result.make_empty
		end

	title: ZSTRING
		deferred
		end

	version: INTEGER
		-- ID3 version number
		deferred
		end

feature -- Element change

	set_album (a_album: READABLE_STRING_GENERAL)
		deferred
		ensure
			set: version > 0 implies album.same_string (a_album)
		end

	set_artist (a_artist: READABLE_STRING_GENERAL)
		deferred
		ensure
			set: version > 0 implies artist.same_string (a_artist)
		end

	set_picture (a_picture: TL_ID3_PICTURE)
		deferred
		end

	set_title (a_title: READABLE_STRING_GENERAL)
		deferred
		ensure
			set: version > 0 implies title.same_string (a_title)
		end

feature -- Status query

	is_default, is_version_zero: BOOLEAN
		-- `True' if type is `TL_ID3_V0_TAG'
		do
			Result := version = 0
		end

end
