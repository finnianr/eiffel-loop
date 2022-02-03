note
	description: "Eiffel keywords"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 11:30:30 GMT (Thursday 3rd February 2022)"
	revision: "6"

class
	EL_EIFFEL_CONSTANTS

feature {NONE} -- Constants

	Reserved_word_list: EL_ZSTRING_LIST
			--
		local
			manifest_text, word: ZSTRING
		once
			manifest_text := Reserved_words
			create Result.make (Reserved_words.occurrences (' ') + Reserved_words.occurrences ('%N') + 10)
			across manifest_text.split ('%N') as line loop
				across line.item.split (' ') as split loop
					word := split.item
					Result.extend (word)
					if word.item (1).is_upper then
						Result.extend (word.as_lower)
					end
				end
			end
		end

	Reserved_word_set: EL_HASH_SET [ZSTRING]
			--
		once
			create Result.make (Reserved_word_list.count)
			Reserved_word_list.do_all (agent Result.put)
		end

	Reserved_words: STRING =
		-- Eiffel reserved words
	"[
		across agent alias all and as assign attached attribute
		check class convert create Current
		debug deferred do
		else elseif end ensure expanded export external
		False feature from frozen
		if implies indexing inherit inspect invariant is
		like local loop
		not note
		obsolete old once only or
		Precursor
		redefine rename require rescue Result retry
		select separate some
		then True TUPLE
		undefine until
		variant Void
		when
		xor
	]"

end