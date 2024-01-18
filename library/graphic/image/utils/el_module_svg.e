note
	description: "Shared access to routines of class ${EL_SVG_IMAGE_UTILS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	EL_MODULE_SVG

inherit
	EL_MODULE

feature {NONE} -- Constants

	SVG: EL_SVG_IMAGE_UTILS
		once
			create Result
		end

end