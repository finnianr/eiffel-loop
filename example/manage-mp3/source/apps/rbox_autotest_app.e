note
	description: "Finalized executable test sets"
	notes: "[
		Command option: `-rbox_autotest'
		
		**Test Sets**
		
			[$source COLLATE_SONGS_TASK_TEST_SET]
			[$source ADD_ALBUM_ART_TASK_TEST_SET]
			[$source COLLATE_SONGS_TASK_TEST_SET]
			[$source EXPORT_MUSIC_TO_DEVICE_TASK_TEST_SET]
			[$source EXPORT_PLAYLISTS_TO_DEVICE_TASK_TEST_SET]
			[$source IMPORT_M3U_PLAYLISTS_TASK_TEST_SET]
			[$source IMPORT_NEW_MP3_TASK_TEST_SET]
			[$source IMPORT_VIDEOS_TASK_TEST_SET]
			[$source PUBLISH_DJ_EVENTS_TASK_TEST_TASK]
			[$source REPLACE_CORTINA_SET_TASK_TEST_SET]
			[$source REPLACE_SONGS_TASK_TEST_SET]
			[$source TANGO_MP3_FILE_COLLATOR_TEST_SET]
			[$source UPDATE_DJ_PLAYLISTS_TASK_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 17:38:41 GMT (Friday 22nd May 2020)"
	revision: "11"

class
	RBOX_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [IMPORT_VIDEOS_TASK_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [
		ADD_ALBUM_ART_TASK_TEST_SET,
		COLLATE_SONGS_TASK_TEST_SET,
		EXPORT_MUSIC_TO_DEVICE_TASK_TEST_SET,
		EXPORT_PLAYLISTS_TO_DEVICE_TASK_TEST_SET,
		IMPORT_M3U_PLAYLISTS_TASK_TEST_SET,
		IMPORT_NEW_MP3_TASK_TEST_SET,
		IMPORT_VIDEOS_TASK_TEST_SET,
		PUBLISH_DJ_EVENTS_TASK_TEST_TASK,
		REPLACE_CORTINA_SET_TASK_TEST_SET,
		REPLACE_SONGS_TASK_TEST_SET,
		TANGO_MP3_FILE_COLLATOR_TEST_SET,
		UPDATE_DJ_PLAYLISTS_TASK_TEST_SET
	]
		do
			create Result
		end
end
