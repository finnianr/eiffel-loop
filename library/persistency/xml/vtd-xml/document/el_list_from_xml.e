note
	description: "List from XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-16 13:54:51 GMT (Friday 16th June 2023)"
	revision: "11"

deferred class
	EL_LIST_FROM_XML [G -> EL_XML_CREATEABLE_OBJECT create make end]

feature {NONE} -- Initaliazation

	make_from_file (file_path: FILE_PATH)
			--
		do
			make_from_root_node (create {EL_XML_DOC_CONTEXT}.make_from_file (file_path))
		end

	make_from_string (xml_string: STRING)
		do
			make_from_root_node (create {EL_XML_DOC_CONTEXT}.make_from_string (xml_string))
		end

	make_from_root_node (root_node: EL_XML_DOC_CONTEXT)
		local
			node_list: EL_XPATH_NODE_CONTEXT_LIST
		do
			node_list := root_node.context_list (Node_list_xpath)
			make_with_count (node_list.count)
			from node_list.start until node_list.after loop
				extend (new_item (node_list.context))
				node_list.forth
			end
		end

	make_with_count (count: INTEGER)
		deferred
		end

feature {NONE} -- Implementation

	extend (v: G)
		deferred
		end

	new_item (node: EL_XPATH_NODE_CONTEXT): G
		do
			create Result.make (node)
		end

	Node_list_xpath: READABLE_STRING_GENERAL
		deferred
		end

end