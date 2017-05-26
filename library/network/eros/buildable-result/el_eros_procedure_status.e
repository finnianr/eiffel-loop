note
	description: "Procedure execution acknowlegement"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-22 8:28:32 GMT (Monday 22nd May 2017)"
	revision: "2"

class
	EL_EROS_PROCEDURE_STATUS

inherit
	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
		rename
			make_default as make
		redefine
			building_action_table
		end

create
	make

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

feature {NONE} -- Building from XML

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result
		end

	Root_node_name: STRING = "procedure-executed"

feature -- Constants

	Template: STRING =
		--
	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<?create EL_EROS_PROCEDURE_STATUS?>
		<procedure-executed/>
	]"

end
