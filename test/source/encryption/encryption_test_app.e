note
	description: "Encryption test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 7:35:43 GMT (Sunday 12th January 2020)"
	revision: "10"

class
	ENCRYPTION_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_OS

create
	make

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_tree_test ("encryption", agent test_encryption, 2559561657)
		end

feature {NONE} -- Implementation

	test_encryption (data_path: EL_DIR_PATH)
			--
		do
			OS.file_list (data_path, "*.txt").do_all (agent test_file_encryption)
		end

	test_file_encryption (file_path: EL_FILE_PATH)
			--
		local
			lines: EL_PLAIN_TEXT_LINE_SOURCE; encrypted_lines: LINKED_LIST [STRING]
		do
			log.enter_with_args ("test_file_encryption", [file_path.base])
			create encrypter.make ("hanami", 256)

			create lines.make (file_path)
			create encrypted_lines.make
			from lines.start until lines.after loop
				log.put_integer_field ("Line", lines.index)
				log.put_string (". ")
				log.put_line (lines.item)
				encrypted_lines.extend (encrypter.base64_encrypted (lines.item))
				lines.forth
			end
			log.put_new_line
			from encrypted_lines.start until encrypted_lines.after loop
				log.put_integer_field ("Line", encrypted_lines.index)
				log.put_string (". ")
				log.put_line (encrypted_lines.item)
				encrypted_lines.forth
			end
			log.put_new_line

			from encrypted_lines.start until encrypted_lines.after loop
				log.put_integer_field ("Line", encrypted_lines.index)
				log.put_string (". ")
				log.put_line (encrypter.decrypted_base64 (encrypted_lines.item))
				encrypted_lines.forth
			end
			log.exit
		end

feature {NONE} -- Internal attributes

	encrypter: EL_AES_ENCRYPTER

feature {NONE} -- Constants

	Description: STRING = "Auto test AES encryption to base 64."

	Option_name: STRING = "test_encryption"

end
