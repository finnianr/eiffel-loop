note
	description: "Fcgi ip echo servlet"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 16:08:54 GMT (Sunday 24th December 2023)"
	revision: "11"

class
	EL_IP_ECHO_SERVLET

inherit
	FCGI_HTTP_SERVLET
		redefine
			on_serve_done
		end

create
	make

feature {NONE} -- Basic operations

	serve
		do
			log.enter ("serve")
			log.put_labeled_string ("IP", request.parameters.remote_addr)
			log.put_new_line
			response.set_content (
				"Your IP address is: " + request.parameters.remote_addr, Text_type.plain, {EL_ENCODING_TYPE}.Latin_1
			)
			log.exit
		end

	on_serve_done
		do
			log.enter ("on_serve_done")
			across request.method_parameters as parameter loop
				log.put_labeled_string (parameter.key, parameter.item)
				log.put_new_line
			end
			log.exit
		end

end