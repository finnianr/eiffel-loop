note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-24 16:33:57 GMT (Tuesday 24th October 2023)"
	revision: "12"

class
	EL_HACKER_INTERCEPT_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			config, error_check, description, on_shutdown
		end

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE

create
	make_port

feature -- Access

	Description: STRING = "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating iptables rule blocking IP address
	]"

	config: EL_HACKER_INTERCEPT_CONFIG

feature -- Basic operations

	error_check (application: EL_FALLIBLE)
		-- check for errors before execution
		local
			sendmail: EL_SENDMAIL_LOG; error: EL_ERROR_DESCRIPTION
		do
			create sendmail.make_default
			if not sendmail.is_log_readable then
				create error.make (sendmail.Default_log_path)
				error.set_lines ("[
					Current user not part of 'adm' group.
					Use command:
					
						sudo usermod -aG adm <username>
					
					Then re-login for command to take effect.
				]")
				application.put (error)
			end
		end

feature {NONE} -- Event handling

	on_shutdown
		do
			if servlet_table.has_key (Default_servlet_key)
				and then attached {EL_HACKER_INTERCEPT_SERVLET} servlet_table.found_item as servlet
			then
				servlet.store_status_table (Firewall_status_data_path)
			end
		end

feature {NONE} -- Implementation

	initialize_servlets
		do
			servlet_table [Default_servlet_key] := new_servlet
		end

	new_servlet: EL_HACKER_INTERCEPT_SERVLET
		do
			if Executable.Is_work_bench or else Args.word_option_exists ("test_servlet") then
				create {EL_HACKER_INTERCEPT_TEST_SERVLET} Result.make (Current)
			else
				create Result.make (Current)
			end
		end

feature {EL_HACKER_INTERCEPT_SERVLET} -- Constants

	Firewall_status_data_path: FILE_PATH
		once
			Result := Directory.Sub_app_data + "firewall-blocks.dat"
		end
end