note
	description: "[
		{[$source PP_ADDRESS]}.address_status: `confirmed' or `unconfirmed' 
		See [https://developer.paypal.com/docs/api-basics/notifications/ipn/IPNandPDTVariables/#buyer-information-variables
		Buyer information variables]
	]"
	tests: "Class [$source PAYPAL_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 9:12:57 GMT (Thursday 16th June 2022)"
	revision: "2"

class
	PP_ADDRESS_STATUS_ENUM

inherit
	EL_BOOLEAN_ENUMERATION
		rename
			foreign_naming as eiffel_naming,
			is_true as confirmed,
			is_false as unconfirmed
		end

create
	make
end