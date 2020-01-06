note
	description: "File data test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-05 15:04:46 GMT (Sunday 5th January 2020)"
	revision: "4"

class
	EL_FILE_DATA_TEST_SET

inherit
	EQA_TEST_SET
		export
			{EL_SUB_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

feature {NONE} -- Events

	on_clean
		do
			clean_work_area
		end

	on_prepare
		local
			l_dir: EL_DIRECTORY
		do
			create l_dir.make (Work_area_dir)
			if l_dir.exists and not l_dir.is_empty then
				l_dir.recursive_delete
			end
			if not l_dir.exists then
				l_dir.create_dir
			end
		end

feature {NONE} -- Implementation

	clean_work_area
		local
			l_dir: EL_DIRECTORY
		do
			create l_dir.make (Work_area_dir)
			l_dir.delete_content
		end

feature {NONE} -- Constants

	Work_area_dir: EL_DIR_PATH
		once
			Result := "workarea"
		end

end
