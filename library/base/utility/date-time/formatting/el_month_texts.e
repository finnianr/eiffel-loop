note
	description: "Deferred i18n of month words"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-29 13:37:51 GMT (Friday 29th October 2021)"
	revision: "3"

class
	EL_MONTH_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		redefine
			initialize_fields, Transient_fields
		end

create
	make_with_locale

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			full_names := <<
				january, february, march, april, may, june, july,
				august, september, october, november, december
			>>
			short_names := <<
				jan, feb, mar, apr, may_short, jun, jul, aug, sep, oct, nov, dec
			>>
			full_names.compare_objects; short_names.compare_objects
		ensure then
			valid_ordinal_indicators: ordinal_indicators.count = 4
		end

feature -- Access

	full_names: ARRAY [ZSTRING]

	short_names: ARRAY [ZSTRING]

	ordinal_indicators: EL_ZSTRING_LIST
		-- list of suffixes for month number "st, nd, rd, th"
		-- 21st March

feature -- Months of year

	january: ZSTRING

	february: ZSTRING

	march: ZSTRING

	april: ZSTRING

	may: ZSTRING

	june: ZSTRING

	july: ZSTRING

	august: ZSTRING

	september: ZSTRING

	october: ZSTRING

	november: ZSTRING

	december: ZSTRING

feature -- Short months of year

	jan: ZSTRING

	feb: ZSTRING

	mar: ZSTRING

	apr: ZSTRING

	may_short: ZSTRING

	jun: ZSTRING

	jul: ZSTRING

	aug: ZSTRING

	sep: ZSTRING

	oct: ZSTRING

	nov: ZSTRING

	dec: ZSTRING

feature {NONE} -- Implementation

	english_table: STRING_8
			-- description of attributes
		do
			Result := "[
				may_short:
					May
				ordinal_indicators:
					st, nd, rd, th
			]"
		end

	Transient_fields: STRING
		-- comma-separated list of fields that will be treated as if they are transient attributes and
		-- excluded from `field_table'
		once
			Result := "full_names, short_names"
		end

end