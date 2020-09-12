note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-12 10:51:54 GMT (Saturday 12th September 2020)"
	revision: "7"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [
		BUILD_INFO, TUPLE [
			APACHE_VELOCITY_TEST_APP, JAVA_TEST_APP, SVG_TO_PNG_TEST_APP
		]
	]

create
	make

note
	to_do: "[
		**c_compiler_warnings**
		
		Find out why addition of -Wno-write-strings does not suppress java warnings
		$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/include/config.sh

		warning: deprecated conversion from string constant to 'char*' [-Wwrite-strings]

		**autotest**
		Make AutoTest suites
	]"

end
