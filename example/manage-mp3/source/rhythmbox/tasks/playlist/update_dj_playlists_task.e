note
	description: "[
		Update DJ playlists tasks.
		Inserts an ignored entry into database indicating location of Pyxis playlist.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-16 11:18:53 GMT (Thursday 16th April 2020)"
	revision: "6"

class
	UPDATE_DJ_PLAYLISTS_TASK

inherit
	RBOX_MANAGEMENT_TASK

	DATABASE_UPDATE_TASK

create
	make

feature -- Basic operations

	apply
		do
			Database.update_dj_playlists (dj_events.dj_name, dj_events.default_title)
			Database.store_all
		end

feature {NONE} -- Internal attributes

	dj_events: DJ_EVENT_INFO

end
