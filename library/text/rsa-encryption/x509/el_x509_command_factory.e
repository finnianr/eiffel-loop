note
	description: "X509 command factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-09 14:35:24 GMT (Tuesday 9th February 2021)"
	revision: "6"

class
	EL_X509_COMMAND_FACTORY

feature -- Factory

	new_certificate_reader (crt_file_path: EL_FILE_PATH): EL_X509_CERTIFICATE_READER_COMMAND_I
		do
			create {EL_X509_CERTIFICATE_READER_COMMAND_IMP} Result.make (crt_file_path)
		end

	new_key_reader (key_file_path: EL_FILE_PATH; credential: EL_AES_CREDENTIAL): EL_X509_KEY_READER_COMMAND_I
		do
			create {EL_X509_KEY_READER_COMMAND_IMP} Result.make (key_file_path, credential)
		end
end