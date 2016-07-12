﻿note
	description: "Summary description for {POST_CARD_VIEWER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 8:41:04 GMT (Sunday 3rd July 2016)"
	revision: "4"

class
	POST_CARD_VIEWER_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make (False)
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

feature {NONE} -- Implementation

	gui: EL_VISION2_USER_INTERFACE [POSTCARD_VIEWER_MAIN_WINDOW]

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "postcards"
		end

	Description: STRING
		once
			Result := "Image viewer for post card sized images"
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{POST_CARD_VIEWER_APP}, "*"],
				[{POSTCARD_VIEWER_MAIN_WINDOW}, "*"],
				[{POSTCARD_VIEWER_TAB}, "*"]
			>>
		end

end
