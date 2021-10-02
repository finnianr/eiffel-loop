note
	description: "Paypal buy options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-02 12:33:20 GMT (Saturday 2nd October 2021)"
	revision: "18"

class
	PP_BUY_OPTIONS

inherit
	EL_HTTP_PARAMETER_LIST
		rename
			make as make_list,
			extend as extend_list
		end

	EL_CURRENCY_PROPERTY

	EL_ZSTRING_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (a_id: like id; name: ZSTRING; a_currency_code: like currency_code)
		require
			valid_id: a_id >= 0 and a_id <= 9
		do
			id := a_id; currency_code := a_currency_code

			create select_parameters.make (id)
			create price_parameters.make (id)
			make_list (<< new_name_parameter (name), select_parameters, price_parameters >>)
		end

	make_default
		do
			make (0, Empty_string, Currency_enum.EUR)
		end

feature -- Access

	id: INTEGER

feature -- Element change

	extend (option_name: ZSTRING; price_x100: INTEGER)
		do
			select_parameters.extend (option_name)
			price_parameters.extend (price_string (price_x100))
		end

feature {NONE} -- Implementation

	new_name_parameter (name: ZSTRING): EL_HTTP_NAME_VALUE_PARAMETER
		do
			create Result.make (Name_template #$ [id], name)
		end

	price_parameters: PP_OPTION_PRICE_PARAMETER_LIST

	price_string (price_x100: INTEGER): ZSTRING
		local
			l_price_x100: INTEGER
		do
			create Result.make (5)
			if Currency_enum.has_decimal (currency_code) then
				l_price_x100 := price_x100
			else
				l_price_x100 := (price_x100 / 100).rounded
			end
			Result.append_integer (l_price_x100)
			if Result.count >= 3 and Currency_enum.has_decimal (currency_code) then
				Result.insert_character ('.', Result.count - 1)
			end
		end

	select_parameters: PP_OPTION_SELECT_SUB_PARAMETER_LIST

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "OPTION%SNAME"
		end

end