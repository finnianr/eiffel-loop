note
	description: "[$source EL_CPP_BOOLEAN_ARRAY] implementation of [$source PRIME_NUMBER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-31 12:37:59 GMT (Wednesday 31st March 2021)"
	revision: "1"

class
	PRIME_NUMBER_SIEVE_3

inherit
	PRIME_NUMBER_COMMAND

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			create bits_array.make_filled (n, True)
		end

feature -- Access

	prime_count: INTEGER
		local
			i, size: INTEGER; bits: like bits_array
		do
			size := sieve_size; bits := bits_array
			Result := 1
			from i := 3 until i >= size loop
				if bits [i] then
					Result := Result + 1
				end
				i := i + 2
			end
		end

feature -- Basic operations

	execute
		local
			factor, q, i, size: INTEGER; done: BOOLEAN
			bits: like bits_array
		do
			size := sieve_size; bits := bits_array

			q := sqrt (sieve_size.to_real).rounded
			from factor := 3 until factor > q loop
				from done := False; i := factor until done or else i >= size loop
					if bits [i] then
						factor := i; done := True
					else
						i := i + 2
					end
				end
				from i := factor * factor until i >= size loop
					bits [i] := False
					i := i + factor * 2
				end
				factor := factor + 2
			end
		end

feature {NONE} -- Implementation

	sieve_size: INTEGER
		do
			Result := bits_array.count
		end

feature {NONE} -- Internal attributes

	bits_array: EL_CPP_BOOLEAN_VECTOR

end