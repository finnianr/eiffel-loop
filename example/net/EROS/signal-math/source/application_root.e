note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [
		BUILD_INFO, TUPLE [
			BEXT_CLIENT_TEST_APP,
			BEXT_SERVER_TEST_APP,
			FFT_MATH_CLIENT_TEST_APP,
			FFT_MATH_SERVER_TEST_APP,
			EL_STANDARD_INSTALLER_APP
		]
	]

create
	make

end
