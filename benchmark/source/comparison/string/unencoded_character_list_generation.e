note
	description: "Unencoded character list generation"
	notes: "[
		Passes over 500 millisecs (in descending order)

			{EL_EXTENDABLE_UNENCODED_CHARACTERS}.extend :  34646.0 times (100%)
			{EL_SUBSTRING_32_LIST}.put_unicode          :  26534.0 times (-23.4%)
			{EL_SUBSTRING_32_BUFFER}.put_unicode        :  16433.0 times (-52.6%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-14 17:28:23 GMT (Tuesday 14th March 2023)"
	revision: "9"

class
	UNENCODED_CHARACTER_LIST_GENERATION

inherit
	STRING_BENCHMARK_COMPARISON
		redefine
			make
		end

create
	make

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_trial_duration: INTEGER_REF)
		do
			trial_duration := a_trial_duration
			create extendable.make
			create substring_list.make (0)
			create substring_buffer.make (0)
		end

feature -- Access

	Description: STRING = "Unencoded list generation"

feature -- Basic operations

	execute
		do
			compare ("compare_character_extend", <<
				["{EL_SUBSTRING_32_BUFFER}.put_unicode", agent buffer_put_unicode],
				["{EL_SUBSTRING_32_LIST}.put_unicode", agent list_put_unicode],
				["{EL_EXTENDABLE_UNENCODED_CHARACTERS}.extend",	agent extendable_extend]
			>>)
		end

feature {NONE} -- String append variations

	buffer_put_unicode
		local
			i: INTEGER; str: STRING_32; c: CHARACTER_32
			buffer: like substring_buffer; array: EL_SUBSTRING_32_ARRAY
		do
			str := String; buffer := substring_buffer
			buffer.wipe_out
			from i := 1  until i > str.count loop
				c := str [i]
				if c.code > 0xFF then
					buffer.put_unicode (c.natural_32_code, i)
				end
				i := i + 1
			end
			create array.make_from_area (buffer.to_substring_area)
		end

	extendable_extend
		local
			i: INTEGER; str: STRING_32; uc: CHARACTER_32
			unencoded: like extendable; characters: EL_UNENCODED_CHARACTERS
		do
			str := String; unencoded := extendable
			unencoded.wipe_out
			from i := 1  until i > str.count loop
				uc := str [i]
				if uc.code > 0xFF then
					unencoded.extend (uc, i)
				end
				i := i + 1
			end
			create characters.make_from_other (unencoded)
		end

	list_put_unicode
		local
			i: INTEGER; str: STRING_32; c: CHARACTER_32
			list: like substring_list; array: EL_SUBSTRING_32_ARRAY
		do
			str := String; list := substring_list
			list.wipe_out
			from i := 1  until i > str.count loop
				c := str [i]
				if c.code > 0xFF then
					list.put_unicode (c.natural_32_code, i)
				end
				i := i + 1
			end
			create array.make_from_area (list.to_substring_area)
		end

feature {NONE} -- Internal attributes

	extendable: EL_UNENCODED_CHARACTERS_BUFFER

	substring_list: EL_SUBSTRING_32_LIST

	substring_buffer: EL_SUBSTRING_32_BUFFER

feature {NONE} -- Constants

	String: STRING_32
		once
			create Result.make (100)
			across Hexagram.Name_list as chinese loop
				Result.append_character (' ')
				Result.append (chinese.item.pinyin)
				Result.append_character (' ')
				Result.append (chinese.item.hanzi)
			end
		end

end