note
	description: "[
		Top level class for Evolicity accessible via class [$source EVOLICITY_SHARED_TEMPLATES]

		The templating substitution language was named `Evolicity' as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-19 17:15:19 GMT (Saturday 19th November 2022)"
	revision: "24"

class
	EVOLICITY_TEMPLATES

inherit
	EL_THREAD_ACCESS [HASH_TABLE [EVOLICITY_COMPILER, FILE_PATH]]

	EL_MODULE_EXCEPTION

	EL_ZSTRING_CONSTANTS

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

	EL_MODULE_DEFERRED_LOCALE

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create stack_table.make_equal (19)
			enable_indentation
		end

feature -- Basic operations

	merge (a_name: FILE_PATH; context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		require
			output_writeable: output.is_open_write and output.is_writable
		local
			template: EVOLICITY_COMPILED_TEMPLATE; stack: like stack_table.stack
			found: BOOLEAN
		do
			if stack_table.has_key (a_name) then
				stack := stack_table.found_stack
			else
				-- using a stack enables use of recursive templates
				create stack.make (5)
				stack_table.extend (stack, a_name)
			end
			if stack.is_empty then
				if attached restricted_access (Mutex_compiler_table) as table then
					if table.has_key (a_name) then
						-- Changed 23 Nov 2013
						-- Before it used to make a deep_twin of an existing compiled template
						template := table.found_item.compiled_template
--						log.put_string_field ("Compiled template", a_name.to_string)
--						log.put_new_line
						stack.put (template)
						found := True
					else
						Exception.raise_developer ("Template [%S] not found", [a_name])
					end
					end_restriction
				end
			else
				template := stack_table.found_stack.item
				found := True
			end
			if found then
				if template.has_file_source and then a_name.modification_date_time > template.modification_time then
					-- File was modified
					stack_table.remove (a_name)
					put_file (a_name, template.encoding)
					-- Try again
					merge (a_name, context, output)
				else
					stack.remove
					if attached {EL_STRING_IO_MEDIUM} output as text_output then
						text_output.grow (template.minimum_buffer_length)
					end
					template.execute (context, output)
					stack.put (template)
				end
			end
		end

	merge_to_file (a_name: FILE_PATH; context: EVOLICITY_CONTEXT; text_file: EL_PLAIN_TEXT_FILE)
			--
		require
			writeable: text_file.is_open_write
		do
			merge (a_name, context, text_file)
			text_file.close
		end

feature -- String output

	merged_to_string (a_name: FILE_PATH; context: EVOLICITY_CONTEXT): ZSTRING
		local
			medium: EL_ZSTRING_IO_MEDIUM
		do
			create medium.make_open_write (1024)
			merge (a_name, context, medium)
			medium.close
			Result := medium.text
		end

	merged_to_utf_8 (a_name: FILE_PATH; context: EVOLICITY_CONTEXT): STRING
			--
		local
			medium: EL_STRING_8_IO_MEDIUM
		do
			create medium.make_open_write (1024)
			merge (a_name, context, medium)
			medium.close
			Result := medium.text
		end

feature -- Status query

	has (a_name: FILE_PATH): BOOLEAN
 		do
 			if attached restricted_access (Mutex_compiler_table) as table then
				Result := table.has (a_name)

				end_restriction
 			end
		end

	is_nested_output_indented: BOOLEAN
		-- is the indenting feature that nicely indents nested XML, active?
		-- Active by default.

feature -- Element change

	put_file (file_path: FILE_PATH; encoding: EL_ENCODING_BASE)
			--
		require
			file_exists: file_path.exists
		do
			put (file_path, Empty_string, encoding)
		end

	put_source (a_name: FILE_PATH; template_source: READABLE_STRING_GENERAL)
		do
			put (a_name, as_zstring (template_source), Void)
		end

feature -- Status change

	disable_indentation
			-- Turn off the indenting feature that nicely indents nested XML
			-- This will make application performance better
		do
			is_nested_output_indented := False
		end

	enable_indentation
			-- Turn on the indenting feature that nicely indents nested XML
		do
			is_nested_output_indented := True
		end

feature -- Removal

	clear_all
			-- Clear all parsed templates
		do
 			if attached restricted_access (Mutex_compiler_table) as table then
				table.wipe_out
				end_restriction
 			end
		end

	remove (a_name: FILE_PATH)
			-- remove template
		do
 			if attached restricted_access (Mutex_compiler_table) as table then
				table.remove (a_name)
				end_restriction
 			end
		end

feature -- Factory

	new_translation_key_table: EL_ZSTRING_TABLE
		-- table of translation keys of the form "{evol.<variable-name>}" by Evolicity variable name
		local
			l_key: ZSTRING -- translation key
			var_name: STRING
		do
			create Result.make_with_count (20)
			across Locale.translation_keys as key loop
				l_key := key.item
				if l_key.enclosed_with (Braces) and then l_key.starts_with (Translation_key_prefix) then
					var_name := l_key.substring (Translation_key_prefix.count + 1, l_key.count - 1)
					Result.extend (l_key, var_name)
				end
			end
		end

feature -- Contract Support

	is_type_template (key_path: FILE_PATH): BOOLEAN
		do
			Result := key_path.has_extension ("template") and then key_path.base_sans_extension.enclosed_with (Braces)
		end

feature {NONE} -- Implementation

	put (key_path: FILE_PATH; template_source: ZSTRING; file_encoding: detachable EL_ENCODING_BASE)
		-- put compiled template into the thread safe global `Mutex_compiler_table' template table

		-- if `file_encoding' attached then compile template stored in file path `key_path'
		-- or else recompile existing template if file modified date is newer

		-- if not `file_encoding' attached then compile `template_source' and store
		-- with key `key_path'
		require
			valid_key_path: not attached file_encoding implies (is_type_template (key_path) and not template_source.is_empty)
		local
			compiler: EVOLICITY_COMPILER; source_is_new_or_updated: BOOLEAN
 		do
			if attached restricted_access (Mutex_compiler_table) as table then
				if table.has_key (key_path) then
					if attached file_encoding then
						source_is_new_or_updated := key_path.modification_date_time > table.found_item.modification_time
					end
				else
					source_is_new_or_updated := True
				end
				if source_is_new_or_updated then
					create compiler.make
					if attached file_encoding as encoding then
						compiler.set_encoding_from_other (encoding)
						compiler.set_source_text_from_file (key_path)
					else
						compiler.set_source_text (template_source)
					end
					compiler.parse
					if compiler.parse_succeeded then
						table [key_path] := compiler
					else
						Exception.raise_developer ("Evolicity compilation failed %S", [key_path])
					end
				end
				end_restriction
			end
		end

feature {NONE} -- Internal attributes

	stack_table: EVOLICITY_TEMPLATE_STACK_TABLE
		-- stacks of compiled templates
		-- This design enables use of recursive templates

feature {NONE} -- Global attributes

	Mutex_compiler_table: EL_MUTEX_REFERENCE [HASH_TABLE [EVOLICITY_COMPILER, FILE_PATH]]
			-- Global template compilers table
		once ("PROCESS")
			create Result.make (create {like Mutex_compiler_table.item}.make (11))
		end

feature {NONE} -- Constants

	Braces: ZSTRING
		once
			Result := "{}"
		end

	Translation_key_prefix: ZSTRING
		once
			Result := "{evol."
		end

end