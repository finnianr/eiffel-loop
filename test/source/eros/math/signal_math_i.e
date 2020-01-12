note
	description: "[
		Common interface to local proxy interface and remote server class for generating a cosine waveform
	]"
	descendants: "[
			SIGNAL_MATH_I*
				[$source SIGNAL_MATH]
				[$source SIGNAL_MATH_PROXY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 16:34:34 GMT (Sunday 12th January 2020)"
	revision: "6"

deferred class
	SIGNAL_MATH_I

inherit
	DOUBLE_MATH
		rename
			log as nlog
		end

feature -- Element change

	cosine_waveform (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE): VECTOR_COMPLEX_DOUBLE
			--
		require
			i_freq_ok: i_freq > 0 and i_freq <= 2 ^ (log2_length - 1)
			i_freq_ok_with_fft_length: ((2 ^ log2_length).rounded \\ i_freq) = 0
			phase_fraction_ok: phase_fraction >= 0.0 and phase_fraction <= 1.0
		deferred
		end

feature {NONE} -- EROS implementation

	routines: ARRAY [TUPLE [STRING, ROUTINE]]
			--
		do
			Result := <<
				["cosine_waveform", agent cosine_waveform]
			>>
		end

end
