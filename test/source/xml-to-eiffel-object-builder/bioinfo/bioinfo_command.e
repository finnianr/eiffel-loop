note
	description: "Summary description for {BIOINFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 20:16:49 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	BIOINFO_COMMAND

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			building_action_table
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create parameter_list.make (10)
		end

feature -- Access

	id: STRING

	menu: STRING

	parameter_list: PARAMETER_LIST

feature -- Basic operations

	display
			--
		do
			log.enter ("display")
			log.put_string_field ("id", id)
			log.put_new_line
			log.put_string_field ("menu", menu)
			log.put_new_line

			from parameter_list.start until parameter_list.after loop
				parameter_list.item.display
				parameter_list.forth
			end
			log.exit
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
			-- Nodes relative to element: command
		do
			-- Call precursor to include xmlns attribute
			create Result.make (<<
				["id/text()", agent do id := node.to_string end],
				["menu/text()", agent do menu := node.to_string end],
				["parlist", agent do set_next_context (parameter_list) end]
			>>)
		end

end
