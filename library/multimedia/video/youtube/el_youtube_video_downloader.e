note
	description: "[
		Command to download and merge selected audio and video streams from a Youtube video.
		
		The user is asked to select:
		
		1. an audio stream
		2. a video stream
		3. an output container type (webm or mp4 for example)
		
		If for some reason the execution is interrupted due to a network outage, it is possible to resume
		the downloads without loosing any progress by requesting a retry when prompted.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 9:56:00 GMT (Tuesday 8th February 2022)"
	revision: "14"

class
	EL_YOUTUBE_VIDEO_DOWNLOADER

inherit
	EL_APPLICATION_COMMAND
		redefine
			description
		end

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_ZSTRING_CONSTANTS

	EL_YOUTUBE_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_url: EL_INPUT_PATH [EL_DIR_URI_PATH])
		do
			a_url.check_path_default
			create video.make (a_url.to_string)
		end

feature -- Basic operations

	execute
		local
			output_extension: ZSTRING; done: BOOLEAN
		do
			video.select_downloads

			output_extension := User_input.line ("Enter an output extension")
			lio.put_new_line

			from until done loop
				video.download_streams
				if video.downloads_exists then
					if video.download.video.stream.extension ~ output_extension then
						video.merge_streams
					elseif video.download.video.stream.extension ~ Mp4_extension then
						video.convert_streams_to_mp4
					end
					if video.is_merge_complete then
						video.cleanup
						lio.put_new_line
						lio.put_line ("DONE")
						done := True
					else
						done := not User_input.approved_action_y_n ("Merging of streams failed. Retry?")
					end
				else
					done := not User_input.approved_action_y_n ("Download of streams failed. Retry?")
				end
			end
		end

feature {NONE} -- Internal attributes

	video: EL_YOUTUBE_VIDEO

feature {NONE} -- Constants

	Description: STRING = "[
		Download selected video and audio stream from youtube video and merge to container
	]"

end