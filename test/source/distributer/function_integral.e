note
	description: "Summary description for {FUNCTION_INTEGRAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FUNCTION_INTEGRAL

inherit
	ROUTINE_INTEGRAL [DOUBLE]
		redefine
			distributer
		end

create
	make

feature {NONE} -- Implementation

	collect_integral (f: FUNCTION [DOUBLE, DOUBLE]; lower, upper: DOUBLE; a_delta_count: INTEGER)
		do
			distributer.wait_apply (agent integral (f, lower, upper, a_delta_count))
			-- collect results
			distributer.collect (result_list)
		end

	collect_final
		do
			distributer.collect_final (result_list)
		end

	result_sum: DOUBLE
		do
			across result_list as a_integral loop
				Result := Result + a_integral.item
			end
		end

feature {NONE} -- Internal attributes

	distributer: EL_FUNCTION_DISTRIBUTER [DOUBLE]

end
