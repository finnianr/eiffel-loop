note
	description: "Class to augment a [$source `EL_STORABLE_LIST'] as a key indexable list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-26 9:37:54 GMT (Tuesday 26th December 2017)"
	revision: "2"

deferred class
	EL_KEY_INDEXABLE [G -> EL_KEY_IDENTIFIABLE_STORABLE create make_default end]

feature {NONE} -- Initialization

	make_index_by_key (index_list: BAG [EL_STORABLE_LIST_INDEX [G, HASHABLE]])
		do
			create index_by_key.make (current_list, capacity)
			index_list.extend (index_by_key)
		end

feature -- Access

	index_by_key: EL_STORABLE_KEY_INDEX [G]

	item_by_key (key: NATURAL): G
		local
			l_index: like index_by_key
		do
			l_index := index_by_key
			l_index.search (key)
			if l_index.found then
				Result := l_index.found_item
			else
				create Result.make_default
			end
		end

feature -- Element change

	key_delete (key: NATURAL)
		require
			has_key: index_by_key.has_key (key)
		do
			index_by_key.list_search (key)
			if found then
				delete
			end
		end

	key_replace (a_item: G)
		require
			has_key: index_by_key.has_key (a_item.key)
		do
			index_by_key.list_search (a_item.key)
			if found then
				replace (a_item)
			end
		end

feature {NONE} -- Implementation

	assign_key (identifiable: EL_KEY_IDENTIFIABLE_STORABLE)
			-- Assign a new if zero
		do
			if identifiable.key = 0 then
				maximum_key := maximum_key + 1
				identifiable.set_key (maximum_key)

			elseif identifiable.key > maximum_key then
				maximum_key := identifiable.key
			end
		end

	capacity: INTEGER
		deferred
		end

	current_list: EL_STORABLE_LIST [G]
		deferred
		end

	delete
		deferred
		end

	found: BOOLEAN
		deferred
		end

	replace (a_item: G)
		deferred
		end

feature {NONE} -- Internal attributes

	maximum_key: NATURAL

end
