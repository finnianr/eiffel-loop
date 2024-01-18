note
	description: "Command line interface to ${VCF_CONTACT_NAME_SWITCHER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "18"

class
	VCF_CONTACT_NAME_SWITCHER_APP

inherit
	VCF_CONTACT_NAME_APPLICATION
		redefine
			command, Option_name
		end

create
	make

feature {NONE} -- Internal attributes

	command: VCF_CONTACT_NAME_SWITCHER

feature {NONE} -- Constants

	Option_name: STRING = "vcf_switch"

end