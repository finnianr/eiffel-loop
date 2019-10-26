note
	description: "Wcom object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 19:02:06 GMT (Saturday   26th   October   2019)"
	revision: "5"

class
	EL_WCOM_OBJECT

inherit
	EL_EXTERNAL_LIBRARY [EL_WCOM_INITIALIZER]

	EL_OWNED_CPP_OBJECT

	EL_MODULE_UTF

feature {NONE} -- Implementation

	internal: CELL [EL_WCOM_INITIALIZER]
			--
		once ("PROCESS")
			create Result.put (Void)
		end

    cpp_delete (this: POINTER)
            --
		local
			ref_count: NATURAL
		do
			ref_count := cpp_release (this)
		end

	call_succeeded (status: INTEGER): BOOLEAN
		do
			Result := status >= 0
		end

	wide_string (str: ZSTRING): SPECIAL [NATURAL_16]
			-- UTF-16 encoded string
		do
			Result := UTF.utf_32_string_to_utf_16_0 (str.to_unicode)
		end

	last_call_result: INTEGER

feature {NONE} -- C++ Externals

	cpp_release (this: POINTER): NATURAL
			-- ULONG Release();
		external
			"C++ [IUnknown <Unknwn.h>](): EIF_NATURAL"
		alias
			"Release"
		end

end
