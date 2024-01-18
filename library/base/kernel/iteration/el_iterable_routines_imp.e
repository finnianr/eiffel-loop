note
	description: "Routines related to ${ITERABLE}"
	notes: "Accessible via ${EL_MODULE_ITERABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-23 10:34:56 GMT (Wednesday 23rd August 2023)"
	revision: "8"

class
	EL_ITERABLE_ROUTINES_IMP [G]

feature -- Measurement

	frozen count (iterable: ITERABLE [G]): INTEGER
		do
			if attached {FINITE [G]} iterable as finite then
				Result := finite.count

			elseif attached {READABLE_INDEXABLE [G]} iterable as indexable then
				Result := indexable.upper - indexable.lower + 1

			else
				across iterable as it loop
					Result := Result + 1
				end
			end
		end

feature -- Access

	first (iterable: ITERABLE [G]): detachable G
		local
			done: BOOLEAN
		do
			across iterable as it until done loop
				Result := it.item
				done := True
			end
		end
end