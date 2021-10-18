note
	description: "Meta data for IP address parsed from JSON query `https://ipapi.co/<IP-address>/json'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-18 13:37:25 GMT (Monday 18th October 2021)"
	revision: "2"

class
	EL_IP_ADDRESS_META_DATA

inherit
	EL_JSON_INTERVALS_OBJECT [EL_IPAPI_CO_JSON_FIELD_ENUM]

create
	make

feature -- Codes

	asn: STRING
		-- autonomous system number
		do
			Result := string_8_value (Field.asn)
		end

	country: STRING
		-- autonomous system number
		do
			Result := string_8_value (Field.country)
		end

feature -- Measurement

	country_area: REAL
		do
			Result := real_value (Field.country_area)
		end

	country_population: NATURAL
		do
			Result := natural_value (Field.country_population)
		end

	latitude: REAL
		do
			Result := real_value (Field.latitude)
		end

	longitude: REAL
		do
			Result := real_value (Field.longitude)
		end

feature -- Status query

	in_eu: BOOLEAN
		-- whether IP address belongs to a country that is a member of the European Union (EU)
		do
			Result := boolean_value (Field.in_eu)
		end

feature -- String

	city: ZSTRING
		-- city name
		do
			Result := string_value (Field.city)
		end

	country_name: ZSTRING
		-- country name
		do
			Result := string_value (Field.country_name)
		end

	region: ZSTRING
		-- region name (administrative division)
		do
			Result := string_value (Field.region)
		end

end