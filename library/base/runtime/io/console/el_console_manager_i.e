note
	description: "Console manager interface accessible via [$source EL_MODULE_CONSOLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-05 10:10:49 GMT (Sunday 5th April 2020)"
	revision: "11"

deferred class
	EL_CONSOLE_MANAGER_I

inherit
	EL_MODULE_ARGS

	EL_SINGLE_THREAD_ACCESS

	EL_SHARED_BASE_OPTION

	EL_MODULE_ENCODINGS

feature {NONE} -- Initialization

	make
		do
			make_default
			create visible_types.make (20)
		end

feature -- Access

	code_page: STRING
		do
			Result := Encodings.Console_encoding.code_page
		end

feature -- Status change

	hide (type: TYPE [EL_MODULE_LIO])
			-- hide conditional `lio' output for type
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				visible_types.prune (type.type_id)
			end_restriction
		end

	show (type: TYPE [EL_MODULE_LIO])
			-- show conditional `lio' output for type
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				visible_types.put (type.type_id)
			end_restriction
		end

	show_all (type_list: ARRAY [TYPE [EL_MODULE_LIO]])
			-- show conditional `lio' output for all types
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				across type_list as type loop
					visible_types.put (type.item.type_id)
				end
			end_restriction
		end

feature -- Status query

	is_highlighting_enabled: BOOLEAN
			-- Can terminal color highlighting sequences be output to console
		deferred
		end

	is_type_visible (type: INTEGER): BOOLEAN
			--
		do
			restrict_access
				Result := visible_types.has (type)
			end_restriction
		end

feature {NONE} -- Internal attributes

	visible_types: EL_HASH_SET [INTEGER]
end
