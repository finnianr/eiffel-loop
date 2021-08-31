note
	description: "Table displaying passphrase attributes and security rating score"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-31 10:35:39 GMT (Tuesday 31st August 2021)"
	revision: "4"

class
	EL_PASSPHRASE_RATING_TABLE

inherit
	EL_VERTICAL_BOX
		rename
			make as make_box
		redefine
			create_interface_objects
		end

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_GUI

	EL_MODULE_VISION_2

	EL_SHARED_PASSPHRASE_TEXTS

create
	make

feature {NONE} -- Initialization

	make (a_new_label: like new_label; a_checked_image_path: EL_FILE_PATH)
		do
			new_label := a_new_label; checked_image_path := a_checked_image_path
			minimum_score := Default_minimum_score
			make_box (0, 0.2)

			create phrase_attributes.make
			across phrase_attributes as table loop
				add_row (new_label (table.key), check_list [table.cursor_index])
			end
			add_row (score_label, secure_enough_check)
			add_row (minimum_score_label, create {EV_CELL})
		end

feature -- Status query

	minimum_score_met: BOOLEAN
		do
			Result := phrase_attributes.score >= minimum_score
		end

feature -- Status change

	update (passphrase: READABLE_STRING_GENERAL)
			--
		do
			phrase_attributes.update (passphrase)
			score_label.set_text (Score_template #$ [phrase_attributes.score])
			secure_enough_check.set_checked (minimum_score_met)

			across phrase_attributes as table loop
				check_list.i_th (table.cursor_index).set_checked (table.item)
			end
		end

feature -- Element change

	set_minimum_score (a_minimum_score: INTEGER)
		do
			minimum_score := a_minimum_score
			minimum_score_label.set_text (Minimum_score_template #$ [a_minimum_score])
		end

feature {NONE} -- Implementation

	add_row (widget_left, widget_right: EV_WIDGET)
		do
			extend_unexpanded (
				Vision_2.new_horizontal_box (0, 0.3, <<
					create {EV_CELL}, widget_left, create {EL_EXPANDED_CELL}, widget_right
				>>)
			)
		end

	create_interface_objects
		local
			check_width: INTEGER
		do
			Precursor
			score_label := new_label (Score_template #$ [0])
			score_label.set_bold

			minimum_score_label := new_label (Minimum_score_template #$ [Default_minimum_score])
			minimum_score_label.set_italic

			check_width := (score_label.height * 1.7).rounded
			create check_list.make (6)
			from until check_list.full loop
				check_list.extend (new_check_area (check_width))
			end
			secure_enough_check := new_check_area (check_width)
		end

	new_check_area (a_width: INTEGER): EL_CHECK_AREA
		do
			create Result.make (checked_image_path, a_width)
		end

feature {NONE} -- Internal attributes

	check_list: ARRAYED_LIST [EL_CHECK_AREA]

	checked_image_path: EL_FILE_PATH

	minimum_score: INTEGER

	minimum_score_label: EL_LABEL

	new_label: FUNCTION [READABLE_STRING_GENERAL, EL_LABEL]

	phrase_attributes: EL_PASSPHRASE_ATTRIBUTE_MAP

	score_label: EL_LABEL

	secure_enough_check: EL_CHECK_AREA

feature {NONE} -- Constants

	Default_minimum_score: INTEGER
		once
			Result := 3
		end

	Minimum_score_template: ZSTRING
		once
			Result := Text.minimum_score
		end

	Score_template: ZSTRING
		once
			Result := Text.passphrase_strength
		end

end