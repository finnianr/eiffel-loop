note
	description: "Signal math"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 16:34:20 GMT (Sunday 12th January 2020)"
	revision: "6"

class
	SIGNAL_MATH

inherit
	SIGNAL_MATH_I

	EL_REMOTELY_ACCESSIBLE

create
	make

feature -- Basic operations

	cosine_waveform (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE): COLUMN_VECTOR_COMPLEX_DOUBLE
   			-- create a sinusoidal wave
   			-- (From Greg Lee's Numeric Eiffel Library test suite)
		local
			c: NEL_COMPLEX_DOUBLE
			i_period, i, n: INTEGER
			y, r: DOUBLE
			      do
			n := (2 ^ log2_length).rounded

			i_period := n // i_freq

			y := (2.0 * Pi) / (1.0 * n)

			create Result.make_with_size (n)
			from i := 1 until i > Result.height loop
				r := cosine (i_freq * y * (i - 1 - phase_fraction * i_period))
				c.set(r, 0.0)
				Result.put( c, i )
				i := i + 1
			end
		end

end
