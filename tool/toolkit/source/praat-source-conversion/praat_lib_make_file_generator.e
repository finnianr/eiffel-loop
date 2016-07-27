note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:56:30 GMT (Thursday 24th December 2015)"
	revision: "4"

class
	PRAAT_LIB_MAKE_FILE_GENERATOR

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			template as make_file_template
		end
create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create object_file_list.make
			create include_directory_list.make
		end

feature -- Access

	object_file_list: LINKED_LIST [STRING]

	library_name: STRING

	include_directory_list: LINKED_LIST [STRING]

feature -- Element change

	set_praat_version_no (version_no: STRING)
			--
		do
			praat_version_no := version_no
		end

	set_library_name (a_library_name: STRING)
			--
		do
			library_name := a_library_name
		end

	add_include_directory (a_include_directory: STRING)
			--
		do
			include_directory_list.extend (a_include_directory)
		end

	add_c_library_object_name (name: STRING)
			--
		do
			object_file_list.extend (name)
		end

feature -- Status query

	is_valid: BOOLEAN
			--
		do
			Result := library_name /= Void and not object_file_list.is_empty
		end

feature {NONE} -- Evolicity access

	get_library_name: STRING
			--
		do
			Result := library_name
		end

	get_include_directory_list: like include_directory_list
			--
		do
			Result := include_directory_list
		end

	get_object_file_list: like object_file_list
			--
		do
			Result := object_file_list
		end

	get_praat_version_no: STRING
			--
		do
			Result := praat_version_no
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["library_name", agent get_library_name],
				["include_directory_list", agent get_include_directory_list],
				["object_file_list", agent get_object_file_list],
				["praat_version_no", agent get_praat_version_no]
			>>)
		end

feature {NONE} -- Implementation

	praat_version_no: STRING

	make_file_template: STRING =
		--
	"[	
	# DO NOT EDIT 
	# Generated by Eiffel-LOOP build tool from class PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP
	
	# MS VC++ makefile of the library "${library_name}-mt.lib"
	
	CFLAGS = -nologo -W1 -c -MT -Ox -DDONT_INCLUDE_QUICKTIME -DCONSOLE_APPLICATION -DEIFFEL_APPLICATION \
	#foreach $include_directory in $include_directory_list loop
		#if $loop_index = $include_directory_list.count then
		-I $include_directory
		#else
		-I $include_directory \
		#end
	#end
	
	LIB = ..\..\lib_$praat_version_no
	
	#foreach $c_object in $object_file_list loop
		#if $loop_index = 1 then
			#if $object_file_list.count = 1 then
	OBJ = ${c_object}.obj
			#else
	OBJ = ${c_object}.obj \
			#end
		#else
			#if $loop_index < $object_file_list.count then
		${c_object}.obj \
			#else
		${c_object}.obj
			#end
		#end
	#end
			   
	${library_name}-mt.lib: $(OBJ)
		if exist $@ del $@
		lib /NOLOGO /OUT:$@ $(OBJ)
		if not exist $(LIB) mkdir $(LIB)
		copy $@ $(LIB)
		del $@
		del *.obj
	]"

end