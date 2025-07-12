	include "cpu/z80/include/common.inc"

	global delay_dsub
	global r_scratch

	ifnd _HEADLESS_

	global joystick_update_byte
	global print_b2_return_to_menu
	global print_passes
	global sound_play_byte_dsub

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

; params:
;  a = mask
;  ix = r_input_edge|r_input_raw
;  iy = ptr to byte
joystick_update_byte:
		ld	(r_mask), a

		ld	b, (ix)
		bit	INPUT_UP_BIT, b
		jr	z, .up_not_pressed
		inc	(iy)

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, b
		jr	z, .down_not_pressed
		ld	a, (iy)
		sub	$1
		ld	(iy), a

	.down_not_pressed:
		bit	INPUT_LEFT_BIT, b
		jr	z, .left_not_pressed
		ld	a, (iy)
		sub	$10
		ld	(iy), a

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, b
		jr	z, .right_not_pressed
		ld	a, (iy)
		add	a, $10
		ld	(iy), a

	.right_not_pressed:
		ld	a, (r_mask)
		ld	b, a
		ld	a, (iy)
		and	b
		ld	(iy), a
		ret

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

; params:
;  b = byte to play
sound_play_byte_dsub:
		exx

		ld	l, $8
		ld	h, b

	.loop_next_bit:
		WATCHDOG
		sla	h
		jr	nc, .is_zero

		ld	a, SOUND_NUM_BIT_ONE
		jr	.sound_play

	.is_zero:
		ld	a, SOUND_NUM_BIT_ZERO

	.sound_play:
		SOUND_PLAY

	; if the machine can only generate tones, we need to
	; stop playing it after a bit
	ifd _SOUND_TONE_
		SOUND_BIT_DELAY
		SOUND_STOP
	endif

		SOUND_BIT_DELAY

		dec	l
		jp	nz, .loop_next_bit
		DSUB_RETURN

	section data

d_str_b2_return_to_menu:	STRING "B2 - RETURN TO MENU"
d_str_passes:			STRING "PASSES"

	endif

	section bss

; The cpu doesn't support register to register add/sub/cmp/etc
; instructions, this is a global scratch location that can be
; used to help work around this (after work ram is tested good).
; ie:
;		stb	r_scratch
;		adda	r_scratch
r_scratch:		dcb.w 1
r_mask			dcb.w 1
