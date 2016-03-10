note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	LB_AUDIO_INPUT_WINDOW

feature -- Basic operations

	start_recording
			-- User pressed start button
		deferred
		end

	stop_recording
			-- User pressed stop button
		deferred
		end

	destroy
			-- User pressed close button
		deferred
		end

end
