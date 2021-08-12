note
	description: "[
		Object available via `{[$source EL_MODULE_DEFERRED_LOCALE]}.Locale' that allows strings in descendants of
		[$source EL_MODULE_DEFERRED_LOCALE] to be optionally localized at an application level by including class
		[$source EL_MODULE_LOCALE] from the `i18n.ecf' library. By default `translation' returns the key as a `ZSTRING'
		
		Localized strings are referred to using the shorthand syntax:
		
			Locale * "<text>"		
		
		Originally this class was introduced to prevent circular library dependencies.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-10 9:40:12 GMT (Tuesday 10th August 2021)"
	revision: "12"

deferred class
	EL_DEFERRED_LOCALE_I

inherit
	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_ZSTRING_CONSTANTS

feature -- Access

	all_languages: EL_STRING_8_LIST
		deferred
		end

	date_text: EL_DATE_TEXT
		deferred
		end

	in (a_language: STRING): EL_DEFERRED_LOCALE_I
		deferred
		end

	language: STRING
		deferred
		end

	quantity_translation (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- translation with adjustments according to value of quanity
			-- keys have
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		do
			Result := quantity_translation_extra (partial_key, quantity, Empty_substitutions)
		end

	quantity_translation_extra (
		partial_key: READABLE_STRING_GENERAL; quantity: INTEGER; substitutions: like Empty_substitutions
	): ZSTRING
			-- translation with adjustments according to value of `quantity'
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		local
			template: like translation_template; name: STRING
		do
			template := translation_template (partial_key, quantity)
			across substitutions as list loop
				name := list.item.name
				if template.has (name) then
					template.put_general (name, list.item.value)
				end
			end
			if template.has (Var_quantity) then
				template.put_general (Var_quantity, quantity.out)
			end
			Result := template.substituted
		end

	translation alias "*" (key: READABLE_STRING_GENERAL): ZSTRING
			-- by default returns `key' as a `ZSTRING' unless localization is enabled at an
			-- application level
		deferred
		end

	translation_keys: ARRAY [ZSTRING]
		deferred
		end

feature -- Status query

	is_valid_quantity_key (key: READABLE_STRING_GENERAL; quantity: INTEGER): BOOLEAN
		deferred
		end

	english_only: BOOLEAN
		-- `True' if application is not localized
		do
			Result := True
		end

feature {EL_MODULE_DEFERRED_LOCALE, EL_DATE_TEXT} -- Element change

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- set text for next call to `translation' with key enclosed with curly braces "{}"
		deferred
		end

	set_next_quantity_translation (quantity: INTEGER; text: READABLE_STRING_GENERAL)
		-- set text for next call to `quantity_translation_extra' with key enclosed with curly braces "{}"
		require
			valid_quantity: 0 <= quantity and quantity <= 2
		deferred
		end

feature {NONE} -- Implementation

	translation_template (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): EL_TEMPLATE [ZSTRING]
		deferred
		end

feature {NONE} -- Constants

	Empty_substitutions: ARRAY [TUPLE [name: STRING; value: READABLE_STRING_GENERAL]]
		once
			create Result.make_empty
		end

	Var_quantity: STRING = "QUANTITY"

end