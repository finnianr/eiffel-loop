note
	description: "[
		Interface to the class `BUILD_INFO' auto-generated by the Eiffel-Loop Scons build system.
		Accessible via ${EL_MODULE_BUILD_INFO}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "16"

deferred class
	EL_BUILD_INFO

inherit
	ANY

	EL_SOLITARY

feature -- Access

	company: ZSTRING
		-- company name
		do
			Result := installation_sub_directory.first_step
		end

	installation_sub_directory: DIR_PATH
			--
		deferred
		ensure
			has_two_parts: Result.step_count = 2
		end

	product: ZSTRING
		-- product name
		do
			Result := installation_sub_directory.base
		end

feature -- Measurement

	build_number: NATURAL
			--
		deferred
		end

	version_number: NATURAL
			-- version in form jj_nn_tt where: jj is major version, nn is minor version and tt is maintenance version
			-- padded with leading zeros: eg. 01_02_15 is Version 1.2.15
		deferred
		end

end