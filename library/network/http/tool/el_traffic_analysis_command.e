note
	description: "Object to analyse web-server log geographically according to configuration"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 19:17:50 GMT (Thursday 11th July 2024)"
	revision: "25"

class
	EL_TRAFFIC_ANALYSIS_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_WEB_LOG_PARSER_COMMAND
		rename
			make as make_parser
		redefine
			execute
		end

	EL_MODULE_DATE; EL_MODULE_DIRECTORY; EL_MODULE_GEOLOCATION; EL_MODULE_IP_ADDRESS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_path: FILE_PATH; a_config: like config)
		do
			make_parser (a_log_path)
			config := a_config
			Geolocation.try_restore (Directory.Sub_app_data)
			create buffer
			create page_table.make_equal (50)
			create bot_agent_table.make_equal (50)
			create human_agent_table.make_equal (50)
			create human_entry_list.make (500)
			create selected_entry_list.make (0)
			across config.page_list as page loop
				page_table.extend_list (create {like page_table.item_list}.make (50), page.item)
			end
		end

feature -- Constants

	Description: STRING = "Analyse web traffic from cherokee log file"

feature -- Basic operations

	execute
		local
			location: ZSTRING
		do
			Precursor -- parse log file
			selected_entry_list := human_entry_list.query_if (agent is_selected)

			-- Cache locations
			lio.put_line ("Getting IP address locations:")

			Geolocation.set_log (Lio)
			across selected_entry_list as entry loop
				location := Geolocation.for_number (entry.item.ip_number)
				human_agent_table.put_copy (entry.item.stripped_user_agent (False))
			end
			Geolocation.set_log (Void)
			lio.put_new_line_x2

			across << bot_agent_table, human_agent_table >> as table loop
				if table.cursor_index = 1 then
					lio.put_line ("WEB CRAWLER AGENTS")
				else
					lio.put_line ("HUMAN AGENTS")
				end
				across table.item.as_sorted_list (False) as map loop
					lio.put_natural_field (map.key, map.value)
					lio.put_new_line
				end
				lio.put_new_line
			end

			lio.put_line ("SELECTED HUMAN VISITS")
			lio.put_new_line

			month_groups.linear_representation.do_all (agent print_month)
			lio.put_line ("Storing geolocation data")
			Geolocation.store (Directory.Sub_app_data)
		end

feature {NONE} -- Implementation

	do_with (entry: EL_WEB_LOG_ENTRY)
		do
			if is_bot (entry) then
				bot_agent_table.put_copy (entry.stripped_user_agent (False))
			else
				human_entry_list.extend (entry)
			end
		end

	entry_month (entry: EL_WEB_LOG_ENTRY): INTEGER
		do
			Result := entry.compact_date |>> 8
		end

	is_bot (entry: EL_WEB_LOG_ENTRY): BOOLEAN
		local
			user_agent: ZSTRING
		do
			user_agent := buffer.copied (entry.user_agent)
			user_agent.to_lower
			Result := across config.crawler_substrings as substring some
				user_agent.has_substring (substring.item)
			end
		end

	is_selected (entry: EL_WEB_LOG_ENTRY): BOOLEAN
		-- `True' if matching configuration page_list items
		do
			Result := across config.page_list as page some
				entry.request_uri.starts_with (page.item)
			end
		end

	month_groups: EL_FUNCTION_GROUP_TABLE [EL_WEB_LOG_ENTRY, INTEGER]
		do
			create Result.make_from_list (agent entry_month, selected_entry_list)
		end

	print_month (entry_list: EL_ARRAYED_LIST [EL_WEB_LOG_ENTRY])
		local
			location_table: EL_COUNTER_TABLE [ZSTRING]; found: BOOLEAN
		do
			across page_table.linear_representation as list loop
				list.item.wipe_out
			end
			across entry_list as entry loop
				found := False
				if entry.cursor_index = 1 then
					lio.put_labeled_string ("-- MONTH", Date.long_month_name (entry.item.date).as_upper)
					lio.put_string (" --")
					lio.put_new_line_x2
				end
				across config.page_list as page until found loop
					if entry.item.request_uri.starts_with (page.item) then
						found := True
						if attached page_table [page.item] as list then
							list.extend (entry.item.ip_number)
						end
					end
				end
			end
			across page_table as page loop
				lio.put_integer_field (page.key, page.item.count)
				lio.put_new_line
				create location_table.make (page.item.count)
				across page.item as ip loop
					location_table.put (Geolocation.for_number (ip.item))
				end
				across location_table.as_sorted_list (False) as map loop
					lio.tab_right
					lio.put_new_line
					lio.put_natural_field (map.key, map.value)
					lio.tab_left
				end
				lio.put_new_line_x2
			end
		end

feature {NONE} -- Internal attributes

	bot_agent_table: EL_COUNTER_TABLE [ZSTRING]

	buffer: EL_ZSTRING_BUFFER

	config: EL_TRAFFIC_ANALYSIS_CONFIG

	human_agent_table: EL_COUNTER_TABLE [ZSTRING]

	human_entry_list: EL_QUERYABLE_ARRAYED_LIST [EL_WEB_LOG_ENTRY]

	page_table: EL_GROUP_TABLE [NATURAL, ZSTRING]

	selected_entry_list: EL_ARRAYED_LIST [EL_WEB_LOG_ENTRY];
		-- human entries that match the configuration page_list items

note
	notes: "[
		**Example Configuration**
		
			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			traffic_analysis_config:
				page_list:
					item:
						"/en/download/latest-version.html"
						"/en/purchase/purchase-a-subscription.html"
					item:
						"/download/install_my_ching.sh"
						"/download/MyChing-en-win32"
						"/download/MyChing-en-win64"

				crawler_substrings:
					item:
						"archiver"
						"bot"
						"crawl"
						"dataprovider"
						"facebookexternalhit"
						"go-http-client"
						"ips-agent"
						"libwww"
						"researchscan"
						"spider"
						"netcraftsurveyagent"
						"python"
						"qwantify"
	]"

end