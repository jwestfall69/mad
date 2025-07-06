	include "cpu/z80/include/common.inc"

	global delay_dsub

	ifnd _HEADLESS_

	global print_b2_return_to_menu
	global print_passes

	endif

	section code

; params:
;  bc = loops
delay_dsub:
		exx
	.loop:
		WATCHDOG
		dec	bc		; 6 cycles
		ld	a, c		; 4 cycles
		or	b		; 4 cycles
		jr	nz, .loop	; 12 cycles
	DSUB_RETURN

	ifnd _HEADLESS_

; these 2 print function help de-dupe some common
; strings in many tests/menu items
print_b2_return_to_menu:
		SEEK_XY	SCREEN_START_X, SCREEN_B2_Y
		ld	de, d_str_b2_return_to_menu
		RSUB	print_string
		ret

print_passes:
		SEEK_XY	SCREEN_START_X, SCREEN_PASSES_Y
		ld	de, d_str_passes
		RSUB	print_string
		ret

	section data

d_str_b2_return_to_menu:	STRING "B2 - RETURN TO MENU"
d_str_passes:			STRING "PASSES"

	endif
