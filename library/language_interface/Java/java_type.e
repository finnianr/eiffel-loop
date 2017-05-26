note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 14:20:57 GMT (Sunday 21st May 2017)"
	revision: "2"

deferred class
	JAVA_TYPE

inherit
	EL_MODULE_LIO
		rename
			Args as Command_args
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make
			--
		do
		end

	make_from_java_method_result (
		target: JAVA_OBJECT_OR_CLASS; a_method_id: POINTER; args: JAVA_ARGUMENTS
	)
			--
		deferred
		end

	make_from_java_attribute (
		target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER
	)
			--
		deferred
		end

feature {JAVA_ARGUMENTS, J_FLOAT, J_INT} -- Basic operations

	set_argument (argument: JAVA_VALUE)
			--
		deferred
		end

feature -- Constant

	Jni_type_signature: STRING
				-- a fully-qualified class name (that is, a package name, delimited by "/",
				-- followed by the class name).
				-- If the name begins with "[" (the array jni_type_name character),
				-- it returns an array class.
		deferred
		end

end -- class JAVA_TYPE
