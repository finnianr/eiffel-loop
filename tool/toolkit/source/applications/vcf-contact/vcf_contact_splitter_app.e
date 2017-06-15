note
	description: "Summary description for {VCF_CONTACT_SPLITTER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-31 20:30:24 GMT (Wednesday 31st May 2017)"
	revision: "4"

class
	VCF_CONTACT_SPLITTER_APP

inherit
	TESTABLE_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_SPLITTER]
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
			Test.do_file_test ("contacts.vcf", agent test_split, 4176544362)
		end

	test_split (vcf_path: EL_FILE_PATH)
			--
		local
		do
			create command.make (vcf_path)
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [vcf_path: EL_FILE_PATH]
		do
			create Result
			Result.vcf_path := ""
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("in", "Path to vcf contacts file", << file_must_exist >>)
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "split_vcf"

	Description: STRING = "Split vcf contacts file into separate files"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{VCF_CONTACT_SPLITTER_APP}, All_routines],
				[{VCF_CONTACT_SPLITTER}, All_routines]
			>>
		end

end
