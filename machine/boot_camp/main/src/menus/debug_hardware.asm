	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts


; these were just to verify reading from $001f was going
; to the 007121 chips
just_loop:
		WATCHDOG
		bra	just_loop

read_001f_loop:
		WATCHDOG
		lda	$001f
		bra	read_001f_loop

	section data

d_menu_list:
;	MENU_ENTRY just_loop, d_str_just_loop, ME_FLAG_NONE
;	MENU_ENTRY read_001f_loop, d_str_read_001f_loop, ME_FLAG_NONE
	MENU_ENTRY sprite_debug, d_str_sprite_debug, ME_FLAG_NONE
	MENU_ENTRY watchdog_time, d_str_watchdog_time, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

;d_str_just_loop:		STRING "JUST LOOP"
;d_str_read_001f_loop:		STRING "READ 001F LOOP"
d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_watchdog_time:		STRING "WATCHDOG TIME"
