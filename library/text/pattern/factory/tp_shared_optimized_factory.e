note
	description: "Shared instance of object conforming to [$source TP_OPTIMIZED_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-24 16:41:01 GMT (Thursday 24th November 2022)"
	revision: "4"

deferred class
	TP_SHARED_OPTIMIZED_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	core: TP_OPTIMIZED_FACTORY
		do
			Result := Optimized_list.item
		end

	set_default_optimal_core
		do
			Optimized_list.go_i_th (1)
		end

	set_optimal_core (text: READABLE_STRING_GENERAL)
		-- set `optimal_core' factory with shared instance that is optimal for `text' type
		do
			if attached {ZSTRING} text then
				Optimized_list.go_i_th (3)

			elseif attached {READABLE_STRING_8} text then
				Optimized_list.go_i_th (2)

			else
				set_default_optimal_core
			end
		end

feature {NONE} -- Constants

	Optimized_list: ARRAYED_LIST [TP_OPTIMIZED_FACTORY]
		once ("PROCESS")
--			Will not work in multi-thread applications unless set to: once ("PROCESS")
--			Assumed to be thread safe since each factory is stateless
			create Result.make_from_array (<<
				create {TP_OPTIMIZED_FACTORY},
				create {TP_RSTRING_FACTORY},
				create {TP_ZSTRING_FACTORY}
			>>)
		end

end

