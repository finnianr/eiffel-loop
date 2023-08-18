﻿note
	description: "Html routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 7:49:46 GMT (Thursday 17th August 2023)"
	revision: "23"

class
	EL_HTML_ROUTINES

inherit
	EL_MARKUP_ROUTINES

	EL_MODULE_FILE; EL_MODULE_TUPLE; EL_MODULE_REUSEABLE; EL_MODULE_XML

feature -- Access

	anchor_name (name: ZSTRING): ZSTRING
		do
			Result := name.twin
			Result.replace_character (' ', '_')
		end

	anchor_reference (name: ZSTRING): ZSTRING
		do
			Result := anchor_name (name)
			Result.prepend_character ('#')
		end

	book_mark_anchor_markup (id, text: ZSTRING): ZSTRING
		do
			Bookmark_template.set_variables_from_array (<<
				[Variable.id, anchor_name (id)],
				[Variable.text, text]
			>>)
			Result := Bookmark_template.substituted
		end

	hyperlink (url, title, text: ZSTRING): ZSTRING
		do
			Hyperlink_template.set_variables_from_array (<<
				[Variable.url, url], [Variable.title, title], [Variable.text, text]
			>>)
			Result := Hyperlink_template.substituted
		end

	image (url, description: ZSTRING): ZSTRING
		do
			Image_template.set_variables_from_array (<<
				[Variable.url, url], [Variable.description, description]
			>>)
			Result := Image_template.substituted
		end

	table_data (data: ZSTRING): ZSTRING
		do
			Result := value_element ("td", data, Void)
		end

	text_element (name: READABLE_STRING_GENERAL; attributes: ARRAY [READABLE_STRING_GENERAL]): XML_TEXT_ELEMENT
		do
			create Result.make_empty (name)
			Result.set_attributes_from_pairs (attributes)
		end

	text_element_class (name, class_name: READABLE_STRING_GENERAL): XML_TEXT_ELEMENT
		do
			create Result.make_empty (name)
			Result.set_attributes_from_pairs (<< "class=" + class_name >>)
		end

	unescape_character_entities (line: ZSTRING)
		local
			entity_name, entity, section: ZSTRING; pos_semicolon: INTEGER
		do
			if line.has ('&') and then line.has (';')
				and then attached Utf_8_character_entity_table as table
			then
				across Reuseable.string_pool as pool loop
					entity_name := pool.borrowed_item
					entity :=  pool.borrowed_item
					across pool.filled_borrowed_item (line).split ('&') as split loop
						if split.cursor_index = 1 then
							line.wipe_out
						else
							line.append_character ('&')
						end
						section := split.item
						pos_semicolon := section.index_of (';', 1)
						if pos_semicolon > 0 then
							entity_name.wipe_out
							entity_name.append_substring (section, 1, pos_semicolon - 1)
							if table.has_key_general (entity_name) then
								set_character_entity (entity, table.found_item)
								line [line.count] := entity [1] -- overwrite '&'
								line.append_substring (section, pos_semicolon + 1, section.count)
							else
								line.append (section)
							end
						else
							line.append (section)
						end
					end
				end
			end
		end

feature -- Conversion

	to_xml (xhtml: READABLE_STRING_8): STRING
		local
			encoding_name, header: STRING; index, i: INTEGER; s: EL_STRING_8_ROUTINES
			cr: EL_CHARACTER_8_ROUTINES; c: CHARACTER_8
		do
			index := xhtml.substring_index (Charset, 1)
			-- Works for parsing either of examples:
			-- 	1. <meta charset="UTF-8" />
			-- 	2. <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

			if index > 0 and then s.is_identifier_boundary (xhtml, index, index + Charset.count - 1) then
				create encoding_name.make (10)

				from i := index + Charset.count until encoding_name.count > 3 and xhtml [i] = '"' loop
					c := xhtml [i]
					if cr.is_c_identifier (c, False) or else c = '-' then
						encoding_name.extend (c)
					end
					i := i + 1
				end
			else
				encoding_name := {CODE_PAGE_CONSTANTS}.Utf8
			end
			header := XML.header (1.0, encoding_name)
			if is_document (xhtml) then
				index := xhtml.index_of ('>', 1)
				create Result.make (xhtml.count - index + header.count)
				Result.append (header); Result.append_substring (xhtml, index + 1, xhtml.count)
			else
				header.append_character ('%N')
				Result := header + xhtml
			end
		end

feature -- Query

	display_map (log: EL_LOGGABLE)
		local
			entity: ZSTRING
		do
			create entity.make_empty
			across Utf_8_character_entity_table as table loop
				set_character_entity (entity, table.item)
				log.put_substitution ("%S := %S", [table.key, entity])
				log.put_new_line
			end
		end

	is_document (text: READABLE_STRING_8): BOOLEAN
		-- `True' if `line' starts with <!DOCTYPE html..
		-- html is case insensitive
		do
			if text.starts_with (Doctype_declaration) then
				Result := text.same_caseless_characters ("html", 1, 4, Doctype_declaration.count + 2)
			end
		end

	is_document_file (path: FILE_PATH): BOOLEAN
		do
			if path.exists then
				Result := is_document (File.line_one (path))
			end
		end

feature {NONE} -- Implementation

	set_character_entity (entity: ZSTRING; utf_8_entity: IMMUTABLE_STRING_8)
		do
			entity.wipe_out
			if utf_8_entity.count = 3 and then utf_8_entity [2] = ' ' then
				entity.append_character (' ')
			else
				entity.append_utf_8 (utf_8_entity)
			end
		end

feature {NONE} -- Constants

	Bookmark_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("<a id=%"$id%">$text</a>")
		end

	Charset: STRING = "charset"

	Doctype_declaration: STRING = "<!DOCTYPE"

	Hyperlink_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				<a href="$url" title="$title">$text</a>
			]")
		end

	Image_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				<img src="$url" alt="$description">
			]")
		end

	Utf_8_character_entity_table: EL_IMMUTABLE_STRING_8_TABLE
		local
			utf_8: EL_UTF_8_CONVERTER
		once
--			note: nbsp requires quotes ' '
			create Result.make_by_assignment (utf_8.string_32_to_string_8 ({STRING_32} "[
				aacute := á
				Aacute := Á
				acirc := â
				Acirc := Â
				acute := ´
				aelig := æ
				AElig := Æ
				agrave := à
				Agrave := À
				aring := å
				Aring := Å
				atilde := ã
				Atilde := Ã
				auml := ä
				Auml := Ä
				brvbar := ¦
				ccedil := ç
				Ccedil := Ç
				cedil := ¸
				cent := ¢
				copy := ©
				curren := ¤
				deg := °
				divide := ÷
				eacute := é
				Eacute := É
				ecirc := ê
				Ecirc := Ê
				egrave := è
				Egrave := È
				eth := ð
				ETH := Ð
				euml := ë
				Euml := Ë
				frac12 := ½
				frac14 := ¼
				frac34 := ¾
				iacute := í
				Iacute := Í
				icirc := î
				Icirc := Î
				iexcl := ¡
				igrave := ì
				Igrave := Ì
				iquest := ¿
				iuml := ï
				Iuml := Ï
				laquo := «
				macr := ¯
				mdash := —
				micro := µ
				middot := ·
				nbsp := ' '
				ndash := –
				not := ¬
				ntilde := ñ
				Ntilde := Ñ
				oacute := ó
				Oacute := Ó
				ocirc := ô
				Ocirc := Ô
				ograve := ò
				Ograve := Ò
				ordf := ª
				ordm := º
				oslash := ø
				Oslash := Ø
				otilde := õ
				Otilde := Õ
				ouml := ö
				Ouml := Ö
				para := ¶
				plusmn := ±
				pound := £
				raquo := »
				reg := ®
				sect := §
				shy := ­
				sup1 := ¹
				sup2 := ²
				sup3 := ³
				szlig := ß
				thorn := þ
				THORN := Þ
				times := ×
				uacute := ú
				Uacute := Ú
				ucirc := û
				Ucirc := Û
				ugrave := ù
				Ugrave := Ù
				uml := ¨
				uuml := ü
				Uuml := Ü
				yacute := ý
				Yacute := Ý
				yen := ¥
			]"))
		end

	Variable: TUPLE [id, description, text, title, url: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "id, description, text, title, url")
		end

end